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
    final effectiveGroupId = _scope.getEffectiveGroupId(groupId) ?? _lastGroupId ?? _lastFocusedNode?.groupId;
    final currentNode = _getCurrentFocusedNode(effectiveGroupId);
    
    if (currentNode == null) {
      return _handleNoFocus(direction, effectiveGroupId);
    }

    final currentGroup = currentNode.groupId ?? effectiveGroupId;

    // 1. First, search for sibling candidates within the current group/container
    if (currentGroup != null) {
      final result = _engine.navigate(direction, fromGroupId: currentGroup, currentNode: currentNode);
      if (result.success && result.targetNode != null) {
        await _applyFocusChange(result, currentGroup);
        _logNavigation(direction, result);
        return result;
      }

      // No sibling candidate found inside current group.
      // Check if group boundary blocks movement in this direction.
      if (!_scope.canExitGroup(currentGroup, direction)) {
        // Blocked by boundary (e.g. left/right boundary of a shelf)
        _logNavigation(direction, result);
        return result;
      }
    }

    // 2. We can exit current group (or no group restriction).
    // Try to find the next section container/group in this direction!
    SpatialNavigationNode? targetNode;
    String? targetGroupId;

    if (currentGroup != null) {
      targetGroupId = _findNextGroup(currentGroup, direction);
      if (targetGroupId != null) {
        targetNode = _resolveGroupEntryNode(targetGroupId, currentNode, direction);
      }
    }

    // 3. Fallback: navigate across all visible nodes
    if (targetNode == null) {
      final result = _engine.navigate(direction, fromGroupId: null, currentNode: currentNode);
      if (result.success && result.targetNode != null) {
        targetNode = result.targetNode!;
        targetGroupId = targetNode.groupId;

        if (targetGroupId != null && targetGroupId != currentGroup) {
          final preferredEntryId = _scope.getPreferredEntryNode(targetGroupId);
          if (preferredEntryId != null) {
            final preferredNode = _registry.getNode(preferredEntryId);
            if (preferredNode != null && preferredNode.isFocusable) {
              targetNode = preferredNode;
            }
          }
        }
      }
    }

    if (targetNode != null && targetNode.isFocusable) {
      final finalResult = SpatialNavigationResult.success(
        targetNode: targetNode,
        direction: direction,
        candidates: [],
        currentNode: currentNode,
      );
      await _applyFocusChange(finalResult, targetNode.groupId ?? targetGroupId);
      _logNavigation(direction, finalResult);
      return finalResult;
    }

    final failResult = SpatialNavigationResult.failure(
      direction: direction,
      currentNode: currentNode,
      reason: 'No valid candidate in direction',
    );
    _logNavigation(direction, failResult);
    return failResult;
  }

  String? _findNextGroup(String currentGroupId, TvNavigationDirection direction) {
    final explicitNextGroup = _scope.groups[currentGroupId]?.boundaries.nextGroup(direction);
    if (explicitNextGroup != null && _scope.groups.containsKey(explicitNextGroup)) {
      return explicitNextGroup;
    }

    final currentRect = _computeGroupRect(currentGroupId);
    if (currentRect == null) return null;

    final candidates = <String, double>{};

    for (final entry in _scope.groups.entries) {
      final gId = entry.key;
      if (gId == currentGroupId) continue;
      final gRect = _computeGroupRect(gId);
      if (gRect == null) continue;

      switch (direction) {
        case TvNavigationDirection.down:
          if (gRect.top >= currentRect.bottom - 15.0 || gRect.center.dy > currentRect.center.dy + 10.0) {
            final primaryDist = (gRect.top - currentRect.bottom).abs();
            final secondaryDist = (gRect.center.dx - currentRect.center.dx).abs();
            candidates[gId] = primaryDist * 5.0 + secondaryDist;
          }
          break;
        case TvNavigationDirection.up:
          if (gRect.bottom <= currentRect.top + 15.0 || gRect.center.dy < currentRect.center.dy - 10.0) {
            final primaryDist = (currentRect.top - gRect.bottom).abs();
            final secondaryDist = (gRect.center.dx - currentRect.center.dx).abs();
            candidates[gId] = primaryDist * 5.0 + secondaryDist;
          }
          break;
        case TvNavigationDirection.right:
          if (gRect.left >= currentRect.right - 15.0 || gRect.center.dx > currentRect.center.dx + 10.0) {
            final primaryDist = (gRect.left - currentRect.right).abs();
            final secondaryDist = (gRect.center.dy - currentRect.center.dy).abs();
            candidates[gId] = primaryDist * 5.0 + secondaryDist;
          }
          break;
        case TvNavigationDirection.left:
          if (gRect.right <= currentRect.left + 15.0 || gRect.center.dx < currentRect.center.dx - 10.0) {
            final primaryDist = (currentRect.left - gRect.right).abs();
            final secondaryDist = (gRect.center.dy - currentRect.center.dy).abs();
            candidates[gId] = primaryDist * 5.0 + secondaryDist;
          }
          break;
      }
    }

    if (candidates.isEmpty) return null;

    final sorted = candidates.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
    return sorted.first.key;
  }

  Rect? _computeGroupRect(String groupId) {
    final nodes = _registry.getGroupNodes(groupId).where((n) => n.enabled && n.visible).toList();
    if (nodes.isEmpty) return null;
    Rect r = nodes.first.rect;
    for (int i = 1; i < nodes.length; i++) {
      r = r.expandToInclude(nodes[i].rect);
    }
    return r;
  }

  SpatialNavigationNode? _resolveGroupEntryNode(
    String targetGroupId,
    SpatialNavigationNode currentNode,
    TvNavigationDirection direction,
  ) {
    final preferredEntryId = _scope.getPreferredEntryNode(targetGroupId);
    if (preferredEntryId != null) {
      final preferredNode = _registry.getNode(preferredEntryId);
      if (preferredNode != null && preferredNode.isFocusable) {
        return preferredNode;
      }
    }

    final lastFocusedInGroup = _registry.getFocusedNode(targetGroupId);
    if (lastFocusedInGroup != null && lastFocusedInGroup.isFocusable) {
      return lastFocusedInGroup;
    }

    final nodes = _registry.getVisibleEnabledNodes(targetGroupId);
    if (nodes.isNotEmpty) {
      nodes.sort((a, b) {
        if (direction.isVertical) {
          final diffA = (a.center.dx - currentNode.center.dx).abs();
          final diffB = (b.center.dx - currentNode.center.dx).abs();
          return diffA.compareTo(diffB);
        } else {
          final diffA = (a.center.dy - currentNode.center.dy).abs();
          final diffB = (b.center.dy - currentNode.center.dy).abs();
          return diffA.compareTo(diffB);
        }
      });
      return nodes.first;
    }

    return null;
  }

  Future<void> _applyFocusChange(SpatialNavigationResult result, String? groupId) async {
    final targetNode = result.targetNode!;
    final currentNode = result.currentNode;
    
    if (currentNode != null) {
      _recordFocusHistory(currentNode, groupId);
    }

    // Attempt a native focus request (works when FocusNode is attached).
    // Visual state is driven via notifyListeners() below regardless of
    // whether the native request succeeds (e.g. off-screen ListView items).
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
      final groupNode = _registry.getFocusedNode(groupId);
      if (groupNode != null && groupNode.isFocusable) return groupNode;
    }
    if (_lastFocusedNode != null && _lastFocusedNode!.isFocusable) {
      return _lastFocusedNode;
    }
    for (final node in _registry.getAllFocusedNodes()) {
      if (node.isFocusable) return node;
    }
    return null;
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

  void activateCurrentNode([String? groupId]) {
    final effectiveGroupId = _scope.getEffectiveGroupId(groupId);
    final currentNode = _getCurrentFocusedNode(effectiveGroupId);
    if (currentNode != null) {
      if (currentNode.metadata is VoidCallback) {
        (currentNode.metadata as VoidCallback)();
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