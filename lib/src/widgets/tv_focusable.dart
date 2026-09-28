import 'package:flutter/foundation.dart';
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
  final VoidCallback? onPressed;
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
    this.onPressed,
    this.focusBuilder,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  late FocusNode _focusNode;

  /// Whether this node is currently focused.
  /// Driven by controller notifications — NOT by FocusNode.hasFocus —
  /// because FocusNode.requestFocus() silently fails when the FocusNode is
  /// unattached (e.g. ListView.builder item scrolled out of view).
  bool _isFocused = false;
  Rect? _lastRect;
  bool _registered = false;
  TvFocusScope? _scope;
  sn.SpatialNavigationController? _controller;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newScope = TvFocusScope.of(context);
    if (newScope?.controller != _controller) {
      // Detach from old controller
      _controller?.removeListener(_onControllerChanged);
      _scope = newScope;
      _controller = newScope?.controller;
      // Attach to new controller
      _controller?.addListener(_onControllerChanged);
    } else {
      _scope = newScope;
    }

    final newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != _scrollPosition) {
      _scrollPosition?.removeListener(_updateRect);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_updateRect);
    }

    _updateRegistration();
  }

  @override
  void didUpdateWidget(covariant TvFocusable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled ||
        widget.visible != oldWidget.visible ||
        widget.groupId != oldWidget.groupId ||
        !mapEquals(widget.navigationOverrides, oldWidget.navigationOverrides)) {
      _updateRegistration();
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode = widget.focusNode ?? FocusNode();
      _updateRegistration();
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_updateRect);
    _controller?.removeListener(_onControllerChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _unregister();
    super.dispose();
  }

  /// Called whenever the SpatialNavigationController notifies listeners.
  /// Updates _isFocused based on whether this node is the currently focused one.
  void _onControllerChanged() {
    if (!mounted) return;
    final controller = _controller;
    if (controller == null) return;

    // Check if this node ID is the currently focused node
    final lastFocused = controller.lastFocusedNode;
    final isFocused = lastFocused?.id == widget.id;

    if (isFocused != _isFocused) {
      if (kDebugMode) {
        debugPrint('[TvFocusable] ${widget.id}: focus=${isFocused ? "ON" : "OFF"}');
      }
      setState(() {
        _isFocused = isFocused;
      });
      if (isFocused) {
        _register();
        widget.onFocused?.call();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isFocused) {
            Scrollable.ensureVisible(
              context,
              alignment: 0.25,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            );
          }
        });
      } else {
        widget.onUnfocused?.call();
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
    _scope?.controller.unregisterNode(widget.id);
  }

  void _updateRegistration() {
    final controller = _controller ?? TvFocusScope.of(context)?.controller;
    if (controller == null) return;

    final groupId = widget.groupId ?? _scope?.groupId ?? TvFocusScope.of(context)?.groupId;

    final node = sn.SpatialNavigationNode(
      id: widget.id,
      rect: _lastRect ?? Rect.zero,
      rectProvider: () {
        if (!mounted) return null;
        final renderObject = context.findRenderObject();
        if (renderObject is RenderBox && renderObject.attached) {
          final transform = renderObject.getTransformTo(null);
          return MatrixUtils.transformRect(transform, renderObject.paintBounds);
        }
        return null;
      },
      enabled: widget.enabled,
      visible: widget.visible,
      row: widget.row,
      column: widget.column,
      groupId: groupId,
      focusNode: _focusNode,
      navigationOverrides: widget.navigationOverrides,
      metadata: widget.onPressed,
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
    // The Focus widget here is kept for completeness (e.g. for consumers that
    // use widget.focusNode directly), but visual focus state is driven by
    // _onControllerChanged above, not by FocusNode.hasFocus.
    Widget child = Focus(
      focusNode: _focusNode,
      canRequestFocus: true,
      skipTraversal: true,
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