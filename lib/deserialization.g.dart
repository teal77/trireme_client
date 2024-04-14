// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deserialization.dart';

// **************************************************************************
// DeserializationGenerator
// **************************************************************************

class $TorrentListItemCustomDeserializer
    extends CustomDeserializer<TorrentListItem> {
  @override
  TorrentListItem deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = TorrentListItem();
    item.name = map['name'] as String;
    item.state = map['state'] as String;
    item.progress = map['progress'] as double;
    item.downloadSpeed = map['download_payload_rate'] as int;
    item.uploadSpeed = map['upload_payload_rate'] as int;
    item.eta = map['eta'] as num;
    item.totalSize = map['total_wanted'] as int;
    item.totalDone = map['total_done'] as int;
    item.totalUploaded = map['total_uploaded'] as int;
    item.isFinished = map['is_finished'] as bool;
    item.ratio = map['ratio'] as double;
    item.timeAdded = map['time_added'] as num;
    item.timeCompleted = map['completed_time'] as num?;
    item.timeSeeding = map['seeding_time'] as int;
    item.label = map['label'] as String?;
    item.trackerHost = map['tracker_host'] as String;
    return item;
  }
}

const torrentListItemKeys = [
  'name',
  'state',
  'progress',
  'download_payload_rate',
  'upload_payload_rate',
  'eta',
  'total_wanted',
  'total_done',
  'total_uploaded',
  'is_finished',
  'ratio',
  'time_added',
  'completed_time',
  'seeding_time',
  'label',
  'tracker_host',
];

class $SessionStatusCustomDeserializer
    extends CustomDeserializer<SessionStatus> {
  @override
  SessionStatus deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = SessionStatus();
    item.totalUploadRate = map['upload_rate'] as num;
    item.totalDownloadRate = map['download_rate'] as num;
    item.payloadUploadRate = map['payload_upload_rate'] as num;
    item.payloadDownloadRate = map['payload_download_rate'] as num;
    return item;
  }
}

const sessionStatusKeys = [
  'upload_rate',
  'download_rate',
  'payload_upload_rate',
  'payload_download_rate',
];

class $FilterTreeCustomDeserializer extends CustomDeserializer<FilterTree> {
  @override
  FilterTree deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = FilterTree();
    item.statusFilters = (map['state'] as List? ?? List.empty()).cast<Object>();
    item.labelFilters = (map['label'] as List? ?? List.empty()).cast<Object>();
    item.trackerFilters =
        (map['tracker_host'] as List? ?? List.empty()).cast<Object>();
    return item;
  }
}

const filterTreeKeys = [
  'state',
  'label',
  'tracker_host',
];

class $TorrentDetailCustomDeserializer
    extends CustomDeserializer<TorrentDetail> {
  @override
  TorrentDetail deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = TorrentDetail();
    item.name = map['name'] as String;
    item.hash = map['hash'] as String;
    item.comment = map['comment'] as String;
    item.label = map['label'] as String?;
    item.files = map['num_files'] as int;
    item.activeTime = map['active_time'] as int;
    item.seedingTime = map['seeding_time'] as int;
    item.addedTime = map['time_added'] as num;
    item.timeCompleted = map['completed_time'] as num?;
    item.private = map['private'] as bool;
    item.uploadedInThisSession = map['total_payload_upload'] as int;
    item.totalUploaded = map['total_uploaded'] as int;
    item.downloadedInThisSesssion = map['total_payload_download'] as int;
    item.totalDownloaded = map['all_time_download'] as int;
    item.totalSize = map['total_size'] as int;
    item.totalWanted = map['total_wanted'] as int;
    item.totalDone = map['total_done'] as int;
    item.downloadPayloadRate = map['download_payload_rate'] as int;
    item.uploadPayloadRate = map['upload_payload_rate'] as int;
    item.tracker = map['tracker'] as String;
    item.message = map['message'] as String;
    item.trackerStatus = map['tracker_status'] as String;
    item.eta = map['eta'] as num;
    item.ratio = map['ratio'] as double;
    item.path = map['save_path'] as String;
    item.trackerHost = map['tracker_host'] as String;
    item.pieces = map['num_pieces'] as int;
    item.pieceLength = map['piece_length'] as int;
    item.totalSeeds = map['total_seeds'] as int;
    item.connectedSeeds = map['num_seeds'] as int;
    item.totalPeers = map['total_peers'] as int;
    item.connectedPeers = map['num_peers'] as int;
    item.isAutoManaged = map['is_auto_managed'] as bool;
    item.isFinished = map['is_finished'] as bool;
    item.state = map['state'] as String;
    item.progress = map['progress'] as double;
    item.seedRank = map['seed_rank'] as int;
    item.nextAnnounce = map['next_announce'] as int;
    item.seedsPeersRatio = map['seeds_peers_ratio'] as double;
    item.distributedCopies = map['distributed_copies'] as double;
    return item;
  }
}

const torrentDetailKeys = [
  'name',
  'hash',
  'comment',
  'label',
  'num_files',
  'active_time',
  'seeding_time',
  'time_added',
  'completed_time',
  'private',
  'total_payload_upload',
  'total_uploaded',
  'total_payload_download',
  'all_time_download',
  'total_size',
  'total_wanted',
  'total_done',
  'download_payload_rate',
  'upload_payload_rate',
  'tracker',
  'message',
  'tracker_status',
  'eta',
  'ratio',
  'save_path',
  'tracker_host',
  'num_pieces',
  'piece_length',
  'total_seeds',
  'num_seeds',
  'total_peers',
  'num_peers',
  'is_auto_managed',
  'is_finished',
  'state',
  'progress',
  'seed_rank',
  'next_announce',
  'seeds_peers_ratio',
  'distributed_copies',
];

class $TorrentFilesCustomDeserializer extends CustomDeserializer<TorrentFiles> {
  @override
  TorrentFiles deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = TorrentFiles();
    item.filePriorities =
        (map['file_priorities'] as List? ?? List.empty()).cast<int>();
    item.fileProgress =
        (map['file_progress'] as List? ?? List.empty()).cast<double>();
    var deserializer = CustomDeserializerFactory()
        .createDeserializer(TorrentFile) as CustomDeserializer<TorrentFile>;
    item.files = (map['files'] as List<Object?>)
        .map((e) => deserializer.deserialize(e))
        .toList();
    return item;
  }
}

const torrentFilesKeys = [
  'file_priorities',
  'file_progress',
  'files',
];

class $TorrentFileCustomDeserializer extends CustomDeserializer<TorrentFile> {
  @override
  TorrentFile deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = TorrentFile();
    item.index = map['index'] as int;
    item.size = map['size'] as int;
    item.offset = map['offset'] as int;
    item.path = map['path'] as String;
    return item;
  }
}

const torrentFileKeys = [
  'index',
  'size',
  'offset',
  'path',
];

class $PeersCustomDeserializer extends CustomDeserializer<Peers> {
  @override
  Peers deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = Peers();
    var deserializer = CustomDeserializerFactory().createDeserializer(Peer)
        as CustomDeserializer<Peer>;
    item.peers = (map['peers'] as List<Object?>)
        .map((e) => deserializer.deserialize(e))
        .toList();
    return item;
  }
}

const peersKeys = [
  'peers',
];

class $PeerCustomDeserializer extends CustomDeserializer<Peer> {
  @override
  Peer deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = Peer();
    item.downSpeed = map['down_speed'] as int;
    item.upSpeed = map['up_speed'] as int;
    item.country = map['country'] as String;
    item.client = map['client'] as String;
    item.ip = map['ip'] as String;
    item.progress = map['progress'] as double;
    item.seed = map['seed'] as int;
    return item;
  }
}

const peerKeys = [
  'down_speed',
  'up_speed',
  'country',
  'client',
  'ip',
  'progress',
  'seed',
];

class $TorrentOptionsCustomDeserializer
    extends CustomDeserializer<TorrentOptions> {
  @override
  TorrentOptions deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = TorrentOptions();
    item.isAutoManaged = map['is_auto_managed'] as bool;
    item.prioritizeFirstLast = map['prioritize_first_last'] as bool;
    item.maxConnections = map['max_connections'] as int;
    item.maxUploadSlots = map['max_upload_slots'] as int;
    item.maxUploadSpeed = map['max_upload_speed'] as num;
    item.maxDownloadSpeed = map['max_download_speed'] as num;
    item.stopAtRatio = map['stop_at_ratio'] as bool;
    item.removeAtRatio = map['remove_at_ratio'] as bool;
    item.stopRatio = map['stop_ratio'] as num;
    item.moveCompleted = map['move_completed'] as bool;
    item.moveCompletedPath = map['move_completed_path'] as String;
    var deserializer = CustomDeserializerFactory().createDeserializer(Tracker)
        as CustomDeserializer<Tracker>;
    item.trackers = (map['trackers'] as List<Object?>)
        .map((e) => deserializer.deserialize(e))
        .toList();
    return item;
  }
}

const torrentOptionsKeys = [
  'is_auto_managed',
  'prioritize_first_last',
  'max_connections',
  'max_upload_slots',
  'max_upload_speed',
  'max_download_speed',
  'stop_at_ratio',
  'remove_at_ratio',
  'stop_ratio',
  'move_completed',
  'move_completed_path',
  'trackers',
];

class $TrackerCustomDeserializer extends CustomDeserializer<Tracker> {
  @override
  Tracker deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = Tracker();
    item.sendStats = map['send_stats'] as bool;
    item.fails = map['fails'] as int;
    item.verified = map['verified'] as bool;
    item.url = map['url'] as String;
    item.failLimit = map['fail_limit'] as int;
    item.completeSent = map['complete_sent'] as bool;
    item.source = map['source'] as int;
    item.startSent = map['start_sent'] as bool;
    item.tier = map['tier'] as int;
    item.updating = map['updating'] as bool;
    return item;
  }
}

const trackerKeys = [
  'send_stats',
  'fails',
  'verified',
  'url',
  'fail_limit',
  'complete_sent',
  'source',
  'start_sent',
  'tier',
  'updating',
];

class $AddTorrentDefaultOptionsCustomDeserializer
    extends CustomDeserializer<AddTorrentDefaultOptions> {
  @override
  AddTorrentDefaultOptions deserialize(Object? o) {
    var oAsMap = (o as Map<Object, Object?>);
    var map = oAsMap.cast<String, Object?>();
    var item = AddTorrentDefaultOptions();
    item.downloadPath = map['download_location'] as String;
    item.moveCompleted = map['move_completed'] as bool;
    item.moveCompletedPath = map['move_completed_path'] as String;
    item.downloadSpeedLimit = map['max_download_speed_per_torrent'] as num;
    item.uploadSpeedLimit = map['max_upload_speed_per_torrent'] as num;
    item.connectionsLimit = map['max_connections_per_torrent'] as num;
    item.uploadSlotsLimit = map['max_upload_slots_per_torrent'] as num;
    item.addPaused = map['add_paused'] as bool;
    item.prioritiseFirstLastPieces =
        map['prioritize_first_last_pieces'] as bool;
    return item;
  }
}

const addTorrentDefaultOptionsKeys = [
  'download_location',
  'move_completed',
  'move_completed_path',
  'max_download_speed_per_torrent',
  'max_upload_speed_per_torrent',
  'max_connections_per_torrent',
  'max_upload_slots_per_torrent',
  'add_paused',
  'prioritize_first_last_pieces',
];

// **************************************************************************
// DeserializationFactoryGenerator
// **************************************************************************

class $CustomDeserializerFactoryImpl extends CustomDeserializerFactory {
  $CustomDeserializerFactoryImpl() : super._();
  @override
  CustomDeserializer createDeserializer(Type modelClass) {
    switch (modelClass) {
      case TorrentListItem:
        return $TorrentListItemCustomDeserializer();
      case SessionStatus:
        return $SessionStatusCustomDeserializer();
      case FilterTree:
        return $FilterTreeCustomDeserializer();
      case TorrentDetail:
        return $TorrentDetailCustomDeserializer();
      case TorrentFiles:
        return $TorrentFilesCustomDeserializer();
      case TorrentFile:
        return $TorrentFileCustomDeserializer();
      case Peers:
        return $PeersCustomDeserializer();
      case Peer:
        return $PeerCustomDeserializer();
      case TorrentOptions:
        return $TorrentOptionsCustomDeserializer();
      case Tracker:
        return $TrackerCustomDeserializer();
      case AddTorrentDefaultOptions:
        return $AddTorrentDefaultOptionsCustomDeserializer();
    }
    throw 'Unsupported type $modelClass';
  }
}
