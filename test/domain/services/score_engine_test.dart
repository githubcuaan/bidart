import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/chain_state.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:flutter_test/flutter_test.dart';

final now = DateTime.utc(2026, 10, 15);
RuleConfig rules({Set<int> disabled = const {}}) => RuleConfig(
  id: 'rules',
  version: 1,
  ballPoints: {
    for (var b = 1; b <= 9; b++)
      b: BallPointConfig(
        enabled: !disabled.contains(b),
        points: disabled.contains(b) ? 0 : b * 5,
      ),
  },
);
GameSession game({
  bool breakChain = false,
  bool held = false,
  Set<int> remaining = const {1, 2, 3, 4, 5, 6, 7, 8, 9},
}) => GameSession(
  id: 'game',
  roomId: 'room',
  gameNumber: 1,
  status: GameStatus.inProgress,
  startedAt: now,
  currentPlayerId: 'B',
  payerId: 'A',
  playerOrder: ['A', 'B', 'C', 'D'],
  remainingBalls: remaining,
  chainState: ChainState(isBreakChain: breakChain, hasLegalPotInChain: held),
);
const scores = {'A': 0, 'B': 0, 'C': 0, 'D': 0};
ScoreEngineResult run(
  GameSession session,
  List<int> balls, {
  FoulClassification foul = FoulClassification.none,
  RuleConfig? config,
  Map<String, int> points = scores,
  String actor = 'B',
  String id = 'turn',
}) => const ScoreEngine().evaluate(
  game: session,
  rules: config ?? rules(),
  scores: points,
  input: TurnInput(turnId: id, actorId: actor, balls: balls, foul: foul),
  occurredAt: now,
);
Matcher failure(ScoreEngineError code) =>
    throwsA(isA<ScoreEngineFailure>().having((e) => e.code, 'code', code));

void main() {
  test(
    'all pot subsets preserve zero-sum and table invariants for 2–5 players',
    () {
      for (var count = 2; count <= 5; count++) {
        final order = ['A', 'B', 'C', 'D', 'E'].take(count).toList();
        for (final breakChain in [false, true]) {
          for (final foul in [false, true]) {
            for (var mask = 0; mask < 512; mask++) {
              final balls = [
                for (var b = 1; b <= 9; b++)
                  if (mask & (1 << (b - 1)) != 0) b,
              ];
              final result = run(
                game(breakChain: breakChain).copyWith(playerOrder: order),
                balls,
                points: {for (final id in order) id: 0},
                foul: !foul
                    ? FoulClassification.none
                    : balls.isEmpty
                    ? FoulClassification.th2
                    : FoulClassification.potAndFoul,
              );
              expect(result.scores.values.reduce((a, b) => a + b), 0);
              expect(
                result.transactions.every(
                  (t) => t.amount > 0 && t.fromPlayerId != t.toPlayerId,
                ),
                isTrue,
              );
              expect(result.game.playerOrder.toSet(), order.toSet());
              expect(
                result.game.currentPlayerId != result.game.payerId,
                isTrue,
              );
              expect(
                result.game.remainingBalls,
                game().remainingBalls.difference({
                  for (final ball in result.balls)
                    if (!ball.isRespotted) ball.ballNumber,
                }),
              );
              if (foul) expect(result.game.remainingBalls.contains(9), isTrue);
            }
          }
        }
      }
    },
  );
  test('legal pots keep cue and fixed payer across consecutive turns', () {
    final first = run(game(), [1]);
    final second = run(first.game, [2], points: first.scores, id: 'second');
    expect(second.scores, {'A': -15, 'B': 15, 'C': 0, 'D': 0});
    expect(second.game.currentPlayerId, 'B');
    expect(second.game.payerId, 'A');
    expect(second.game.chainState.hasLegalPotInChain, isTrue);
    expect(
      second.logs.map((l) => [l.participantId, l.previousScore, l.newScore]),
      [
        ['A', -5, -15],
        ['B', 5, 15],
      ],
    );
  });
  test(
    'multiple balls produce one transfer and input order does not matter',
    () {
      final result = run(game(), [3, 1, 2]);
      expect(result.transactions.single.amount, 30);
      expect(result.game.remainingBalls, {4, 5, 6, 7, 8, 9});
      expect(result.balls.every((b) => !b.isRespotted), isTrue);
    },
  );
  test('early balls score and respot, including repeat pots of early nine', () {
    final first = run(game(), [9, 3]);
    final second = run(first.game, [9], points: first.scores, id: 'second');
    expect(first.balls.every((b) => b.isRespotted), isTrue);
    expect(second.game.remainingBalls, game().remainingBalls);
    expect(second.game.status, GameStatus.inProgress);
    expect(second.scores['B'], 105);
  });
  test('prefix stops at an unpotted remaining ball', () {
    final result = run(game(), [1, 3]);
    expect(result.game.remainingBalls, {2, 3, 4, 5, 6, 7, 8, 9});
    expect(result.balls.last.isRespotted, isTrue);
  });
  test('disabled ball changes table and keeps cue without transactions', () {
    final result = run(game(), [1], config: rules(disabled: {1}));
    expect(result.transactions, isEmpty);
    expect(result.logs, isEmpty);
    expect(result.scores, scores);
    expect(result.game.remainingBalls.contains(1), isFalse);
    expect(result.game.chainState.hasLegalPotInChain, isTrue);
  });
  test('break chain pays each opponent and remains break chain', () {
    final result = run(game(breakChain: true), [2]);
    expect(result.scores, {'A': -10, 'B': 30, 'C': -10, 'D': -10});
    expect(result.transactions.length, 3);
    expect(result.transactions.map((t) => t.transactionGroupId).toSet(), {
      'turn',
    });
    expect(result.game.chainState.isBreakChain, isTrue);
  });
  test('miss passes cue, actor becomes payer and break chain ends', () {
    final result = run(game(breakChain: true), []);
    expect(result.game.currentPlayerId, 'C');
    expect(result.game.payerId, 'B');
    expect(result.game.playerOrder, ['A', 'B', 'C', 'D']);
    expect(result.game.chainState.isBreakChain, isFalse);
    expect(result.transactions, isEmpty);
  });
  test('TH1 preserves points and order, passes cue', () {
    final first = run(game(), [1]);
    final result = run(
      first.game,
      [],
      foul: FoulClassification.th1,
      points: first.scores,
      id: 'second',
    );
    expect(result.scores, first.scores);
    expect(result.game.playerOrder, ['A', 'B', 'C', 'D']);
    expect(result.game.currentPlayerId, 'C');
    expect(result.game.payerId, 'B');
  });
  test(
    'TH2 swaps order and payer shoots; subsequent miss follows new order',
    () {
      final result = run(game(), [], foul: FoulClassification.th2);
      expect(result.game.playerOrder, ['B', 'A', 'C', 'D']);
      expect(result.game.currentPlayerId, 'A');
      expect(result.game.payerId, 'B');
      expect(
        run(result.game, [], actor: 'A', id: 'second').game.currentPlayerId,
        'C',
      );
    },
  );
  test(
    'pot plus foul reverses score and swaps even after previous legal pot',
    () {
      final result = run(game(held: true), [
        1,
        2,
      ], foul: FoulClassification.potAndFoul);
      expect(result.scores, {'A': 15, 'B': -15, 'C': 0, 'D': 0});
      expect(result.game.playerOrder, ['B', 'A', 'C', 'D']);
      expect(result.game.remainingBalls, {3, 4, 5, 6, 7, 8, 9});
    },
  );
  test('break pot plus foul reverses to every opponent, swaps setup payer', () {
    final result = run(game(breakChain: true), [
      2,
    ], foul: FoulClassification.potAndFoul);
    expect(result.scores, {'A': 10, 'B': -30, 'C': 10, 'D': 10});
    expect(result.game.currentPlayerId, 'A');
    expect(result.game.chainState.isBreakChain, isFalse);
  });
  test('fouled nine always respots, early foul ball also respots', () {
    final result = run(game(remaining: {8, 9}), [
      9,
    ], foul: FoulClassification.potAndFoul);
    expect(result.game.status, GameStatus.inProgress);
    expect(result.game.remainingBalls, {8, 9});
    expect(result.balls.single.isRespotted, isTrue);
    final last = run(game(remaining: {9}), [
      9,
    ], foul: FoulClassification.potAndFoul);
    expect(last.game.remainingBalls, {9});
  });
  test('legal last two balls finish game with outcome and timestamp', () {
    final result = run(game(remaining: {8, 9}), [9, 8]);
    expect(result.game.status, GameStatus.finished);
    expect(result.game.winnerId, 'B');
    expect(result.game.finalPayerId, 'A');
    expect(result.game.endedAt, now);
    expect(result.game.isBreakClear, isFalse);
    expect(result.scores['B'], 85);
  });
  test('disabled nine still wins', () {
    final result = run(game(remaining: {9}), [9], config: rules(disabled: {9}));
    expect(result.game.status, GameStatus.finished);
    expect(result.transactions, isEmpty);
  });
  test(
    'break clear pays village, preserves order and records fixed final payer',
    () {
      final result = run(game(breakChain: true), [9, 8, 7, 6, 5, 4, 3, 2, 1]);
      expect(result.game.isBreakClear, isTrue);
      expect(result.game.playerOrder, game().playerOrder);
      expect(result.game.finalPayerId, 'A');
      expect(result.transactions.length, 3);
      expect(result.scores.values.reduce((a, b) => a + b), 0);
    },
  );
  test('invalid ball numbers, duplicates and already removed balls reject', () {
    for (final balls in [
      [0],
      [10],
      [1, 1],
      [2],
    ]) {
      expect(
        () => run(game(remaining: {1, 9}), balls),
        failure(ScoreEngineError.invalidBalls),
      );
    }
  });
  test('wrong actor rejects', () {
    expect(
      () => run(game(), [1], actor: 'C'),
      failure(ScoreEngineError.wrongActor),
    );
  });
  test('inconsistent foul classifications reject', () {
    for (final foul in [FoulClassification.th1, FoulClassification.th2]) {
      expect(
        () => run(game(), [1], foul: foul),
        failure(ScoreEngineError.invalidFoul),
      );
    }
    expect(
      () => run(game(), [], foul: FoulClassification.th1),
      failure(ScoreEngineError.invalidFoul),
    );
    expect(
      () => run(game(held: true), [], foul: FoulClassification.th2),
      failure(ScoreEngineError.invalidFoul),
    );
    expect(
      () => run(game(), [], foul: FoulClassification.potAndFoul),
      failure(ScoreEngineError.invalidFoul),
    );
  });
  test('invalid rules reject before scoring', () {
    expect(
      () => run(game(), [1], config: rules().copyWith(ballPoints: {})),
      failure(ScoreEngineError.invalidRules),
    );
    expect(
      () => run(game(), [
        1,
      ], config: rules(disabled: {1, 2, 3, 4, 5, 6, 7, 8, 9})),
      failure(ScoreEngineError.invalidRules),
    );
  });
  test('malformed session and ledger reject', () {
    for (final session in [
      game().copyWith(status: GameStatus.finished),
      game().copyWith(payerId: 'B'),
      game().copyWith(payerId: 'missing'),
      game().copyWith(playerOrder: ['A', 'B', 'B']),
      game().copyWith(remainingBalls: {1}),
      game().copyWith(remainingBalls: {0, 9}),
    ]) {
      expect(() => run(session, []), failure(ScoreEngineError.invalidState));
    }
    expect(
      () => run(game(), [], points: {'A': 1, 'B': 0, 'C': 0, 'D': 0}),
      failure(ScoreEngineError.invalidState),
    );
  });
  test(
    'input and source state unchanged on success and failure; result immutable',
    () {
      final session = game();
      final json = session.toJson();
      final balls = [1];
      final input = TurnInput(turnId: 'turn', actorId: 'B', balls: balls);
      balls.add(2);
      expect(input.balls, [1]);
      final result = run(session, [1]);
      expect(() => result.scores['A'] = 4, throwsUnsupportedError);
      expect(() => result.balls.clear(), throwsUnsupportedError);
      expect(() => result.game.remainingBalls.clear(), throwsUnsupportedError);
      expect(() => run(session, [0]), throwsA(isA<ScoreEngineFailure>()));
      expect(session.toJson(), json);
      expect(scores, {'A': 0, 'B': 0, 'C': 0, 'D': 0});
    },
  );
  test('retired participant balance stays in ledger', () {
    final result = run(
      game(),
      [1],
      points: {'A': -10, 'B': 0, 'C': 0, 'D': 0, 'retired': 10},
    );
    expect(result.scores['retired'], 10);
    expect(result.scores.values.reduce((a, b) => a + b), 0);
  });
}
