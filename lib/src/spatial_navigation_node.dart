import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import 'spatial_navigation_direction.dart';

class SpatialNavigationNode {
  final String id;
  final Rect rect;
  final bool enabled;
  final bool visible;
  final int? row;
  final int? column;
  final String? groupId;
  final FocusNode focusNode;
  final Map<TvNavigationDirection, String>? navigationOverrides;
  final int registrationOrder;
  final Object? metadata;

  const SpatialNavigationNode({
    required this.id,
    required this.rect,
    this.enabled = true,
    this.visible = true,
    this.row,
    this.column,
    this.groupId,
    required this.focusNode,
    this.navigationOverrides,
    this.registrationOrder = 0,
    this.metadata,
  });

  SpatialNavigationNode copyWith({
    String? id,
    Rect? rect,
    bool? enabled,
    bool? visible,
    int? row,
    int? column,
    String? groupId,
    FocusNode? focusNode,
    Map<TvNavigationDirection, String>? navigationOverrides,
    int? registrationOrder,
    Object? metadata,
  }) {
    return SpatialNavigationNode(
      id: id ?? this.id,
      rect: rect ?? this.rect,
      enabled: enabled ?? this.enabled,
      visible: visible ?? this.visible,
      row: row ?? this.row,
      column: column ?? this.column,
      groupId: groupId ?? this.groupId,
      focusNode: focusNode ?? this.focusNode,
      navigationOverrides: navigationOverrides ?? this.navigationOverrides,
      registrationOrder: registrationOrder ?? this.registrationOrder,
      metadata: metadata ?? this.metadata,
    );
  }

  Offset get center => rect.center;
  double get left => rect.left;
  double get right => rect.right;
  double get top => rect.top;
  double get bottom => rect.bottom;
  double get width => rect.width;
  double get height => rect.height;

  bool get isFocusable => enabled && visible && rect.width > 0 && rect.height > 0;

  bool hasOverride(TvNavigationDirection direction) {
    return navigationOverrides?.containsKey(direction) ?? false;
  }

  String? getOverride(TvNavigationDirection direction) {
    return navigationOverrides?[direction];
  }

  double getPrimaryDistance(SpatialNavigationNode other, TvNavigationDirection direction) {
    switch (direction) {
      case TvNavigationDirection.right:
        return other.left - right;
      case TvNavigationDirection.left:
        return left - other.right;
      case TvNavigationDirection.down:
        return other.top - bottom;
      case TvNavigationDirection.up:
        return top - other.bottom;
    }
  }

  double getSecondaryDistance(SpatialNavigationNode other, TvNavigationDirection direction) {
    if (direction.isHorizontal) {
      return (other.center.dy - center.dy).abs();
    } else {
      return (other.center.dx - center.dx).abs();
    }
  }

  double getOverlap(SpatialNavigationNode other, TvNavigationDirection direction) {
    if (direction.isHorizontal) {
      final start = math.max(top, other.top);
      final end = math.min(bottom, other.bottom);
      final overlap = (end - start).clamp(0.0, double.infinity);
      final minHeight = math.min(height, other.height);
      return minHeight > 0 ? overlap / minHeight : 0.0;
    } else {
      final start = math.max(left, other.left);
      final end = math.min(right, other.right);
      final overlap = (end - start).clamp(0.0, double.infinity);
      final minWidth = math.min(width, other.width);
      return minWidth > 0 ? overlap / minWidth : 0.0;
    }
  }

  bool isInDirection(SpatialNavigationNode other, TvNavigationDirection direction) {
    switch (direction) {
      case TvNavigationDirection.right:
        return other.center.dx >= center.dx;
      case TvNavigationDirection.left:
        return other.center.dx <= center.dx;
      case TvNavigationDirection.down:
        return other.center.dy >= center.dy;
      case TvNavigationDirection.up:
        return other.center.dy <= center.dy;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpatialNavigationNode && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SpatialNavigationNode(id: $id, rect: $rect, enabled: $enabled, visible: $visible, groupId: $groupId)';
  }
}