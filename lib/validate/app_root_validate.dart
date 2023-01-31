import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saaaltodos/status/app_root.dart' as raw show appRoot;
import 'package:saaaltodos/status/app_root.dart' hide appRoot;

/// Validate theme mode of the [AppRoot].
///
/// 1. Display [Brightness] of current [BuildContext]'s [Theme].
/// 2. Display [Brightness] of current platform (using [PlatformDispatcher]).
/// 3. Buttons to set current [ThemeMode].
///
/// Make sure it locates inside the [AppRoot] widgets and
/// they have the same [GlobalKey].
///
class ThemeModeValidate extends StatelessWidget {
  ThemeModeValidate({Key? key, GlobalKey? appRoot}) : super(key: key) {
    this.appRoot = appRoot ?? raw.appRoot;
  }

  late final GlobalKey appRoot;

  @override
  Widget build(BuildContext context) {
    final appRoot = this.appRoot.currentState as AppRootState?;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('brightness: ${Theme.of(context).brightness}'),
        Text('platform: ${MediaQuery.of(context).platformBrightness}'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => appRoot?.themeMode = ThemeMode.dark,
              child: const Text('to dark'),
            ),
            TextButton(
              onPressed: () => appRoot?.themeMode = ThemeMode.light,
              child: const Text('to light'),
            ),
            TextButton(
              onPressed: () => appRoot?.themeMode = ThemeMode.system,
              child: const Text('to system'),
            ),
          ],
        ),
      ],
    );
  }
}
