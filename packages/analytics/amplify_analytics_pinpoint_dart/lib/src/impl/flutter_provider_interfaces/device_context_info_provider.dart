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

/// Provide information required for Pinpoint EndpointDemographic object
/// https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-endpoints.html
abstract class DeviceContextInfoProvider {
  Future<DeviceContextInfo> getDeviceInfoDetails();
}

/// Data representation of DeviceContextInfo required for Pinpoint EndpointDemographic:
/// https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-endpoints.html
class DeviceContextInfo {
  factory DeviceContextInfo({
    String? countryCode,
    String? locale,
    String? timezone,
    String? appName,
    String? appPackageName,
    String? appVersion,
    String? make,
    String? model,
    String? modelVersion,
    String? platformVersion,
    DevicePlatform? platform,
  }) {
    return DeviceContextInfo._(
      countryCode: sanitize(countryCode),
      locale: sanitize(locale),
      timezone: sanitize(timezone),
      appName: sanitize(appName),
      appPackageName: sanitize(appPackageName),
      appVersion: sanitize(appVersion),
      make: sanitize(make),
      model: sanitize(model),
      modelVersion: sanitize(modelVersion),
      platformVersion: sanitize(platformVersion),
      platform: platform,
    );
  }

  const DeviceContextInfo._({
    this.countryCode,
    this.locale,
    this.timezone,
    this.appName,
    this.appPackageName,
    this.appVersion,
    this.make,
    this.model,
    this.modelVersion,
    this.platform,
    this.platformVersion,
  });

  static final int _maxFieldLength = 50;
  static String? sanitize(String? field) {
    if (field == null || field.length <= _maxFieldLength) return field;
    return field.substring(0, _maxFieldLength);
  }

  final String? countryCode;
  final String? locale;
  final String? timezone;
  final String? appName;
  final String? appPackageName;
  final String? appVersion;
  final String? make;
  final String? model;
  final String? modelVersion;
  final String? platformVersion;
  final DevicePlatform? platform;
}

/// Device Platforms
enum DevicePlatform { iOS, android, web, macOS, windows, linux, unknown }
