import 'package:flutter/widgets.dart';


class TvScrollableRow extends StatefulWidget {
  final List<Widget> children;
  final double pivotFraction;
  final Duration scrollDuration;
  final Curve scrollCurve;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final double? itemExtent;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final String? groupId;
  final Widget Function(int, Widget)? itemBuilder;
  final double? height;

  const TvScrollableRow({
    super.key,
    required this.children,
    this.pivotFraction = 0.3,
    this.scrollDuration = const Duration(milliseconds: 300),
    this.scrollCurve = Curves.easeOutCubic,
    this.padding,
    this.physics,
    this.itemExtent,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.groupId,
    this.itemBuilder,
    this.height,
  });

  @override
  State<TvScrollableRow> createState() => _TvScrollableRowState();
}

class _TvScrollableRowState extends State<TvScrollableRow> {
  late ScrollController _scrollController;
  bool _isAnimating = false;
  final List<GlobalKey> _itemKeys = [];

  ScrollController get effectiveController => widget.controller ?? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _itemKeys.clear();
    for (int i = 0; i < widget.children.length; i++) {
      _itemKeys.add(GlobalKey());
    }
    effectiveController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant TvScrollableRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _itemKeys.clear();
      for (int i = 0; i < widget.children.length; i++) {
        _itemKeys.add(GlobalKey());
      }
    }
  }

  @override
  void dispose() {
    effectiveController.removeListener(_onScroll);
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_isAnimating) {
    }
  }

  Future<void> scrollToIndex(int index, {Duration? duration, Curve? curve}) async {
    if (index < 0 || index >= widget.children.length) return;
    if (!effectiveController.hasClients) return;

    double? targetOffset;
    if (index < _itemKeys.length) {
      final key = _itemKeys[index];
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.attached) {
          final itemRect = MatrixUtils.transformRect(renderBox.getTransformTo(null), renderBox.paintBounds);
          final viewportWidth = context.size!.width;
          final pivotX = viewportWidth * widget.pivotFraction;
          final itemCenterX = itemRect.left + itemRect.width / 2;
          targetOffset = itemCenterX - pivotX;
        }
      }
    }

    if (targetOffset == null && widget.itemExtent != null) {
      targetOffset = index * widget.itemExtent!;
    }

    if (targetOffset == null) return;

    final maxScrollExtent = effectiveController.position.maxScrollExtent;
    targetOffset = targetOffset.clamp(0.0, maxScrollExtent);

    if (targetOffset == effectiveController.offset) return;

    _isAnimating = true;

    await effectiveController.animateTo(
      targetOffset,
      duration: duration ?? widget.scrollDuration,
      curve: curve ?? widget.scrollCurve,
    );

    _isAnimating = false;
  }

  Future<void> ensureIndexVisible(int index) async {
    await scrollToIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      controller: effectiveController,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      padding: widget.padding,
      physics: widget.physics,
      itemExtent: widget.itemExtent,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        final child = widget.children[index];
        final key = _itemKeys[index];
        
        if (widget.itemBuilder != null) {
          return widget.itemBuilder!(index, child);
        }
        
        return KeyedSubtree(
          key: key,
          child: child,
        );
      },
    );
    
    if (widget.height != null) {
      return SizedBox(
        height: widget.height,
        child: listView,
      );
    }
    
    return listView;
  }
}

class TvScrollableGrid extends StatefulWidget {
  final List<Widget> children;
  final double pivotFractionX;
  final double pivotFractionY;
  final Duration scrollDuration;
  final Curve scrollCurve;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final SliverGridDelegate gridDelegate;
  final bool shrinkWrap;
  final ScrollController? controller;
  final String? groupId;

  const TvScrollableGrid({
    super.key,
    required this.children,
    this.pivotFractionX = 0.3,
    this.pivotFractionY = 0.3,
    this.scrollDuration = const Duration(milliseconds: 300),
    this.scrollCurve = Curves.easeOutCubic,
    this.padding,
    this.physics,
    required this.gridDelegate,
    this.shrinkWrap = false,
    this.controller,
    this.groupId,
  });

  @override
  State<TvScrollableGrid> createState() => _TvScrollableGridState();
}

class _TvScrollableGridState extends State<TvScrollableGrid> {
  late ScrollController _scrollController;
  bool _isAnimating = false;
  final List<GlobalKey> _itemKeys = [];

  ScrollController get effectiveController => widget.controller ?? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _itemKeys.clear();
    for (int i = 0; i < widget.children.length; i++) {
      _itemKeys.add(GlobalKey());
    }
    effectiveController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant TvScrollableGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _itemKeys.clear();
      for (int i = 0; i < widget.children.length; i++) {
        _itemKeys.add(GlobalKey());
      }
    }
  }

  @override
  void dispose() {
    effectiveController.removeListener(_onScroll);
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_isAnimating) {}
  }

  Future<void> scrollToIndex(int index, {Duration? duration, Curve? curve}) async {
    if (index < 0 || index >= widget.children.length) return;
    if (!effectiveController.hasClients) return;

    double? targetOffset;
    if (index < _itemKeys.length) {
      final key = _itemKeys[index];
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.attached) {
          final itemRect = MatrixUtils.transformRect(renderBox.getTransformTo(null), renderBox.paintBounds);
          final viewportSize = context.size!;
          final isHorizontal = effectiveController.position.axis == Axis.horizontal;
          final pivot = isHorizontal 
              ? viewportSize.width * widget.pivotFractionX 
              : viewportSize.height * widget.pivotFractionY;
          final itemCenter = isHorizontal 
              ? itemRect.left + itemRect.width / 2 
              : itemRect.top + itemRect.height / 2;
          targetOffset = itemCenter - pivot;
        }
      }
    }

    if (targetOffset == null) return;

    final maxScrollExtent = effectiveController.position.maxScrollExtent;
    targetOffset = targetOffset.clamp(0.0, maxScrollExtent);

    if (targetOffset == effectiveController.offset) return;

    _isAnimating = true;

    await effectiveController.animateTo(
      targetOffset,
      duration: duration ?? widget.scrollDuration,
      curve: curve ?? widget.scrollCurve,
    );

    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: effectiveController,
      padding: widget.padding,
      physics: widget.physics,
      gridDelegate: widget.gridDelegate,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        final child = widget.children[index];
        final key = _itemKeys[index];
        return KeyedSubtree(key: key, child: child);
      },
    );
  }
}

class TvScrollableList extends StatefulWidget {
  final List<Widget> children;
  final double pivotFraction;
  final Duration scrollDuration;
  final Curve scrollCurve;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final String? groupId;

  const TvScrollableList({
    super.key,
    required this.children,
    this.pivotFraction = 0.3,
    this.scrollDuration = const Duration(milliseconds: 300),
    this.scrollCurve = Curves.easeOutCubic,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.groupId,
  });

  @override
  State<TvScrollableList> createState() => _TvScrollableListState();
}

class _TvScrollableListState extends State<TvScrollableList> {
  late ScrollController _scrollController;
  bool _isAnimating = false;
  final List<GlobalKey> _itemKeys = [];

  ScrollController get effectiveController => widget.controller ?? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _itemKeys.clear();
    for (int i = 0; i < widget.children.length; i++) {
      _itemKeys.add(GlobalKey());
    }
    effectiveController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant TvScrollableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _itemKeys.clear();
      for (int i = 0; i < widget.children.length; i++) {
        _itemKeys.add(GlobalKey());
      }
    }
  }

  @override
  void dispose() {
    effectiveController.removeListener(_onScroll);
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_isAnimating) {}
  }

  Future<void> scrollToIndex(int index, {Duration? duration, Curve? curve}) async {
    if (index < 0 || index >= widget.children.length) return;
    if (!effectiveController.hasClients) return;

    double? targetOffset;
    if (index < _itemKeys.length) {
      final key = _itemKeys[index];
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.attached) {
          final itemRect = MatrixUtils.transformRect(renderBox.getTransformTo(null), renderBox.paintBounds);
          final viewportSize = context.size!;
          final isHorizontal = widget.scrollDirection == Axis.horizontal;
          final viewportLength = isHorizontal ? viewportSize.width : viewportSize.height;
          final pivot = viewportLength * widget.pivotFraction;
          final itemCenter = isHorizontal 
              ? itemRect.left + itemRect.width / 2
              : itemRect.top + itemRect.height / 2;
          targetOffset = itemCenter - pivot;
        }
      }
    }

    if (targetOffset == null) return;

    final maxScrollExtent = effectiveController.position.maxScrollExtent;
    targetOffset = targetOffset.clamp(0.0, maxScrollExtent);

    if (targetOffset == effectiveController.offset) return;

    _isAnimating = true;

    await effectiveController.animateTo(
      targetOffset,
      duration: duration ?? widget.scrollDuration,
      curve: curve ?? widget.scrollCurve,
    );

    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: effectiveController,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      padding: widget.padding,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        final child = widget.children[index];
        final key = _itemKeys[index];
        return KeyedSubtree(key: key, child: child);
      },
    );
  }
}

class TvLazyScrollableRow extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double pivotFraction;
  final Duration scrollDuration;
  final Curve scrollCurve;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final double? itemExtent;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final String? groupId;
  final Future<void> Function(int)? onPageRequest;

  const TvLazyScrollableRow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.pivotFraction = 0.3,
    this.scrollDuration = const Duration(milliseconds: 300),
    this.scrollCurve = Curves.easeOutCubic,
    this.padding,
    this.physics,
    this.itemExtent,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.groupId,
    this.onPageRequest,
  });

  @override
  State<TvLazyScrollableRow> createState() => _TvLazyScrollableRowState();
}

class _TvLazyScrollableRowState extends State<TvLazyScrollableRow> {
  late ScrollController _scrollController;
  bool _isAnimating = false;

  ScrollController get effectiveController => widget.controller ?? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    effectiveController.addListener(_onScroll);
  }

  @override
  void dispose() {
    effectiveController.removeListener(_onScroll);
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_isAnimating && widget.onPageRequest != null && effectiveController.hasClients) {
      final position = effectiveController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        final currentItem = _estimateCurrentItem();
        widget.onPageRequest!(currentItem);
      }
    }
  }

  int _estimateCurrentItem() {
    if (effectiveController.hasClients && widget.itemExtent != null && widget.itemExtent! > 0) {
      return (effectiveController.offset / widget.itemExtent!).floor();
    }
    return 0;
  }

  Future<void> scrollToIndex(int index, {Duration? duration, Curve? curve}) async {
    if (index < 0 || index >= widget.itemCount) return;
    if (!effectiveController.hasClients) return;
    if (widget.itemExtent == null) return;

    final targetOffset = index * widget.itemExtent!;
    final maxScrollExtent = effectiveController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

    if (clampedOffset == effectiveController.offset) return;

    _isAnimating = true;

    await effectiveController.animateTo(
      clampedOffset,
      duration: duration ?? widget.scrollDuration,
      curve: curve ?? widget.scrollCurve,
    );

    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: effectiveController,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      padding: widget.padding,
      physics: widget.physics,
      itemExtent: widget.itemExtent,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
    );
  }
}