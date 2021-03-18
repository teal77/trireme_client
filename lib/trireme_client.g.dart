// GENERATED CODE - DO NOT MODIFY BY HAND

part of trireme_client;

// **************************************************************************
// ApiCallGenerator
// **************************************************************************

class _$TriremeClientImpl extends TriremeClient {
  _$TriremeClientImpl(String username, String password, String host, int port,
      List<int>? pinnedCert)
      : super._(username, password, host, port, pinnedCert);
  @override
  Future<bool> _registerForEvents(List<String> events) async {
    var result =
        await _client.rpcCall<bool>('daemon.set_event_interest', [events]);
    var result2 = result;
    return result2;
  }

  @override
  Future<String> daemonInfo() async {
    var result = await _client.rpcCall<String>('daemon.info');
    var result2 = result;
    return result2;
  }

  @override
  Future<List<String>> getSessionState() async {
    var result = await _client.rpcCall<List<Object?>>('core.get_session_state');
    var result2 = result.cast<String>();
    return result2;
  }

  @override
  Future<Response<SessionStatus>> getSessionStatus(
      {List<String> sessionStatusKeys = sessionStatusKeys}) async {
    var result = await _client.rpcCall<Response<Object>>(
        'core.get_session_status', [sessionStatusKeys]);
    var resultUnwrapped = result.response as Map<Object, Object?>;
    var deserializer = CustomDeserializerFactory()
        .createDeserializer(SessionStatus) as CustomDeserializer<SessionStatus>;
    var result2 = deserializer.deserialize(resultUnwrapped);
    return Response(result.apiName, result.requestId, result2);
  }

  @override
  Future<dynamic> pauseSession() async {
    var result = await _client.rpcCall<dynamic>('core.pause_session');
    return result;
  }

  @override
  Future<dynamic> resumeSession() async {
    var result = await _client.rpcCall<dynamic>('core.resume_session');
    return result;
  }

  @override
  Future<String> addTorrentFile(
      String fileName, String fileDump, Map<String, Object> options) async {
    var result = await _client.rpcCall<String>(
        'core.add_torrent_file', [fileName, fileDump, options]);
    var result2 = result;
    return result2;
  }

  @override
  Future<String> addTorrentUrl(String url, Map<String, Object> options) async {
    var result =
        await _client.rpcCall<String>('core.add_torrent_url', [url, options]);
    var result2 = result;
    return result2;
  }

  @override
  Future<String> addTorrentMagnet(
      String magnet, Map<String, Object> options) async {
    var result = await _client
        .rpcCall<String>('core.add_torrent_magnet', [magnet, options]);
    var result2 = result;
    return result2;
  }

  @override
  Future<bool> removeTorrent(String torrentId, bool removeData) async {
    var result = await _client
        .rpcCall<bool>('core.remove_torrent', [torrentId, removeData]);
    var result2 = result;
    return result2;
  }

  @override
  Future<List<Object>> removeTorrents(
      List<String> torrentIds, bool removeData) async {
    var result = await _client.rpcCall<List<Object?>>(
        'core.remove_torrents', [torrentIds, removeData]);
    var result2 = result.cast<Object>();
    return result2;
  }

  @override
  Future<dynamic> pauseTorrents(List<String> torrentIds) async {
    var result =
        await _client.rpcCall<dynamic>('core.pause_torrent', [torrentIds]);
    return result;
  }

  @override
  Future<dynamic> resumeTorrents(List<String> torrentIds) async {
    var result =
        await _client.rpcCall<dynamic>('core.resume_torrent', [torrentIds]);
    return result;
  }

  @override
  Future<dynamic> forceRecheck(List<String> torrentIds) async {
    var result =
        await _client.rpcCall<dynamic>('core.force_recheck', [torrentIds]);
    return result;
  }

  @override
  Future<dynamic> forceReAnnounce(List<String> torrentIds) async {
    var result =
        await _client.rpcCall<dynamic>('core.force_reannounce', [torrentIds]);
    return result;
  }

  @override
  Future<bool> moveStorage(List<String> torrentIds, String destination) async {
    var result = await _client
        .rpcCall<bool>('core.move_storage', [torrentIds, destination]);
    var result2 = result;
    return result2;
  }

  @override
  Future<dynamic> renameTorrentFiles(
      String torrentId, List<List<dynamic>> fileNames) async {
    var result = await _client
        .rpcCall<dynamic>('core.rename_files', [torrentId, fileNames]);
    return result;
  }

  @override
  Future<dynamic> renameTorrentFolder(
      String torrentId, String oldName, String newName) async {
    var result = await _client
        .rpcCall<dynamic>('core.rename_folder', [torrentId, oldName, newName]);
    return result;
  }

  @override
  Future<dynamic> setTorrentOptions(
      List<String> torrentIds, Map<dynamic, dynamic> options) async {
    var result = await _client
        .rpcCall<dynamic>('core.set_torrent_options', [torrentIds, options]);
    return result;
  }

  @override
  Future<dynamic> setTorrentTrackers(
      String torrentId, List<Map<dynamic, dynamic>> trackers) async {
    var result = await _client
        .rpcCall<dynamic>('core.set_torrent_trackers', [torrentId, trackers]);
    return result;
  }

  @override
  Future<Response<Map<String, Object>>> getTorrentStatus(
      String torrentId, List<String> keys) async {
    var result = await _client.rpcCall<Response<Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    var resultUnwrapped = result.response as Map<Object, Object?>;
    var result2 = resultUnwrapped.cast<String, Object>();
    return Response(result.apiName, result.requestId, result2);
  }

  @override
  Future<Response<TorrentDetail>> getTorrentDetails(String torrentId,
      {List<String> keys = torrentDetailKeys}) async {
    var result = await _client.rpcCall<Response<Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    var resultUnwrapped = result.response as Map<Object, Object?>;
    var deserializer = CustomDeserializerFactory()
        .createDeserializer(TorrentDetail) as CustomDeserializer<TorrentDetail>;
    var result2 = deserializer.deserialize(resultUnwrapped);
    return Response(result.apiName, result.requestId, result2);
  }

  @override
  Future<Response<TorrentFiles>> getTorrentFileList(String torrentId,
      {List<String> keys = torrentFilesKeys}) async {
    var result = await _client.rpcCall<Response<Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    var resultUnwrapped = result.response as Map<Object, Object?>;
    var deserializer = CustomDeserializerFactory()
        .createDeserializer(TorrentFiles) as CustomDeserializer<TorrentFiles>;
    var result2 = deserializer.deserialize(resultUnwrapped);
    return Response(result.apiName, result.requestId, result2);
  }

  @override
  Future<Response<Peers>> getTorrentPeers(String torrentId,
      {List<String> keys = peersKeys}) async {
    var result = await _client.rpcCall<Response<Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    var resultUnwrapped = result.response as Map<Object, Object?>;
    var deserializer = CustomDeserializerFactory().createDeserializer(Peers)
        as CustomDeserializer<Peers>;
    var result2 = deserializer.deserialize(resultUnwrapped);
    return Response(result.apiName, result.requestId, result2);
  }

  @override
  Future<Response<TorrentOptions>> getTorrentOptions(String torrentId,
      {List<String> keys = torrentOptionsKeys}) async {
    var result = await _client.rpcCall<Response<Object>>(
        'core.get_torrent_status', [torrentId, keys]);
    var resultUnwrapped = result.response as Map<Object, Object?>;
    var deserializer =
        CustomDeserializerFactory().createDeserializer(TorrentOptions)
            as CustomDeserializer<TorrentOptions>;
    var result2 = deserializer.deserialize(resultUnwrapped);
    return Response(result.apiName, result.requestId, result2);
  }

  @override
  Future<Response<Map<String, TorrentListItem>>> getTorrentsList(
      Map<String, Object> filterDict,
      {List<String> keys = torrentListItemKeys}) async {
    var result = await _client.rpcCall<Response<Object>>(
        'core.get_torrents_status', [filterDict, keys]);
    var resultUnwrapped = result.response as Map<Object, Object?>;
    var deserializer =
        CustomDeserializerFactory().createDeserializer(TorrentListItem)
            as CustomDeserializer<TorrentListItem>;
    var result2 = resultUnwrapped
        .map((k, v) => MapEntry(k as String, deserializer.deserialize(v)));
    return Response(result.apiName, result.requestId, result2);
  }

  @override
  Future<Map<String, Object>> getTorrentsStatus(
      Map<String, Object> filterDict, List<String> keys) async {
    var result = await _client.rpcCall<Map<Object, Object?>>(
        'core.get_torrents_status', [filterDict, keys]);
    var result2 = result.cast<String, Object>();
    return result2;
  }

  @override
  Future<FilterTree> getFilterTree() async {
    var result =
        await _client.rpcCall<Map<Object, Object?>>('core.get_filter_tree');
    var deserializer = CustomDeserializerFactory()
        .createDeserializer(FilterTree) as CustomDeserializer<FilterTree>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  @override
  Future<Map<String, Object>> getConfig() async {
    var result = await _client.rpcCall<Map<Object, Object?>>('core.get_config');
    var result2 = result.cast<String, Object>();
    return result2;
  }

  @override
  Future<Object> getConfigValue(String key) async {
    var result = await _client.rpcCall<Object>('core.get_config_value', [key]);
    var result2 = result;
    return result2;
  }

  @override
  Future<Map<String, Object>> getConfigValues(List<String> keys) async {
    var result = await _client
        .rpcCall<Map<Object, Object?>>('core.get_config_values', [keys]);
    var result2 = result.cast<String, Object>();
    return result2;
  }

  @override
  Future<AddTorrentDefaultOptions> getAddTorrentDefaultOptions(
      {List<String> keys = addTorrentDefaultOptionsKeys}) async {
    var result = await _client
        .rpcCall<Map<Object, Object?>>('core.get_config_values', [keys]);
    var deserializer =
        CustomDeserializerFactory().createDeserializer(AddTorrentDefaultOptions)
            as CustomDeserializer<AddTorrentDefaultOptions>;
    var result2 = deserializer.deserialize(result);
    return result2;
  }

  @override
  Future<dynamic> setConfig(Map<String, Object> config) async {
    var result = await _client.rpcCall<dynamic>('core.set_config', [config]);
    return result;
  }

  @override
  Future<String> getListenPort() async {
    var result = await _client.rpcCall<String>('core.get_listen_port');
    var result2 = result;
    return result2;
  }

  @override
  Future<bool> testListenPort() async {
    var result = await _client.rpcCall<bool>('core.test_listen_port');
    var result2 = result;
    return result2;
  }

  @override
  Future<String> getExternalIp() async {
    var result = await _client.rpcCall<String>('core.get_external_ip');
    var result2 = result;
    return result2;
  }

  @override
  Future<String> getLibtorrentVersion() async {
    var result = await _client.rpcCall<String>('core.get_libtorrent_version');
    var result2 = result;
    return result2;
  }

  @override
  Future<Map<String, Object>> getProxySettings() async {
    var result = await _client.rpcCall<Map<Object, Object?>>('core.get_proxy');
    var result2 = result.cast<String, Object>();
    return result2;
  }

  @override
  Future<List<String>> getAvailablePlugins() async {
    var result =
        await _client.rpcCall<List<Object?>>('core.get_available_plugins');
    var result2 = result.cast<String>();
    return result2;
  }

  @override
  Future<List<String>> getEnabledPlugins() async {
    var result =
        await _client.rpcCall<List<Object?>>('core.get_enabled_plugins');
    var result2 = result.cast<String>();
    return result2;
  }

  @override
  Future<bool> enablePlugin(String plugin) async {
    var result = await _client.rpcCall<bool>('core.enable_plugin', [plugin]);
    var result2 = result;
    return result2;
  }

  @override
  Future<bool> disablePlugin(String plugin) async {
    var result = await _client.rpcCall<bool>('core.disable_plugin', [plugin]);
    var result2 = result;
    return result2;
  }

  @override
  Future<dynamic> rescanPlugins() async {
    var result = await _client.rpcCall<dynamic>('core.rescan_plugins');
    return result;
  }

  @override
  Future<int> getPathSize(String path) async {
    var result = await _client.rpcCall<int>('core.get_path_size', [path]);
    var result2 = result;
    return result2;
  }

  @override
  Future<int> getFreeSpace(String path) async {
    var result = await _client.rpcCall<int>('core.get_free_space', [path]);
    var result2 = result;
    return result2;
  }

  @override
  Future<dynamic> queueTop(List<String> torrentIds) async {
    var result = await _client.rpcCall<dynamic>('core.queue_top', [torrentIds]);
    return result;
  }

  @override
  Future<dynamic> queueUp(List<String> torrentIds) async {
    var result = await _client.rpcCall<dynamic>('core.queue_up', [torrentIds]);
    return result;
  }

  @override
  Future<dynamic> queueDown(List<String> torrentIds) async {
    var result =
        await _client.rpcCall<dynamic>('core.queue_down', [torrentIds]);
    return result;
  }

  @override
  Future<dynamic> queueBottom(List<String> torrentIds) async {
    var result =
        await _client.rpcCall<dynamic>('core.queue_bottom', [torrentIds]);
    return result;
  }

  @override
  Future<List<String>> getKnownAccounts() async {
    var result =
        await _client.rpcCall<List<Object?>>('core.get_known_accounts');
    var result2 = result.cast<String>();
    return result2;
  }

  @override
  Future<bool> createAccount(
      String username, String password, int authLevel) async {
    var result = await _client
        .rpcCall<bool>('core.create_account', [username, password, authLevel]);
    var result2 = result;
    return result2;
  }

  @override
  Future<bool> updateAccount(
      String username, String password, int authLevel) async {
    var result = await _client
        .rpcCall<bool>('core.update_account', [username, password, authLevel]);
    var result2 = result;
    return result2;
  }

  @override
  Future<bool> deleteAccount(String username) async {
    var result = await _client.rpcCall<bool>('core.remove_account', [username]);
    var result2 = result;
    return result2;
  }

  @override
  Future<List<String>> getLabels() async {
    var result = await _client.rpcCall<List<Object?>>('label.get_labels');
    var result2 = result.cast<String>();
    return result2;
  }

  @override
  Future<dynamic> setTorrentLabel(String torrentId, String label) async {
    var result =
        await _client.rpcCall<dynamic>('label.set_torrent', [torrentId, label]);
    return result;
  }
}
