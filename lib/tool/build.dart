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

import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';

import 'api_call_generator.dart';
import 'deserialization_generator.dart';

Future main(List<String> args) async {
  var builders = [
    apply(
        "builderKey",
        [
          (_) => new PartBuilder([
                new ApiCallGenerator(),
                new DeserializationGenerator(),
                new DeserializationFactoryGenerator()
              ])
        ],
        toRoot(),
        hideOutput: false),
  ];

  await run(['build', '--delete-conflicting-outputs'], builders);
}
