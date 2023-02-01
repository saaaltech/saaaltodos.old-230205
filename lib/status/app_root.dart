import 'package:change_case/change_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saaaltodos/build_options.dart' as build_options;

/// Global key as the default key of [AppRoot] instance.
final appRoot = GlobalKey();

// Shortcuts of setThemeMode.
void toDark({GlobalKey? key}) => setThemeMode(ThemeMode.dark, key: key);
void toLight({GlobalKey? key}) => setThemeMode(ThemeMode.light, key: key);
void toSystem({GlobalKey? key}) => setThemeMode(ThemeMode.system, key: key);

/// Set theme mode of an [AppRoot] widget according to its [GlobalKey].
/// If the [key] is not given, it will use default [appRoot] key.
///
/// You may also consider its shortcuts: [toDark], [toLight] and [toSystem].
///
void setThemeMode(ThemeMode mode, {GlobalKey? key}) {
  final state = (key ?? appRoot).currentState as AppRootState?;
  state?.themeMode = ThemeMode.system;
}

/// Set locale of an [AppRoot] widget according to its [GlobalKey].
/// If the [key] is not given, it will use default [appRoot] key.
///
/// If you are setting an unsupported locale
/// (not in [AppLocalizations.supportedLocales]),
/// it will throw an exception.
///
void setLocale(Locale locale, {GlobalKey? key}) {
  final state = (key ?? appRoot).currentState as AppRootState?;
  if (!AppLocalizations.supportedLocales.contains(locale)) {
    throw Exception('set unsupported locale');
  }
  state?.locale = locale;
}

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
    this.defaultLocale = build_options.defaultLocale,
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
  final Locale defaultLocale;

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
  late Locale _locale = widget.defaultLocale;

  // Getter of current theme and locale status.
  ThemeMode get themeMode => _themeMode;
  ThemeData get darkTheme => _darkTheme;
  ThemeData get lightTheme => _lightTheme;
  Locale get locale => _locale;

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

  /// Update locale.
  set locale(Locale locale) {
    if (_locale != locale) {
      setState(() => _locale = locale);
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
      // Theme mode and theme data control.
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: _darkTheme,
      theme: _lightTheme,

      // Locale control.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,

      // Home and routes.
      home: widget.home,
      routes: widget.routes,
      initialRoute: widget.initialRoute,
      onUnknownRoute: widget.onUnknownRoute,
    );
  }
}

/// Convert from json value and apply the parsed value.
///
/// As they are parsed from json, the raw value can be dynamic.
/// When the raw value is invalid, nothing will happen.
///
extension AppRootJsonApi on AppRootState {
  /// Convert from theme mode name string into [ThemeMode] value
  /// and if the value is valid, then apply the value.
  ///
  void themeModeFromName(dynamic raw) {
    if (raw is! String) return;
    for (final value in ThemeMode.values) {
      if (value.name == raw) {
        themeMode = value;
      }
    }
  }

  /// Convert from locale code into existing supported [Locale] value
  /// and then apply the value.
  ///
  /// If there's no such supported locale or code is invalid,
  /// then nothing will happen.
  ///
  void localeFromCode(dynamic raw) {
    if (raw is! String) return;

    final parts = raw.toKebabCase().split('-');
    final locales = List.generate(
      AppLocalizations.supportedLocales.length,
      (index) => AppLocalizations.supportedLocales[index]
          .toLanguageTag()
          .toKebabCase(),
    );

    int index = -1;
    int match = 0;
    for (int i = 0; i < locales.length; i++) {
      int currentMatch = 0;
      for (final localePart in locales[i].split('-')) {
        for (final part in parts) {
          if (localePart == part) currentMatch++;
        }
      }

      if (currentMatch > match) {
        match = currentMatch;
        index = i;
      }
    }

    if (index != -1) locale = AppLocalizations.supportedLocales[index];
  }
}
