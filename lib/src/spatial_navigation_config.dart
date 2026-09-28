class SpatialNavigationConfig {
  final double primaryWeight;
  final double secondaryWeight;
  final double adjacentSliceWeight;
  final double adjacentSliceThreshold;
  final double overlapBonus;
  final double alignmentBonus;
  final double maxPrimaryDistance;
  final double maxSecondaryDistance;
  final double minOverlapThreshold;
  final double tieBreakerThreshold;

  const SpatialNavigationConfig({
    this.primaryWeight = 5.0,
    this.secondaryWeight = 1.0,
    this.adjacentSliceWeight = 5.0,
    this.adjacentSliceThreshold = 0.2,
    this.overlapBonus = 50.0,
    this.alignmentBonus = 20.0,
    this.maxPrimaryDistance = double.infinity,
    this.maxSecondaryDistance = double.infinity,
    this.minOverlapThreshold = 0.1,
    this.tieBreakerThreshold = 0.001,
  });

  SpatialNavigationConfig copyWith({
    double? primaryWeight,
    double? secondaryWeight,
    double? adjacentSliceWeight,
    double? adjacentSliceThreshold,
    double? overlapBonus,
    double? alignmentBonus,
    double? maxPrimaryDistance,
    double? maxSecondaryDistance,
    double? minOverlapThreshold,
    double? tieBreakerThreshold,
  }) {
    return SpatialNavigationConfig(
      primaryWeight: primaryWeight ?? this.primaryWeight,
      secondaryWeight: secondaryWeight ?? this.secondaryWeight,
      adjacentSliceWeight: adjacentSliceWeight ?? this.adjacentSliceWeight,
      adjacentSliceThreshold: adjacentSliceThreshold ?? this.adjacentSliceThreshold,
      overlapBonus: overlapBonus ?? this.overlapBonus,
      alignmentBonus: alignmentBonus ?? this.alignmentBonus,
      maxPrimaryDistance: maxPrimaryDistance ?? this.maxPrimaryDistance,
      maxSecondaryDistance: maxSecondaryDistance ?? this.maxSecondaryDistance,
      minOverlapThreshold: minOverlapThreshold ?? this.minOverlapThreshold,
      tieBreakerThreshold: tieBreakerThreshold ?? this.tieBreakerThreshold,
    );
  }
}