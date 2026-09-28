import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import 'spatial_navigation_config.dart';
import 'spatial_navigation_node.dart';
import 'spatial_navigation_direction.dart';
import 'spatial_navigation_registry.dart';
import 'spatial_navigation_result.dart';

class SpatialNavigationEngine extends ChangeNotifier {
  final SpatialNavigationRegistry registry;
  SpatialNavigationConfig _config;

  SpatialNavigationConfig get config => _config;

  SpatialNavigationEngine({
    required this.registry,
    SpatialNavigationConfig? config,
  }) : _config = config ?? const SpatialNavigationConfig();

  SpatialNavigationResult navigate(
    TvNavigationDirection direction, {
    String? fromGroupId,
    SpatialNavigationNode? currentNode,
  }) {
    _refreshNodeRects();
    if (currentNode != null) {
      currentNode = registry.getNode(currentNode.id) ?? currentNode;
    } else {
      currentNode = _getCurrentFocusedNode(fromGroupId);
    }
    
    if (currentNode == null) {
      return SpatialNavigationResult.failure(
        direction: direction,
        currentNode: currentNode,
        reason: 'No currently focused node',
      );
    }

    if (currentNode.hasOverride(direction)) {
      final overrideId = currentNode.getOverride(direction)!;
      final targetNode = registry.getNode(overrideId);
      if (targetNode != null && targetNode.isFocusable) {
        return SpatialNavigationResult.success(
          targetNode: targetNode,
          direction: direction,
          candidates: [],
          currentNode: currentNode,
        );
      }
    }

    final candidates = _findCandidates(currentNode, direction, fromGroupId);

    if (candidates.isEmpty) {
      return SpatialNavigationResult.failure(
        direction: direction,
        currentNode: currentNode,
        reason: 'No valid candidates found',
      );
    }

    final scoredCandidates = _scoreCandidates(currentNode, candidates, direction);
    scoredCandidates.sort(_compareCandidates);

    final bestCandidate = scoredCandidates.first;
    
    return SpatialNavigationResult.success(
      targetNode: bestCandidate.node,
      direction: direction,
      candidates: scoredCandidates,
      currentNode: currentNode,
    );
  }

  void _refreshNodeRects() {
    for (final node in registry.getAllNodes()) {
      final context = node.focusNode.context;
      if (context != null && context.mounted) {
        final renderBox = context.findRenderObject();
        if (renderBox is RenderBox && renderBox.attached) {
          final transform = renderBox.getTransformTo(null);
          final globalRect = MatrixUtils.transformRect(transform, renderBox.paintBounds);
          if (globalRect != node.rect) {
            registry.updateNodeRect(node.id, globalRect);
          }
        }
      }
    }
  }

  SpatialNavigationNode? _getCurrentFocusedNode(String? groupId) {
    if (groupId != null) {
      return registry.getFocusedNode(groupId);
    }
    for (final node in registry.getAllFocusedNodes()) {
      if (node.isFocusable) return node;
    }
    return null;
  }

  List<SpatialNavigationNode> _findCandidates(
    SpatialNavigationNode current,
    TvNavigationDirection direction,
    String? groupId,
  ) {
    final allNodes = groupId != null 
        ? registry.getGroupNodes(groupId)
        : registry.getVisibleEnabledNodes();

    final candidates = allNodes.where((node) {
      if (node.id == current.id) return false;
      if (!node.isFocusable) return false;
      if (!current.isInDirection(node, direction)) return false;
      return true;
    }).toList();

    // For horizontal navigation within rows, if there are candidates sharing the same row corridor
    // (overlap >= 0.6), restrict to row corridor so left/right moves purely along the shelf.
    if (direction.isHorizontal) {
      final inCorridor = candidates.where((c) => current.getOverlap(c, direction) >= 0.6).toList();
      if (inCorridor.isNotEmpty) {
        return inCorridor;
      }
    }

    return candidates;
  }

  bool _isAdjacentSlice(
    SpatialNavigationNode current,
    SpatialNavigationNode candidate,
    TvNavigationDirection direction,
  ) {
    if (direction.isVertical) {
      final refA = current.left;
      final refB = current.right;
      final sibA = candidate.left;
      final sibB = candidate.right;
      final threshold = (refB - refA) * config.adjacentSliceThreshold;
      final intersection = math.max(0.0, math.min(refB, sibB) - math.max(refA, sibA));
      return intersection >= threshold;
    } else {
      final refA = current.top;
      final refB = current.bottom;
      final sibA = candidate.top;
      final sibB = candidate.bottom;
      final threshold = (refB - refA) * config.adjacentSliceThreshold;
      final intersection = math.max(0.0, math.min(refB, sibB) - math.max(refA, sibA));
      return intersection >= threshold;
    }
  }

  double _getPrimaryAxisDistance(
    SpatialNavigationNode current,
    SpatialNavigationNode candidate,
    TvNavigationDirection direction,
  ) {
    return current.getPrimaryDistance(candidate, direction);
  }

  double _getSecondaryAxisDistance(
    SpatialNavigationNode current,
    SpatialNavigationNode candidate,
    TvNavigationDirection direction,
  ) {
    if (direction.isVertical) {
      final d1 = (candidate.left - current.left).abs();
      final d2 = (candidate.left - current.right).abs();
      final d3 = (candidate.right - current.left).abs();
      final d4 = (candidate.right - current.right).abs();
      final hasOverlap = math.max(current.left, candidate.left) < math.min(current.right, candidate.right);
      if (hasOverlap) return 0.0;
      return math.min(math.min(d1, d2), math.min(d3, d4));
    } else {
      final d1 = (candidate.top - current.top).abs();
      final d2 = (candidate.top - current.bottom).abs();
      final d3 = (candidate.bottom - current.top).abs();
      final d4 = (candidate.bottom - current.bottom).abs();
      final hasOverlap = math.max(current.top, candidate.top) < math.min(current.bottom, candidate.bottom);
      if (hasOverlap) return 0.0;
      return math.min(math.min(d1, d2), math.min(d3, d4));
    }
  }

  List<SpatialNavigationCandidate> _scoreCandidates(
    SpatialNavigationNode current,
    List<SpatialNavigationNode> candidates,
    TvNavigationDirection direction,
  ) {
    return candidates.map((candidate) {
      final primaryDistance = _getPrimaryAxisDistance(current, candidate, direction);
      final secondaryDistance = _getSecondaryAxisDistance(current, candidate, direction);
      final isAdjacent = _isAdjacentSlice(current, candidate, direction);
      final overlap = current.getOverlap(candidate, direction);

      // Norigin-aligned distance points:
      // If adjacent, primary axis distance is weighted by MAIN_COORDINATE_WEIGHT (5).
      // If diagonal (not adjacent), secondary axis distance is weighted by MAIN_COORDINATE_WEIGHT (5).
      final totalDistancePoints = isAdjacent
          ? primaryDistance * config.primaryWeight + secondaryDistance * config.secondaryWeight
          : secondaryDistance * config.primaryWeight + primaryDistance * config.secondaryWeight;

      final priority = (totalDistancePoints + 1.0) / (isAdjacent ? config.adjacentSliceWeight : 1.0);

      double alignment = 0;
      if (direction.isHorizontal) {
        alignment = (candidate.center.dy - current.center.dy).abs();
      } else {
        alignment = (candidate.center.dx - current.center.dx).abs();
      }

      return SpatialNavigationCandidate(
        node: candidate,
        primaryDistance: primaryDistance,
        secondaryDistance: secondaryDistance,
        overlap: overlap,
        alignment: alignment,
        score: priority,
        registrationOrder: candidate.registrationOrder,
      );
    }).toList();
  }

  int _compareCandidates(SpatialNavigationCandidate a, SpatialNavigationCandidate b) {
    final aInCorridor = a.overlap >= 0.6;
    final bInCorridor = b.overlap >= 0.6;
    if (aInCorridor != bInCorridor) {
      return aInCorridor ? -1 : 1;
    }

    final scoreDiff = a.score - b.score;
    if (scoreDiff.abs() > config.tieBreakerThreshold) {
      return scoreDiff > 0 ? 1 : -1;
    }

    if (a.primaryDistance != b.primaryDistance) {
      return a.primaryDistance < b.primaryDistance ? -1 : 1;
    }

    if (a.secondaryDistance != b.secondaryDistance) {
      return a.secondaryDistance < b.secondaryDistance ? -1 : 1;
    }

    if (a.overlap != b.overlap) {
      return a.overlap > b.overlap ? -1 : 1;
    }

    return a.registrationOrder - b.registrationOrder;
  }

  void setConfig(SpatialNavigationConfig newConfig) {
    _config = newConfig;
    notifyListeners();
  }
}