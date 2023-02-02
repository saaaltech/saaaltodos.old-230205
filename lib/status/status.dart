import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:saaaltodos/status/app_root.dart';
import 'package:saaaltodos/tools/persistence.dart';

/// A global instance of [LocalStatus].
///
/// Don't forget to initialize by setting its file and local storage key,
/// or it will throw exceptions when reading and saving data.
///
final status = LocalStatus();

/// Local status about the app,
/// including user options and status about the app.
/// Close the app and open again, those data will be recovered.
///
class LocalStatus extends JsonPersistence {
  // Handle app root of current status instance.
  late GlobalKey appRoot = appRoot;
  AppRootState? get appRootState => appRoot.currentState as AppRootState?;

  // Key names (use kebab-case in json style).
  static final themeModeKey = 'theme mode'.toKebabCase();
  static final localeKey = 'locale'.toKebabCase();

  @override
  void fromMap(Map<String, dynamic> map) {
    appRootState?.resolveThemeMode(map[themeModeKey]);
    appRootState?.resolveLocale(map[localeKey]);
  }

  @override
  Map<String, dynamic> get map {
    return {
      themeModeKey: appRootState?.themeMode.name,
      localeKey: appRootState?.locale.toLanguageTag().toKebabCase(),
    };
  }
}
