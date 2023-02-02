import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saaaltodos/build_options.dart';
import 'package:saaaltodos/tools/extensions.dart';

/// Whether running in debug mode.
///
/// 1. Principle: code in `assets` will run in debug mode.
/// 2. Final variable rather than getter, in order to save cost. (see [_debug])
///
final debug = _debug;
bool get _debug {
  bool flag = false;
  assert(flag = true);
  return flag;
}

VersionInfo get version => VersionInfo.instance;

class VersionInfo {
  const VersionInfo({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  @override
  String toString() =>
      version == buildNumber ? version : '$version ($buildNumber)';

  static VersionInfo get instance => _instance;
  static late final VersionInfo _instance;
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;

    final info = await PackageInfo.fromPlatform();
    _instance = VersionInfo(
      version: info.version,
      buildNumber: info.buildNumber,
    );
    _initialized = true;
  }
}

PlatformInfo get platform => PlatformInfo.instance;

class PlatformInfo {
  PlatformInfo({
    required this.os,
    required this.type,
    required this.screen,
    required this.path,
  });

  final OperatingSystem os;
  final PlatformType type;
  final ScreenType screen;

  final PlatformPath path;

  @override
  String toString() {
    return 'platform type: $type\n'
        'operating system: $os\n'
        'screen type: $screen\n'
        'platform paths:\n\t${path.toString().replaceAll('\n', '\n\t')}';
  }

  static PlatformInfo get instance => _instance;
  static late final PlatformInfo _instance;

  static bool _initialized = false;
  static Future<void> ensureInitialized({
    bool strict = false,
    ScreenType unknownDefault = ScreenType.landscape,
    ScreenType unknownDefaultMobile = ScreenType.portrait,
    List<String> androidPadModels = const <String>[],
  }) async {
    if (_initialized) return;

    _instance = await detect(
      strict: strict,
      unknownDefault: unknownDefault,
      unknownDefaultMobile: unknownDefaultMobile,
      androidPadModels: androidPadModels,
    );

    _initialized = true;
  }

  static Future<PlatformInfo> detect({
    bool strict = false,
    ScreenType unknownDefault = ScreenType.landscape,
    ScreenType unknownDefaultMobile = ScreenType.portrait,
    List<String> androidPadModels = const <String>[],
  }) async {
    final os = await OperatingSystem.detect(strict: strict);
    return PlatformInfo(
      os: os,
      path: await PlatformPath.detect(),
      type: PlatformType.detect(),
      screen: await ScreenType.detect(
        os,
        unknownDefault: unknownDefault,
        unknownDefaultMobile: unknownDefaultMobile,
        androidPadModels: androidPadModels,
      ),
    );
  }

  // Basic encapsulation.
  late final isWindows = os == OperatingSystem.windows;
  late final isMacos = os == OperatingSystem.macos;
  late final isLinux = os == OperatingSystem.linux;
  late final isAndroid = os == OperatingSystem.android;
  late final isIOS = os == OperatingSystem.ios;
  late final isUnknown = os == OperatingSystem.unknown;

  late final isNative = type == PlatformType.native;
  late final isWeb = type == PlatformType.web;

  late final isPortrait = screen == ScreenType.portrait;
  late final isLandscape = screen == ScreenType.landscape;
  late final double defaultRem = isLandscape
      ? ScreenType.landscapeDefaultRem
      : ScreenType.portraitDefaultRem;

  // Helpers.
  late final isDesktop = isWindows || isMacos || isLinux;
  late final isMobile = isAndroid || isIOS;
  late final isPad = isMobile && isLandscape;
  late final isPhone = isMobile && isPortrait;
}

class PlatformPath {
  const PlatformPath({
    required this.appDocumentsDir,
    required this.appSupportDir,
    required this.temporaryDir,
  });

  final Directory appDocumentsDir;
  final Directory appSupportDir;
  final Directory temporaryDir;

  @override
  String toString() {
    return 'app documents dir: $appDocumentsDir\n'
        'app support dir: $appSupportDir\n'
        'temporary dir: $temporaryDir';
  }

  static Future<PlatformPath> detect() async => PlatformPath(
        appDocumentsDir: await getApplicationDocumentsDirectory(),
        appSupportDir: await getApplicationSupportDirectory(),
        temporaryDir: await getTemporaryDirectory(),
      );
}

enum OperatingSystem {
  windows('Windows'),
  macos('MacOS'),
  linux('Linux'),
  android('Android'),
  ios('IOS'),
  unknown('unknown');

  const OperatingSystem(this.name);

  final String name;

  @override
  String toString() => name;

  static Future<OperatingSystem> detect({bool strict = false}) async {
    if (kIsWeb) {
      final rawUA = (await DeviceInfoPlugin().webBrowserInfo).userAgent;
      if (rawUA == null && strict) {
        throw Exception('cannot get ua of current browser');
      }

      final ua = (rawUA ?? '').toLowerCase();

      if (ua.containsAny(['windows'])) return OperatingSystem.windows;
      if (ua.containsAny(['macos'])) return OperatingSystem.macos;
      if (ua.containsAny(['ios', 'iphone', 'ipad'])) return OperatingSystem.ios;

      if (ua.containsAny(['android'])) return OperatingSystem.android;
      if (ua.containsAny(['linux'])) return OperatingSystem.linux;

      if (strict) throw Exception('cannot detect os from ua: $ua');
      return OperatingSystem.unknown;
    } else {
      if (Platform.isWindows) return OperatingSystem.windows;
      if (Platform.isMacOS) return OperatingSystem.macos;
      if (Platform.isLinux) return OperatingSystem.linux;
      if (Platform.isAndroid) return OperatingSystem.android;
      if (Platform.isIOS) return OperatingSystem.ios;

      if (!strict) return OperatingSystem.unknown;
      throw Exception('unsupported os: ${Platform.operatingSystem}');
    }
  }

  bool get isWindows => this == OperatingSystem.windows;
  bool get isMacos => this == OperatingSystem.macos;
  bool get isLinux => this == OperatingSystem.linux;
  bool get isAndroid => this == OperatingSystem.android;
  bool get isIOS => this == OperatingSystem.ios;
  bool get isUnknown => this == OperatingSystem.unknown;
}

enum PlatformType {
  native('native app'),
  web('browser webpage');

  const PlatformType(this.name);

  final String name;

  @override
  String toString() => name;

  static PlatformType detect() =>
      kIsWeb ? PlatformType.web : PlatformType.native;

  bool get isNative => this == PlatformType.native;
  bool get isWeb => this == PlatformType.web;
}

enum ScreenType {
  /// Desktop or pad horizontal large screen.
  landscape('landscape'),

  /// Mobile phone vertical small screen.
  portrait('portrait');

  const ScreenType(this.name);

  final String name;

  @override
  String toString() => name;

  static Future<ScreenType> detect(
    OperatingSystem os, {
    ScreenType unknownDefault = ScreenType.landscape,
    ScreenType unknownDefaultMobile = ScreenType.portrait,
    List<String> androidPadModels = const <String>[],
  }) async {
    if (os.isWindows || os.isMacos || os.isLinux) {
      return ScreenType.landscape;
    } else if (os.isIOS) {
      await ScreenType.detectIOS(unknownDefault: unknownDefaultMobile);
    } else if (os.isAndroid) {
      await ScreenType.detectAndroid(
        unknownDefault: unknownDefaultMobile,
        androidPadModels: androidPadModels,
      );
    }

    return unknownDefault;
  }

  static Future<ScreenType> detectAndroid({
    ScreenType unknownDefault = ScreenType.portrait,
    List<String> androidPadModels = const <String>[],
  }) async {
    // As build config.
    if (forceAndroidPad) return ScreenType.landscape;

    // Detect from configured models.
    final model = (await DeviceInfoPlugin().androidInfo).model.toLowerCase();
    if (model.containsAny(androidPadModels.toLowerCase())) {
      return ScreenType.landscape;
    }
    return unknownDefault;
  }

  static Future<ScreenType> detectIOS({
    ScreenType unknownDefault = ScreenType.portrait,
  }) async {
    final rawMachine = (await DeviceInfoPlugin().iosInfo).utsname.machine;
    final machine = (rawMachine ?? '').toLowerCase();

    if (machine.contains('ipad')) return ScreenType.landscape;
    return unknownDefault;
  }

  bool get isPortrait => this == ScreenType.portrait;
  bool get isLandscape => this == ScreenType.landscape;

  static const double portraitDefaultRem = 65;
  static const double landscapeDefaultRem = 14;
}
