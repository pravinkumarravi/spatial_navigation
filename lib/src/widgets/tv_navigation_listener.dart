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
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleGlobalKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleGlobalKeyEvent);
    super.dispose();
  }

  bool _handleGlobalKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return false;
    }
    final result = _handleKeyEvent(event);
    return result == KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    // A root Focus with autofocus:true creates the live focus tree anchor that
    // Flutter's focus system requires. Without a focused ancestor, child Focus
    // nodes' requestFocus() calls are silently dropped.
    // We pass KeyEventResult.ignored so this node never consumes key events;
    // all key handling happens via HardwareKeyboard.instance above.
    return Focus(
      autofocus: true,
      skipTraversal: true,
      onKeyEvent: (_, __) => KeyEventResult.ignored,
      child: widget.child,
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    final logicalKey = event.logicalKey;
    final physicalKey = event.physicalKey;
    final keyId = logicalKey.keyId;
    final usbHid = physicalKey.usbHidUsage;

    sn.TvNavigationDirection? direction;
    bool isSelect = false;
    bool isBack = false;

    if (logicalKey == LogicalKeyboardKey.arrowRight ||
        logicalKey == LogicalKeyboardKey.keyD ||
        logicalKey == LogicalKeyboardKey.gameButton14 ||
        physicalKey == PhysicalKeyboardKey.arrowRight ||
        keyId == 0x00200000016 ||
        keyId == 0x00100000016 ||
        usbHid == 0x0007004f) {
      direction = sn.TvNavigationDirection.right;
    } else if (logicalKey == LogicalKeyboardKey.arrowLeft ||
               logicalKey == LogicalKeyboardKey.keyA ||
               logicalKey == LogicalKeyboardKey.gameButton15 ||
               physicalKey == PhysicalKeyboardKey.arrowLeft ||
               keyId == 0x00200000015 ||
               keyId == 0x00100000015 ||
               usbHid == 0x00070050) {
      direction = sn.TvNavigationDirection.left;
    } else if (logicalKey == LogicalKeyboardKey.arrowUp ||
               logicalKey == LogicalKeyboardKey.keyW ||
               logicalKey == LogicalKeyboardKey.gameButton12 ||
               physicalKey == PhysicalKeyboardKey.arrowUp ||
               keyId == 0x00200000013 ||
               keyId == 0x00100000013 ||
               usbHid == 0x00070052) {
      direction = sn.TvNavigationDirection.up;
    } else if (logicalKey == LogicalKeyboardKey.arrowDown ||
               logicalKey == LogicalKeyboardKey.keyS ||
               logicalKey == LogicalKeyboardKey.gameButton13 ||
               physicalKey == PhysicalKeyboardKey.arrowDown ||
               keyId == 0x00200000014 ||
               keyId == 0x00100000014 ||
               usbHid == 0x00070051) {
      direction = sn.TvNavigationDirection.down;
    } else if (logicalKey == LogicalKeyboardKey.enter ||
               logicalKey == LogicalKeyboardKey.numpadEnter ||
               logicalKey == LogicalKeyboardKey.select ||
               logicalKey == LogicalKeyboardKey.space ||
               logicalKey == LogicalKeyboardKey.gameButtonA ||
               logicalKey == LogicalKeyboardKey.gameButtonSelect ||
               logicalKey == LogicalKeyboardKey.gameButtonStart ||
               physicalKey == PhysicalKeyboardKey.enter ||
               physicalKey == PhysicalKeyboardKey.numpadEnter ||
               physicalKey == PhysicalKeyboardKey.select ||
               keyId == 0x00200000017 ||
               keyId == 0x00100000017 ||
               usbHid == 0x00070028 ||
               usbHid == 0x00070058) {
      isSelect = true;
    } else if (logicalKey == LogicalKeyboardKey.escape ||
               logicalKey == LogicalKeyboardKey.gameButtonB ||
               logicalKey == LogicalKeyboardKey.goBack ||
               logicalKey == LogicalKeyboardKey.backspace ||
               physicalKey == PhysicalKeyboardKey.escape ||
               physicalKey == PhysicalKeyboardKey.backspace ||
               keyId == 0x00200000004 ||
               keyId == 0x00100000004 ||
               usbHid == 0x00070029) {
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
    final groupId = widget.groupId ?? TvFocusScope.of(context)?.groupId;
    widget.controller.activateCurrentNode(groupId);
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
        final physicalKey = event.physicalKey;
        final keyId = logicalKey.keyId;
        final usbHid = physicalKey.usbHidUsage;

        sn.TvNavigationDirection? direction;
        bool isSelect = false;
        bool isBack = false;

        if (logicalKey == LogicalKeyboardKey.arrowRight ||
            logicalKey == LogicalKeyboardKey.keyD ||
            logicalKey == LogicalKeyboardKey.gameButton14 ||
            physicalKey == PhysicalKeyboardKey.arrowRight ||
            keyId == 0x00200000016 ||
            keyId == 0x00100000016 ||
            usbHid == 0x0007004f) {
          direction = sn.TvNavigationDirection.right;
        } else if (logicalKey == LogicalKeyboardKey.arrowLeft ||
                   logicalKey == LogicalKeyboardKey.keyA ||
                   logicalKey == LogicalKeyboardKey.gameButton15 ||
                   physicalKey == PhysicalKeyboardKey.arrowLeft ||
                   keyId == 0x00200000015 ||
                   keyId == 0x00100000015 ||
                   usbHid == 0x00070050) {
          direction = sn.TvNavigationDirection.left;
        } else if (logicalKey == LogicalKeyboardKey.arrowUp ||
                   logicalKey == LogicalKeyboardKey.keyW ||
                   logicalKey == LogicalKeyboardKey.gameButton12 ||
                   physicalKey == PhysicalKeyboardKey.arrowUp ||
                   keyId == 0x00200000013 ||
                   keyId == 0x00100000013 ||
                   usbHid == 0x00070052) {
          direction = sn.TvNavigationDirection.up;
        } else if (logicalKey == LogicalKeyboardKey.arrowDown ||
                   logicalKey == LogicalKeyboardKey.keyS ||
                   logicalKey == LogicalKeyboardKey.gameButton13 ||
                   physicalKey == PhysicalKeyboardKey.arrowDown ||
                   keyId == 0x00200000014 ||
                   keyId == 0x00100000014 ||
                   usbHid == 0x00070051) {
          direction = sn.TvNavigationDirection.down;
        } else if (logicalKey == LogicalKeyboardKey.enter ||
                   logicalKey == LogicalKeyboardKey.numpadEnter ||
                   logicalKey == LogicalKeyboardKey.select ||
                   logicalKey == LogicalKeyboardKey.space ||
                   logicalKey == LogicalKeyboardKey.gameButtonA ||
                   logicalKey == LogicalKeyboardKey.gameButtonSelect ||
                   physicalKey == PhysicalKeyboardKey.enter ||
                   physicalKey == PhysicalKeyboardKey.numpadEnter ||
                   physicalKey == PhysicalKeyboardKey.select ||
                   keyId == 0x00200000017 ||
                   keyId == 0x00100000017 ||
                   usbHid == 0x00070028 ||
                   usbHid == 0x00070058) {
          isSelect = true;
        } else if (logicalKey == LogicalKeyboardKey.escape ||
                   logicalKey == LogicalKeyboardKey.gameButtonB ||
                   logicalKey == LogicalKeyboardKey.goBack ||
                   logicalKey == LogicalKeyboardKey.backspace ||
                   physicalKey == PhysicalKeyboardKey.escape ||
                   physicalKey == PhysicalKeyboardKey.backspace ||
                   keyId == 0x00200000004 ||
                   keyId == 0x00100000004 ||
                   usbHid == 0x00070029) {
          isBack = true;
        }

        if (direction != null) {
          final effectiveGroupId = groupId ?? TvFocusScope.of(context)?.groupId;
          controller.move(direction, groupId: effectiveGroupId);
          onDirection?.call(direction);
          return KeyEventResult.handled;
        } else if (isSelect) {
          onSelect?.call();
          final effectiveGroupId = groupId ?? TvFocusScope.of(context)?.groupId;
          controller.activateCurrentNode(effectiveGroupId);
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