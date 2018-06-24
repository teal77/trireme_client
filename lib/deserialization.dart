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

library trireme_deserialization;

part 'deserialization.g.dart';

abstract class CustomDeserializer<T> {
  T deserialize(Object o);
}

abstract class CustomDeserializerFactory {
  CustomDeserializer createDeserializer(Type modelClass);

  factory CustomDeserializerFactory() {
    return new $CustomDeserializerFactoryImpl();
  }

  CustomDeserializerFactory._();
}

class MapKey {
  final String key;

  const MapKey(this.key);
}

class CustomDeserialize {
  const CustomDeserialize();
}

const customDeserialize = const CustomDeserialize();

class Exclude {
  const Exclude();
}

const exclude = const Exclude();

@customDeserialize
class TorrentListItem {
  String name;

  String state;

  double progress;

  @MapKey("download_payload_rate")
  int downloadSpeed;

  @MapKey("upload_payload_rate")
  int uploadSpeed;

  num eta;

  @MapKey("total_wanted")
  int totalSize;

  @MapKey("total_done")
  int totalDone;

  @MapKey("total_uploaded")
  int totalUploaded;

  @MapKey("is_finished")
  bool isFinished;

  double ratio;

  @MapKey("time_added")
  num timeAdded;

  @MapKey("completed_time")
  num timeCompleted;

  @MapKey("seeding_time")
  int timeSeeding;

  String label;

  @MapKey("tracker_host")
  String trackerHost;

  @override
  String toString() {
    return 'TorrentListItem{name: $name, state: $state, progress: $progress, downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, eta: $eta, totalSize: $totalSize, totalDone: $totalDone, totalUploaded: $totalUploaded, isFinished: $isFinished, ratio: $ratio, timeAdded: $timeAdded, timeCompleted: $timeCompleted, timeSeeding: $timeSeeding, label: $label, tackerHost: $trackerHost}';
  }
}

@customDeserialize
class SessionStatus {
  @MapKey("upload_rate")
  num totalUploadRate;

  @MapKey("download_rate")
  num totalDownloadRate;

  @MapKey("payload_upload_rate")
  num payloadUploadRate;

  @MapKey("payload_download_rate")
  num payloadDownloadRate;

  @override
  String toString() {
    return 'SessionStatus{totalUploadRate: $totalUploadRate, totalDownloadRate: $totalDownloadRate, payloadUploadRate: $payloadUploadRate, payloadDownloadRate: $payloadDownloadRate}';
  }
}

@customDeserialize
class FilterTree {
  @MapKey("state")
  List<Object> statusFilters;

  @MapKey("label")
  List<Object> labelFilters;

  @MapKey("tracker_host")
  List<Object> trackerFilters;
}

@customDeserialize
class TorrentDetail {
  String name;

  String hash;

  String comment;

  String label;

  @MapKey("num_files")
  int files;

  @MapKey("active_time")
  int activeTime;

  @MapKey("seeding_time")
  int seedingTime;

  @MapKey("time_added")
  num addedTime;

  bool private;

  @MapKey("total_payload_upload")
  int uploadedInThisSession;

  @MapKey("total_uploaded")
  int totalUploaded;

  @MapKey("total_payload_download")
  int downloadedInThisSesssion;

  @MapKey("all_time_download")
  int totalDownloaded;

  @MapKey("total_size")
  int totalSize;

  @MapKey("total_wanted")
  int totalWanted;

  @MapKey("total_done")
  int totalDone;

  @MapKey("download_payload_rate")
  int downloadPayloadRate;

  @MapKey("upload_payload_rate")
  int uploadPayloadRate;

  String tracker;

  String message;

  @MapKey("tracker_status")
  String trackerStatus;

  num eta;

  double ratio;

  @MapKey("save_path")
  String path;

  @MapKey("tracker_host")
  String trackerHost;

  @MapKey("num_pieces")
  int pieces;

  @MapKey("piece_length")
  int pieceLength;

  @MapKey("total_seeds")
  int totalSeeds;

  @MapKey("num_seeds")
  int connectedSeeds;

  @MapKey("total_peers")
  int totalPeers;

  @MapKey("num_peers")
  int connectedPeers;

  @MapKey("is_auto_managed")
  bool isAutoManaged;

  @MapKey("is_finished")
  bool isFinished;

  String state;

  double progress;

  @MapKey("seed_rank")
  int seedRank;

  @MapKey("next_announce")
  int nextAnnounce;

  @MapKey("seeds_peers_ratio")
  double seedsPeersRatio;

  @MapKey("distributed_copies")
  double distributedCopies;

  @override
  String toString() {
    return 'TorrentDetail{name: $name, hash: $hash, comment: $comment, label: $label, files: $files, activeTime: $activeTime, seedingTime: $seedingTime, addedTime: $addedTime, private: $private, uploadedInThisSession: $uploadedInThisSession, totalUploaded: $totalUploaded, downloadedInThisSesssion: $downloadedInThisSesssion, totalDownloaded: $totalDownloaded, totalSize: $totalSize, totalWanted: $totalWanted, totalDone: $totalDone, downloadPayloadRate: $downloadPayloadRate, uploadPayloadRate: $uploadPayloadRate, tracker: $tracker, message: $message, trackerStatus: $trackerStatus, eta: $eta, ratio: $ratio, path: $path, trackerHost: $trackerHost, pieces: $pieces, pieceLength: $pieceLength, totalSeeds: $totalSeeds, connectedSeeds: $connectedSeeds, totalPeers: $totalPeers, connectedPeers: $connectedPeers, isAutoManaged: $isAutoManaged, isFinished: $isFinished, state: $state, progress: $progress, seedRank: $seedRank, nextAnnounce: $nextAnnounce, seedsPeersRatio: $seedsPeersRatio, distributedCopies: $distributedCopies}';
  }
}

@customDeserialize
class TorrentFiles {
  @MapKey("file_priorities")
  List<int> filePriorities;

  @MapKey("file_progress")
  List<double> fileProgress;

  List<TorrentFile> files;
}

@customDeserialize
class TorrentFile {
  int index;

  int size;

  int offset;

  String path;
}


@customDeserialize
class Peers {
  List<Peer> peers;
}

@customDeserialize
class Peer {
  @MapKey("down_speed")
  int downSpeed;

  @MapKey("up_speed")
  int upSpeed;

  String country;

  String client;

  String ip;

  double progress;

  int seed;
}

@customDeserialize
class TorrentOptions {
  @MapKey("is_auto_managed")
  bool isAutoManaged;

  @MapKey("prioritize_first_last")
  bool prioritizeFirstLast;

  @MapKey("max_connections")
  int maxConnections;

  @MapKey("max_upload_slots")
  int maxUploadSlots;

  @MapKey("max_upload_speed")
  num maxUploadSpeed;

  @MapKey("max_download_speed")
  num maxDownloadSpeed;

  @MapKey("stop_at_ratio")
  bool stopAtRatio;

  @MapKey("remove_at_ratio")
  bool removeAtRatio;

  @MapKey("stop_ratio")
  num stopRatio;

  @MapKey("move_completed")
  bool moveCompleted;

  @MapKey("move_completed_path")
  String moveCompletedPath;

  List<Tracker> trackers;
}

@customDeserialize
class Tracker {
  @MapKey("send_stats")
  bool sendStats;

  int fails;

  bool verified;

  String url;

  @MapKey("fail_limit")
  int failLimit;

  @MapKey("complete_sent")
  bool completeSent;

  int source;

  @MapKey("start_sent")
  bool startSent;

  int tier;

  bool updating;
}

@customDeserialize
class AddTorrentDefaultOptions {
  @MapKey("download_location")
  String downloadPath;

  @MapKey("move_completed")
  bool moveCompleted;

  @MapKey("move_completed_path")
  String moveCompletedPath;

  @MapKey("max_download_speed_per_torrent")
  num downloadSpeedLimit;

  @MapKey("max_upload_speed_per_torrent")
  num uploadSpeedLimit;

  @MapKey("max_connections_per_torrent")
  num connectionsLimit;

  @MapKey("max_upload_slots_per_torrent")
  num uploadSlotsLimit;

  @MapKey("add_paused")
  bool addPaused;

  @MapKey("prioritize_first_last_pieces")
  bool prioritiseFirstLastPieces;
}