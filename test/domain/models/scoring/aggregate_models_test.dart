import 'dart:convert';

import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/chain_state.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/potted_ball.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_event.dart';
import 'package:bidart/domain/models/scoring/room_event_type.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/domain/models/scoring/score_log.dart';
import 'package:bidart/domain/models/scoring/score_transaction.dart';
import 'package:bidart/domain/models/scoring/transaction_type.dart';
import 'package:bidart/domain/models/scoring/turn.dart';
import 'package:bidart/domain/models/scoring/turn_state_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

Map<int, BallPointConfig> balls({int disabled = 2}) => {
  for (var i = 1; i <= 9; i++)
    i: i == disabled
        ? const BallPointConfig(enabled: false, points: 0)
        : BallPointConfig(enabled: true, points: i * 5),
};

TurnStateSnapshot snapshot() => TurnStateSnapshot(
  roomId: 'room-1',
  gameId: 'game-1',
  scores: {'a': 10, 'b': -10},
  activePlayerIds: ['a', 'b'],
  playerOrder: ['a', 'b'],
  currentPlayerId: 'a',
  previousPlayerId: 'b',
  payerId: 'b',
  chainState: const ChainState(isBreakChain: false, hasLegalPotInChain: true),
  remainingBalls: {1, 3, 4, 5, 6, 7, 8, 9},
  roomStatus: RoomStatus.active,
  gameStatus: GameStatus.inProgress,
  roomCreatedAt: DateTime.utc(2026, 10, 12),
  gameStartedAt: DateTime.utc(2026, 10, 12, 0, 1),
  isBreakClear: false,
  pendingEndReasons: {},
);

Turn turn() => Turn(
  id: 'turn-1',
  commandId: 'cmd-1',
  roomId: 'room-1',
  gameId: 'game-1',
  turnNumber: 1,
  actorId: 'a',
  payerIds: ['b'],
  ruleConfigId: 'rule-1',
  ruleVersion: 1,
  pottedBalls: const [
    PottedBall(ballNumber: 3, points: 15, isRespotted: false),
    PottedBall(ballNumber: 9, points: 50, isRespotted: true),
  ],
  foulClassification: FoulClassification.none,
  transactions: const [
    ScoreTransaction(
      id: 'tx-1',
      gameId: 'game-1',
      turnId: 'turn-1',
      fromPlayerId: 'b',
      toPlayerId: 'a',
      amount: 15,
      type: TransactionType.legalPot,
    ),
  ],
  logs: const [ScoreLog(participantId: 'a', previousScore: 0, newScore: 15)],
  beforeSnapshot: snapshot(),
  afterSnapshot: snapshot(),
  createdAt: DateTime.utc(2026, 10, 12, 0, 2),
);

Room room() => Room(
  id: 'room-1',
  name: 'Ban 1',
  ownerId: 'owner-local',
  mode: RoomMode.local,
  status: RoomStatus.active,
  createdAt: DateTime.utc(2026, 10, 12),
  revision: 3,
  participants: [
    PlayerInGame(
      id: 'a',
      displayName: 'A',
      joinedAt: DateTime.utc(2026, 10, 12),
    ),
    PlayerInGame(
      id: 'b',
      displayName: 'B',
      joinedAt: DateTime.utc(2026, 10, 12),
    ),
  ],
  activePlayerIds: ['a', 'b'],
  playerOrder: ['a', 'b'],
  scores: {'a': 15, 'b': -15},
  ruleVersions: [
    RuleConfig(id: 'rule-1', version: 1, ballPoints: balls()),
    RuleConfig(id: 'rule-2', version: 2, ballPoints: balls(disabled: 5)),
  ],
  currentRuleVersion: 2,
  games: [
    GameSession(
      id: 'game-1',
      roomId: 'room-1',
      gameNumber: 1,
      status: GameStatus.inProgress,
      startedAt: DateTime.utc(2026, 10, 12, 0, 1),
      currentPlayerId: 'a',
      payerId: 'b',
      playerOrder: ['a', 'b'],
      remainingBalls: {1, 3, 4, 5, 6, 7, 8, 9},
      chainState: const ChainState(
        isBreakChain: false,
        hasLegalPotInChain: true,
      ),
      turns: [turn()],
    ),
  ],
  currentGameId: 'game-1',
  endConditions: const EndConditions(scoreThreshold: 100),
  pendingEndReasons: {},
);

void main() {
  test('ball map uses integer keys through real JSON encoding', () {
    final config = RuleConfig(id: 'rule-1', version: 1, ballPoints: balls());
    final raw = jsonDecode(jsonEncode(config.toJson())) as Map<String, dynamic>;
    final ballMap = raw['ballPoints'] as Map<String, dynamic>;
    expect(ballMap.keys, containsAll(['1', '9']));
    final decoded = RuleConfig.fromJson(raw);
    expect(decoded, config);
    expect(decoded.ballPoints.keys, everyElement(isA<int>()));
    expect(
      decoded.ballPoints[2],
      const BallPointConfig(enabled: false, points: 0),
    );
  });

  test('room/game/turn round-trip with nested snapshots', () {
    final original = room();
    final decoded = Room.fromJson(
      jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
    );
    expect(decoded, original);
    expect(decoded.games.single.turns.single.beforeSnapshot, snapshot());
    expect(
      GameSession.fromJson(decoded.games.single.toJson()),
      decoded.games.single,
    );
    expect(Turn.fromJson(turn().toJson()), turn());
  });

  test('historical rule versions preserved after template copy', () {
    final before = room();
    final template = RuleTemplate(
      id: 'tpl-1',
      name: 'Fav',
      ballPoints: Map.of(before.ruleVersions.first.ballPoints),
      createdAt: DateTime.utc(2026, 10, 13),
    );
    final stored = RuleTemplate.fromJson(
      jsonDecode(jsonEncode(template.toJson())) as Map<String, dynamic>,
    );
    expect(stored.ballPoints, template.ballPoints);
    // Template holds an independent copy: mutating a mutable copy of its
    // map must not alias room history.
    final mutableCopy = Map.of(template.ballPoints);
    mutableCopy[1] = const BallPointConfig(enabled: false, points: 0);
    expect(before.ruleVersions.first.ballPoints[1]!.enabled, isTrue);
    expect(before.ruleVersions[1].ballPoints[5]!.enabled, isFalse);
    expect(before.currentRuleVersion, 2);
  });

  test('aggregates expose immutable collections', () {
    final state = room();
    expect(() => state.scores['a'] = 0, throwsUnsupportedError);
    expect(() => state.playerOrder.add('c'), throwsUnsupportedError);
    expect(
      () => state.games.single.playerOrder.clear(),
      throwsUnsupportedError,
    );
    expect(
      () => state.games.single.remainingBalls.remove(9),
      throwsUnsupportedError,
    );
    expect(() => state.games.single.turns.add(turn()), throwsUnsupportedError);
    expect(() => turn().payerIds.add('a'), throwsUnsupportedError);
    expect(
      () => turn().transactions.add(turn().transactions.single),
      throwsUnsupportedError,
    );
  });

  test('removed vs respotted balls distinguished', () {
    final t = turn();
    final removed = t.pottedBalls.where((b) => !b.isRespotted);
    final respotted = t.pottedBalls.where((b) => b.isRespotted);
    expect(removed.map((b) => b.ballNumber), [3]);
    expect(respotted.map((b) => b.ballNumber), [9]);
    expect(Turn.fromJson(t.toJson()).pottedBalls, t.pottedBalls);
  });

  test('transactions require distinct parties and positive amounts', () {
    expect(
      () => ScoreTransaction(
        id: 'x',
        gameId: 'g',
        turnId: 't',
        fromPlayerId: 'a',
        toPlayerId: 'a',
        amount: 10,
        type: TransactionType.legalPot,
      ),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => ScoreTransaction(
        id: 'x',
        gameId: 'g',
        turnId: 't',
        fromPlayerId: 'a',
        toPlayerId: 'b',
        amount: 0,
        type: TransactionType.legalPot,
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  test('room event carries revision, edit data and undo barrier', () {
    final event = RoomEvent(
      id: 'ev-1',
      roomId: 'room-1',
      commandId: 'cmd-ev-1',
      revision: 4,
      type: RoomEventType.reorderPlayers,
      beforeSnapshot: snapshot(),
      afterSnapshot: snapshot().copyWith(playerOrder: ['b', 'a']),
      createdAt: DateTime.utc(2026, 10, 12, 0, 3),
    );
    expect(event.isUndoBarrier, isTrue);
    final decoded = RoomEvent.fromJson(
      jsonDecode(jsonEncode(event.toJson())) as Map<String, dynamic>,
    );
    expect(decoded, event);
    expect(decoded.afterSnapshot.playerOrder, ['b', 'a']);
  });

  test('turn references IDs and keeps undone marker through JSON', () {
    final undone = turn().copyWith(isUndone: true);
    expect(undone.isUndone, isTrue);
    expect(turn().isUndone, isFalse);
    final decoded = Turn.fromJson(
      jsonDecode(jsonEncode(undone.toJson())) as Map<String, dynamic>,
    );
    expect(decoded.isUndone, isTrue);
    expect(decoded.actorId, 'a');
    expect(decoded.ruleVersion, 1);
  });
}
