import 'dart:io';

import 'package:drift/native.dart';
import 'package:bidart/data/local/app_database.dart';
import 'package:bidart/data/repositories/game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/services/room_commands.dart';
import 'package:bidart/domain/services/room_service.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Persistence gates: real file close/reopen and in-memory service recreation.
/// Scores, balls, order, history, undo barriers and receipts restore exactly.
void main() {
  test(
    'file reopen restores TH2 undo, receipts and closed room history',
    () async {
      final directory = await Directory.systemTemp.createTemp('bidart-phase5-');
      final file = File('${directory.path}/game.sqlite');
      var db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await directory.delete(recursive: true);
      });
      var serial = 0;
      final now = DateTime.utc(2026, 10, 15);
      RoomService service() => RoomService(
        repository: DriftGameRepository(database: db),
        clock: () => now,
        idFactory: () => 'disk-${++serial}',
      );
      var svc = service();
      final id = await svc.createRoom(
        commandId: 'create',
        name: 'Offline',
        ownerId: 'owner',
        participants: [
          for (final id in ['A', 'B', 'C'])
            PlayerInGame(id: id, displayName: id, joinedAt: now),
        ],
        playerOrder: ['A', 'B', 'C'],
        starterId: 'A',
        payerId: 'B',
        ballPoints: {
          for (var i = 1; i <= 9; i++)
            i: const BallPointConfig(enabled: true, points: 10),
        },
      );
      var room = await svc.getRoom(id);
      for (final command in ['pot', 'miss', 'th2']) {
        room = await svc.recordTurn(
          commandId: command,
          roomId: id,
          expectedRevision: room.revision,
          gameId: room.currentGameId!,
          input: TurnInput(
            turnId: command,
            actorId: room.games.last.currentPlayerId,
            balls: command == 'pot' ? [1] : [],
            foul: command == 'th2'
                ? FoulClassification.th2
                : FoulClassification.none,
          ),
        );
      }
      final beforeUndo = room.toJson();
      await db.close();
      db = AppDatabase(NativeDatabase(file));
      svc = service();
      expect((await svc.getRoom(id)).toJson(), beforeUndo);
      room = await svc.undoLastTurn(
        commandId: 'undo',
        roomId: id,
        expectedRevision: room.revision,
        gameId: room.currentGameId!,
      );
      expect(room.playerOrder, ['A', 'B', 'C']);
      expect(room.games.last.currentPlayerId, 'B');
      expect(room.games.last.turns.last.isUndone, isTrue);
      expect(room.scores, {'A': 20, 'B': -10, 'C': -10});
      final undone = room.toJson();
      await db.close();
      db = AppDatabase(NativeDatabase(file));
      svc = service();
      expect((await svc.getRoom(id)).toJson(), undone);
      final replay = await svc.undoLastTurn(
        commandId: 'undo',
        roomId: id,
        expectedRevision: 0,
        gameId: room.currentGameId!,
      );
      expect(replay.toJson(), undone);
      room = await svc.finishRoom(
        commandId: 'finish',
        roomId: id,
        expectedRevision: room.revision,
        confirmed: true,
      );
      final closed = room.toJson();
      await db.close();
      db = AppDatabase(NativeDatabase(file));
      svc = service();
      expect((await svc.getRoom(id)).toJson(), closed);
      expect((await svc.getRoom(id)).status, RoomStatus.finished);
      await expectLater(
        svc.undoLastTurn(
          commandId: 'closed-undo',
          roomId: id,
          expectedRevision: room.revision,
          gameId: room.currentGameId!,
        ),
        throwsA(isA<Exception>()),
      );
      expect((await svc.getRoom(id)).toJson(), closed);
    },
  );

  test('record + TH2 + edit barrier survive restart with receipts', () async {
    final db = AppDatabase.memory();
    addTearDown(() => db.close());
    var serial = 0;
    final now = DateTime.utc(2026, 10, 15);
    RoomService service() => RoomService(
      repository: DriftGameRepository(database: db, clock: () => now),
      clock: () => now,
      idFactory: () => 'id-${++serial}',
    );

    var svc = service();
    final roomId = await svc.createRoom(
      commandId: 'create',
      name: 'Bàn 1',
      ownerId: 'owner',
      participants: [
        for (final id in ['A', 'B', 'C'])
          PlayerInGame(id: id, displayName: id, joinedAt: now),
      ],
      playerOrder: ['A', 'B', 'C'],
      starterId: 'A',
      payerId: 'B',
      ballPoints: {
        for (var i = 1; i <= 9; i++)
          i: const BallPointConfig(enabled: true, points: 10),
      },
    );
    var room = await svc.getRoom(roomId);

    // A pots ball 1 on the break: whole table pays (spec break chain).
    room = await svc.recordTurn(
      commandId: 'turn-1',
      roomId: roomId,
      expectedRevision: room.revision,
      gameId: room.currentGameId!,
      input: TurnInput(
        turnId: 'shot:turn-1',
        actorId: 'A',
        balls: [1],
        foul: FoulClassification.none,
      ),
    );
    expect(room.scores, {'A': 20, 'B': -10, 'C': -10});

    // TH2 foul before any legal pot in a later chain: swap order.
    // Force a miss to pass turn to B, then B fouls.
    room = await svc.recordTurn(
      commandId: 'turn-2',
      roomId: roomId,
      expectedRevision: room.revision,
      gameId: room.currentGameId!,
      input: TurnInput(
        turnId: 'shot:turn-2',
        actorId: room.games.last.currentPlayerId,
        balls: const [],
        foul: FoulClassification.none,
      ),
    );
    final beforeTh2Order = [...room.games.last.playerOrder];
    room = await svc.recordTurn(
      commandId: 'turn-3',
      roomId: roomId,
      expectedRevision: room.revision,
      gameId: room.currentGameId!,
      input: TurnInput(
        turnId: 'shot:turn-3',
        actorId: room.games.last.currentPlayerId,
        balls: const [],
        foul: FoulClassification.th2,
      ),
    );
    expect(room.games.last.playerOrder, isNot(beforeTh2Order));

    // Edit barrier: reorder players.
    room = await svc.reorderPlayers(
      commandId: 'edit-1',
      roomId: roomId,
      expectedRevision: room.revision,
      playerOrder: [...room.playerOrder.reversed],
    );
    final committedJson = room.toJson();

    // Recreate service only; the file-backed test above closes/reopens the DB.
    svc = service();
    final restored = await svc.getRoom(roomId);
    expect(restored.toJson(), committedJson);
    expect(restored.scores.values.reduce((a, b) => a + b), 0);

    // Receipt idempotency survives restart: same command returns the
    // original committed room, not the latest revision.
    final replay = await svc.recordTurn(
      commandId: 'turn-3',
      roomId: roomId,
      expectedRevision: 0,
      gameId: restored.currentGameId!,
      input: TurnInput(
        turnId: 'other',
        actorId: 'A',
        balls: [9],
        foul: FoulClassification.none,
      ),
    );
    expect(replay.revision, isNot(restored.revision));
    expect((await svc.getRoom(roomId)).toJson(), committedJson);

    // Undo cannot cross the edit barrier, even after restart.
    await expectLater(
      svc.undoLastTurn(
        commandId: 'undo-1',
        roomId: roomId,
        expectedRevision: restored.revision,
        gameId: restored.currentGameId!,
      ),
      throwsA(isA<Exception>()),
    );
  });
}
