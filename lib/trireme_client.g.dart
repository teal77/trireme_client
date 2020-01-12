// GENERATED CODE - DO NOT MODIFY BY HAND

part of trireme_client;

// **************************************************************************
// ApiCallGenerator
// **************************************************************************

class _$TriremeClientImpl extends TriremeClient {
  _$TriremeClientImpl(String username, String password, String host, int port,
      List<int> pinnedCert)
      : super._(username, password, host, port, pinnedCert);
  Future<bool> _registerForEvents(List<String> events) async {
    bool result =
        await _client.rpcCall<bool>('daemon.set_event_interest', [events]);
    var result2 = result;
    return result2;
  }

  Future<String> daemonInfo() async {
    String result = await _client.rpcCall<String>('daemon.info');
    var result2 = result;
    return result2;
  }

  Future<List<String>> getSessionState() async {
    List<Object> result =
        await _client.rpcCall<List<Object>>('core.get_session_state');
    var result2 = result.cast<String>();
    return result2;
  }

  Future<SessionStatus> getSessionStatus(
      {List<String> sessionStatusKeys: sessionStatusKeys}) async {
    Map<Object, Object> result = await _client.rpcCall<Map<Object, Object>>(
        'core.get_session_status', [sessionStatusKeys]);
    CustomDeserializer<SessionStatus> deserializer =
        new CustomDeserializerFactory().createDeserializer(SessionStatus)
            as CustomDeserializer<SessionStatus>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  Future<dynamic> pauseSession() async {
    dynamic result = await _client.rpcCall<dynamic>('core.pause_session');
    return result;
  }

  Future<dynamic> resumeSession() async {
    dynamic result = await _client.rpcCall<dynamic>('core.resume_session');
    return result;
  }

  Future<String> addTorrentFile(
      String fileName, String fileDump, Map<String, Object> options) async {
    String result = await _client.rpcCall<String>(
        'core.add_torrent_file', [fileName, fileDump, options]);
    var result2 = result;
    return result2;
  }

  Future<String> addTorrentUrl(String url, Map<String, Object> options) async {
    String result =
        await _client.rpcCall<String>('core.add_torrent_url', [url, options]);
    var result2 = result;
    return result2;
  }

  Future<String> addTorrentMagnet(
      String magnet, Map<String, Object> options) async {
    String result = await _client
        .rpcCall<String>('core.add_torrent_magnet', [magnet, options]);
    var result2 = result;
    return result2;
  }

  Future<bool> removeTorrent(String torrentId, bool removeData) async {
    bool result = await _client
        .rpcCall<bool>('core.remove_torrent', [torrentId, removeData]);
    var result2 = result;
    return result2;
  }

  Future<List<Object>> removeTorrents(
      List<String> torrentIds, bool removeData) async {
    List<Object> result = await _client.rpcCall<List<Object>>(
        'core.remove_torrents', [torrentIds, removeData]);
    var result2 = result.cast<Object>();
    return result2;
  }

  Future<dynamic> pauseTorrents(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.pause_torrent', [torrentIds]);
    return result;
  }

  Future<dynamic> resumeTorrents(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.resume_torrent', [torrentIds]);
    return result;
  }

  Future<dynamic> forceRecheck(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.force_recheck', [torrentIds]);
    return result;
  }

  Future<dynamic> forceReAnnounce(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.force_reannounce', [torrentIds]);
    return result;
  }

  Future<bool> moveStorage(List<String> torrentIds, String destination) async {
    bool result = await _client
        .rpcCall<bool>('core.move_storage', [torrentIds, destination]);
    var result2 = result;
    return result2;
  }

  Future<dynamic> renameTorrentFiles(
      String torrentId, List<List<dynamic>> fileNames) async {
    dynamic result = await _client
        .rpcCall<dynamic>('core.rename_files', [torrentId, fileNames]);
    return result;
  }

  Future<dynamic> renameTorrentFolder(
      String torrentId, String oldName, String newName) async {
    dynamic result = await _client
        .rpcCall<dynamic>('core.rename_folder', [torrentId, oldName, newName]);
    return result;
  }

  Future<dynamic> setTorrentOptions(
      List<String> torrentIds, Map<dynamic, dynamic> options) async {
    dynamic result = await _client
        .rpcCall<dynamic>('core.set_torrent_options', [torrentIds, options]);
    return result;
  }

  Future<dynamic> setTorrentTrackers(
      String torrentId, List<Map<dynamic, dynamic>> trackers) async {
    dynamic result = await _client
        .rpcCall<dynamic>('core.set_torrent_trackers', [torrentId, trackers]);
    return result;
  }

  Future<Response<Map<String, Object>>> getTorrentStatus(
      String torrentId, List<String> keys) async {
    Response<Object> result = await _client.rpcCall<Response<Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    var resultUnwrapped = result.response as Map<Object, Object>;
    var result2 = resultUnwrapped.cast<String, Object>();
    return new Response(result.apiName, result.requestId, result2);
  }

  Future<Response<TorrentDetail>> getTorrentDetails(String torrentId,
      {List<String> keys: torrentDetailKeys}) async {
    Response<Object> result = await _client.rpcCall<Response<Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    var resultUnwrapped = result.response as Map<Object, Object>;
    CustomDeserializer<TorrentDetail> deserializer =
        new CustomDeserializerFactory().createDeserializer(TorrentDetail)
            as CustomDeserializer<TorrentDetail>;
    var result2 = deserializer.deserialize(resultUnwrapped);
    return new Response(result.apiName, result.requestId, result2);
  }

  Future<TorrentFiles> getTorrentFileList(String torrentId,
      {List<String> keys: torrentFilesKeys}) async {
    Map<Object, Object> result = await _client.rpcCall<Map<Object, Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    CustomDeserializer<TorrentFiles> deserializer =
        new CustomDeserializerFactory().createDeserializer(TorrentFiles)
            as CustomDeserializer<TorrentFiles>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  Future<Peers> getTorrentPeers(String torrentId,
      {List<String> keys: peersKeys}) async {
    Map<Object, Object> result = await _client.rpcCall<Map<Object, Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    CustomDeserializer<Peers> deserializer = new CustomDeserializerFactory()
        .createDeserializer(Peers) as CustomDeserializer<Peers>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  Future<TorrentOptions> getTorrentOptions(String torrentId,
      {List<String> keys: torrentOptionsKeys}) async {
    Map<Object, Object> result = await _client.rpcCall<Map<Object, Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    CustomDeserializer<TorrentOptions> deserializer =
        new CustomDeserializerFactory().createDeserializer(TorrentOptions)
            as CustomDeserializer<TorrentOptions>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  Future<Map<String, TorrentListItem>> getTorrentsList(
      Map<String, Object> filterDict,
      {List<String> keys: torrentListItemKeys}) async {
    Map<Object, Object> result = await _client.rpcCall<Map<Object, Object>>(
        'core.get_torrents_status', [filterDict, keys]);
    CustomDeserializer<TorrentListItem> deserializer =
        new CustomDeserializerFactory().createDeserializer(TorrentListItem)
            as CustomDeserializer<TorrentListItem>;
    var result2 = result
        .map((k, v) => new MapEntry(k as String, deserializer.deserialize(v)));
    return result2;
  }

  Future<Map<String, Object>> getTorrentsStatus(
      Map<String, Object> filterDict, List<String> keys) async {
    Map<Object, Object> result = await _client.rpcCall<Map<Object, Object>>(
        'core.get_torrents_status', [filterDict, keys]);
    var result2 = result.cast<String, Object>();
    return result2;
  }

  Future<FilterTree> getFilterTree() async {
    Map<Object, Object> result =
        await _client.rpcCall<Map<Object, Object>>('core.get_filter_tree');
    CustomDeserializer<FilterTree> deserializer =
        new CustomDeserializerFactory().createDeserializer(FilterTree)
            as CustomDeserializer<FilterTree>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  Future<Map<String, Object>> getConfig() async {
    Map<Object, Object> result =
        await _client.rpcCall<Map<Object, Object>>('core.get_config');
    var result2 = result.cast<String, Object>();
    return result2;
  }

  Future<Object> getConfigValue(String key) async {
    Object result =
        await _client.rpcCall<Object>('core.get_config_value', [key]);
    var result2 = result;
    return result2;
  }

  Future<Map<String, Object>> getConfigValues(List<String> keys) async {
    Map<Object, Object> result = await _client
        .rpcCall<Map<Object, Object>>('core.get_config_values', [keys]);
    var result2 = result.cast<String, Object>();
    return result2;
  }

  Future<AddTorrentDefaultOptions> getAddTorrentDefaultOptions(
      {List<String> keys: addTorrentDefaultOptionsKeys}) async {
    Map<Object, Object> result = await _client
        .rpcCall<Map<Object, Object>>('core.get_config_values', [keys]);
    CustomDeserializer<AddTorrentDefaultOptions> deserializer =
        new CustomDeserializerFactory()
                .createDeserializer(AddTorrentDefaultOptions)
            as CustomDeserializer<AddTorrentDefaultOptions>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  Future<dynamic> setConfig(Map<String, Object> config) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.set_config', [config]);
    return result;
  }

  Future<String> getListenPort() async {
    String result = await _client.rpcCall<String>('core.get_listen_port');
    var result2 = result;
    return result2;
  }

  Future<bool> testListenPort() async {
    bool result = await _client.rpcCall<bool>('core.test_listen_port');
    var result2 = result;
    return result2;
  }

  Future<String> getExternalIp() async {
    String result = await _client.rpcCall<String>('core.get_external_ip');
    var result2 = result;
    return result2;
  }

  Future<String> getLibtorrentVersion() async {
    String result =
        await _client.rpcCall<String>('core.get_libtorrent_version');
    var result2 = result;
    return result2;
  }

  Future<Map<String, Object>> getProxySettings() async {
    Map<Object, Object> result =
        await _client.rpcCall<Map<Object, Object>>('core.get_proxy');
    var result2 = result.cast<String, Object>();
    return result2;
  }

  Future<List<String>> getAvailablePlugins() async {
    List<Object> result =
        await _client.rpcCall<List<Object>>('core.get_available_plugins');
    var result2 = result.cast<String>();
    return result2;
  }

  Future<List<String>> getEnabledPlugins() async {
    List<Object> result =
        await _client.rpcCall<List<Object>>('core.get_enabled_plugins');
    var result2 = result.cast<String>();
    return result2;
  }

  Future<bool> enablePlugin(String plugin) async {
    bool result = await _client.rpcCall<bool>('core.enable_plugin', [plugin]);
    var result2 = result;
    return result2;
  }

  Future<bool> disablePlugin(String plugin) async {
    bool result = await _client.rpcCall<bool>('core.disable_plugin', [plugin]);
    var result2 = result;
    return result2;
  }

  Future<dynamic> rescanPlugins() async {
    dynamic result = await _client.rpcCall<dynamic>('core.rescan_plugins');
    return result;
  }

  Future<int> getPathSize(String path) async {
    int result = await _client.rpcCall<int>('core.get_path_size', [path]);
    var result2 = result;
    return result2;
  }

  Future<int> getFreeSpace(String path) async {
    int result = await _client.rpcCall<int>('core.get_free_space', [path]);
    var result2 = result;
    return result2;
  }

  Future<dynamic> queueTop(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.queue_top', [torrentIds]);
    return result;
  }

  Future<dynamic> queueUp(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.queue_up', [torrentIds]);
    return result;
  }

  Future<dynamic> queueDown(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.queue_down', [torrentIds]);
    return result;
  }

  Future<dynamic> queueBottom(List<String> torrentIds) async {
    dynamic result =
        await _client.rpcCall<dynamic>('core.queue_bottom', [torrentIds]);
    return result;
  }

  Future<List<String>> getKnownAccounts() async {
    List<Object> result =
        await _client.rpcCall<List<Object>>('core.get_known_accounts');
    var result2 = result.cast<String>();
    return result2;
  }

  Future<bool> createAccount(
      String username, String password, int authLevel) async {
    bool result = await _client
        .rpcCall<bool>('core.create_account', [username, password, authLevel]);
    var result2 = result;
    return result2;
  }

  Future<bool> updateAccount(
      String username, String password, int authLevel) async {
    bool result = await _client
        .rpcCall<bool>('core.update_account', [username, password, authLevel]);
    var result2 = result;
    return result2;
  }

  Future<bool> deleteAccount(String username) async {
    bool result =
        await _client.rpcCall<bool>('core.remove_account', [username]);
    var result2 = result;
    return result2;
  }

  Future<List<String>> getLabels() async {
    List<Object> result =
        await _client.rpcCall<List<Object>>('label.get_labels');
    var result2 = result.cast<String>();
    return result2;
  }

  Future<dynamic> setTorrentLabel(String torrentId, String label) async {
    dynamic result =
        await _client.rpcCall<dynamic>('label.set_torrent', [torrentId, label]);
    return result;
  }
}
