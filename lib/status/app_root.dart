import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Global key as the default key of [AppRoot] instance.
final appRoot = GlobalKey();

/// Handle theme and locale change at the root of an app.
///
/// You can call the getters of its [State] from its [GlobalKey]
/// to set the theme, theme mode and locale and it will change as is.
///
/// It contains [MaterialApp] and has usually only one instance
/// at the root of the whole app.
/// Most of its parameters are similar to [MaterialApp] that
/// you can attach [routes] or [home] on it directly.
///
class AppRoot extends StatefulWidget {
  AppRoot({
    GlobalKey? key,
    this.defaultThemeMode = ThemeMode.system,
    ThemeData? defaultDarkTheme,
    ThemeData? defaultLightTheme,
    Widget? home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onUnknownRoute,
  }) : super(key: appRoot) {
    this.defaultDarkTheme = defaultDarkTheme ?? ThemeData.dark();
    this.defaultLightTheme = defaultLightTheme ?? ThemeData.light();
    this.home = routes.isEmpty
        ? home ?? const Scaffold(body: Center(child: Text('app root')))
        : null;
  }

  // Theme and locale default values.
  final ThemeMode defaultThemeMode;
  late final ThemeData defaultDarkTheme;
  late final ThemeData defaultLightTheme;

  // Home and routes of the handled material app.
  late final Widget? home;
  final Map<String, Widget Function(BuildContext)> routes;
  final String? initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  // Local private variables about theme and locale.
  late ThemeMode _themeMode = widget.defaultThemeMode;
  late ThemeData _darkTheme = widget.defaultDarkTheme;
  late ThemeData _lightTheme = widget.defaultLightTheme;

  /// Whether the app root is current in dark mode.
  bool get dark => _themeMode == ThemeMode.system
      ? PlatformDispatcher.instance.platformBrightness == Brightness.dark
      : _themeMode == ThemeMode.dark;

  /// Update theme mode.
  set themeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      setState(() => _themeMode = mode);
    }
  }

  /// Update dark theme data.
  set darkTheme(ThemeData themeData) {
    if (_darkTheme != themeData) {
      setState(() => _darkTheme = themeData);
    }
  }

  /// Update light theme data.
  set lightTheme(ThemeData themeData) {
    if (_lightTheme != themeData) {
      setState(() => _lightTheme = themeData);
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Theme and locales.
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: _darkTheme,
      theme: _lightTheme,

      // Home and routes.
      home: widget.home,
      routes: widget.routes,
      initialRoute: widget.initialRoute,
      onUnknownRoute: widget.onUnknownRoute,
    );
  }
}
