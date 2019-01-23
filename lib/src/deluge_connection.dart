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

import '../trireme_client.dart';

class DaemonDetector {
  static const Duration timeout = const Duration(seconds: 30);

  final String host;
  final int port;

  Completer<DaemonDetails> _completer = new Completer();
  int _requestId = 0;
  DelugeConnection _deluge1Connection;
  DelugeConnection _oldDeluge2Connection;
  DelugeConnection _deluge2Connection;

  DaemonDetector(this.host, this.port);

  Future<DaemonDetails> detect() {
    _deluge1Connection = new Deluge1Connection(
        host, port, null, timeout, _receiveDeluge1, _error);
    _oldDeluge2Connection = new OldDeluge2Connection(
        host, port, null, timeout, _receiveOldDeluge2, _error);
    _deluge2Connection = new Deluge2Connection(
        host, port, null, timeout, _receiveDeluge2, _error);

    _getDaemonInfo(_deluge1Connection);
    _getDaemonInfo(_oldDeluge2Connection);
    _getDaemonInfo(_deluge2Connection);
    new Timer(timeout, () {
      if (!_completer.isCompleted) {
        _completer
            .completeError(new DelugeRpcError("Timeout", "Request timed out"));
      }
    });
    return _completer.future;
  }

  void _getDaemonInfo(DelugeConnection connection) async {
    try {
      await connection.connect();
      var payload = <dynamic>[
        _requestId++,
        "daemon.info",
        <dynamic>[],
        <dynamic, dynamic>{}
      ];
      connection.send(payload);
    } catch (e, s) {
      if (!_completer.isCompleted) {
        _completer.completeError(e, s);
      }
    }
  }

  void _receiveDeluge1(Object response) async {
    var cert = _deluge1Connection.certificate;
    _deluge1Connection.disconnect();
    _oldDeluge2Connection.disconnect();
    _deluge2Connection.disconnect();
    _dispatchResult(cert, _getDaemonVersion(response), true, 0);
  }

  void _receiveOldDeluge2(Object response) async {
    var cert = _oldDeluge2Connection.certificate;
    _deluge1Connection.disconnect();
    _oldDeluge2Connection.disconnect();
    _deluge2Connection.disconnect();
    _dispatchResult(cert, _getDaemonVersion(response), false, 0);
  }

  void _receiveDeluge2(Object response) async {
    var cert = _deluge2Connection.certificate;
    _deluge1Connection.disconnect();
    _oldDeluge2Connection.disconnect();
    _deluge2Connection.disconnect();
    _dispatchResult(cert, _getDaemonVersion(response), false,
        Deluge2Connection.protocolVersion);
  }

  void _error(Object error) {
    if (!_completer.isCompleted) {
      _completer.completeError(error);
    }
  }

  String _getDaemonVersion(Object object) {
    var response = object as List<Object>;
    if ((response.first as int) == 1) {
      return response[2] as String;
    } else {
      return "";
    }
  }

  void _dispatchResult(X509Certificate cert, String daemonVersion,
      bool isDeluge1, int protocolVersion) {
    var details = new DaemonDetails(host, port, cert, daemonVersion,
        protocolVersion, isDeluge1, !isDeluge1);
    if (!_completer.isCompleted) {
      _completer.complete(details);
    }
  }
}

class DaemonDetails {
  final String host;
  final int port;
  final X509Certificate daemonCertificate;
  final String daemonVersion;
  final int protocolVersion;
  final bool isDeluge1;
  final bool isDeluge2;

  DaemonDetails(this.host, this.port, this.daemonCertificate,
      this.daemonVersion, this.protocolVersion, this.isDeluge1, this.isDeluge2);

  @override
  String toString() => "Daemon at $host:$port, version [$daemonVersion] "
      "cert: ${daemonCertificate.sha1} isDeluge1: $isDeluge1";
}

class ConnectionFactory {
  final String host;
  final int port;
  final List<int> pinnedCertificate;
  final Duration timeout;
  final ResponseCallback responseCallback;
  final ErrorCallback errorCallback;

  final Completer<DelugeConnection> _completer =
      new Completer<DelugeConnection>();

  ConnectionFactory(this.host, this.port, this.pinnedCertificate, this.timeout,
      this.responseCallback, this.errorCallback);

  Future<DelugeConnection> getConnection() async {
    return new Future.sync(() async {
      var daemonDetails = await (new DaemonDetector(host, port)).detect();
      DelugeConnection connection;
      if (daemonDetails.isDeluge1) {
        connection = new Deluge1Connection(host, port, pinnedCertificate,
            timeout, responseCallback, errorCallback);
      } else {
        if (daemonDetails.protocolVersion > 0) {
          connection = new Deluge2Connection(host, port, pinnedCertificate,
              timeout, responseCallback, errorCallback);
        } else {
          connection = new OldDeluge2Connection(host, port, pinnedCertificate,
              timeout, responseCallback, errorCallback);
        }
      }
      await connection.connect();
      return connection;
    });
  }
}

typedef void ResponseCallback(Object response);
typedef void ErrorCallback(Object error);

abstract class DelugeConnection {
  final String host;
  final int port;
  final List<int> pinnedCertificate;
  final Duration timeout;
  final ResponseCallback _responseCallback;
  final ErrorCallback _errorCallback;

  SecureSocket _socket;
  BytesBuilder _partialData = new BytesBuilder();

  Codec<Object, List<int>> _codec = new RencodeCodec().fuse(new ZLibCodec());

  DelugeConnection(
    this.host,
    this.port,
    this.pinnedCertificate,
    this.timeout,
    this._responseCallback,
    this._errorCallback,
  );

  Future connect() async {
    SecurityContext securityContext;
    if (pinnedCertificate != null && pinnedCertificate.isNotEmpty) {
      securityContext = new SecurityContext();
      securityContext.setTrustedCertificatesBytes(pinnedCertificate);
    } else {
      securityContext = SecurityContext.defaultContext;
    }

    _socket = await SecureSocket.connect(host, port,
        timeout: timeout,
        context: securityContext,
        onBadCertificate: _onBadCertificate);

    _socket.listen((response) {
      receive(response);
    }, onError: (Object e) {
      _errorCallback(e);
    }, onDone: () {
      _socket?.destroy();
      _socket = null;
    });
  }

  bool _onBadCertificate(X509Certificate badCert) {
    //if we dont have a pinned certificate, accept all certs.
    //this is necessary because the Deluge daemon uses self signed certificates
    return pinnedCertificate == null || pinnedCertificate.isEmpty;
  }

  X509Certificate get certificate => _socket?.peerCertificate;

  void receive(List<int> response);

  void send(Object request);

  bool isConnected() => _socket != null;

  void disconnect() {
    _socket?.destroy();
    _socket = null;
  }
}

class Deluge1Connection extends DelugeConnection {
  Deluge1Connection(
      String host,
      int port,
      List<int> pinnedCert,
      Duration timeout,
      ResponseCallback responseCallback,
      ErrorCallback errorCallback)
      : super(host, port, pinnedCert, timeout, responseCallback, errorCallback);

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

        _responseCallback(responseObj);
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
      _responseCallback(responseObj);
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

class OldDeluge2Connection extends DelugeConnection {
  static const int headerSize = 5;

  static final int headerChar = ascii.encode("D").first;

  int _responseLength;

  OldDeluge2Connection(
      String host,
      int port,
      List<int> pinnedCert,
      Duration timeout,
      ResponseCallback responseCallback,
      ErrorCallback errorCallback)
      : super(host, port, pinnedCert, timeout, responseCallback, errorCallback);

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
      _responseCallback(_codec.decode(_partialData.takeBytes()));
    }
  }
}

class Deluge2Connection extends DelugeConnection {
  static const int headerSize = 5;

  static final int protocolVersion = 1;

  int _responseLength;

  Deluge2Connection(
      String host,
      int port,
      List<int> pinnedCert,
      Duration timeout,
      ResponseCallback responseCallback,
      ErrorCallback errorCallback)
      : super(host, port, pinnedCert, timeout, responseCallback, errorCallback);

  void send(Object object) {
    var request = _codec.encode([object]);
    _socket.add(_getRequestHeader(request.length));
    _socket.add(_codec.encode([object]));
  }

  List<int> _getRequestHeader(int requestLength) {
    BytesBuilder bb = new BytesBuilder();
    bb.addByte(protocolVersion);

    var bd = new ByteData(4);
    bd.setUint32(0, requestLength);
    bb.add(bd.buffer.asUint8List());
    return bb.takeBytes();
  }

  void receive(List<int> response) {
    if (_partialData.isEmpty) {
      if (response.length < headerSize) {
        return;
      }
      if (response.first != protocolVersion) {
        throw "Unknown protocol version ${response.first}";
      }
      _responseLength =
          new Uint8List.fromList(response.getRange(1, headerSize).toList())
              .buffer
              .asByteData()
              .getUint32(0);
      _partialData.add(response.getRange(headerSize, response.length).toList());
    } else {
      _partialData.add(response);
      if (response.first == protocolVersion) {
        if (_partialData.length > _responseLength) {
          _partialData.clear();
          receive(response);
        }
      }
    }

    if (_partialData.length >= _responseLength) {
      _responseCallback(_codec.decode(_partialData.takeBytes()));
    }
  }
}
