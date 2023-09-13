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

import '../events.dart';
import '../trireme_client.dart';

import 'deluge_connection.dart';
import 'type_helper.dart';

class DelugeClient {
  final bool _log = false;

  static const int rpcResponse = 1;
  static const int rpcError = 2;
  static const int rpcEvent = 3;

  static const List<Object> emptyList = [];
  static const Map<Object, Object> emptyMap = {};

  final Duration timeoutDuration = Duration(seconds: 15);

  final String host;
  final int port;
  final String username;
  final String _password;
  final List<int>? pinnedCertificate;
  final Map<int, _Request> _requests = {};

  int _requestId = 0;
  DelugeConnection? _connection;
  late StreamController<DelugeRpcEvent> _streamController;

  Future? _connecting;

  DelugeClient(this.host, this.port, this.username, this._password,
      {this.pinnedCertificate}) {
    init();
  }

  void init() {
    _streamController = StreamController.broadcast();
  }

  int get latestRequestId => _requestId;

  void _connect() {
    if (_connection == null) {
      var connectionFactory = ConnectionFactory(host, port,
          pinnedCertificate, timeoutDuration, _receive, _errorCallback);
      _connecting = connectionFactory.getConnection().then<int>((connection) {
        _connection = connection;
        return login();
      }).whenComplete(() => _connecting = null);
    } else {
      _connecting = _connection!
          .connect()
          .then<int>((dynamic _) => login())
          .whenComplete(() => _connecting = null);
    }
  }

  Future<T> rpcCall<T>(String name,
      [List<Object>? args, Map<Object, Object>? kwargs]) async {
    return Future.sync(() async {
      if (_connection == null || !_connection!.isConnected()) {
        if (_connecting == null) {
          _connect();
        }
        await _connecting;
      }

      return _sendCall<T>(name, args, kwargs);
    });
  }

  Stream<DelugeRpcEvent> delugeEvents() {
    return _streamController.stream;
  }

  Future<int> login() async {
    if (_connection is Deluge1Connection) {
      return await _sendCall<int>('daemon.login', [username, _password]);
    } else {
      return await _sendCall<int>('daemon.login', [username, _password],
          {'client_version': 'Trireme Client v0.0.1'});
    }
  }

  Future<T> _sendCall<T>(String name,
      [List<Object>? args, Map<Object, Object>? kwargs]) async {
    return Future.sync(() async {
      //Captures all exceptions in this block and throws them through our Future.

      _requestId++;
      var payload = [_requestId, name, args ?? emptyList, kwargs ?? emptyMap];
      _connection!.send(payload);

      _registerForTimeout(_requestId);

      if (_log) print('>>> $payload');

      var r = _Request<T>(name, _requestId, payload);
      _requests[_requestId] = r;
      return r.completer.future;
    });
  }

  void _receive(Object? responseObj) {
    var response = responseObj as List<Object?>;

    if (_log) print('<<< $response');

    if (response[0] == rpcResponse) {
      var requestId = response[1] as int;
      var r = _requests.remove(requestId);
      r?.onResponse(response[2]);
    } else if (response[0] == rpcError) {
      var requestId = response[1] as int;
      var r = _requests.remove(requestId);

      if (_connection is Deluge1Connection) {
        var delugeRpcError = response[2] as List<Object>;
        r?.onError(delugeRpcError[0] as String, delugeRpcError[1] as String,
            delugeRpcError[2] as String);
      } else {
        r?.onError(response[2] as String, response[3].toString(),
            response[5] as String);
      }
    } else if (response[0] == rpcEvent) {
      var event = DelugeRpcEvent(
          response[1] as String, (response[2] as List<Object?>).cast<Object>());
      if (_streamController.hasListener) _streamController.add(event);
    } else {
      throw 'Unknown response type ${response[0]}';
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
    Timer(timeoutDuration, () {
      var r = _requests.remove(requestId);
      if (r != null) {
        r.timeout();
        _connection!.disconnect();
      }
    });
  }

  void dispose() {
    if (_log) print('Client disposed');

    _requests.clear();
    _connection?.disconnect();
    _streamController.close();
  }
}

class _Request<T> {
  final String apiName;
  final int requestId;
  final Object payload;
  final Completer<T> completer = Completer<T>();

  _Request(this.apiName, this.requestId, this.payload);

  void onResponse(Object? response) {
    if (!completer.isCompleted) {
      if (isTypeOf<T, Response>()) {
        completer.complete(Response<Object>(apiName, requestId, response) as T);
      } else {
        completer.complete(response as T);
      }
    }
  }

  void onError(String type, String msg, String traceback) {
    var delugeRpcError = DelugeRpcError(type, msg, traceback);
    _dispatchError(delugeRpcError);
  }

  void timeout() {
    var error = DelugeRpcError('Timeout', 'Request timed out');
    _dispatchError(error);
  }

  void _dispatchError(DelugeRpcError error) {
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }
}
