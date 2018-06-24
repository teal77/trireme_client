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

List<String> fullEventList = [
  "TorrentAddedEvent",
  "TorrentRemovedEvent",
  "PreTorrentRemovedEvent",
  "TorrentStateChangedEvent",
  "TorrentTrackerStatusEvent",
  "TorrentQueueChangedEvent",
  "TorrentFolderRenamedEvent",
  "TorrentFileRenamedEvent",
  "TorrentFinishedEvent",
  "TorrentResumedEvent",
  "TorrentFileCompletedEvent",
  "TorrentStorageMovedEvent",
  "SessionPausedEvent",
  "SessionResumedEvent",
  "ConfigValueChangedEvent",
  "ExternalIpEvent"
];

abstract class DelugeRpcEvent {
  factory DelugeRpcEvent(String name, List<Object> args) {
    switch (name) {
      case "TorrentAddedEvent":
        return new TorrentAddedEvent(args[0] as String);
      case "TorrentRemovedEvent":
        return new TorrentRemovedEvent(args[0] as String);
      case "PreTorrentRemovedEvent":
        return new PreTorrentRemovedEvent(args[0] as String);
      case "TorrentStateChangedEvent":
        return new TorrentStateChangedEvent(args[0] as String, args[1] as String);
      case "TorrentTrackerStatusEvent":
        return new TorrentTrackerStatusEvent(args[0] as String, args[1] as String);
      case "TorrentQueueChangedEvent":
        return new TorrentQueueChangedEvent();
      case "TorrentFolderRenamedEvent":
        return new TorrentFolderRenamedEvent(args[0] as String, args[1] as String, args[2] as String);
      case "TorrentFileRenamedEvent":
        return new TorrentFileRenamedEvent(args[0] as String, args[1] as int, args[2] as String);
      case "TorrentFinishedEvent":
        return new TorrentFinishedEvent(args[0] as String);
      case "TorrentResumedEvent":
        return new TorrentResumedEvent(args[0] as String);
      case "TorrentFileCompletedEvent":
        return new TorrentFileCompletedEvent(args[0] as String, args[1] as int);
      case "TorrentStorageMovedEvent":
        return new TorrentStorageMovedEvent(args[0] as String, args[1] as String);
      case "SessionPausedEvent":
        return new SessionPausedEvent();
      case "SessionResumedEvent":
        return new SessionResumedEvent();
      case "ConfigValueChangedEvent":
        return new ConfigValueChangedEvent(args[0] as String, args[1]);
      case "ExternalIpEvent":
        return new ExternalIpEvent(args[0] as String);
      default: throw "No event class for $name";
    }
  }
}

class TorrentAddedEvent implements DelugeRpcEvent {
  final String torrentId;

  TorrentAddedEvent(this.torrentId);
}

class TorrentRemovedEvent implements DelugeRpcEvent {
  final String torrentId;

  TorrentRemovedEvent(this.torrentId);
}

class PreTorrentRemovedEvent implements DelugeRpcEvent {
  final String torrentId;

  PreTorrentRemovedEvent(this.torrentId);
}

class TorrentStateChangedEvent implements DelugeRpcEvent {
  final String torrentId;
  final String newState;

  TorrentStateChangedEvent(this.torrentId, this.newState);
}

class TorrentTrackerStatusEvent implements DelugeRpcEvent {
  final String torrentId;
  final String newStatus;

  TorrentTrackerStatusEvent(this.torrentId, this.newStatus);
}

class TorrentQueueChangedEvent implements DelugeRpcEvent {}

class TorrentFolderRenamedEvent implements DelugeRpcEvent {
  final String torrentId;
  final String oldFolder;
  final String newFolder;

  TorrentFolderRenamedEvent(this.torrentId, this.oldFolder, this.newFolder);
}

class TorrentFileRenamedEvent implements DelugeRpcEvent {
  final String torrentId;
  final int fileIndex;
  final String newFileName;

  TorrentFileRenamedEvent(this.torrentId, this.fileIndex, this.newFileName);
}

class TorrentFinishedEvent implements DelugeRpcEvent {
  final String torrentId;

  TorrentFinishedEvent(this.torrentId);
}

class TorrentResumedEvent implements DelugeRpcEvent {
  final String torrentId;

  TorrentResumedEvent(this.torrentId);
}

class TorrentFileCompletedEvent implements DelugeRpcEvent {
  final String torrentId;
  final int fileIndex;

  TorrentFileCompletedEvent(this.torrentId, this.fileIndex);
}

class TorrentStorageMovedEvent implements DelugeRpcEvent {
  final String torrentId;
  final String path;

  TorrentStorageMovedEvent(this.torrentId, this.path);
}

class SessionPausedEvent implements DelugeRpcEvent {}

class SessionResumedEvent implements DelugeRpcEvent {}

class ConfigValueChangedEvent implements DelugeRpcEvent {
  final String key;
  final Object value;

  ConfigValueChangedEvent(this.key, this.value);
}

class ExternalIpEvent implements DelugeRpcEvent {
  final String newIp;

  ExternalIpEvent(this.newIp);
}
