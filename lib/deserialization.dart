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
  T deserialize(Object? o);
}

abstract class CustomDeserializerFactory {
  CustomDeserializer createDeserializer(Type modelClass);

  factory CustomDeserializerFactory() {
    return $CustomDeserializerFactoryImpl();
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

const customDeserialize = CustomDeserialize();

class Exclude {
  const Exclude();
}

const exclude = Exclude();

@customDeserialize
class TorrentListItem {
  late String name;

  late String state;

  late double progress;

  @MapKey('download_payload_rate')
  late int downloadSpeed;

  @MapKey('upload_payload_rate')
  late int uploadSpeed;

  late num eta;

  @MapKey('total_wanted')
  late int totalSize;

  @MapKey('total_done')
  late int totalDone;

  @MapKey('total_uploaded')
  late int totalUploaded;

  @MapKey('is_finished')
  late bool isFinished;

  late double ratio;

  @MapKey('time_added')
  late num timeAdded;

  @MapKey('completed_time')
  late num timeCompleted;

  @MapKey('seeding_time')
  late int timeSeeding;

  late String label;

  @MapKey('tracker_host')
  late String trackerHost;

  @override
  String toString() {
    return 'TorrentListItem{name: $name, state: $state, progress: $progress, downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, eta: $eta, totalSize: $totalSize, totalDone: $totalDone, totalUploaded: $totalUploaded, isFinished: $isFinished, ratio: $ratio, timeAdded: $timeAdded, timeCompleted: $timeCompleted, timeSeeding: $timeSeeding, label: $label, tackerHost: $trackerHost}';
  }
}

@customDeserialize
class SessionStatus {
  @MapKey('upload_rate')
  late num totalUploadRate;

  @MapKey('download_rate')
  late num totalDownloadRate;

  @MapKey('payload_upload_rate')
  late num payloadUploadRate;

  @MapKey('payload_download_rate')
  late num payloadDownloadRate;

  @override
  String toString() {
    return 'SessionStatus{totalUploadRate: $totalUploadRate, totalDownloadRate: $totalDownloadRate, payloadUploadRate: $payloadUploadRate, payloadDownloadRate: $payloadDownloadRate}';
  }
}

@customDeserialize
class FilterTree {
  @MapKey('state')
  late List<Object> statusFilters;

  @MapKey('label')
  late List<Object> labelFilters;

  @MapKey('tracker_host')
  late List<Object> trackerFilters;
}

@customDeserialize
class TorrentDetail {
  late String name;

  late String hash;

  late String comment;

  late String? label;

  @MapKey('num_files')
  late int files;

  @MapKey('active_time')
  late int activeTime;

  @MapKey('seeding_time')
  late int seedingTime;

  @MapKey('time_added')
  late num addedTime;

  @MapKey('completed_time')
  late num timeCompleted;

  late bool private;

  @MapKey('total_payload_upload')
  late int uploadedInThisSession;

  @MapKey('total_uploaded')
  late int totalUploaded;

  @MapKey('total_payload_download')
  late int downloadedInThisSesssion;

  @MapKey('all_time_download')
  late int totalDownloaded;

  @MapKey('total_size')
  late int totalSize;

  @MapKey('total_wanted')
  late int totalWanted;

  @MapKey('total_done')
  late int totalDone;

  @MapKey('download_payload_rate')
  late int downloadPayloadRate;

  @MapKey('upload_payload_rate')
  late int uploadPayloadRate;

  late String tracker;

  late String message;

  @MapKey('tracker_status')
  late String trackerStatus;

  late num eta;

  late double ratio;

  @MapKey('save_path')
  late String path;

  @MapKey('tracker_host')
  late String trackerHost;

  @MapKey('num_pieces')
  late int pieces;

  @MapKey('piece_length')
  late int pieceLength;

  @MapKey('total_seeds')
  late int totalSeeds;

  @MapKey('num_seeds')
  late int connectedSeeds;

  @MapKey('total_peers')
  late int totalPeers;

  @MapKey('num_peers')
  late int connectedPeers;

  @MapKey('is_auto_managed')
  late bool isAutoManaged;

  @MapKey('is_finished')
  late bool isFinished;

  late String state;

  late double progress;

  @MapKey('seed_rank')
  late int seedRank;

  @MapKey('next_announce')
  late int nextAnnounce;

  @MapKey('seeds_peers_ratio')
  late double seedsPeersRatio;

  @MapKey('distributed_copies')
  late double distributedCopies;

  @override
  String toString() {
    return 'TorrentDetail{name: $name, hash: $hash, comment: $comment, label: $label, files: $files, activeTime: $activeTime, seedingTime: $seedingTime, addedTime: $addedTime, private: $private, uploadedInThisSession: $uploadedInThisSession, totalUploaded: $totalUploaded, downloadedInThisSesssion: $downloadedInThisSesssion, totalDownloaded: $totalDownloaded, totalSize: $totalSize, totalWanted: $totalWanted, totalDone: $totalDone, downloadPayloadRate: $downloadPayloadRate, uploadPayloadRate: $uploadPayloadRate, tracker: $tracker, message: $message, trackerStatus: $trackerStatus, eta: $eta, ratio: $ratio, path: $path, trackerHost: $trackerHost, pieces: $pieces, pieceLength: $pieceLength, totalSeeds: $totalSeeds, connectedSeeds: $connectedSeeds, totalPeers: $totalPeers, connectedPeers: $connectedPeers, isAutoManaged: $isAutoManaged, isFinished: $isFinished, state: $state, progress: $progress, seedRank: $seedRank, nextAnnounce: $nextAnnounce, seedsPeersRatio: $seedsPeersRatio, distributedCopies: $distributedCopies}';
  }
}

@customDeserialize
class TorrentFiles {
  @MapKey('file_priorities')
  late List<int> filePriorities;

  @MapKey('file_progress')
  late List<double> fileProgress;

  late List<TorrentFile> files;
}

@customDeserialize
class TorrentFile {
  late int index;

  late int size;

  late int offset;

  late String path;
}


@customDeserialize
class Peers {
  late List<Peer> peers;
}

@customDeserialize
class Peer {
  @MapKey('down_speed')
  late int downSpeed;

  @MapKey('up_speed')
  late int upSpeed;

  late String country;

  late String client;

  late String ip;

  late double progress;

  late int seed;
}

@customDeserialize
class TorrentOptions {
  @MapKey('is_auto_managed')
  late bool isAutoManaged;

  @MapKey('prioritize_first_last')
  late bool prioritizeFirstLast;

  @MapKey('max_connections')
  late int maxConnections;

  @MapKey('max_upload_slots')
  late int maxUploadSlots;

  @MapKey('max_upload_speed')
  late num maxUploadSpeed;

  @MapKey('max_download_speed')
  late num maxDownloadSpeed;

  @MapKey('stop_at_ratio')
  late bool stopAtRatio;

  @MapKey('remove_at_ratio')
  late bool removeAtRatio;

  @MapKey('stop_ratio')
  late num stopRatio;

  @MapKey('move_completed')
  late bool moveCompleted;

  @MapKey('move_completed_path')
  late String moveCompletedPath;

  late List<Tracker> trackers;
}

@customDeserialize
class Tracker {
  @MapKey('send_stats')
  late bool sendStats;

  late int fails;

  late bool verified;

  late String url;

  @MapKey('fail_limit')
  late int failLimit;

  @MapKey('complete_sent')
  late bool completeSent;

  late int source;

  @MapKey('start_sent')
  late bool startSent;

  late int tier;

  late bool updating;
}

@customDeserialize
class AddTorrentDefaultOptions {
  @MapKey('download_location')
  late String downloadPath;

  @MapKey('move_completed')
  late bool moveCompleted;

  @MapKey('move_completed_path')
  late String moveCompletedPath;

  @MapKey('max_download_speed_per_torrent')
  late num downloadSpeedLimit;

  @MapKey('max_upload_speed_per_torrent')
  late num uploadSpeedLimit;

  @MapKey('max_connections_per_torrent')
  late num connectionsLimit;

  @MapKey('max_upload_slots_per_torrent')
  late num uploadSlotsLimit;

  @MapKey('add_paused')
  late bool addPaused;

  @MapKey('prioritize_first_last_pieces')
  late bool prioritiseFirstLastPieces;
}