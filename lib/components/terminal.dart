import 'package:flutter/material.dart';
import 'package:saaaltodos/tools/environment.dart';
import 'package:saaaltodos/tools/logger.dart';

/// Global key as the default key of [TerminalContainer] instance.
///
/// There's usually only one [TerminalContainer] widget in the whole app,
/// as it is recommended.
///
final terminalContainer = GlobalKey(debugLabel: 'terminal container');

/// Tab shortcuts to show or hide terminal pad.
///
/// It is designed for desktop and will not be compatible with phones.
/// And it is recommended to be used only in the app root.
///
class TerminalContainer extends StatefulWidget {
  TerminalContainer({
    GlobalKey? key,
    this.terminalPad = const Center(child: Text('terminal pad')),
    this.mainArea = const Center(child: Text('main area')),
  }) : super(key: key ?? terminalContainer);

  final Widget terminalPad;
  final Widget mainArea;

  @override
  State<TerminalContainer> createState() => TerminalContainerState();
}

class TerminalContainerState extends State<TerminalContainer> {
  // Controller of show or hide terminal pad.
  bool _show = false;
  bool get show => _show;
  set show(bool flag) {
    if (_show != flag) {
      setState(() => _show = flag);
    }
  }

  @override
  void initState() {
    super.initState();
    if (platform.isPortrait) {
      log.warn('use terminal container on portrait screen');
    }
  }

  /// Terminal pad display.
  Widget get terminal {
    return Positioned(
      child: Container(
        color: Colors.teal,
        child: widget.terminalPad,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: _show ? [widget.mainArea, terminal] : [widget.mainArea],
    );
  }
}
