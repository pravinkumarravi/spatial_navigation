class SpatialNavigationConfig {
  final double primaryWeight;
  final double secondaryWeight;
  final double overlapBonus;
  final double alignmentBonus;
  final double maxPrimaryDistance;
  final double maxSecondaryDistance;
  final double minOverlapThreshold;
  final double tieBreakerThreshold;

  const SpatialNavigationConfig({
    this.primaryWeight = 1.0,
    this.secondaryWeight = 0.5,
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
      overlapBonus: overlapBonus ?? this.overlapBonus,
      alignmentBonus: alignmentBonus ?? this.alignmentBonus,
      maxPrimaryDistance: maxPrimaryDistance ?? this.maxPrimaryDistance,
      maxSecondaryDistance: maxSecondaryDistance ?? this.maxSecondaryDistance,
      minOverlapThreshold: minOverlapThreshold ?? this.minOverlapThreshold,
      tieBreakerThreshold: tieBreakerThreshold ?? this.tieBreakerThreshold,
    );
  }
}