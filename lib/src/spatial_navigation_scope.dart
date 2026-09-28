import 'package:flutter/foundation.dart';

import 'spatial_navigation_direction.dart';

class NavigationBoundaries {
  final bool canExitLeft;
  final bool canExitRight;
  final bool canExitUp;
  final bool canExitDown;

  const NavigationBoundaries({
    this.canExitLeft = true,
    this.canExitRight = true,
    this.canExitUp = true,
    this.canExitDown = true,
  });

  bool canExit(TvNavigationDirection direction) {
    switch (direction) {
      case TvNavigationDirection.left:
        return canExitLeft;
      case TvNavigationDirection.right:
        return canExitRight;
      case TvNavigationDirection.up:
        return canExitUp;
      case TvNavigationDirection.down:
        return canExitDown;
    }
  }

  NavigationBoundaries copyWith({
    bool? canExitLeft,
    bool? canExitRight,
    bool? canExitUp,
    bool? canExitDown,
  }) {
    return NavigationBoundaries(
      canExitLeft: canExitLeft ?? this.canExitLeft,
      canExitRight: canExitRight ?? this.canExitRight,
      canExitUp: canExitUp ?? this.canExitUp,
      canExitDown: canExitDown ?? this.canExitDown,
    );
  }
}

enum NavigationMode {
  spatial,
  logical,
  hybrid,
}

class SpatialNavigationGroup {
  final String id;
  final String? parentId;
  final NavigationBoundaries boundaries;
  final NavigationMode mode;
  final String? preferredEntryNodeId;
  final String? preferredExitNodeId;
  final bool isModal;
  final int priority;

  SpatialNavigationGroup({
    required this.id,
    this.parentId,
    NavigationBoundaries? boundaries,
    this.mode = NavigationMode.spatial,
    this.preferredEntryNodeId,
    this.preferredExitNodeId,
    this.isModal = false,
    this.priority = 0,
  }) : boundaries = boundaries ?? const NavigationBoundaries();

  SpatialNavigationGroup copyWith({
    String? id,
    String? parentId,
    NavigationBoundaries? boundaries,
    NavigationMode? mode,
    String? preferredEntryNodeId,
    String? preferredExitNodeId,
    bool? isModal,
    int? priority,
  }) {
    return SpatialNavigationGroup(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      boundaries: boundaries ?? this.boundaries,
      mode: mode ?? this.mode,
      preferredEntryNodeId: preferredEntryNodeId ?? this.preferredEntryNodeId,
      preferredExitNodeId: preferredExitNodeId ?? this.preferredExitNodeId,
      isModal: isModal ?? this.isModal,
      priority: priority ?? this.priority,
    );
  }
}

class SpatialNavigationScope extends ChangeNotifier {
  final Map<String, SpatialNavigationGroup> _groups = {};
  final List<String> _groupStack = [];
  String? _currentGroupId;
  String? _modalGroupId;

  Map<String, SpatialNavigationGroup> get groups => Map.unmodifiable(_groups);
  String? get currentGroupId => _currentGroupId;
  String? get modalGroupId => _modalGroupId;
  bool get hasModal => _modalGroupId != null;

  SpatialNavigationGroup? getCurrentGroup() {
    if (_currentGroupId != null) {
      return _groups[_currentGroupId];
    }
    return null;
  }

  SpatialNavigationGroup? getGroup(String id) => _groups[id];

  void addGroup(SpatialNavigationGroup group) {
    _groups[group.id] = group;
    notifyListeners();
  }

  void removeGroup(String groupId) {
    _groups.remove(groupId);
    _groupStack.remove(groupId);
    if (_currentGroupId == groupId) {
      _currentGroupId = _groupStack.isNotEmpty ? _groupStack.last : null;
    }
    if (_modalGroupId == groupId) {
      _modalGroupId = null;
    }
    notifyListeners();
  }

  void enterGroup(String groupId) {
    final group = _groups[groupId];
    if (group == null) return;

    if (group.isModal) {
      _modalGroupId = groupId;
    }

    _groupStack.add(groupId);
    _currentGroupId = groupId;
    notifyListeners();
  }

  void exitGroup(String groupId) {
    _groupStack.remove(groupId);
    if (_currentGroupId == groupId) {
      _currentGroupId = _groupStack.isNotEmpty ? _groupStack.last : null;
    }
    if (_modalGroupId == groupId) {
      _modalGroupId = null;
    }
    notifyListeners();
  }

  void setCurrentGroup(String? groupId) {
    _currentGroupId = groupId;
    notifyListeners();
  }

  String? getEffectiveGroupId(String? requestedGroupId) {
    if (_modalGroupId != null) {
      return _modalGroupId;
    }
    return requestedGroupId ?? _currentGroupId;
  }

  NavigationBoundaries? getEffectiveBoundaries(String? groupId) {
    final effectiveId = getEffectiveGroupId(groupId);
    if (effectiveId != null) {
      return _groups[effectiveId]?.boundaries;
    }
    return null;
  }

  bool canExitGroup(String groupId, TvNavigationDirection direction) {
    final group = _groups[groupId];
    if (group == null) return true;
    return group.boundaries.canExit(direction);
  }

  String? getPreferredEntryNode(String groupId) {
    return _groups[groupId]?.preferredEntryNodeId;
  }

  String? getPreferredExitNode(String groupId) {
    return _groups[groupId]?.preferredExitNodeId;
  }

  List<String> getGroupStack() => List.unmodifiable(_groupStack);

  void clear() {
    _groups.clear();
    _groupStack.clear();
    _currentGroupId = null;
    _modalGroupId = null;
    notifyListeners();
  }
}