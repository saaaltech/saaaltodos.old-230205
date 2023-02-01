import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension StatefulHelper on State {
  AppLocalizations get locale => AppLocalizations.of(context)!;
}

extension StatelessHelper on StatelessWidget {
  AppLocalizations locale(BuildContext context) =>
      AppLocalizations.of(context)!;
}
