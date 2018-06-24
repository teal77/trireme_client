/*
 * Trireme Client - Deluge RPC Client for Dart.
 * Copyright (C) 2018  Aashrava Holla
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:rencode/rencode.dart';

import '../events.dart';
import '../trireme_client.dart';

class DelugeClient {
  bool _log = false;

  static const int rpcResponse = 1;
  static const int rpcError = 2;
  static const int rpcEvent = 3;

  static const List<Object> emptyList = const [];
  static const Map<Object, Object> emptyMap = const {};

  final Duration timeoutDuration = new Duration(seconds: 15);

  final String host;
  final int port;
  final String username;
  final String _password;

  int delugeVersion;
  String daemonVersionName;

  int _requestId = 0;
  _DelugeConnection _connection;
  Map<int, _Request> _requests = {};
  StreamController<DelugeRpcEvent> _streamController;

  Future _connecting;

  DelugeClient(this.host, this.port, this.username, this._password) {
    init();
  }

  void init() {
    _streamController = new StreamController.broadcast();
  }

  void _connect() {
    if (_connection == null) {
      var connectionFactory = new _ConnectionFactory(
          host, port, timeoutDuration, _receive, _errorCallback);
      _connecting =
          connectionFactory.getConnection().then<int>((connection) {
            _connection = connection;
            return login();
          });
    } else {
      _connecting = _connection.connect().then<int>((dynamic _) => login());
    }
  }

  Future<T> rpcCall<T>(String name,
      [List<Object> args, Map<Object, Object> kwargs]) async {
    return new Future.sync(() async {
      if (_connection == null || !_connection.isConnected()) {
        if (_connecting != null) {
          await _connecting;
          _connecting = null;
        } else {
          _connect();
          await _connecting;
          _connecting = null;
        }
      }

      return _sendCall(name, args, kwargs);
    }
    );
  }

  Stream<DelugeRpcEvent> delugeEvents() {
    return _streamController.stream;
  }

  Future<int> login() async {
    if (_connection is _Deluge1Connection) {
      return await _sendCall<int>("daemon.login", [username, _password]);
    } else {
      return await _sendCall<int>("daemon.login", [username, _password],
          {"client_version": "Trireme Client v0.0.1"});
    }
  }

  Future<T> _sendCall<T>(String name,
      [List<Object> args, Map<Object, Object> kwargs]) async {
    return new Future.sync(() async {
      //Captures all exceptions in this block and throws them through our Future.

      _requestId++;
      var payload = [_requestId, name]..add(args ?? emptyList)..add(
          kwargs ?? emptyMap);
      _connection.send(payload);

      _registerForTimeout(_requestId);

      if (_log) print(">>> $payload");

      var r = new _Request<T>(payload);
      _requests[_requestId] = r;
      return r.completer.future;
    });
  }

  void _receive(Object responseObj) {
    List<Object> response = responseObj as List<Object>;

    if (_log) print("<<< $response");

    if (response[0] == rpcResponse) {
      int requestId = response[1];
      var r = _requests.remove(requestId);
      r?.onResponse(response[2]);
    } else if (response[0] == rpcError) {
      int requestId = response[1];
      var r = _requests.remove(requestId);

      if (_connection is _Deluge1Connection) {
        List<Object> delugeRpcError = response[2];
        r?.onError(delugeRpcError[0] as String, delugeRpcError[1] as String,
            delugeRpcError[2] as String);
      } else {
        r?.onError(response[2] as String, response[3].toString(),
            response[5] as String);
      }
    } else if (response[0] == rpcEvent) {
      var event = new DelugeRpcEvent(
          response[1] as String, response[2] as List<Object>);
      if (_streamController.hasListener) _streamController.add(event);
    } else {
      throw "Unkown response type ${response[0]}";
    }
  }

  void _errorCallback(Object error) {
    // no way to know which request failed >_<
    if (error is String) {
      print(error);
    } else {
      throw error;
    }
  }

  void _registerForTimeout(int requestId) {
    new Timer(timeoutDuration, () {
      var r = _requests.remove(requestId);
      if (r != null) {
        r.timeout();
        _connection.disconnect();
      }
    });
  }

  void dispose() {
    if (_log) print("Client disposed");

    _requests.clear();
    _connection?.disconnect();
    _streamController.close();
  }
}

class _Request<T> {
  final Object payload;
  final Completer<T> completer = new Completer<T>();

  _Request(this.payload);

  T castResponse(Object o) {
    return o as T;
  }

  void onResponse(Object response) {
    if (!completer.isCompleted) {
      completer.complete(castResponse(response));
    }
  }

  void onError(String type, String msg, String traceback) {
    var delugeRpcError = new DelugeRpcError(type, msg, traceback);
    _dispatchError(delugeRpcError);
  }

  void timeout() {
    var error = new DelugeRpcError("Timeout", "Request timed out");
    _dispatchError(error);
  }

  void _dispatchError(DelugeRpcError error) {
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }
}

class _ConnectionFactory {
  final String host;
  final int port;
  final Duration timeout;
  final _ResponseCallback responseCallback;
  final _ErrorCallback errorCallback;

  final Completer<_DelugeConnection> _completer =
  new Completer<_DelugeConnection>();

  int _requestId = -100;
  _DelugeConnection deluge1Connection;
  _DelugeConnection deluge2Connection;

  _ConnectionFactory(this.host, this.port, this.timeout, this.responseCallback,
      this.errorCallback);

  Future<_DelugeConnection> getConnection() {
    deluge1Connection =
    new _Deluge1Connection(host, port, timeout, _receiveDeluge1, _error);
    deluge2Connection =
    new _Deluge2Connection(host, port, timeout, _receiveDeluge2, _error);

    _getDaemonInfo(deluge1Connection);
    _getDaemonInfo(deluge2Connection);
    return _completer.future;
  }

  void _getDaemonInfo(_DelugeConnection connection) async {
    try {
      await connection.connect();
      connection
          .send([_requestId++, "daemon.info", <dynamic>[], <dynamic, dynamic>{}]);
    } catch (e) {
      if (!_completer.isCompleted) {
        _completer.completeError(e);
      }
    }
  }

  void _receiveDeluge1(Object response) async {
    deluge1Connection.disconnect();
    deluge2Connection.disconnect();

    var connection = new _Deluge1Connection(
        host, port, timeout, responseCallback, errorCallback);
    await connection.connect();
    _completer.complete(connection);
  }

  void _receiveDeluge2(Object response) async {
    deluge1Connection.disconnect();
    deluge2Connection.disconnect();

    var connection = new _Deluge2Connection(
        host, port, timeout, responseCallback, errorCallback);
    await connection.connect();
    _completer.complete(connection);
  }

  void _error(Object error) {
    throw error;
  }
}

typedef void _ResponseCallback(Object response);
typedef void _ErrorCallback(Object error);

abstract class _DelugeConnection {
  final String host;
  final int port;
  final Duration timeout;
  final _ResponseCallback responseCallback;
  final _ErrorCallback _errorCallback;

  SecureSocket _socket;
  BytesBuilder _partialData = new BytesBuilder();

  Codec<Object, List<int>> _codec = new RencodeCodec().fuse(new ZLibCodec());

  _DelugeConnection(this.host, this.port, this.timeout, this.responseCallback,
      this._errorCallback);

  Future connect() async {
    _socket = await SecureSocket.connect(host, port,
        timeout: timeout, onBadCertificate: (c) => true);

    _socket.listen((response) {
      receive(response);
    }, onError: (Object e) {
      _errorCallback(e);
    }, onDone: () {
      _socket?.destroy();
      _socket = null;
    });
  }

  void receive(List<int> response);

  void send(Object request);

  bool isConnected() => _socket != null;

  void disconnect() {
    _socket?.destroy();
    _socket = null;
  }
}

class _Deluge1Connection extends _DelugeConnection {
  _Deluge1Connection(String host, int port, Duration timeout,
      _ResponseCallback responseCallback, _ErrorCallback errorCallback)
      : super(host, port, timeout, responseCallback, errorCallback);

  void send(Object object) {
    _socket.add(_codec.encode([object]));
  }

  void receive(List<int> response) {
    try {
      Object responseObj;
      try {
        responseObj = _codec.decode(response);

        /*The response was valid, so clear any partial data stored from the
        previous request, that request will be timed out by deluge client*/
        _partialData.clear();

        responseCallback(responseObj);
        return;
      } on FormatException {
        //nop
      } catch (e) {
        //catch zlib error
        if (e.toString().contains("Filter error")) {
          //nop
        } else {
          rethrow;
        }
      }

      /*The response is not valid zlib or rencode, so add it to partial data
      and try decoding*/
      _partialData.add(response);
      responseObj = _codec.decode(_partialData.toBytes());

      /*The response together with previous response was valid, so we
      can return that object and clear partialData*/
      _partialData.clear();
      responseCallback(responseObj);
    } on FormatException {
      /*The response is still not valid, wait for next response so that
      it can be added to paritalData and checked again.
      Eventually, a proper response will be formed, which will clear
      the partial data or a full response will be received which will also clear
      the partial data.

      This will not handle out of order responses, they will be timed out by
      DelugeClient*/
    } catch (e) {
      //catch zlib error
      if (e.toString().contains("Filter error")) {
        //nop
      } else {
        rethrow;
      }
    }
  }
}

class _Deluge2Connection extends _DelugeConnection {
  static const int headerSize = 5;

  static final int headerChar = ascii
      .encode("D")
      .first;

  int _responseLength;

  _Deluge2Connection(String host, int port, Duration timeout,
      _ResponseCallback responseCallback, _ErrorCallback errorCallback)
      : super(host, port, timeout, responseCallback, errorCallback);

  void send(Object object) {
    var request = _codec.encode([object]);
    _socket.add(_getRequestHeader(request.length));
    _socket.add(_codec.encode([object]));
  }

  List<int> _getRequestHeader(int requestLength) {
    BytesBuilder bb = new BytesBuilder();
    bb.addByte(headerChar);

    var bd = new ByteData(4);
    bd.setInt32(0, requestLength);
    bb.add(bd.buffer.asUint8List());
    return bb.takeBytes();
  }

  void receive(List<int> response) {
    if (response.first == headerChar && response.length == headerSize) {
      //clear any previous partial data, that request will timeout
      _partialData.clear();

      _responseLength =
          new Uint8List.fromList(response.getRange(1, headerSize).toList())
              .buffer
              .asByteData()
              .getInt32(0);
      return;
    }

    _partialData.add(response);

    if (_partialData.length >= _responseLength) {
      responseCallback(_codec.decode(_partialData.takeBytes()));
    }
  }
}
