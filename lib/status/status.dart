import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:saaaltodos/components/terminal.dart';
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
  // Handle keys current status instance.
  late GlobalKey appRoot = appRoot;
  late GlobalKey terminalContainer = terminalContainer;

  // Key names (use kebab-case in json style).
  static final themeModeKey = 'theme mode'.toKebabCase();
  static final localeKey = 'locale'.toKebabCase();
  static final showTerminalShortcutsKey = 'terminal show'.toKebabCase();
  static final hideTerminalShortcutsKey = 'terminal hide'.toKebabCase();

  @override
  void fromMap(Map<String, dynamic> map) {
    final appRoot = appRootState(key: this.appRoot);
    final terminalCon = terminalContainerState(key: terminalContainer);

    appRoot?.resolveThemeMode(map[themeModeKey]);
    appRoot?.resolveLocale(map[localeKey]);
    terminalCon?.resolve(
      map[showTerminalShortcutsKey],
      map[hideTerminalShortcutsKey],
    );
  }

  @override
  Map<String, dynamic> get map {
    final appRoot = appRootState(key: this.appRoot);
    final terminalCon = terminalContainerState(key: terminalContainer);

    return {
      themeModeKey: appRoot?.themeMode.name,
      localeKey: appRoot?.locale.toLanguageTag().toKebabCase(),
      showTerminalShortcutsKey: terminalCon?.showShortcuts,
      hideTerminalShortcutsKey: terminalCon?.hideShortcuts,
    };
  }
}
