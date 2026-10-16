import 'dart:convert';

import 'package:bidart/domain/models/scoring/chain_state.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/pending_end_reason.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/turn_state_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TurnStateSnapshot snapshot() => TurnStateSnapshot(
    roomId: 'room-1',
    gameId: 'game-1',
    scores: {'a': 10, 'b': -10, 'departed': 0},
    activePlayerIds: ['a', 'b'],
    playerOrder: ['b', 'a'],
    currentPlayerId: 'b',
    previousPlayerId: 'a',
    payerId: 'a',
    chainState: const ChainState(isBreakChain: false, hasLegalPotInChain: true),
    remainingBalls: {2, 3, 4, 5, 6, 7, 8, 9},
    roomStatus: RoomStatus.active,
    gameStatus: GameStatus.inProgress,
    roomCreatedAt: DateTime.utc(2026, 10, 12),
    gameStartedAt: DateTime.utc(2026, 10, 12, 0, 1),
    isBreakClear: false,
    pendingEndReasons: {
      PendingEndReason.timeLimit,
      PendingEndReason.scoreThreshold,
    },
  );

  test('end conditions support disabled and independent limits', () {
    const unlimited = EndConditions();
    expect(unlimited.durationSeconds, isNull);
    expect(unlimited.scoreThreshold, isNull);
    const limited = EndConditions(durationSeconds: 3600, scoreThreshold: 100);
    expect(EndConditions.fromJson(limited.toJson()), limited);
    expect(limited.copyWith(scoreThreshold: null).durationSeconds, 3600);
    expect(limited.copyWith(scoreThreshold: null).scoreThreshold, isNull);
  });

  test('chain tracks legal pots independently of break state', () {
    const chain = ChainState(isBreakChain: true, hasLegalPotInChain: true);
    expect(ChainState.fromJson(chain.toJson()), chain);
    expect(chain.copyWith(isBreakChain: false).hasLegalPotInChain, isTrue);
  });

  test('snapshot survives actual JSON encoding with both end reasons', () {
    final original = snapshot();
    final decoded = jsonDecode(jsonEncode(original.toJson()));
    expect(
      TurnStateSnapshot.fromJson(decoded as Map<String, dynamic>),
      original,
    );
    expect(original.pendingEndReasons, hasLength(2));
    expect(original.scores.keys, contains('departed'));
  });

  test('snapshot collections reject mutation', () {
    final state = snapshot();
    expect(() => state.scores['a'] = 99, throwsUnsupportedError);
    expect(() => state.activePlayerIds.add('c'), throwsUnsupportedError);
    expect(() => state.playerOrder.clear(), throwsUnsupportedError);
    expect(() => state.remainingBalls.remove(9), throwsUnsupportedError);
    expect(() => state.pendingEndReasons.clear(), throwsUnsupportedError);
  });

  test('copying outcome does not change previous state', () {
    final before = snapshot();
    final after = before.copyWith(
      gameStatus: GameStatus.finished,
      gameEndedAt: DateTime.utc(2026, 10, 12, 1),
      winnerId: 'b',
      finalPayerId: 'a',
      remainingBalls: {},
    );
    expect(before.gameStatus, GameStatus.inProgress);
    expect(before.remainingBalls, contains(9));
    expect(after.winnerId, 'b');
    expect(TurnStateSnapshot.fromJson(after.toJson()), after);
  });

  test('snapshot excludes history and non-restorable metadata', () {
    final json = snapshot().toJson();
    for (final key in [
      'turns',
      'games',
      'events',
      'revision',
      'commandReceipts',
    ]) {
      expect(json, isNot(contains(key)));
    }
  });
}
