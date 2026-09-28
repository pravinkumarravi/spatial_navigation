enum TvNavigationDirection {
  up,
  down,
  left,
  right,
}

extension TvNavigationDirectionExtension on TvNavigationDirection {
  TvNavigationDirection get opposite {
    switch (this) {
      case TvNavigationDirection.up:
        return TvNavigationDirection.down;
      case TvNavigationDirection.down:
        return TvNavigationDirection.up;
      case TvNavigationDirection.left:
        return TvNavigationDirection.right;
      case TvNavigationDirection.right:
        return TvNavigationDirection.left;
    }
  }

  bool get isHorizontal {
    return this == TvNavigationDirection.left || this == TvNavigationDirection.right;
  }

  bool get isVertical {
    return this == TvNavigationDirection.up || this == TvNavigationDirection.down;
  }
}