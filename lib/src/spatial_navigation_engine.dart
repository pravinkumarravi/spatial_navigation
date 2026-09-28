import 'package:flutter/foundation.dart';

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
    currentNode ??= _getCurrentFocusedNode(fromGroupId);
    
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

    return allNodes.where((node) {
      if (node.id == current.id) return false;
      if (!node.isFocusable) return false;
      if (!current.isInDirection(node, direction)) return false;
      return true;
    }).toList();
  }

  List<SpatialNavigationCandidate> _scoreCandidates(
    SpatialNavigationNode current,
    List<SpatialNavigationNode> candidates,
    TvNavigationDirection direction,
  ) {
    return candidates.map((candidate) {
      final primaryDistance = current.getPrimaryDistance(candidate, direction);
      final secondaryDistance = current.getSecondaryDistance(candidate, direction);
      final overlap = current.getOverlap(candidate, direction);
      
      double alignment = 0;
      if (direction.isHorizontal) {
        alignment = (candidate.center.dy - current.center.dy).abs();
      } else {
        alignment = (candidate.center.dx - current.center.dx).abs();
      }

      double score = 0;
      score += primaryDistance * config.primaryWeight;
      score += secondaryDistance * config.secondaryWeight;
      
      if (overlap >= config.minOverlapThreshold) {
        score -= config.overlapBonus * overlap;
      }
      
      score -= config.alignmentBonus / (1 + alignment);

      if (primaryDistance > config.maxPrimaryDistance) {
        score += (primaryDistance - config.maxPrimaryDistance) * 1000;
      }
      if (secondaryDistance > config.maxSecondaryDistance) {
        score += (secondaryDistance - config.maxSecondaryDistance) * 100;
      }

      return SpatialNavigationCandidate(
        node: candidate,
        primaryDistance: primaryDistance,
        secondaryDistance: secondaryDistance,
        overlap: overlap,
        alignment: alignment,
        score: score,
        registrationOrder: candidate.registrationOrder,
      );
    }).toList();
  }

  int _compareCandidates(SpatialNavigationCandidate a, SpatialNavigationCandidate b) {
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