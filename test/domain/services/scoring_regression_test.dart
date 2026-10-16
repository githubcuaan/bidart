import 'dart:convert';
import 'dart:math';

import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_commands.dart';
import 'package:bidart/domain/services/room_service.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Independent ledger/table reconstruction, not an engine-result comparison.
void verifyHistory(Room room) {
  final ledger = {for (final player in room.participants) player.id: 0};
  for (final game in room.games) {
    final remaining = {for (var b = 1; b <= 9; b++) b};
    for (final turn in game.turns.where((t) => !t.isUndone)) {
      final deltas = <String, int>{};
      for (final transaction in turn.transactions) {
        expect(transaction.gameId, game.id);
        expect(transaction.turnId, turn.id);
        expect(transaction.amount, greaterThan(0));
        expect(transaction.fromPlayerId, isNot(transaction.toPlayerId));
        for (final entry in {
          transaction.fromPlayerId: -transaction.amount,
          transaction.toPlayerId: transaction.amount,
        }.entries) {
          ledger[entry.key] = ledger[entry.key]! + entry.value;
          deltas.update(
            entry.key,
            (v) => v + entry.value,
            ifAbsent: () => entry.value,
          );
        }
      }
      expect({
        for (final log in turn.logs)
          log.participantId: log.newScore - log.previousScore,
      }, deltas);
      for (final ball in turn.pottedBalls) {
        expect(remaining.contains(ball.ballNumber), isTrue);
        if (!ball.isRespotted) remaining.remove(ball.ballNumber);
      }
    }
    expect(game.remainingBalls, remaining);
  }
  expect(room.scores, ledger);
  expect(ledger.values.fold(0, (a, b) => a + b), 0);
  expect(
    Room.fromJson(
      jsonDecode(jsonEncode(room.toJson())) as Map<String, dynamic>,
    ),
    room,
  );
}

void main() {
  final now = DateTime.utc(2026, 10, 15);
  late InMemoryGameRepository repository;
  late RoomService service;
  late Room room;
  var ids = 0;
  Future<void> create(int count) async {
    repository = InMemoryGameRepository();
    ids = 0;
    service = RoomService(
      repository: repository,
      idFactory: () => 'id-${++ids}',
      clock: () => now,
    );
    final order = ['A', 'B', 'C', 'D', 'E'].take(count).toList();
    final id = await service.createRoom(
      commandId: 'create',
      name: 'Regression',
      ownerId: 'owner',
      participants: [
        for (final id in order)
          PlayerInGame(id: id, displayName: id, joinedAt: now),
      ],
      playerOrder: order,
      starterId: 'A',
      payerId: 'B',
      ballPoints: {
        for (var b = 1; b <= 9; b++)
          b: BallPointConfig(enabled: b != 4, points: b == 4 ? 0 : b * 5),
      },
    );
    room = await service.getRoom(id);
  }

  Future<void> shot(List<int> balls, {bool foul = false}) async {
    final game = room.games.last;
    final classification = !foul
        ? FoulClassification.none
        : balls.isNotEmpty
        ? FoulClassification.potAndFoul
        : game.chainState.hasLegalPotInChain
        ? FoulClassification.th1
        : FoulClassification.th2;
    final command = 'shot-${++ids}';
    room = await service.recordTurn(
      commandId: command,
      roomId: room.id,
      expectedRevision: room.revision,
      gameId: game.id,
      input: TurnInput(
        turnId: command,
        actorId: game.currentPlayerId,
        balls: balls,
        foul: classification,
      ),
    );
    verifyHistory(room);
  }

  Future<void> next() async {
    room = await service.startNextGame(
      commandId: 'next-${++ids}',
      roomId: room.id,
      expectedRevision: room.revision,
    );
    verifyHistory(room);
  }

  Future<void> undo() async {
    room = await service.undoLastTurn(
      commandId: 'undo-${++ids}',
      roomId: room.id,
      expectedRevision: room.revision,
      gameId: room.currentGameId!,
      confirmReopen: true,
    );
    verifyHistory(room);
  }

  test('three-game journey: TH1/TH2, undo, normal next game, break clear and read-only review', () async {
    await create(4);
    await shot([]); // B shoots, A pays.
    await shot([1]);
    await shot([], foul: true); // TH1: C shoots, B pays.
    final beforeSwap = room;
    await shot([], foul: true); // TH2: swap C/B.
    expect(room.playerOrder, ['A', 'C', 'B', 'D']);
    await undo();
    expect(room.playerOrder, beforeSwap.playerOrder);
    expect(room.games.single.currentPlayerId, 'C');
    await shot([2, 3, 4, 5, 6, 7, 8, 9]);
    final first = room.games.single;
    final firstScores = room.scores;
    await next();
    expect(room.playerOrder, ['C', 'B', 'D', 'A']);
    expect(room.scores, firstScores);
    await shot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    expect(room.games.last.isBreakClear, isTrue);
    await next();
    expect(room.playerOrder, ['C', 'B', 'D', 'A']);
    await shot([9]); // Early nine, no win, stays on table.
    final committed = room;
    room = await service.finishRoom(
      commandId: 'finish',
      roomId: room.id,
      expectedRevision: room.revision,
      confirmed: true,
    );
    verifyHistory(room);
    expect(room.status, RoomStatus.finished);
    expect(room.games.last.status, GameStatus.incomplete);
    expect(room.games.first, first);
    expect(room.scores, committed.scores);
    expect(await service.getRoom(room.id), room);
    expect(
      (await service.listRooms(status: RoomStatus.finished)).single.gameCount,
      3,
    );
  });

  test('new service on same RAM repository reads undone history and original command receipt', () async {
    await create(3);
    await shot([1, 2]);
    final original = room;
    final turn = room.games.single.turns.single;
    await undo();
    final undone = room;
    // This is service recreation, NOT app restart/durable persistence.
    service = RoomService(
      repository: repository,
      idFactory: () => 'id-${++ids}',
      clock: () => now,
    );
    expect(await service.getRoom(room.id), undone);
    final retry = await service.recordTurn(
      commandId: turn.commandId,
      roomId: room.id,
      expectedRevision: -1,
      gameId: turn.gameId,
      input: TurnInput(turnId: turn.id, actorId: turn.actorId, balls: [1, 2]),
    );
    expect(retry, original);
    expect(await service.getRoom(room.id), undone);
    await shot([1]);
    expect(room.games.single.turns.first.isUndone, isTrue);
    verifyHistory(room);
  });

  for (var players = 2; players <= 5; players++) {
    test(
      'seeded $players-player command sequences reconstruct ledger/table across games',
      () async {
        await create(players);
        final random = Random(20261015 + players);
        for (var step = 0; step < 100; step++) {
          final game = room.games.last;
          if (game.status == GameStatus.finished) {
            await next();
            continue;
          }
          if (step % 11 == 0 && game.turns.any((t) => !t.isUndone)) {
            await undo();
            continue;
          }
          final sorted = game.remainingBalls.toList()..sort();
          final balls = switch (random.nextInt(4)) {
            0 => <int>[],
            1 => [sorted.last],
            2 => [sorted.first],
            _ => sorted.take(1 + random.nextInt(sorted.length)).toList(),
          };
          await shot(balls, foul: random.nextInt(4) == 0);
        }
        room = await service.cancelRoom(
          commandId: 'cancel',
          roomId: room.id,
          expectedRevision: room.revision,
          confirmed: true,
        );
        verifyHistory(room);
        final closed = room;
        await expectLater(
          service.undoLastTurn(
            commandId: 'blocked',
            roomId: room.id,
            expectedRevision: room.revision,
            gameId: room.currentGameId!,
            confirmReopen: true,
          ),
          throwsA(isA<RepositoryValidationFailure>()),
        );
        expect(await repository.getRoom(room.id), closed);
      },
    );
  }
}
