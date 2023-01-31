import 'package:flutter/material.dart';
import 'package:saaaltodos/status/app_root.dart';
import 'package:saaaltodos/validate/app_root_validate.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppRoot(
      home: Scaffold(
        body: Center(
          child: ThemeModeValidate(),
        ),
      ),
    );
  }
}
