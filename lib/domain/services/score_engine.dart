import '../models/scoring/chain_state.dart';
import '../models/scoring/foul_classification.dart';
import '../models/scoring/game_session.dart';
import '../models/scoring/game_status.dart';
import '../models/scoring/potted_ball.dart';
import '../models/scoring/rule_config.dart';
import '../models/scoring/score_log.dart';
import '../models/scoring/score_transaction.dart';
import '../models/scoring/transaction_type.dart';
import '../validation/rule_config_validator.dart';

enum ScoreEngineError {
  invalidState,
  invalidRules,
  wrongActor,
  invalidBalls,
  invalidFoul,
}

class ScoreEngineFailure implements Exception {
  const ScoreEngineFailure(this.code);
  final ScoreEngineError code;
  @override
  String toString() => 'ScoreEngineFailure: ${code.name}';
}

/// Draft input contains ball numbers, never arbitrary score deltas.
class TurnInput {
  TurnInput({
    required this.turnId,
    required this.actorId,
    required List<int> balls,
    this.foul = FoulClassification.none,
  }) : balls = List.unmodifiable(balls);
  final String turnId;
  final String actorId;
  final List<int> balls;
  final FoulClassification foul;
}

/// Candidate state only. Commands add room snapshots/history and persist it.
class ScoreEngineResult {
  ScoreEngineResult({
    required this.game,
    required Map<String, int> scores,
    required List<PottedBall> balls,
    required List<String> payerIds,
    required List<ScoreTransaction> transactions,
    required List<ScoreLog> logs,
  }) : scores = Map.unmodifiable(scores),
       balls = List.unmodifiable(balls),
       payerIds = List.unmodifiable(payerIds),
       transactions = List.unmodifiable(transactions),
       logs = List.unmodifiable(logs);
  final GameSession game;
  final Map<String, int> scores;
  final List<PottedBall> balls;
  final List<String> payerIds;
  final List<ScoreTransaction> transactions;
  final List<ScoreLog> logs;
}

/// Pure scoring policy. No clock, storage, Flutter or Riverpod dependencies.
class ScoreEngine {
  const ScoreEngine();

  ScoreEngineResult evaluate({
    required GameSession game,
    required RuleConfig rules,
    required Map<String, int> scores,
    required TurnInput input,
    required DateTime occurredAt,
  }) {
    Never fail(ScoreEngineError code) => throw ScoreEngineFailure(code);
    final order = game.playerOrder;
    if (game.status != GameStatus.inProgress ||
        input.turnId.trim().isEmpty ||
        game.id.isEmpty ||
        game.roomId.isEmpty ||
        order.length < 2 ||
        order.length > 5 ||
        order.toSet().length != order.length ||
        !order.contains(game.currentPlayerId) ||
        !order.contains(game.payerId) ||
        game.currentPlayerId == game.payerId ||
        order.any((id) => id.isEmpty || !scores.containsKey(id)) ||
        scores.values.fold(0, (a, b) => a + b) != 0 ||
        game.remainingBalls.isEmpty ||
        !game.remainingBalls.contains(9) ||
        game.remainingBalls.any((b) => b < 1 || b > 9) ||
        game.turns.any((t) => t.id == input.turnId)) {
      fail(ScoreEngineError.invalidState);
    }
    if (rules.id.isEmpty ||
        rules.version < 1 ||
        RuleConfigValidator.validate(rules).isNotEmpty) {
      fail(ScoreEngineError.invalidRules);
    }
    if (input.actorId != game.currentPlayerId) {
      fail(ScoreEngineError.wrongActor);
    }
    if (input.balls.toSet().length != input.balls.length ||
        input.balls.any((b) => !game.remainingBalls.contains(b))) {
      fail(ScoreEngineError.invalidBalls);
    }
    final hasPot = input.balls.isNotEmpty;
    final foul = input.foul != FoulClassification.none;
    final expectedFoul = hasPot
        ? FoulClassification.potAndFoul
        : game.chainState.hasLegalPotInChain
        ? FoulClassification.th1
        : FoulClassification.th2;
    if (foul && input.foul != expectedFoul) fail(ScoreEngineError.invalidFoul);

    // Only a contiguous prefix of remaining balls stays down. Input order is
    // irrelevant: potting 2+3 together removes both, potting 3 alone respots it.
    final sorted = game.remainingBalls.toList()..sort();
    final removed = <int>{};
    for (final ball in sorted) {
      if (!input.balls.contains(ball)) break;
      removed.add(ball);
    }
    if (foul) removed.remove(9);
    final outcomes = [
      for (final b in input.balls)
        PottedBall(
          ballNumber: b,
          points: rules.ballPoints[b]!.points,
          isRespotted: !removed.contains(b),
        ),
    ];
    final amount = outcomes.fold(0, (sum, b) => sum + b.points);
    final actor = input.actorId;
    final payers = game.chainState.isBreakChain
        ? order.where((id) => id != actor).toList()
        : [game.payerId];
    final transactions = <ScoreTransaction>[];
    if (amount > 0) {
      for (var i = 0; i < payers.length; i++) {
        transactions.add(
          ScoreTransaction(
            id: '${input.turnId}:$i',
            gameId: game.id,
            turnId: input.turnId,
            fromPlayerId: foul ? actor : payers[i],
            toPlayerId: foul ? payers[i] : actor,
            amount: amount,
            type: foul
                ? TransactionType.foulReversal
                : TransactionType.legalPot,
            transactionGroupId: game.chainState.isBreakChain
                ? input.turnId
                : null,
          ),
        );
      }
    }
    final nextScores = Map<String, int>.of(scores);
    final affected = <String>{};
    for (final t in transactions) {
      nextScores[t.fromPlayerId] = nextScores[t.fromPlayerId]! - t.amount;
      nextScores[t.toPlayerId] = nextScores[t.toPlayerId]! + t.amount;
      affected.addAll([t.fromPlayerId, t.toPlayerId]);
    }
    final nextOrder = List<String>.of(order);
    var current = actor;
    var payer = game.payerId;
    final keepsCue = hasPot && !foul;
    if (!keepsCue) {
      if (input.foul == FoulClassification.th2 ||
          input.foul == FoulClassification.potAndFoul) {
        final a = order.indexOf(actor);
        final p = order.indexOf(payer);
        nextOrder[a] = payer;
        nextOrder[p] = actor;
        current = payer;
      } else {
        current = order[(order.indexOf(actor) + 1) % order.length];
      }
      payer = actor;
    }
    final remaining = game.remainingBalls.difference(removed);
    final won = !foul && remaining.isEmpty;
    final nextGame = game.copyWith(
      currentPlayerId: current,
      previousPlayerId: actor,
      payerId: payer,
      playerOrder: List.unmodifiable(nextOrder),
      remainingBalls: Set.unmodifiable(remaining),
      chainState: ChainState(
        isBreakChain: keepsCue && game.chainState.isBreakChain,
        hasLegalPotInChain: keepsCue,
      ),
      status: won ? GameStatus.finished : GameStatus.inProgress,
      endedAt: won ? occurredAt : null,
      winnerId: won ? actor : null,
      finalPayerId: won ? game.payerId : null,
      isBreakClear: won && game.chainState.isBreakChain,
    );
    return ScoreEngineResult(
      game: nextGame,
      scores: nextScores,
      balls: outcomes,
      payerIds: hasPot ? payers : [],
      transactions: transactions,
      logs: [
        for (final id in affected)
          ScoreLog(
            participantId: id,
            previousScore: scores[id]!,
            newScore: nextScores[id]!,
          ),
      ],
    );
  }
}
