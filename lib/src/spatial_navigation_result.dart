import 'spatial_navigation_node.dart';
import 'spatial_navigation_direction.dart';

class SpatialNavigationResult {
  final bool success;
  final SpatialNavigationNode? targetNode;
  final TvNavigationDirection direction;
  final List<SpatialNavigationCandidate> candidates;
  final SpatialNavigationNode? currentNode;
  final String? reason;

  const SpatialNavigationResult({
    required this.success,
    this.targetNode,
    required this.direction,
    this.candidates = const [],
    this.currentNode,
    this.reason,
  });

  factory SpatialNavigationResult.success({
    required SpatialNavigationNode targetNode,
    required TvNavigationDirection direction,
    required List<SpatialNavigationCandidate> candidates,
    SpatialNavigationNode? currentNode,
  }) {
    return SpatialNavigationResult(
      success: true,
      targetNode: targetNode,
      direction: direction,
      candidates: candidates,
      currentNode: currentNode,
    );
  }

  factory SpatialNavigationResult.failure({
    required TvNavigationDirection direction,
    SpatialNavigationNode? currentNode,
    String? reason,
    List<SpatialNavigationCandidate> candidates = const [],
  }) {
    return SpatialNavigationResult(
      success: false,
      direction: direction,
      candidates: candidates,
      currentNode: currentNode,
      reason: reason,
    );
  }

  @override
  String toString() {
    if (success) {
      return 'SpatialNavigationResult(success: true, target: ${targetNode?.id}, direction: $direction, candidates: ${candidates.length})';
    } else {
      return 'SpatialNavigationResult(success: false, direction: $direction, reason: $reason)';
    }
  }
}

class SpatialNavigationCandidate {
  final SpatialNavigationNode node;
  final double primaryDistance;
  final double secondaryDistance;
  final double overlap;
  final double alignment;
  final double score;
  final int registrationOrder;

  const SpatialNavigationCandidate({
    required this.node,
    required this.primaryDistance,
    required this.secondaryDistance,
    required this.overlap,
    required this.alignment,
    required this.score,
    required this.registrationOrder,
  });

  @override
  String toString() {
    return 'SpatialNavigationCandidate(node: ${node.id}, primary: ${primaryDistance.toStringAsFixed(1)}, secondary: ${secondaryDistance.toStringAsFixed(1)}, overlap: ${overlap.toStringAsFixed(2)}, alignment: ${alignment.toStringAsFixed(2)}, score: ${score.toStringAsFixed(2)})';
  }
}