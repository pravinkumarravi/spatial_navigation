import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:spatial_navigation/spatial_navigation.dart' as sn;
import 'tv_focus_scope.dart';

class TvNavigationListener extends StatefulWidget {
  final Widget child;
  final sn.SpatialNavigationController controller;
  final String? groupId;
  final bool autofocus;
  final FocusNode? focusNode;
  final void Function(sn.TvNavigationDirection)? onDirection;
  final VoidCallback? onSelect;
  final VoidCallback? onBack;

  const TvNavigationListener({
    super.key,
    required this.child,
    required this.controller,
    this.groupId,
    this.autofocus = true,
    this.focusNode,
    this.onDirection,
    this.onSelect,
    this.onBack,
  });

  @override
  State<TvNavigationListener> createState() => _TvNavigationListenerState();
}

class _TvNavigationListenerState extends State<TvNavigationListener> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKeyEvent,
      child: widget.child,
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final logicalKey = event.logicalKey;
    sn.TvNavigationDirection? direction;
    bool isSelect = false;
    bool isBack = false;

    if (logicalKey == LogicalKeyboardKey.arrowRight ||
        logicalKey == LogicalKeyboardKey.keyD ||
        logicalKey == LogicalKeyboardKey.gameButton14) {
      direction = sn.TvNavigationDirection.right;
    } else if (logicalKey == LogicalKeyboardKey.arrowLeft ||
               logicalKey == LogicalKeyboardKey.keyA ||
               logicalKey == LogicalKeyboardKey.gameButton15) {
      direction = sn.TvNavigationDirection.left;
    } else if (logicalKey == LogicalKeyboardKey.arrowUp ||
               logicalKey == LogicalKeyboardKey.keyW ||
               logicalKey == LogicalKeyboardKey.gameButton12) {
      direction = sn.TvNavigationDirection.up;
    } else if (logicalKey == LogicalKeyboardKey.arrowDown ||
               logicalKey == LogicalKeyboardKey.keyS ||
               logicalKey == LogicalKeyboardKey.gameButton13) {
      direction = sn.TvNavigationDirection.down;
    } else if (logicalKey == LogicalKeyboardKey.enter ||
               logicalKey == LogicalKeyboardKey.numpadEnter ||
               logicalKey == LogicalKeyboardKey.select ||
               logicalKey == LogicalKeyboardKey.space ||
               logicalKey == LogicalKeyboardKey.gameButtonA ||
               logicalKey == LogicalKeyboardKey.gameButtonSelect) {
      isSelect = true;
    } else if (logicalKey == LogicalKeyboardKey.escape ||
               logicalKey == LogicalKeyboardKey.gameButtonB ||
               logicalKey == LogicalKeyboardKey.goBack) {
      isBack = true;
    }

    if (direction != null) {
      return _handleDirection(direction, event is KeyRepeatEvent);
    } else if (isSelect) {
      return _handleSelect();
    } else if (isBack) {
      return _handleBack();
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _handleDirection(sn.TvNavigationDirection direction, bool isRepeat) {
    final groupId = widget.groupId ?? TvFocusScope.of(context)?.groupId;
    widget.controller.move(direction, groupId: groupId);
    widget.onDirection?.call(direction);
    return KeyEventResult.handled;
  }

  KeyEventResult _handleSelect() {
    widget.onSelect?.call();
    return KeyEventResult.handled;
  }

  KeyEventResult _handleBack() {
    final scope = TvFocusScope.of(context);
    if (scope != null && scope.controller.scope.hasModal) {
      final modalGroupId = scope.controller.scope.modalGroupId!;
      scope.controller.hideModal(modalGroupId);
      return KeyEventResult.handled;
    }
    
    widget.onBack?.call();
    return KeyEventResult.handled;
  }
}

class TvKeyboardListener extends StatelessWidget {
  final Widget child;
  final sn.SpatialNavigationController controller;
  final String? groupId;
  final void Function(sn.TvNavigationDirection)? onDirection;
  final VoidCallback? onSelect;
  final VoidCallback? onBack;

  const TvKeyboardListener({
    super.key,
    required this.child,
    required this.controller,
    this.groupId,
    this.onDirection,
    this.onSelect,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }

        final logicalKey = event.logicalKey;
        sn.TvNavigationDirection? direction;
        bool isSelect = false;
        bool isBack = false;

        if (logicalKey == LogicalKeyboardKey.arrowRight) {
          direction = sn.TvNavigationDirection.right;
        } else if (logicalKey == LogicalKeyboardKey.arrowLeft) {
          direction = sn.TvNavigationDirection.left;
        } else if (logicalKey == LogicalKeyboardKey.arrowUp) {
          direction = sn.TvNavigationDirection.up;
        } else if (logicalKey == LogicalKeyboardKey.arrowDown) {
          direction = sn.TvNavigationDirection.down;
        } else if (logicalKey == LogicalKeyboardKey.enter ||
                   logicalKey == LogicalKeyboardKey.numpadEnter ||
                   logicalKey == LogicalKeyboardKey.select) {
          isSelect = true;
        } else if (logicalKey == LogicalKeyboardKey.escape) {
          isBack = true;
        }

        if (direction != null) {
          final effectiveGroupId = groupId ?? TvFocusScope.of(context)?.groupId;
          controller.move(direction, groupId: effectiveGroupId);
          onDirection?.call(direction);
          return KeyEventResult.handled;
        } else if (isSelect) {
          onSelect?.call();
          return KeyEventResult.handled;
        } else if (isBack) {
          onBack?.call();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}

mixin TvNavigationMixin<T extends StatefulWidget> on State<T> {
  sn.SpatialNavigationController get navigationController;
  String? get navigationGroupId;

  void moveFocus(sn.TvNavigationDirection direction) {
    navigationController.move(direction, groupId: navigationGroupId);
  }

  void requestFocus(String nodeId) {
    final node = navigationController.registry.getNode(nodeId);
    if (node != null) {
      node.focusNode.requestFocus();
    }
  }

  void restoreFocus() {
    navigationController.restoreFocus(navigationGroupId);
  }
}