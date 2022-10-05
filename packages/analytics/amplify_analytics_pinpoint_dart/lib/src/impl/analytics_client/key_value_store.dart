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

import 'dart:async';
import 'package:amplify_secure_storage_dart/amplify_secure_storage_dart.dart';
import 'package:uuid/uuid.dart';

/// Interface with underlying device key-value storage using [SecureStorageInterface]
/// Present interface for saving/retrieving Strings
class KeyValueStore {
  KeyValueStore._(this.uniqueId, this._storage);
  // Stored Keys
  static const String uniqueIdKey = 'UniqueId';

  static const String eventsGlobalAttrsKey = 'EventsGlobalAttributesKey';

  static const String endpointGlobalAttrsKey = 'EndpointGlobalAttributesKey';

  static const String eventsGlobalMetricsKey = 'EventsGlobalMetricsKey';

  static const String endpointGlobalMetricsKey = 'EndpointGlobalMetricsKey';

  final SecureStorageInterface _storage;

  final String uniqueId;

  static Future<KeyValueStore> getInstance(
    SecureStorageInterface? storage,
  ) async {
    // Initialize storage component
    storage ??= AmplifySecureStorageWorker(
      config: AmplifySecureStorageConfig(
        scope: 'analytics',
      ),
    );

    // TODO: Move logic
    // Retrieve Unique ID
    var storedUniqueId = await storage.read(key: uniqueIdKey);
    if (storedUniqueId == null) {
      storedUniqueId = const Uuid().v1();
      await storage.write(key: uniqueIdKey, value: storedUniqueId);
    }

    return KeyValueStore._(storedUniqueId, storage);
  }

  Future<void> saveJson(String key, String json) async {
    await _storage.write(key: key, value: json);
  }

  Future<String?> getJson(String key) async {
    return await _storage.read(key: key);
  }

  /// UniqueID is used to identify the Pinpoint Endpoint attached to this device
  /// It must be constant and never changed
  Future<String> getFixedEndpointId() {
    return _storage.read(key: key);
  }
}
