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

import 'dart:collection';
import 'dart:convert';

import 'package:amplify_analytics_pinpoint_dart/src/impl/analytics_client/key_value_store.dart';
import 'package:amplify_core/amplify_core.dart';

/// Manages the storage, retrieval, and update of [Attributes] and [Metrics] for
/// Events.
///
/// - Attributes are String/bool
/// - Metrics are double/int
///
/// These values are sent with every new Event. For more details, see
/// [Pinpoint Event](https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-events.html) online spec.
class EventGlobalFieldsManager {
  EventGlobalFieldsManager(
    this._keyValueStore,
    this._globalAttributes,
    this._globalMetrics,
  );

  final Map<String, String> _globalAttributes;
  final Map<String, double> _globalMetrics;

  UnmodifiableMapView<String, String> get globalAttributes =>
      UnmodifiableMapView(_globalAttributes);
  UnmodifiableMapView<String, double> get globalMetrics =>
      UnmodifiableMapView(_globalMetrics);

  final KeyValueStore _keyValueStore;

  static EventGlobalFieldsManager? _instance;

  static Future<EventGlobalFieldsManager> getInstance(
    KeyValueStore keyValueStore,
  ) async =>
      _instance ??= EventGlobalFieldsManager(
        keyValueStore,
        (jsonDecode(
          await keyValueStore.getJson(KeyValueStore.eventsGlobalAttrsKey) ??
              '{}',
        ) as Map<String, Object?>)
            .cast(),
        Map<String, double>.from(
          jsonDecode(
            await keyValueStore
                    .getJson(KeyValueStore.endpointGlobalMetricsKey) ??
                '{}',
          ),
        ),
      );

  Future<void> addGlobalProperties(AnalyticsProperties globalProperties) async {
    _globalAttributes.addAll(globalProperties.attributes);
    _globalMetrics.addAll(globalProperties.metrics);

    await _saveProperties();
  }

  Future<void> removeGlobalProperties(List<String> propertyNames) async {
    if (propertyNames.isEmpty) {
      _globalAttributes.clear();
      _globalMetrics.clear();
    } else {
      for (final key in propertyNames) {
        _globalAttributes.remove(key);
        _globalMetrics.remove(key);
      }
    }
    await _saveProperties();
  }

  Future<void> _saveProperties() async {
    await _keyValueStore.saveJson(
      KeyValueStore.eventsGlobalAttrsKey,
      jsonEncode(_globalAttributes),
    );
    await _keyValueStore.saveJson(
      KeyValueStore.eventsGlobalMetricsKey,
      jsonEncode(_globalMetrics),
    );
  }

  /// Extract Attributes and Metrics from [analyticsProperties] and add them to [attrs] and [metrics]
  static void extractAnalyticsProperties(
    Map<String, String> attrs,
    Map<String, double> metrics,
    AnalyticsProperties analyticsProperties,
  ) {
    final propertiesMap = analyticsProperties.getAllProperties();
    final propertiesTypesMap = analyticsProperties.getAllPropertiesTypes();

    propertiesTypesMap.forEach((k, v) {
      final type = propertiesTypesMap[k]!;

      switch (type) {
        case 'STRING':
          attrs[k] = propertiesMap[k] as String;
          break;
        case 'BOOL':
          attrs[k] = propertiesMap[k].toString(); // as String;
          break;
        case 'INT':
          metrics[k] = (propertiesMap[k] as int).toDouble();
          break;
        case 'DOUBLE':
          metrics[k] = propertiesMap[k] as double;
          break;
        default:
      }
    });
  }
}
