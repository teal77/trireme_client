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

class ConnectionFactory {
  final String host;
  final int port;
  final Duration timeout;
  final ResponseCallback responseCallback;
  final ErrorCallback errorCallback;

  final Completer<DelugeConnection> _completer =
  new Completer<DelugeConnection>();

  int _requestId = -100;
  DelugeConnection deluge1Connection;
  DelugeConnection deluge2Connection;

  ConnectionFactory(this.host, this.port, this.timeout, this.responseCallback,
      this.errorCallback);

  Future<DelugeConnection> getConnection() {
    deluge1Connection =
    new Deluge1Connection(host, port, timeout, _receiveDeluge1, _error);
    deluge2Connection =
    new Deluge2Connection(host, port, timeout, _receiveDeluge2, _error);

    _getDaemonInfo(deluge1Connection);
    _getDaemonInfo(deluge2Connection);
    return _completer.future;
  }

  void _getDaemonInfo(DelugeConnection connection) async {
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

    var connection = new Deluge1Connection(
        host, port, timeout, responseCallback, errorCallback);
    await connection.connect();
    _completer.complete(connection);
  }

  void _receiveDeluge2(Object response) async {
    deluge1Connection.disconnect();
    deluge2Connection.disconnect();

    var connection = new Deluge2Connection(
        host, port, timeout, responseCallback, errorCallback);
    await connection.connect();
    _completer.complete(connection);
  }

  void _error(Object error) {
    throw error;
  }
}

typedef void ResponseCallback(Object response);
typedef void ErrorCallback(Object error);

abstract class DelugeConnection {
  final String host;
  final int port;
  final Duration timeout;
  final ResponseCallback responseCallback;
  final ErrorCallback _errorCallback;

  SecureSocket _socket;
  BytesBuilder _partialData = new BytesBuilder();

  Codec<Object, List<int>> _codec = new RencodeCodec().fuse(new ZLibCodec());

  DelugeConnection(this.host, this.port, this.timeout, this.responseCallback,
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

class Deluge1Connection extends DelugeConnection {
  Deluge1Connection(String host, int port, Duration timeout,
      ResponseCallback responseCallback, ErrorCallback errorCallback)
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

class Deluge2Connection extends DelugeConnection {
  static const int headerSize = 5;

  static final int headerChar = ascii
      .encode("D")
      .first;

  int _responseLength;

  Deluge2Connection(String host, int port, Duration timeout,
      ResponseCallback responseCallback, ErrorCallback errorCallback)
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