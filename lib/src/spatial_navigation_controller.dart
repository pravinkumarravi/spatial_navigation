import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'spatial_navigation_direction.dart';
import 'spatial_navigation_node.dart';
import 'spatial_navigation_registry.dart';
import 'spatial_navigation_engine.dart';
import 'spatial_navigation_scope.dart';
import 'spatial_navigation_result.dart';
import 'spatial_navigation_config.dart';

class SpatialNavigationController extends ChangeNotifier {
  final SpatialNavigationRegistry _registry;
  final SpatialNavigationEngine _engine;
  final SpatialNavigationScope _scope;
  
  SpatialNavigationNode? _lastFocusedNode;
  String? _lastGroupId;
  final Map<String, String> _focusHistory = {};
  final List<FocusHistoryEntry> _navigationHistory = [];
  static const int _maxHistorySize = 100;

  factory SpatialNavigationController({
    SpatialNavigationRegistry? registry,
    SpatialNavigationEngine? engine,
    SpatialNavigationScope? scope,
    SpatialNavigationConfig? config,
  }) {
    final effectiveRegistry = registry ?? engine?.registry ?? SpatialNavigationRegistry();
    final effectiveEngine = engine ??
        SpatialNavigationEngine(
          registry: effectiveRegistry,
          config: config ?? const SpatialNavigationConfig(),
        );
    final effectiveScope = scope ?? SpatialNavigationScope();
    return SpatialNavigationController._(
      registry: effectiveRegistry,
      engine: effectiveEngine,
      scope: effectiveScope,
    );
  }

  SpatialNavigationController._({
    required SpatialNavigationRegistry registry,
    required SpatialNavigationEngine engine,
    required SpatialNavigationScope scope,
  })  : _registry = registry,
        _engine = engine,
        _scope = scope;

  SpatialNavigationRegistry get registry => _registry;
  SpatialNavigationEngine get engine => _engine;
  SpatialNavigationScope get scope => _scope;

  SpatialNavigationNode? get lastFocusedNode => _lastFocusedNode;
  String? get lastGroupId => _lastGroupId;

  Future<SpatialNavigationResult> move(
    TvNavigationDirection direction, {
    String? groupId,
  }) async {
    final effectiveGroupId = _scope.getEffectiveGroupId(groupId);
    final currentNode = _getCurrentFocusedNode(effectiveGroupId);
    
    if (currentNode == null) {
      return _handleNoFocus(direction, effectiveGroupId);
    }

    // Check if group boundary blocks movement in this direction
    if (effectiveGroupId != null && !_scope.canExitGroup(effectiveGroupId, direction)) {
      // Force navigation to remain within effectiveGroupId candidates
      final result = _engine.navigate(direction, fromGroupId: effectiveGroupId, currentNode: currentNode);
      if (result.success && result.targetNode != null) {
        await _applyFocusChange(result, effectiveGroupId);
      }
      _logNavigation(direction, result);
      return result;
    }

    final result = _engine.navigate(direction, fromGroupId: effectiveGroupId, currentNode: currentNode);
    
    if (result.success && result.targetNode != null) {
      await _applyFocusChange(result, effectiveGroupId);
    }

    _logNavigation(direction, result);
    return result;
  }

  Future<void> _applyFocusChange(SpatialNavigationResult result, String? groupId) async {
    final targetNode = result.targetNode!;
    final currentNode = result.currentNode;
    
    if (currentNode != null) {
      _recordFocusHistory(currentNode, groupId);
    }

    targetNode.focusNode.requestFocus();
    _lastFocusedNode = targetNode;
    _lastGroupId = groupId;
    _registry.setFocusedNode(groupId ?? targetNode.groupId ?? '', targetNode);
    notifyListeners();
  }

  SpatialNavigationResult _handleNoFocus(TvNavigationDirection direction, String? groupId) {
    final entryNodeId = groupId != null ? _scope.getPreferredEntryNode(groupId) : null;
    if (entryNodeId != null) {
      final entryNode = _registry.getNode(entryNodeId);
      if (entryNode != null && entryNode.isFocusable) {
        entryNode.focusNode.requestFocus();
        _lastFocusedNode = entryNode;
        _lastGroupId = groupId;
        _registry.setFocusedNode(groupId!, entryNode);
        notifyListeners();
        return SpatialNavigationResult.success(
          targetNode: entryNode,
          direction: direction,
          candidates: [],
          currentNode: null,
        );
      }
    }

    final nodes = _registry.getVisibleEnabledNodes(groupId);
    if (nodes.isNotEmpty) {
      final firstNode = nodes.first;
      firstNode.focusNode.requestFocus();
      _lastFocusedNode = firstNode;
      _lastGroupId = groupId;
      _registry.setFocusedNode(groupId ?? firstNode.groupId ?? '', firstNode);
      notifyListeners();
      return SpatialNavigationResult.success(
        targetNode: firstNode,
        direction: direction,
        candidates: [],
        currentNode: null,
      );
    }

    return SpatialNavigationResult.failure(
      direction: direction,
      currentNode: null,
      reason: 'No focusable nodes available',
    );
  }

  SpatialNavigationNode? _getCurrentFocusedNode(String? groupId) {
    if (groupId != null) {
      return _registry.getFocusedNode(groupId);
    }
    return _lastFocusedNode;
  }

  void _recordFocusHistory(SpatialNavigationNode node, String? groupId) {
    final key = '${groupId ?? 'root'}:${node.id}';
    _focusHistory[key] = node.id;
    
    _navigationHistory.add(FocusHistoryEntry(
      groupId: groupId,
      nodeId: node.id,
      timestamp: DateTime.now(),
    ));
    
    if (_navigationHistory.length > _maxHistorySize) {
      _navigationHistory.removeAt(0);
    }
  }

  void restoreFocus(String? groupId) {
    final effectiveGroupId = groupId ?? _lastGroupId;
    if (effectiveGroupId == null) return;

    final historyKey = '$effectiveGroupId:${_focusHistory['$effectiveGroupId:${_lastFocusedNode?.id}'] ?? ''}';
    final lastNodeId = _focusHistory[historyKey] ?? _focusHistory['$effectiveGroupId:'];
    
    if (lastNodeId != null) {
      final node = _registry.getNode(lastNodeId);
      if (node != null && node.isFocusable) {
        node.focusNode.requestFocus();
        _lastFocusedNode = node;
        _registry.setFocusedNode(effectiveGroupId, node);
        notifyListeners();
        return;
      }
    }

    final preferredEntry = _scope.getPreferredEntryNode(effectiveGroupId);
    if (preferredEntry != null) {
      final node = _registry.getNode(preferredEntry);
      if (node != null && node.isFocusable) {
        node.focusNode.requestFocus();
        _lastFocusedNode = node;
        _registry.setFocusedNode(effectiveGroupId, node);
        notifyListeners();
        return;
      }
    }

    final nodes = _registry.getVisibleEnabledNodes(effectiveGroupId);
    if (nodes.isNotEmpty) {
      final node = nodes.first;
      node.focusNode.requestFocus();
      _lastFocusedNode = node;
      _registry.setFocusedNode(effectiveGroupId, node);
      notifyListeners();
    }
  }

  void onNodeFocused(String nodeId, String? groupId) {
    final node = _registry.getNode(nodeId);
    if (node != null) {
      _lastFocusedNode = node;
      _lastGroupId = groupId ?? node.groupId;
      if (_lastGroupId != null) {
        _registry.setFocusedNode(_lastGroupId!, node);
      }
      notifyListeners();
    }
  }

  void onNodeUnfocused(String nodeId) {
    if (_lastFocusedNode?.id == nodeId) {
      _lastFocusedNode = null;
      notifyListeners();
    }
  }

  void registerNode(SpatialNavigationNode node) {
    _registry.registerNode(node);
  }

  void unregisterNode(String id) {
    _registry.unregisterNode(id);
  }

  void updateNodeRect(String id, Rect rect) {
    _registry.updateNodeRect(id, rect);
  }

  void updateNodeVisibility(String id, bool visible) {
    _registry.updateNodeVisibility(id, visible);
  }

  void updateNodeEnabled(String id, bool enabled) {
    _registry.updateNodeEnabled(id, enabled);
  }

  void addGroup(SpatialNavigationGroup group) {
    _scope.addGroup(group);
  }

  void removeGroup(String groupId) {
    _scope.removeGroup(groupId);
  }

  void enterGroup(String groupId) {
    _scope.enterGroup(groupId);
  }

  void exitGroup(String groupId) {
    _scope.exitGroup(groupId);
  }

  void showModal(String groupId) {
    _scope.addGroup(SpatialNavigationGroup(
      id: groupId,
      isModal: true,
      priority: 100,
    ));
    _scope.enterGroup(groupId);
  }

  void hideModal(String groupId) {
    _scope.exitGroup(groupId);
    _scope.removeGroup(groupId);
    restoreFocus(_lastGroupId);
  }

  void _logNavigation(TvNavigationDirection direction, SpatialNavigationResult result) {
    if (kDebugMode) {
      if (result.success) {
        debugPrint('[TVNav] $direction -> ${result.targetNode?.id} (candidates: ${result.candidates.length})');
        if (result.candidates.isNotEmpty) {
          debugPrint('[TVNav] Top candidate: ${result.candidates.first}');
        }
      } else {
        debugPrint('[TVNav] $direction -> FAILED: ${result.reason}');
      }
    }
  }

  void clearHistory() {
    _focusHistory.clear();
    _navigationHistory.clear();
  }

  List<FocusHistoryEntry> getNavigationHistory() => List.unmodifiable(_navigationHistory);
}

class FocusHistoryEntry {
  final String? groupId;
  final String nodeId;
  final DateTime timestamp;

  const FocusHistoryEntry({
    required this.groupId,
    required this.nodeId,
    required this.timestamp,
  });
}