import 'package:flutter/material.dart';

/// Global key as the default key of [sidebarContainer] instance.
///
/// There's usually only one [sidebarContainer] widget
/// at the root of the whole app, as it is recommended.
///
final sidebarContainer = GlobalKey(debugLabel: 'sidebar container');

class SidebarContainer extends StatefulWidget {
  SidebarContainer({
    GlobalKey? key,
    this.sidebar = const Center(child: Text('sidebar')),
    this.mainArea = const Center(child: Text('main area')),
  }) : super(key: sidebarContainer);

  final Widget sidebar;
  final Widget mainArea;

  @override
  State<SidebarContainer> createState() => _SidebarContainerState();
}

class _SidebarContainerState extends State<SidebarContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        widget.mainArea,
      ],
    );
  }
}
