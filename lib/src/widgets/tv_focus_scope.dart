import 'package:flutter/widgets.dart';

import 'package:spatial_navigation/spatial_navigation.dart' as sn;

class TvFocusScope extends InheritedWidget {
  final sn.SpatialNavigationController controller;
  final String? groupId;
  final bool autoFocus;
  final String? initialFocusId;

  const TvFocusScope({
    super.key,
    required this.controller,
    required super.child,
    this.groupId,
    this.autoFocus = true,
    this.initialFocusId,
  });

  static TvFocusScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TvFocusScope>();
  }

  @override
  bool updateShouldNotify(covariant TvFocusScope oldWidget) {
    return controller != oldWidget.controller ||
        groupId != oldWidget.groupId ||
        autoFocus != oldWidget.autoFocus ||
        initialFocusId != oldWidget.initialFocusId;
  }
}

class TvNavigationScope extends StatefulWidget {
  final sn.SpatialNavigationController controller;
  final Widget child;
  final String? groupId;
  final sn.NavigationBoundaries? boundaries;
  final sn.NavigationMode mode;
  final String? preferredEntryNodeId;
  final String? preferredExitNodeId;
  final bool autoFocus;
  final String? initialFocusId;
  final bool isModal;

  const TvNavigationScope({
    super.key,
    required this.controller,
    required this.child,
    this.groupId,
    this.boundaries,
    this.mode = sn.NavigationMode.spatial,
    this.preferredEntryNodeId,
    this.preferredExitNodeId,
    this.autoFocus = true,
    this.initialFocusId,
    this.isModal = false,
  });

  @override
  State<TvNavigationScope> createState() => _TvNavigationScopeState();
}

class _TvNavigationScopeState extends State<TvNavigationScope> {
  late String _resolvedGroupId;
  bool _groupRegistered = false;

  @override
  void initState() {
    super.initState();
    _resolvedGroupId = widget.groupId ?? 'scope_${identityHashCode(this)}';
    _registerGroup();
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoFocus();
      });
    }
  }

  @override
  void didUpdateWidget(covariant TvNavigationScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.groupId != oldWidget.groupId ||
        widget.boundaries != oldWidget.boundaries ||
        widget.mode != oldWidget.mode) {
      _updateGroup();
    }
  }

  @override
  void dispose() {
    _unregisterGroup();
    super.dispose();
  }

  void _registerGroup() {
    if (_groupRegistered) return;
    
    final group = sn.SpatialNavigationGroup(
      id: _resolvedGroupId,
      boundaries: widget.boundaries,
      mode: widget.mode,
      preferredEntryNodeId: widget.preferredEntryNodeId ?? widget.initialFocusId,
      preferredExitNodeId: widget.preferredExitNodeId,
      isModal: widget.isModal,
    );
    
    widget.controller.addGroup(group);
    widget.controller.enterGroup(_resolvedGroupId);
    _groupRegistered = true;
  }

  void _updateGroup() {
    widget.controller.removeGroup(_resolvedGroupId);
    _registerGroup();
  }

  void _unregisterGroup() {
    if (!_groupRegistered) return;
    widget.controller.exitGroup(_resolvedGroupId);
    widget.controller.removeGroup(_resolvedGroupId);
    _groupRegistered = false;
  }

  void _autoFocus() {
    if (widget.initialFocusId != null) {
      final node = widget.controller.registry.getNode(widget.initialFocusId!);
      if (node != null && node.isFocusable) {
        node.focusNode.requestFocus();
        return;
      }
    }
    
    final preferredEntry = widget.preferredEntryNodeId;
    if (preferredEntry != null) {
      final node = widget.controller.registry.getNode(preferredEntry);
      if (node != null && node.isFocusable) {
        node.focusNode.requestFocus();
        return;
      }
    }
    
    widget.controller.restoreFocus(_resolvedGroupId);
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusScope(
      controller: widget.controller,
      groupId: _resolvedGroupId,
      autoFocus: widget.autoFocus,
      initialFocusId: widget.initialFocusId,
      child: widget.child,
    );
  }
}

class TvNavigationBoundary extends StatelessWidget {
  final Widget child;
  final bool canExitLeft;
  final bool canExitRight;
  final bool canExitUp;
  final bool canExitDown;

  const TvNavigationBoundary({
    super.key,
    required this.child,
    this.canExitLeft = true,
    this.canExitRight = true,
    this.canExitUp = true,
    this.canExitDown = true,
  });

  @override
  Widget build(BuildContext context) {
    final scope = TvFocusScope.of(context);
    if (scope != null) {
      final controller = scope.controller;
      final groupId = scope.groupId;
      if (groupId != null) {
        final boundaries = sn.NavigationBoundaries(
          canExitLeft: canExitLeft,
          canExitRight: canExitRight,
          canExitUp: canExitUp,
          canExitDown: canExitDown,
        );
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final existingGroup = controller.scope.getGroup(groupId);
          if (existingGroup != null) {
            controller.scope.removeGroup(groupId);
            controller.addGroup(existingGroup.copyWith(boundaries: boundaries));
          }
        });
      }
    }
    return child;
  }
}