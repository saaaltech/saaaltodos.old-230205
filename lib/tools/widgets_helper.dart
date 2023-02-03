import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension StatefulHelper on State {
  AppLocalizations get locale => AppLocalizations.of(context)!;

  Size get size => MediaQuery.of(context).size;
}

extension StatelessHelper on StatelessWidget {
  AppLocalizations locale(BuildContext context) =>
      AppLocalizations.of(context)!;

  Size size(BuildContext context) => MediaQuery.of(context).size;
}
