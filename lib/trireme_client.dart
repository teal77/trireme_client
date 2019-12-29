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

library trireme_client;

import 'dart:async';

import 'deserialization.dart';
import 'events.dart';
import 'src/deluge_connection.dart';
import 'src/trireme_client_core.dart';

export 'deserialization.dart';
export 'events.dart';
export 'src/deluge_connection.dart' show DaemonDetails;

part 'trireme_client.g.dart';

abstract class TriremeClient {

  static Future<DaemonDetails> detectDaemon(String host, int port) {
    return new DaemonDetector(host, port).detect();
  }

  final DelugeClient _client;

  bool isDisposed;

  factory TriremeClient(String username, String password, String host,
      {int port = 58846, List<int> pinnedCertificate}) {
    return new _$TriremeClientImpl(
        username, password, host, port, pinnedCertificate);
  }

  TriremeClient._(String username, String _password, String host, int port,
      List<int> pinnedCertificate)
      : _client = new DelugeClient(host, port, username, _password,
            pinnedCertificate: pinnedCertificate);

  Future init() async {
    isDisposed = true;
    _client.init();
    await _registerForEvents(fullEventList);
    isDisposed = false;
  }

  void dispose() {
    isDisposed = true;
    _client.dispose();
  }

  String get username => _client.username;

  String get host => _client.host;

  int get port => _client.port;

  int get latestRequestId => _client.latestRequestId;

  Stream<DelugeRpcEvent> delugeRpcEvents() => _client.delugeEvents();

  Future<int> login() => _client.login();

  @ApiName("daemon.set_event_interest")
  Future<bool> _registerForEvents(List<String> events);

  @ApiName("daemon.info")
  Future<String> daemonInfo();

  @ApiName("core.get_session_state")
  Future<List<String>> getSessionState();

  @ApiName("core.get_session_status")
  Future<SessionStatus> getSessionStatus(
      {List<String> sessionStatusKeys = sessionStatusKeys});

  @ApiName("core.pause_session")
  Future pauseSession();

  @ApiName("core.resume_session")
  Future resumeSession();

  @ApiName("core.add_torrent_file")
  Future<String> addTorrentFile(
      String fileName, String fileDump, Map<String, Object> options);

  @ApiName("core.add_torrent_url")
  Future<String> addTorrentUrl(String url, Map<String, Object> options);

  @ApiName("core.add_torrent_magnet")
  Future<String> addTorrentMagnet(String magnet, Map<String, Object> options);

  @ApiName("core.remove_torrent")
  Future<bool> removeTorrent(String torrentId, bool removeData);

  @ApiName("core.remove_torrents")
  Future<List<Object>> removeTorrents(List<String> torrentIds, bool removeData);

  @ApiName("core.pause_torrent")
  Future pauseTorrents(List<String> torrentIds);

  @ApiName("core.resume_torrent")
  Future resumeTorrents(List<String> torrentIds);

  @ApiName("core.force_recheck")
  Future forceRecheck(List<String> torrentIds);

  @ApiName("core.force_reannounce")
  Future forceReAnnounce(List<String> torrentIds);

  @ApiName("core.move_storage")
  Future<bool> moveStorage(List<String> torrentIds, String destination);

  @ApiName("core.rename_files")
  Future renameTorrentFiles(String torrentId, List<List> fileNames);

  @ApiName("core.rename_folder")
  Future renameTorrentFolder(String torrentId, String oldName, String newName);

  @ApiName("core.set_torrent_options")
  Future setTorrentOptions(List<String> torrentIds, Map options);

  @ApiName("core.set_torrent_trackers")
  Future setTorrentTrackers(String torrentId, List<Map> trackers);

  @ApiName("core.get_torrent_status")
  Future<Response<Map<String, Object>>> getTorrentStatus(
      String torrentId, List<String> keys);

  @ApiName("core.get_torrent_status")
  Future<Response<TorrentDetail>> getTorrentDetails(String torrentId,
      {List<String> keys = torrentDetailKeys});

  @ApiName("core.get_torrent_status")
  Future<TorrentFiles> getTorrentFileList(String torrentId,
      {List<String> keys = torrentFilesKeys});

  @ApiName("core.get_torrent_status")
  Future<Peers> getTorrentPeers(String torrentId,
      {List<String> keys = peersKeys});

  @ApiName("core.get_torrent_status")
  Future<TorrentOptions> getTorrentOptions(String torrentId,
      {List<String> keys = torrentOptionsKeys});

  @ApiName("core.get_torrents_status")
  Future<Map<String, TorrentListItem>> getTorrentsList(
      Map<String, Object> filterDict,
      {List<String> keys = torrentListItemKeys});

  @ApiName("core.get_torrents_status")
  Future<Map<String, Object>> getTorrentsStatus(
      Map<String, Object> filterDict, List<String> keys);

  @ApiName("core.get_filter_tree")
  Future<FilterTree> getFilterTree();

  @ApiName("core.get_config")
  Future<Map<String, Object>> getConfig();

  @ApiName("core.get_config_value")
  Future<Object> getConfigValue(String key);

  @ApiName("core.get_config_values")
  Future<Map<String, Object>> getConfigValues(List<String> keys);

  @ApiName("core.get_config_values")
  Future<AddTorrentDefaultOptions> getAddTorrentDefaultOptions(
      {List<String> keys = addTorrentDefaultOptionsKeys});

  @ApiName("core.set_config")
  Future setConfig(Map<String, Object> config);

  @ApiName("core.get_listen_port")
  Future<String> getListenPort();

  @ApiName("core.test_listen_port")
  Future<bool> testListenPort();

  @ApiName("core.get_external_ip")
  Future<String> getExternalIp();

  @ApiName("core.get_libtorrent_version")
  Future<String> getLibtorrentVersion();

  @ApiName("core.get_proxy")
  Future<Map<String, Object>> getProxySettings();

  @ApiName("core.get_available_plugins")
  Future<List<String>> getAvailablePlugins();

  @ApiName("core.get_enabled_plugins")
  Future<List<String>> getEnabledPlugins();

  @ApiName("core.enable_plugin")
  Future<bool> enablePlugin(String plugin);

  @ApiName("core.disable_plugin")
  Future<bool> disablePlugin(String plugin);

  @ApiName("core.rescan_plugins")
  Future rescanPlugins();

  @ApiName("core.get_path_size")
  Future<int> getPathSize(String path);

  @ApiName("core.get_free_space")
  Future<int> getFreeSpace(String path);

  @ApiName("core.queue_top")
  Future queueTop(List<String> torrentIds);

  @ApiName("core.queue_up")
  Future queueUp(List<String> torrentIds);

  @ApiName("core.queue_down")
  Future queueDown(List<String> torrentIds);

  @ApiName("core.queue_bottom")
  Future queueBottom(List<String> torrentIds);

  @ApiName("core.get_known_accounts")
  Future<List<String>> getKnownAccounts();

  @ApiName("core.create_account")
  Future<bool> createAccount(String username, String password, int authLevel);

  @ApiName("core.update_account")
  Future<bool> updateAccount(String username, String password, int authLevel);

  @ApiName("core.remove_account")
  Future<bool> deleteAccount(String username);

  @ApiName("label.get_labels")
  Future<List<String>> getLabels();

  @ApiName("label.set_torrent")
  Future setTorrentLabel(String torrentId, String label);
}

class DelugeRpcError {
  final String type;
  final String msg;
  final String trace;

  DelugeRpcError(this.type, this.msg, [this.trace]);

  @override
  String toString() => "$type, $msg";
}

//A wrapper class which contains requestId
class Response<T> {
  final int requestId;
  final T response;

  Response(this.requestId, Object response): this.response = response as T;

  @override
  String toString() {
    return 'requestId: $requestId => $response}';
  }
}

//Used for codegen
class ApiName {
  final String name;

  const ApiName(this.name);
}
