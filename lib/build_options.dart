import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// When cannot detect local system locale, the default locale will be applied.
///
/// You can set it to the locale you need in your own distribution,
/// but make sure the locale is already supported
/// in [AppLocalizations.supportedLocales],
/// or it will throw exceptions.
///
const defaultLocale = Locale('en');
