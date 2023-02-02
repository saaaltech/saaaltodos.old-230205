import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saaaltodos/tools/environment.dart';
import 'package:saaaltodos/tools/logger.dart';

/// Global key as the default key of [TerminalContainer] instance.
///
/// There's usually only one [TerminalContainer] widget in the whole app,
/// as it is recommended.
///
final terminalContainer = GlobalKey(debugLabel: 'terminal container');

/// Get terminal container state for calling apis.
///
/// If the [key] is not specified,
/// it will use the default key [terminalContainer].
///
TerminalContainerState? terminalContainerState({GlobalKey? key}) {
  return (key ?? terminalContainer).currentState as TerminalContainerState?;
}

/// Tab shortcuts to show or hide terminal pad.
///
/// It is designed for desktop and will not be compatible with phones.
/// And it is recommended to be used only in the app root.
///
/// `show` shortcut here means when terminal hide, then show,
/// and when terminal show, then hide, while `hide` will only hide.
///
class TerminalContainer extends StatefulWidget {
  TerminalContainer({
    GlobalKey? key,
    this.defaultShowShortcuts = const [
      SingleActivator(LogicalKeyboardKey.keyK, meta: true),
      SingleActivator(LogicalKeyboardKey.keyK, control: true),
    ],
    this.defaultHideShortcuts = const [
      SingleActivator(LogicalKeyboardKey.escape),
    ],
    this.terminalPad = const Center(child: Text('terminal pad')),
    this.mainArea = const Center(child: Text('main area')),
  }) : super(key: key ?? terminalContainer);

  final List<ShortcutActivator> defaultShowShortcuts;
  final List<ShortcutActivator> defaultHideShortcuts;

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

  late Map<ShortcutActivator, Intent> _shortcuts = _resolveShortcuts(
    showShortcuts: widget.defaultShowShortcuts,
    hideShortcuts: widget.defaultHideShortcuts,
  );

  Map<ShortcutActivator, Intent> _resolveShortcuts({
    List<ShortcutActivator> showShortcuts = const [],
    List<ShortcutActivator> hideShortcuts = const [],
  }) {
    final Map<ShortcutActivator, Intent> generator = {};

    for (final shortcut in showShortcuts) {
      generator[shortcut] = generator[shortcut] ?? const TerminalIntent();
    }

    for (final shortcut in hideShortcuts) {
      generator[shortcut] =
          generator[shortcut] ?? const TerminalIntent(hideOnly: true);
    }

    return generator;
  }

  void addShowShortcut(ShortcutActivator shortcut) {
    setState(() {
      _shortcuts[shortcut] = _shortcuts[shortcut] ?? const TerminalIntent();
    });
  }

  void addHideShortcut(ShortcutActivator shortcut) {
    setState(() {
      _shortcuts[shortcut] =
          _shortcuts[shortcut] ?? const TerminalIntent(hideOnly: true);
    });
  }

  void addShortcuts({
    List<ShortcutActivator> showShortcuts = const <ShortcutActivator>[],
    List<ShortcutActivator> hideShortcuts = const <ShortcutActivator>[],
  }) {
    setState(() {
      _shortcuts = _resolveShortcuts(
        showShortcuts: showShortcuts,
        hideShortcuts: hideShortcuts,
      );
    });
  }

  void removeShortcut(ShortcutActivator shortcut) {
    setState(() {
      _shortcuts.remove(shortcut);
    });
  }

  void removeShortcuts(List<ShortcutActivator> shortcuts) {
    setState(() {
      for (final shortcut in shortcuts) {
        _shortcuts.remove(shortcut);
      }
    });
  }

  void clearShortcuts() => setState(() => _shortcuts.clear());

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
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: {
          TerminalIntent: CallbackAction<TerminalIntent>(
            onInvoke: (intent) {
              if (intent.hideOnly && !_show) return null;
              setState(() => _show = !_show);
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: _show ? [widget.mainArea, terminal] : [widget.mainArea],
          ),
        ),
      ),
    );
  }
}

class TerminalIntent extends Intent {
  const TerminalIntent({this.hideOnly = false});
  final bool hideOnly;
}

extension TerminalControllerJsonApi on TerminalContainerState {
  void resolve(dynamic show, dynamic hide) {
    final List<ShortcutActivator> showShortcuts = [];
    final List<ShortcutActivator> hideShortcuts = [];

    if (show is List<String>) {}

    if (hide is List<String>) {}

    addShortcuts(showShortcuts: showShortcuts, hideShortcuts: hideShortcuts);
  }

  List<String> get showShortcuts {
    return [];
  }

  List<String> get hideShortcuts {
    return [];
  }
}
