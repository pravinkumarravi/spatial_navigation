import 'package:flutter/widgets.dart';

import 'spatial_navigation_node.dart';

class SpatialNavigationRegistry extends ChangeNotifier {
  final Map<String, SpatialNavigationNode> _nodes = {};
  final Map<String, Set<String>> _groupNodes = {};
  final Map<String, SpatialNavigationNode> _focusedNodes = {};
  int _registrationCounter = 0;

  Map<String, SpatialNavigationNode> get nodes => Map.unmodifiable(_nodes);
  Map<String, Set<String>> get groupNodes => Map.unmodifiable(_groupNodes);

  SpatialNavigationNode? getNode(String id) => _nodes[id];

  List<SpatialNavigationNode> getAllNodes() => _nodes.values.toList();

  Set<String> getGroupNodeIds(String groupId) => _groupNodes[groupId] ?? {};

  List<SpatialNavigationNode> getGroupNodes(String groupId) {
    final ids = _groupNodes[groupId];
    if (ids == null) return [];
    return ids.map((id) => _nodes[id]).nonNulls.toList();
  }

  SpatialNavigationNode? getFocusedNode(String groupId) => _focusedNodes[groupId];

  void setFocusedNode(String groupId, SpatialNavigationNode node) {
    _focusedNodes[groupId] = node;
    notifyListeners();
  }

  void clearFocusedNode(String groupId) {
    _focusedNodes.remove(groupId);
    notifyListeners();
  }

  Iterable<SpatialNavigationNode> getAllFocusedNodes() => _focusedNodes.values;

  void registerNode(SpatialNavigationNode node) {
    final existing = _nodes[node.id];
    if (existing != null) {
      if (existing.groupId != node.groupId) {
        if (existing.groupId != null) {
          _groupNodes[existing.groupId!]?.remove(node.id);
          if (_groupNodes[existing.groupId!]?.isEmpty ?? false) {
            _groupNodes.remove(existing.groupId!);
          }
        }
        if (node.groupId != null) {
          _groupNodes.putIfAbsent(node.groupId!, () => {}).add(node.id);
        }
      }
      _nodes[node.id] = existing.copyWith(
        rect: node.rect,
        enabled: node.enabled,
        visible: node.visible,
        row: node.row,
        column: node.column,
        groupId: node.groupId,
        focusNode: node.focusNode, // Always update – prevents stale FocusNode after rebuilds
        navigationOverrides: node.navigationOverrides,
        metadata: node.metadata,
      );
    } else {
      _nodes[node.id] = node.copyWith(registrationOrder: _registrationCounter++);
      if (node.groupId != null) {
        _groupNodes.putIfAbsent(node.groupId!, () => {}).add(node.id);
      }
    }
    notifyListeners();
  }

  void unregisterNode(String id) {
    final node = _nodes.remove(id);
    if (node != null && node.groupId != null) {
      _groupNodes[node.groupId!]?.remove(id);
      if (_groupNodes[node.groupId!]?.isEmpty ?? false) {
        _groupNodes.remove(node.groupId!);
      }
      _focusedNodes.remove(node.groupId);
    }
    notifyListeners();
  }

  void updateNodeRect(String id, Rect rect) {
    final node = _nodes[id];
    if (node != null && node.rect != rect) {
      _nodes[id] = node.copyWith(rect: rect);
    }
  }

  void updateNodeVisibility(String id, bool visible) {
    final node = _nodes[id];
    if (node != null) {
      _nodes[id] = node.copyWith(visible: visible);
      notifyListeners();
    }
  }

  void updateNodeEnabled(String id, bool enabled) {
    final node = _nodes[id];
    if (node != null) {
      _nodes[id] = node.copyWith(enabled: enabled);
      notifyListeners();
    }
  }

  void updateNodeGroup(String id, String? newGroupId) {
    final node = _nodes[id];
    if (node != null) {
      if (node.groupId != null) {
        _groupNodes[node.groupId!]?.remove(id);
        if (_groupNodes[node.groupId!]?.isEmpty ?? false) {
          _groupNodes.remove(node.groupId!);
        }
      }
      _nodes[id] = node.copyWith(groupId: newGroupId);
      if (newGroupId != null) {
        _groupNodes.putIfAbsent(newGroupId, () => {}).add(id);
      }
      notifyListeners();
    }
  }

  List<SpatialNavigationNode> getVisibleEnabledNodes([String? groupId]) {
    if (groupId != null) {
      return getGroupNodes(groupId).where((n) => n.isFocusable).toList();
    }
    return _nodes.values.where((n) => n.isFocusable).toList();
  }

  void clear() {
    _nodes.clear();
    _groupNodes.clear();
    _focusedNodes.clear();
    _registrationCounter = 0;
    notifyListeners();
  }

  void clearGroup(String groupId) {
    final ids = _groupNodes.remove(groupId);
    if (ids != null) {
      for (final id in ids) {
        _nodes.remove(id);
      }
    }
    _focusedNodes.remove(groupId);
    notifyListeners();
  }
}