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

import 'package:test/test.dart';

import 'package:trireme_client/trireme_client.dart';

import 'config.dart';

void main() {
  TriremeClient client;

  setUp(() async {
    client = new TriremeClient(username, password, host);
    await client.init();
  });

  test("Test", () async {
    Object res = await client.daemonInfo();
    print(res);
    var torrents = await client.getSessionState();
    var tid = torrents.isEmpty ? "" : torrents[0];
    print(torrents);
    res = await client.getSessionStatus();
    print(res);
    res = await client.getTorrentsList({"state" : "Seeding"});
    print(res);
    res = await client.getFilterTree();
    print(res);
    res = await client.getTorrentStatus(tid, []);
    print(res);
    res = await client.getTorrentDetails(tid);
    print(res);
    res = await client.getTorrentOptions(tid);
    print(res);
    res = await client.getConfig();
    print(res);
  });

  tearDown(() {
    client.dispose();
  });
}
