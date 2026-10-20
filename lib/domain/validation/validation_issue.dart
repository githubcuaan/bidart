/// Structured validation failure: field path + machine code.
/// UI maps [code] to messages outside domain.
enum ValidationCode {
  rosterSize,
  duplicateParticipantId,
  duplicateActivePlayerId,
  unknownActivePlayerId,
  emptyName,
  duplicateName,
  invalidOrder,
  invalidOpeningOrder,
  starterNotInRoster,
  payerNotInRoster,
  starterEqualsPayer,
  missingBallConfig,
  extraBallConfig,
  noEnabledBall,
  invalidBallPoints,
  invalidDisabledBallPoints,
  invalidDuration,
  invalidScoreThreshold,
}

/// Immutable validation issue with field path (e.g. `participants[1].name`,
/// `ruleConfig.ballPoints[3].points`) and machine-readable [code].
class ValidationIssue {
  const ValidationIssue({required this.fieldPath, required this.code});

  final String fieldPath;
  final ValidationCode code;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationIssue &&
          fieldPath == other.fieldPath &&
          code == other.code;

  @override
  int get hashCode => Object.hash(fieldPath, code);

  @override
  String toString() => 'ValidationIssue($fieldPath, $code)';
}
