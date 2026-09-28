import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import 'package:spatial_navigation/spatial_navigation.dart' as sn;
import 'tv_focus_scope.dart';

class TvFocusable extends StatefulWidget {
  final String id;
  final Widget child;
  final String? groupId;
  final int? row;
  final int? column;
  final bool enabled;
  final bool visible;
  final Map<sn.TvNavigationDirection, String>? navigationOverrides;
  final FocusNode? focusNode;
  final VoidCallback? onFocused;
  final VoidCallback? onUnfocused;
  final Widget Function(BuildContext, Widget, bool)? focusBuilder;

  const TvFocusable({
    super.key,
    required this.id,
    required this.child,
    this.groupId,
    this.row,
    this.column,
    this.enabled = true,
    this.visible = true,
    this.navigationOverrides,
    this.focusNode,
    this.onFocused,
    this.onUnfocused,
    this.focusBuilder,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  Rect? _lastRect;
  bool _registered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateRegistration();
  }

  @override
  void didUpdateWidget(covariant TvFocusable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled ||
        widget.visible != oldWidget.visible ||
        widget.groupId != oldWidget.groupId) {
      _updateRegistration();
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
      _updateRegistration();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _unregister();
    super.dispose();
  }

  void _onFocusChange() {
    final focused = _focusNode.hasFocus;
    if (focused != _isFocused) {
      setState(() {
        _isFocused = focused;
      });
      if (focused) {
        _register();
        widget.onFocused?.call();
        TvFocusScope.of(context)?.controller.onNodeFocused(widget.id, widget.groupId);
      } else {
        widget.onUnfocused?.call();
        TvFocusScope.of(context)?.controller.onNodeUnfocused(widget.id);
      }
    }
  }

  void _register() {
    _registered = true;
    _updateRegistration();
  }

  void _unregister() {
    if (!_registered) return;
    _registered = false;
    TvFocusScope.of(context)?.controller.unregisterNode(widget.id);
  }

  void _updateRegistration() {
    final controller = TvFocusScope.of(context)?.controller;
    if (controller == null) return;

    final groupId = widget.groupId ?? TvFocusScope.of(context)?.groupId;

    final node = sn.SpatialNavigationNode(
      id: widget.id,
      rect: _lastRect ?? Rect.zero,
      enabled: widget.enabled,
      visible: widget.visible,
      row: widget.row,
      column: widget.column,
      groupId: groupId,
      focusNode: _focusNode,
      navigationOverrides: widget.navigationOverrides,
    );
    controller.registerNode(node);
    _registered = true;
  }

  void _updateRect() {
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.attached) {
      final transform = renderObject.getTransformTo(null);
      final globalRect = MatrixUtils.transformRect(transform, renderObject.paintBounds);
      
      if (_lastRect != globalRect) {
        _lastRect = globalRect;
        final controller = TvFocusScope.of(context)?.controller;
        if (controller != null) {
          if (controller.registry.getNode(widget.id) == null) {
            _updateRegistration();
          } else {
            controller.updateNodeRect(widget.id, globalRect);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Focus(
      focusNode: _focusNode,
      onFocusChange: (focused) {
        if (focused) {
          _register();
          _updateRect();
        }
      },
      child: widget.child,
    );

    if (widget.focusBuilder != null) {
      child = widget.focusBuilder!(context, child, _isFocused);
    }

    return TvFocusableLayoutNotifier(
      onLayout: _updateRect,
      child: child,
    );
  }
}

class TvFocusableLayoutNotifier extends SingleChildRenderObjectWidget {
  final VoidCallback onLayout;

  const TvFocusableLayoutNotifier({
    super.key,
    required this.onLayout,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _LayoutNotifierRenderObject(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _LayoutNotifierRenderObject renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _LayoutNotifierRenderObject extends RenderProxyBox {
  VoidCallback onLayout;

  _LayoutNotifierRenderObject(this.onLayout);

  @override
  void performLayout() {
    super.performLayout();
    // Schedule the callback after layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached) {
        onLayout();
      }
    });
  }
}