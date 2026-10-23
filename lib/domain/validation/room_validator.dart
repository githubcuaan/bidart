import '../models/scoring/end_conditions.dart';
import '../models/scoring/player_in_game.dart';
import '../models/scoring/rule_config.dart';
import 'rule_config_validator.dart';
import 'validation_issue.dart';

/// Pure validator for room create/setup inputs (Step 2 §4, Step 1 §1/§4).
///
/// Duplicate-name policy: trim + case-insensitive comparison.
/// Confirmed policy: case-insensitive comparison prevents confusing rosters
/// like `An` vs `an`/` AN `. IDs remain the stable identity, names are
/// display-only.
class RoomValidator {
  const RoomValidator._();

  static const minRoster = 2;
  static const maxRoster = 5;

  /// Services must use this result before validating and persisting input.
  /// Preserves identity, timestamps and display casing; never mutates input.
  static List<PlayerInGame> normalizeParticipants(
    List<PlayerInGame> participants,
  ) => List.unmodifiable([
    for (final player in participants)
      player.copyWith(displayName: player.displayName.trim()),
  ]);

  /// Validates roster/order/starter/payer/rule/end-conditions together.
  /// [activePlayerIds] defaults to all participant IDs (create-room case).
  static List<ValidationIssue> validate({
    required List<PlayerInGame> participants,
    List<String>? activePlayerIds,
    required List<String> playerOrder,
    required String starterId,
    required String payerId,
    required RuleConfig ruleConfig,
    required EndConditions endConditions,
  }) {
    final active = activePlayerIds ?? participants.map((p) => p.id).toList();
    return [
      ...validateRoster(participants, active),
      ...validateOrder(active, playerOrder),
      ...validateStarterPayer(
        activePlayerIds: active,
        starterId: starterId,
        payerId: payerId,
      ),
      ...validateOpeningOrder(
        playerOrder: playerOrder,
        starterId: starterId,
        payerId: payerId,
      ),
      ...RuleConfigValidator.validate(ruleConfig),
      ...validateEndConditions(endConditions),
    ];
  }

  static List<ValidationIssue> validateRoster(
    List<PlayerInGame> participants,
    List<String> activePlayerIds,
  ) {
    final issues = <ValidationIssue>[];
    final participantIds = participants.map((p) => p.id).toSet();
    final activeIds = <String>{};
    for (var i = 0; i < activePlayerIds.length; i++) {
      final id = activePlayerIds[i];
      if (!activeIds.add(id)) {
        issues.add(
          ValidationIssue(
            fieldPath: 'activePlayerIds[$i]',
            code: ValidationCode.duplicateActivePlayerId,
          ),
        );
      }
      if (!participantIds.contains(id)) {
        issues.add(
          ValidationIssue(
            fieldPath: 'activePlayerIds[$i]',
            code: ValidationCode.unknownActivePlayerId,
          ),
        );
      }
    }
    final rosterSize = activeIds.intersection(participantIds).length;

    if (rosterSize < minRoster || rosterSize > maxRoster) {
      issues.add(
        const ValidationIssue(
          fieldPath: 'participants',
          code: ValidationCode.rosterSize,
        ),
      );
    }

    final seenIds = <String>{};
    for (var i = 0; i < participants.length; i++) {
      final id = participants[i].id;
      if (!seenIds.add(id)) {
        issues.add(
          ValidationIssue(
            fieldPath: 'participants[$i].id',
            code: ValidationCode.duplicateParticipantId,
          ),
        );
      }
    }

    final seenNames = <String, int>{};
    for (var i = 0; i < participants.length; i++) {
      final trimmed = participants[i].displayName.trim();
      if (trimmed.isEmpty) {
        issues.add(
          ValidationIssue(
            fieldPath: 'participants[$i].displayName',
            code: ValidationCode.emptyName,
          ),
          // Empty names never participate in duplicate detection.
        );
        continue;
      }
      final key = trimmed.toLowerCase();
      if (seenNames.containsKey(key)) {
        issues.add(
          ValidationIssue(
            fieldPath: 'participants[$i].displayName',
            code: ValidationCode.duplicateName,
          ),
        );
      } else {
        seenNames[key] = i;
      }
    }
    return issues;
  }

  /// [playerOrder] must be an exact permutation of [activePlayerIds]:
  /// same length, same set, no duplicates.
  static List<ValidationIssue> validateOrder(
    List<String> activePlayerIds,
    List<String> playerOrder,
  ) {
    final activeSet = activePlayerIds.toSet();
    final orderSet = playerOrder.toSet();
    final exact =
        playerOrder.length == activePlayerIds.length &&
        orderSet.length == playerOrder.length &&
        orderSet.containsAll(activeSet) &&
        activeSet.containsAll(orderSet);
    if (exact) return const [];
    return const [
      ValidationIssue(
        fieldPath: 'playerOrder',
        code: ValidationCode.invalidOrder,
      ),
    ];
  }

  static List<ValidationIssue> validateStarterPayer({
    required List<String> activePlayerIds,
    required String starterId,
    required String payerId,
  }) {
    final issues = <ValidationIssue>[];
    final roster = activePlayerIds.toSet();
    if (!roster.contains(starterId)) {
      issues.add(
        const ValidationIssue(
          fieldPath: 'starterId',
          code: ValidationCode.starterNotInRoster,
        ),
      );
    }
    if (!roster.contains(payerId)) {
      issues.add(
        const ValidationIssue(
          fieldPath: 'payerId',
          code: ValidationCode.payerNotInRoster,
        ),
      );
    }
    if (starterId == payerId) {
      issues.add(
        const ValidationIssue(
          fieldPath: 'payerId',
          code: ValidationCode.starterEqualsPayer,
        ),
      );
    }
    return issues;
  }

  /// At setup the break player shoots first and the initial payer shoots second.
  /// Later players may be reordered; these two positions may not.
  static List<ValidationIssue> validateOpeningOrder({
    required List<String> playerOrder,
    required String starterId,
    required String payerId,
  }) {
    if (playerOrder.length < 2) return const [];
    if (playerOrder[0] == starterId && playerOrder[1] == payerId) {
      return const [];
    }
    return const [
      ValidationIssue(
        fieldPath: 'playerOrder',
        code: ValidationCode.invalidOpeningOrder,
      ),
    ];
  }

  static List<ValidationIssue> validateEndConditions(EndConditions conditions) {
    final issues = <ValidationIssue>[];
    if (conditions.durationSeconds != null &&
        conditions.durationSeconds! <= 0) {
      issues.add(
        const ValidationIssue(
          fieldPath: 'endConditions.durationSeconds',
          code: ValidationCode.invalidDuration,
        ),
      );
    }
    if (conditions.scoreThreshold != null && conditions.scoreThreshold! <= 0) {
      issues.add(
        const ValidationIssue(
          fieldPath: 'endConditions.scoreThreshold',
          code: ValidationCode.invalidScoreThreshold,
        ),
      );
    }
    return issues;
  }
}
