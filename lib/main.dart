import 'package:flutter/material.dart';
import 'package:saaaltodos/components/sidebar.dart';
import 'package:saaaltodos/components/terminal.dart';
import 'package:saaaltodos/status/app_root.dart';
import 'package:saaaltodos/tools/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlatformInfo.ensureInitialized();
  await VersionInfo.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppRoot(
      home: Scaffold(
        body: TerminalContainer(
          mainArea: SidebarContainer(),
        ),
      ),
    );
  }
}
