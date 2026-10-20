import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/validation/room_validator.dart';
import 'package:bidart/domain/validation/rule_config_validator.dart';
import 'package:bidart/domain/validation/validation_issue.dart';
import 'package:flutter_test/flutter_test.dart';

Map<int, BallPointConfig> validBalls() => <int, BallPointConfig>{
  for (var i = 1; i <= 9; i++) i: BallPointConfig(enabled: true, points: i * 5),
};

RuleConfig validRules() =>
    RuleConfig(id: 'rule-1', version: 1, ballPoints: validBalls());

List<PlayerInGame> players(List<String> names, {String prefix = 'p'}) => [
  for (var i = 0; i < names.length; i++)
    PlayerInGame(
      id: '$prefix$i',
      displayName: names[i],
      joinedAt: DateTime.utc(2026, 10, 13),
    ),
];

bool hasCode(List<ValidationIssue> issues, ValidationCode code) =>
    issues.any((e) => e.code == code);

void main() {
  group('roster', () {
    test('normalization trims names without changing identity or input', () {
      final original = players([' An ', ' B ']);
      final normalized = RoomValidator.normalizeParticipants(original);
      expect(normalized[0], original[0].copyWith(displayName: 'An'));
      expect(normalized[1], original[1].copyWith(displayName: 'B'));
      expect(original[0].displayName, ' An ');
      expect(() => normalized.clear(), throwsUnsupportedError);
      expect(RoomValidator.validateRoster(normalized, ['p0', 'p1']), isEmpty);
    });

    test('duplicate active IDs rejected with indexed path', () {
      final issues = RoomValidator.validateRoster(players(['A', 'B']), [
        'p0',
        'p1',
        'p1',
      ]);
      expect(
        issues,
        contains(
          const ValidationIssue(
            fieldPath: 'activePlayerIds[2]',
            code: ValidationCode.duplicateActivePlayerId,
          ),
        ),
      );
    });

    test('unknown active IDs cannot inflate roster size', () {
      final issues = RoomValidator.validateRoster(players(['A']), [
        'p0',
        'missing',
      ]);
      expect(
        issues,
        contains(
          const ValidationIssue(
            fieldPath: 'activePlayerIds[1]',
            code: ValidationCode.unknownActivePlayerId,
          ),
        ),
      );
      expect(hasCode(issues, ValidationCode.rosterSize), isTrue);
    });

    test('historical participants do not inflate active roster size', () {
      expect(
        RoomValidator.validateRoster(players(['A', 'B', 'C', 'D', 'E', 'F']), [
          'p0',
          'p1',
        ]),
        isEmpty,
      );
    });
    test('valid 2 and 5 players pass', () {
      for (final names in [
        ['A', 'B'],
        ['A', 'B', 'C', 'D', 'E'],
      ]) {
        final ps = players(names);
        final issues = RoomValidator.validate(
          participants: ps,
          playerOrder: ps.map((p) => p.id).toList(),
          starterId: ps.first.id,
          payerId: ps[1].id,
          ruleConfig: validRules(),
          endConditions: const EndConditions(),
        );
        expect(issues, isEmpty, reason: names.toString());
      }
    });

    test('1 and 6 players rejected', () {
      for (final names in [
        ['A'],
        ['A', 'B', 'C', 'D', 'E', 'F'],
      ]) {
        final ps = players(names);
        final issues = RoomValidator.validateRoster(
          ps,
          ps.map((p) => p.id).toList(),
        );
        expect(hasCode(issues, ValidationCode.rosterSize), isTrue);
      }
    });

    test('whitespace names rejected', () {
      final ps = players(['A', '   ']);
      final issues = RoomValidator.validateRoster(
        ps,
        ps.map((p) => p.id).toList(),
      );
      expect(hasCode(issues, ValidationCode.emptyName), isTrue);
    });

    test('duplicate names rejected (trim + case-insensitive)', () {
      final ps = players([' An ', 'an']);
      final issues = RoomValidator.validateRoster(
        ps,
        ps.map((p) => p.id).toList(),
      );
      expect(hasCode(issues, ValidationCode.duplicateName), isTrue);
    });

    test('duplicate IDs rejected', () {
      final t = DateTime.utc(2026, 10, 13);
      final ps = [
        PlayerInGame(id: 'x', displayName: 'A', joinedAt: t),
        PlayerInGame(id: 'x', displayName: 'B', joinedAt: t),
      ];
      final issues = RoomValidator.validateRoster(ps, ['x']);
      expect(hasCode(issues, ValidationCode.duplicateParticipantId), isTrue);
    });
  });

  group('order/starter/payer', () {
    test('duplicate order rejected', () {
      final issues = RoomValidator.validateOrder(['a', 'b'], ['a', 'a']);
      expect(hasCode(issues, ValidationCode.invalidOrder), isTrue);
    });

    test('missing order entries rejected', () {
      expect(
        hasCode(
          RoomValidator.validateOrder(['a', 'b', 'c'], ['a', 'b']),
          ValidationCode.invalidOrder,
        ),
        isTrue,
      );
      // Extra entry beyond roster also rejected.
      expect(
        hasCode(
          RoomValidator.validateOrder(['a', 'b'], ['a', 'b', 'c']),
          ValidationCode.invalidOrder,
        ),
        isTrue,
      );
    });

    test('invalid starter/payer rejected', () {
      final roster = ['a', 'b'];
      expect(
        hasCode(
          RoomValidator.validateStarterPayer(
            activePlayerIds: roster,
            starterId: 'zzz',
            payerId: 'b',
          ),
          ValidationCode.starterNotInRoster,
        ),
        isTrue,
      );
      expect(
        hasCode(
          RoomValidator.validateStarterPayer(
            activePlayerIds: roster,
            starterId: 'a',
            payerId: 'zzz',
          ),
          ValidationCode.payerNotInRoster,
        ),
        isTrue,
      );
      expect(
        hasCode(
          RoomValidator.validateStarterPayer(
            activePlayerIds: roster,
            starterId: 'a',
            payerId: 'a',
          ),
          ValidationCode.starterEqualsPayer,
        ),
        isTrue,
      );
    });

    test('opening order must start with starter then payer', () {
      expect(
        RoomValidator.validateOpeningOrder(
          playerOrder: ['a', 'b', 'c'],
          starterId: 'a',
          payerId: 'b',
        ),
        isEmpty,
      );
      for (final order in [
        ['b', 'a', 'c'],
        ['a', 'c', 'b'],
        ['c', 'a', 'b'],
      ]) {
        expect(
          hasCode(
            RoomValidator.validateOpeningOrder(
              playerOrder: order,
              starterId: 'a',
              payerId: 'b',
            ),
            ValidationCode.invalidOpeningOrder,
          ),
          isTrue,
          reason: order.toString(),
        );
      }
    });
  });

  group('rules/end conditions', () {
    test('missing/extra ball numbers rejected', () {
      final missing = Map.of(validBalls())..remove(9);
      expect(
        hasCode(
          RuleConfigValidator.validateBallPoints(missing),
          ValidationCode.missingBallConfig,
        ),
        isTrue,
      );
      final extra = Map.of(validBalls())
        ..[10] = const BallPointConfig(enabled: true, points: 50);
      expect(
        hasCode(
          RuleConfigValidator.validateBallPoints(extra),
          ValidationCode.extraBallConfig,
        ),
        isTrue,
      );
    });

    test('malformed ball points rejected', () {
      // Model asserts guard debug misuse; validator covers raw values
      // (production path where asserts are stripped).
      expect(
        RuleConfigValidator.validateBallEntry(3, true, 0).single.code,
        ValidationCode.invalidBallPoints,
      );
      expect(
        RuleConfigValidator.validateBallEntry(2, false, 10).single.code,
        ValidationCode.invalidDisabledBallPoints,
      );
      expect(RuleConfigValidator.validateBallEntry(2, false, 0), isEmpty);
      expect(
        () => BallPointConfig(enabled: true, points: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => BallPointConfig(enabled: false, points: 10),
        throwsA(isA<AssertionError>()),
      );
    });

    test('no enabled ball rejected', () {
      final allOff = {
        for (var i = 1; i <= 9; i++)
          i: const BallPointConfig(enabled: false, points: 0),
      };
      expect(
        hasCode(
          RuleConfigValidator.validateBallPoints(allOff),
          ValidationCode.noEnabledBall,
        ),
        isTrue,
      );
    });

    test('optional score limit belongs to end conditions', () {
      for (final threshold in [null, 100]) {
        expect(
          RoomValidator.validateEndConditions(
            EndConditions(scoreThreshold: threshold, durationSeconds: 60),
          ),
          isEmpty,
        );
      }
      expect(
        RoomValidator.validateEndConditions(
          const EndConditions(scoreThreshold: 0),
        ).single.code,
        ValidationCode.invalidScoreThreshold,
      );
    });

    test('non-positive end conditions rejected', () {
      expect(
        hasCode(
          RoomValidator.validateEndConditions(
            const EndConditions(durationSeconds: 0),
          ),
          ValidationCode.invalidDuration,
        ),
        isTrue,
      );
      expect(
        hasCode(
          RoomValidator.validateEndConditions(
            const EndConditions(scoreThreshold: -5),
          ),
          ValidationCode.invalidScoreThreshold,
        ),
        isTrue,
      );
      expect(
        RoomValidator.validateEndConditions(const EndConditions()),
        isEmpty,
      );
    });
  });
}
