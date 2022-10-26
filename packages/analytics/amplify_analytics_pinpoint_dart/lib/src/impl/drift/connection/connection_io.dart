// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';
import 'dart:isolate';

import 'package:amplify_core/amplify_core.dart';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

// Code adapted from:
// https://github.com/simolus3/drift/blob/develop/examples/app/lib/database/connection/native.dart

/// {@template amplify_analytics_pinpoint_dart.connection_io}
/// Obtains a database connection for running drift in a Dart VM.
///
/// The [NativeDatabase] from drift will synchronously use sqlite3's C APIs.
/// To move synchronous database work off the main thread, we use a
/// [DriftIsolate], which can run queries in a background isolate under the
/// hood.
/// {@endtemplate}
QueryExecutor connect({
  String? driftStoragePath,
}) {
  return DatabaseConnection.delayed(
    Future.sync(() async {
      if (driftStoragePath == null) {
        throw const AnalyticsException(
          'driftStoragePath is null for a non web platform',
          recoverySuggestion:
              'Make sure the pathProvider sent in the constructor of AmplifyAnalyticsPinpointDart '
              'is returning nonnull and returning a value. ',
        );
      }

      final dbPath =
          p.join(driftStoragePath, 'amplify_analytics_cached_events.sqlite');

      final receiveDriftIsolate = ReceivePort();
      await Isolate.spawn(
        _entrypointForDriftIsolate,
        _IsolateStartRequest(receiveDriftIsolate.sendPort, dbPath),
      );

      final driftIsolate = await receiveDriftIsolate.first as DriftIsolate;
      return driftIsolate.connect();
    }),
  ).executor;
}

/// The entrypoint of isolates can only take a single message, but we need two
/// (a send port to reach the originating isolate and the database's path that
/// should be opened on the background isolate). So, we bundle this information
/// in a single class.
class _IsolateStartRequest {
  _IsolateStartRequest(this.talkToMain, this.databasePath);
  final SendPort talkToMain;
  final String databasePath;
}

/// The entrypoint for a background isolate launching a drift server.
///
/// The main isolate can then connect to that isolate server to transparently
/// run queries in the background.
void _entrypointForDriftIsolate(_IsolateStartRequest request) {
  // The native database synchronously uses sqlite3's C API with `dart:ffi` for
  // a fast database implementation that doesn't require platform channels.
  final databaseImpl = NativeDatabase(File(request.databasePath));

  // We can use DriftIsolate.inCurrent because this function is the entrypoint
  // of a background isolate itself.
  final driftServer =
      DriftIsolate.inCurrent(() => DatabaseConnection(databaseImpl));

  // Inform the main isolate about the server we just created.
  request.talkToMain.send(driftServer);
}
