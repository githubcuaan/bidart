import '../models/scoring/ball_point_config.dart';
import '../models/scoring/rule_config.dart';
import 'validation_issue.dart';

/// Pure validator for [RuleConfig] ball table.
///
/// Rules (Step 2 §4, Step 1 §2):
/// - keys must be exactly 1–9, no extras/missing.
/// - enabled ball: positive integer points.
/// - disabled ball: contributes zero (points == 0).
/// - at least one enabled ball.
/// Score limits belong to EndConditions and are checked by RoomValidator.
class RuleConfigValidator {
  const RuleConfigValidator._();

  static const _minBall = 1;
  static const _maxBall = 9;

  static List<ValidationIssue> validate(RuleConfig config) =>
      validateBallPoints(config.ballPoints);

  static List<ValidationIssue> validateBallPoints(
    Map<int, BallPointConfig> ballPoints,
  ) {
    final issues = <ValidationIssue>[];

    for (var ball = _minBall; ball <= _maxBall; ball++) {
      if (!ballPoints.containsKey(ball)) {
        issues.add(
          ValidationIssue(
            fieldPath: 'ruleConfig.ballPoints[$ball]',
            code: ValidationCode.missingBallConfig,
          ),
        );
      }
    }
    for (final key in ballPoints.keys) {
      if (key < _minBall || key > _maxBall) {
        issues.add(
          ValidationIssue(
            fieldPath: 'ruleConfig.ballPoints[$key]',
            code: ValidationCode.extraBallConfig,
          ),
        );
      }
    }

    var enabledCount = 0;
    for (final entry in ballPoints.entries) {
      final ball = entry.key;
      if (ball < _minBall || ball > _maxBall) continue;
      issues.addAll(
        validateBallEntry(ball, entry.value.enabled, entry.value.points),
      );
      if (entry.value.enabled) enabledCount++;
    }

    if (enabledCount == 0) {
      issues.add(
        const ValidationIssue(
          fieldPath: 'ruleConfig.ballPoints',
          code: ValidationCode.noEnabledBall,
        ),
      );
    }
    return issues;
  }

  /// Pure per-ball check on raw values (no model asserts involved).
  /// Extracted so malformed entries are testable in debug mode, where
  /// constructing an invalid [BallPointConfig] already throws.
  static List<ValidationIssue> validateBallEntry(
    int ball,
    bool enabled,
    int points,
  ) {
    if (enabled && points <= 0) {
      return [
        ValidationIssue(
          fieldPath: 'ruleConfig.ballPoints[$ball].points',
          code: ValidationCode.invalidBallPoints,
        ),
      ];
    }
    if (!enabled && points != 0) {
      return [
        ValidationIssue(
          fieldPath: 'ruleConfig.ballPoints[$ball].points',
          code: ValidationCode.invalidDisabledBallPoints,
        ),
      ];
    }
    return const [];
  }
}
