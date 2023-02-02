import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// todo create a widget to select shortcut by pressing the shortcut.

const controlAndSep = 'control$shortcutSep';
const shiftAndSep = 'shift$shortcutSep';
const metaAndSep = 'meta$shortcutSep';
const altAndSep = 'alt$shortcutSep';
const shortcutSep = '+';

SingleActivator? resolveSingleActivator(dynamic raw) {
  if (raw is! String) return null;

  final trigger = resolveKeyFromLabel(raw.split(shortcutSep).last);
  if (trigger == null) return null;

  return SingleActivator(
    trigger,
    control: raw.contains(controlAndSep),
    shift: raw.contains(shiftAndSep),
    meta: raw.contains(metaAndSep),
    alt: raw.contains(altAndSep),
  );
}

extension SingleActivatorJsonApis on SingleActivator {
  /// A string code representing this shortcut combination.
  /// It is usually used in json convert for persistence.
  ///
  String get code {
    final control = this.control ? controlAndSep : '';
    final shift = this.shift ? shiftAndSep : '';
    final meta = this.meta ? metaAndSep : '';
    final alt = this.alt ? altAndSep : '';

    final trigger = this.trigger.keyLabel;

    return '$control$shift$meta$alt$trigger';
  }
}

LogicalKeyboardKey? resolveKeyFromLabel(String raw) {
  for (final key in LogicalKeyboardKey.knownLogicalKeys) {
    if (key.keyLabel == raw) return key;
  }
  return null;
}
