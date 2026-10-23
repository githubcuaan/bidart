class MatchmakingFilter {
  final double maxDistanceKm;

  const MatchmakingFilter({
    this.maxDistanceKm = 10.0,
  });

  MatchmakingFilter copyWith({
    double? maxDistanceKm,
  }) {
    return MatchmakingFilter(
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }
}
