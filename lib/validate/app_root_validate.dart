import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saaaltodos/status/app_root.dart' as raw show appRoot;
import 'package:saaaltodos/status/app_root.dart' hide appRoot;
import 'package:saaaltodos/tools/widgets_helper.dart';

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
    final controller = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => toDark(key: appRoot),
          child: const Text('to dark'),
        ),
        TextButton(
          onPressed: () => toLight(key: appRoot),
          child: const Text('to light'),
        ),
        TextButton(
          onPressed: () => toSystem(key: appRoot),
          child: const Text('to system'),
        ),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('brightness: ${Theme.of(context).brightness}'),
        Text('platform: ${MediaQuery.of(context).platformBrightness}'),
        controller,
      ],
    );
  }
}

class LocaleValidate extends StatelessWidget {
  LocaleValidate({Key? key, GlobalKey? appRoot}) : super(key: key) {
    this.appRoot = appRoot ?? raw.appRoot;
  }

  late final GlobalKey appRoot;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('current locale: ${locale(context).theLanguageName}'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => setLocale(const Locale('en'), key: appRoot),
              child: const Text('to en'),
            ),
            TextButton(
              onPressed: () => setLocale(const Locale('zh'), key: appRoot),
              child: const Text('to zh'),
            ),
          ],
        ),
      ],
    );
  }
}
