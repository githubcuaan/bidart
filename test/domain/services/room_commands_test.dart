import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/pending_end_reason.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_commands.dart';
import 'package:bidart/domain/services/room_service.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final start = DateTime.utc(2026, 10, 15);
  late DateTime now;
  late InMemoryGameRepository repo;
  late RoomService service;
  late Room room;
  var serial = 0;
  final points = {
    for (var i = 1; i <= 9; i++)
      i: const BallPointConfig(enabled: true, points: 10),
  };

  setUp(() async {
    now = start;
    serial = 0;
    repo = InMemoryGameRepository();
    service = RoomService(
      repository: repo,
      clock: () => now,
      idFactory: () => 'id-${++serial}',
    );
    final id = await service.createRoom(
      commandId: 'create',
      name: 'Table',
      ownerId: 'owner',
      participants: [
        for (final id in ['A', 'B', 'C', 'D'])
          PlayerInGame(id: id, displayName: id, joinedAt: start),
      ],
      playerOrder: ['A', 'B', 'C', 'D'],
      starterId: 'A',
      payerId: 'B',
      ballPoints: points,
    );
    room = await service.getRoom(id);
  });

  Future<Room> pot(
    List<int> balls, {
    FoulClassification foul = FoulClassification.none,
    String? command,
    String? actor,
    int? revision,
    String? gameId,
  }) async {
    final id = command ?? 'turn-${++serial}';
    final result = await service.recordTurn(
      commandId: id,
      roomId: room.id,
      expectedRevision: revision ?? room.revision,
      gameId: gameId ?? room.currentGameId!,
      input: TurnInput(
        turnId: 'shot:$id',
        actorId: actor ?? room.games.last.currentPlayerId,
        balls: balls,
        foul: foul,
      ),
    );
    room = result;
    return result;
  }

  Future<Room> undo({
    bool confirm = false,
    String? command,
    String? gameId,
  }) async {
    room = await service.undoLastTurn(
      commandId: command ?? 'undo-${++serial}',
      roomId: room.id,
      expectedRevision: room.revision,
      gameId: gameId ?? room.currentGameId!,
      confirmReopen: confirm,
    );
    return room;
  }

  Future<void> limits(EndConditions conditions) async {
    room = room.copyWith(
      endConditions: conditions,
      revision: room.revision + 1,
    );
    await repo.updateRoom(
      commandId: 'fixture-limits',
      expectedRevision: room.revision - 1,
      room: room,
    );
  }

  Future<void> next({String? starter, String? payer}) async {
    room = await service.startNextGame(
      commandId: 'next-${++serial}',
      roomId: room.id,
      expectedRevision: room.revision,
      replacementStarterId: starter,
      replacementPayerId: payer,
    );
  }

  Future<void> remove(String id) async {
    room = await service.removePlayer(
      commandId: 'remove-$id',
      roomId: room.id,
      expectedRevision: room.revision,
      participantId: id,
    );
  }

  test('record commits turn, snapshots, logs, rule reference and serialized history', () async {
    final before = room;
    await pot([1, 2]);
    final turn = room.games.single.turns.single;
    expect(room.revision, 1);
    expect(turn.revision, 1);
    expect(turn.beforeSnapshot.scores, before.scores);
    expect(turn.afterSnapshot.scores, room.scores);
    expect(turn.afterSnapshot.remainingBalls, {3, 4, 5, 6, 7, 8, 9});
    expect(turn.payerIds, ['B', 'C', 'D']);
    expect(turn.logs.length, 4);
    expect(turn.ruleConfigId, room.ruleVersions.single.id);
    expect(await service.getRoom(room.id), room);
    expect(Room.fromJson(room.toJson()), room);
    expect(before.games.single.turns, isEmpty);
  });
  test(
    'save failure leaves aggregate and receipt unchanged; retry commits once',
    () async {
      final before = room;
      repo.failNextWrite();
      await expectLater(
        pot([1], command: 'shot'),
        throwsA(isA<PersistenceFailure>()),
      );
      expect(await service.getRoom(room.id), before);
      expect(await repo.getCommandReceipt('shot'), isNull);
      final first = await pot([1], command: 'shot');
      await pot([2]);
      final latest = room;
      final retry = await pot([1], command: 'shot', revision: -1);
      expect(retry, first);
      expect(await service.getRoom(room.id), latest);
    },
  );
  test(
    'concurrent identical record commands return one original receipt',
    () async {
      final results = await Future.wait([
        pot([1], command: 'same'),
        pot([1], command: 'same'),
      ]);
      expect(results.first, results.last);
      expect((await service.getRoom(room.id)).games.single.turns.length, 1);
    },
  );
  test(
    'stale revision, wrong actor/game and reused operation ID publish nothing',
    () async {
      final before = room;
      await expectLater(
        pot([1], revision: -1),
        throwsA(isA<StaleRevisionFailure>()),
      );
      await expectLater(
        pot([1], actor: 'B'),
        throwsA(isA<ScoreEngineFailure>()),
      );
      await expectLater(
        pot([1], gameId: 'missing'),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      await expectLater(
        pot([1], command: 'create'),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      expect(await service.getRoom(room.id), before);
    },
  );
  test(
    'undo restores TH2 order/current/payer/balls and keeps undone audit',
    () async {
      await pot([]); // A misses; B shoots, A pays.
      final before = room;
      await pot([], foul: FoulClassification.th2);
      expect(room.playerOrder, ['B', 'A', 'C', 'D']);
      await undo(command: 'undo-th2');
      expect(room.playerOrder, before.playerOrder);
      expect(room.games.single.currentPlayerId, 'B');
      expect(room.games.single.payerId, 'A');
      expect(room.games.single.turns.last.isUndone, isTrue);
      final receipt = room;
      await undo(command: 'undo-th2');
      expect(room, receipt);
      await undo();
      expect(room.games.single.turns.every((t) => t.isUndone), isTrue);
      await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
    },
  );
  test(
    'undo scores/balls/chain then new turn leaves old record undone',
    () async {
      final before = room;
      await pot([1, 2]);
      await undo();
      expect(room.scores, before.scores);
      expect(
        room.games.single.remainingBalls,
        before.games.single.remainingBalls,
      );
      expect(room.games.single.chainState, before.games.single.chainState);
      await pot([1]);
      expect(room.games.single.turns.length, 2);
      expect(room.games.single.turns.first.isUndone, isTrue);
      expect(room.games.single.turns.last.turnNumber, 2);
    },
  );
  test('winning turn requires confirmation to undo; next game prevents undo old game', () async {
    await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    final gameId = room.currentGameId!;
    expect(room.games.single.status, GameStatus.finished);
    await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
    await undo(confirm: true);
    expect(room.games.single.status, GameStatus.inProgress);
    expect(room.games.single.winnerId, isNull);
    await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    final scores = room.scores;
    await next();
    expect(room.scores, scores);
    await expectLater(
      undo(confirm: true, gameId: gameId),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  test('undo save failure restores nothing and retry succeeds', () async {
    await pot([1]);
    final before = room;
    repo.failNextWrite();
    await expectLater(undo(command: 'u'), throwsA(isA<PersistenceFailure>()));
    expect(await service.getRoom(room.id), before);
    await undo(command: 'u');
    expect(room.scores.values.every((v) => v == 0), isTrue);
  });
  test(
    'threshold stays pending after score falls; closes at full final score',
    () async {
      await limits(const EndConditions(scoreThreshold: 30));
      await pot([1]); // A +30, pending.
      expect(room.pendingEndReasons, {PendingEndReason.scoreThreshold});
      await pot([2], foul: FoulClassification.potAndFoul); // A 0, others 0.
      expect(room.scores['A'], 0);
      expect(room.pendingEndReasons, {PendingEndReason.scoreThreshold});
      await pot([3, 4, 5, 6, 7, 8, 9]);
      expect(room.status, RoomStatus.finished);
      expect(room.scores['B'], 70); // Full score, not clamped at 30.
      expect(
        room.games.single.turns.last.afterSnapshot.roomStatus,
        RoomStatus.finished,
      );
      await expectLater(
        undo(confirm: true),
        throwsA(isA<RepositoryValidationFailure>()),
      );
    },
  );
  test(
    'undo threshold clears pending; undo cannot roll back expired clock',
    () async {
      await limits(
        const EndConditions(scoreThreshold: 30, durationSeconds: 60),
      );
      await pot([1]);
      await undo();
      expect(room.pendingEndReasons, isEmpty);
      await pot([1]);
      now = start.add(const Duration(seconds: 60));
      await undo();
      expect(room.pendingEndReasons, {PendingEndReason.timeLimit});
      expect(room.scores['A'], 0);
      await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
      expect(room.status, RoomStatus.finished);
    },
  );
  test('load/resume evaluation keeps expired unfinished game; closes between games', () async {
    await limits(const EndConditions(durationSeconds: 60));
    now = start.add(const Duration(seconds: 60));
    room = await service.evaluateEndConditions(
      commandId: 'timer',
      roomId: room.id,
      expectedRevision: room.revision,
    );
    expect(room.status, RoomStatus.active);
    expect(room.games.single.status, GameStatus.inProgress);
    expect(room.pendingEndReasons, {PendingEndReason.timeLimit});
    final evaluated = room;
    expect(
      await service.evaluateEndConditions(
        commandId: 'timer',
        roomId: room.id,
        expectedRevision: -1,
      ),
      evaluated,
    );
  });
  test(
    'timer after completed game closes on evaluation, cannot reopen with undo',
    () async {
      await limits(const EndConditions(durationSeconds: 60));
      await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
      now = start.add(const Duration(seconds: 60));
      await expectLater(
        undo(confirm: true),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      room = await service.evaluateEndConditions(
        commandId: 'timer',
        roomId: room.id,
        expectedRevision: room.revision,
      );
      expect(room.status, RoomStatus.finished);
    },
  );
  for (final cancel in [false, true]) {
    test(
      'manual ${cancel ? 'cancel' : 'finish'} requires confirmation and preserves ledger',
      () async {
        await pot([1]);
        final before = room;
        Future<Room> close(bool confirmed) => cancel
            ? service.cancelRoom(
                commandId: 'close',
                roomId: room.id,
                expectedRevision: room.revision,
                confirmed: confirmed,
              )
            : service.finishRoom(
                commandId: 'close',
                roomId: room.id,
                expectedRevision: room.revision,
                confirmed: confirmed,
              );
        await expectLater(
          close(false),
          throwsA(isA<RepositoryValidationFailure>()),
        );
        repo.failNextWrite();
        await expectLater(close(true), throwsA(isA<PersistenceFailure>()));
        expect(await service.getRoom(room.id), before);
        room = await close(true);
        expect(
          room.status,
          cancel ? RoomStatus.cancelled : RoomStatus.finished,
        );
        expect(
          room.games.single.status,
          cancel ? GameStatus.cancelled : GameStatus.incomplete,
        );
        expect(room.scores, before.scores);
        expect(room.games.single.turns, before.games.single.turns);
        expect(await close(true), room);
        await expectLater(
          pot([2]),
          throwsA(isA<RepositoryValidationFailure>()),
        );
        await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
      },
    );
  }
  test(
    'rule edit versions immutable, blocks old undo; new turn uses new config',
    () async {
      await pot([1]);
      final oldTurn = room.games.single.turns.single;
      final oldRules = room.ruleVersions.single;
      room = await service.updateRules(
        commandId: 'rules',
        roomId: room.id,
        expectedRevision: room.revision,
        ballPoints: {
          ...points,
          2: const BallPointConfig(enabled: true, points: 25),
        },
      );
      expect(room.currentRuleVersion, 2);
      expect(room.ruleVersions.first, oldRules);
      expect(room.games.single.turns.single, oldTurn);
      expect(room.events.single.beforeRules, oldRules);
      expect(room.events.single.afterRules, room.ruleVersions.last);
      await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
      await pot([2]);
      expect(room.games.single.turns.last.ruleVersion, 2);
      expect(room.scores['A'], 105);
      await undo();
      expect(room.scores['A'], 30);
      await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
      expect(Room.fromJson(room.toJson()), room);
    },
  );
  test('reorder keeps current/payer and uses new cycle; edit barrier uses revision not clock', () async {
    await pot([1]);
    room = await service.reorderPlayers(
      commandId: 'order',
      roomId: room.id,
      expectedRevision: room.revision,
      playerOrder: ['A', 'D', 'C', 'B'],
    );
    expect(room.games.single.currentPlayerId, 'A');
    expect(room.games.single.payerId, 'B');
    await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
    await pot([]);
    expect(room.games.single.currentPlayerId, 'D');
    await undo();
    expect(room.playerOrder, ['A', 'D', 'C', 'B']);
  });
  test(
    'add player appends zero score, preserves chain, joins village payments',
    () async {
      await pot([1]);
      final chain = room.games.single.chainState;
      room = await service.addPlayer(
        commandId: 'add',
        roomId: room.id,
        expectedRevision: room.revision,
        participantId: 'E',
        name: ' E ',
      );
      expect(room.participants.last.displayName, 'E');
      expect(room.activePlayerIds, ['A', 'B', 'C', 'D', 'E']);
      expect(room.scores['E'], 0);
      expect(room.games.single.chainState, chain);
      await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
      await pot([2]);
      expect(room.scores['E'], -10);
    },
  );
  test(
    'invalid edits and save failure leave no event or changed rules',
    () async {
      final before = room;
      await expectLater(
        service.addPlayer(
          commandId: 'duplicate',
          roomId: room.id,
          expectedRevision: 0,
          participantId: 'E',
          name: ' a ',
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      await expectLater(
        remove('A'),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      await expectLater(
        service.updateRules(
          commandId: 'bad',
          roomId: room.id,
          expectedRevision: 0,
          ballPoints: {},
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      await expectLater(
        service.reorderPlayers(
          commandId: 'bad-order',
          roomId: room.id,
          expectedRevision: 0,
          playerOrder: ['A', 'B'],
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      repo.failNextWrite();
      await expectLater(
        service.updateRules(
          commandId: 'fail',
          roomId: room.id,
          expectedRevision: 0,
          ballPoints: points,
        ),
        throwsA(isA<PersistenceFailure>()),
      );
      expect(await service.getRoom(room.id), before);
      expect(await repo.getCommandReceipt('fail'), isNull);
    },
  );
  test('removed winner and payer require explicit distinct replacements; history unchanged', () async {
    await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    final finished = room.games.single;
    final ledger = room.scores;
    await remove('A');
    await remove('B');
    expect(room.activePlayerIds, ['C', 'D']);
    expect(room.games.single, finished);
    expect(room.scores, ledger);
    expect(room.participants.first.leftAt, now);
    await expectLater(next(), throwsA(isA<RepositoryValidationFailure>()));
    await expectLater(
      next(starter: 'C', payer: 'C'),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await expectLater(
      next(starter: 'A', payer: 'D'),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await next(starter: 'D', payer: 'C');
    expect(room.games.last.currentPlayerId, 'D');
    expect(room.games.last.payerId, 'C');
    expect(room.playerOrder, ['D', 'C']);
    expect(room.games.first, finished);
    expect(room.scores, ledger);
    await pot([1]);
    expect(room.scores['A'], ledger['A']);
    expect(room.scores.values.reduce((a, b) => a + b), 0);
  });
  test(
    'normal next-game order uses remaining room cycle and replacement payer',
    () async {
      await pot([]); // B takes over, A pays.
      await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]); // B wins, A pays.
      final history = room.games.single;
      await remove('A');
      await expectLater(next(), throwsA(isA<RepositoryValidationFailure>()));
      await next(payer: 'D');
      expect(room.playerOrder, ['B', 'D', 'C']);
      expect(room.games.first, history);
    },
  );
  test('minimum roster, sixth player and arbitrary replacement of present roles reject', () async {
    room = await service.addPlayer(
      commandId: 'add',
      roomId: room.id,
      expectedRevision: room.revision,
      participantId: 'E',
      name: 'E',
    );
    await expectLater(
      service.addPlayer(
        commandId: 'six',
        roomId: room.id,
        expectedRevision: room.revision,
        participantId: 'F',
        name: 'F',
      ),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    await expectLater(
      next(starter: 'C'),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await remove('C');
    await remove('D');
    await remove('E');
    await expectLater(remove('A'), throwsA(isA<RepositoryValidationFailure>()));
  });
  test(
    'different concurrent commands at same revision cannot both commit',
    () async {
      final revision = room.revision;
      final gameId = room.currentGameId!;
      Future<Object> attempt(String id) async {
        try {
          return await service.recordTurn(
            commandId: id,
            roomId: room.id,
            expectedRevision: revision,
            gameId: gameId,
            input: TurnInput(turnId: id, actorId: 'A', balls: [1]),
          );
        } catch (error) {
          return error;
        }
      }

      final results = await Future.wait([attempt('one'), attempt('two')]);
      expect(results.whereType<Room>().length, 1);
      expect(results.whereType<StaleRevisionFailure>().length, 1);
      expect((await service.getRoom(room.id)).games.single.turns.length, 1);
    },
  );
  test('undo after edit keeps earlier threshold hit pending', () async {
    await limits(const EndConditions(scoreThreshold: 30));
    await pot([1]);
    room = await service.reorderPlayers(
      commandId: 'barrier',
      roomId: room.id,
      expectedRevision: room.revision,
      playerOrder: ['A', 'D', 'C', 'B'],
    );
    await pot([2], foul: FoulClassification.potAndFoul);
    await undo();
    expect(room.pendingEndReasons, {PendingEndReason.scoreThreshold});
    await expectLater(undo(), throwsA(isA<RepositoryValidationFailure>()));
  });
  test(
    'edits between games preserve outcome order and block reopening old turn',
    () async {
      await pot([1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final outcome = room.games.single;
      room = await service.reorderPlayers(
        commandId: 'between',
        roomId: room.id,
        expectedRevision: room.revision,
        playerOrder: ['A', 'D', 'C', 'B'],
      );
      expect(room.games.single, outcome);
      await expectLater(
        undo(confirm: true),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      await next();
      expect(room.playerOrder, ['A', 'D', 'C', 'B']);
      expect(room.games.first, outcome);
    },
  );
  test(
    'edit retries return original commit and event is not duplicated',
    () async {
      room = await service.addPlayer(
        commandId: 'add',
        roomId: room.id,
        expectedRevision: room.revision,
        participantId: 'E',
        name: 'E',
      );
      final committed = room;
      await pot([1]);
      final latest = room;
      final retry = await service.addPlayer(
        commandId: 'add',
        roomId: room.id,
        expectedRevision: -1,
        participantId: 'E',
        name: 'E',
      );
      expect(retry, committed);
      expect(await service.getRoom(room.id), latest);
      expect(latest.events.length, 1);
    },
  );
  test(
    'closed rooms reject edits and end reevaluation without mutation',
    () async {
      room = await service.finishRoom(
        commandId: 'close',
        roomId: room.id,
        expectedRevision: room.revision,
        confirmed: true,
      );
      final closed = room;
      await expectLater(
        service.addPlayer(
          commandId: 'add',
          roomId: room.id,
          expectedRevision: room.revision,
          participantId: 'E',
          name: 'E',
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      await expectLater(
        service.evaluateEndConditions(
          commandId: 'timer',
          roomId: room.id,
          expectedRevision: room.revision,
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      expect(await service.getRoom(room.id), closed);
    },
  );
  test(
    'duplicate turn ID with new command rejects without another write',
    () async {
      await pot([1], command: 'first');
      final before = room;
      await expectLater(
        service.recordTurn(
          commandId: 'second',
          roomId: room.id,
          expectedRevision: room.revision,
          gameId: room.currentGameId!,
          input: TurnInput(turnId: 'shot:first', actorId: 'A', balls: [2]),
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      expect(await service.getRoom(room.id), before);
      expect(await repo.getCommandReceipt('second'), isNull);
    },
  );
  test(
    'timer evaluation save failure leaves aggregate and receipt unchanged',
    () async {
      await limits(const EndConditions(durationSeconds: 1));
      now = start.add(const Duration(seconds: 1));
      final before = room;
      repo.failNextWrite();
      await expectLater(
        service.evaluateEndConditions(
          commandId: 'timer',
          roomId: room.id,
          expectedRevision: room.revision,
        ),
        throwsA(isA<PersistenceFailure>()),
      );
      expect(await service.getRoom(room.id), before);
      expect(await repo.getCommandReceipt('timer'), isNull);
      room = await service.evaluateEndConditions(
        commandId: 'timer',
        roomId: room.id,
        expectedRevision: room.revision,
      );
      expect(room.pendingEndReasons, {PendingEndReason.timeLimit});
    },
  );
  test('old JSON without new fields remains readable', () async {
    final json = room.toJson()..remove('events');
    expect(Room.fromJson(json).events, isEmpty);
    await pot([1]);
    final turn = room.games.single.turns.single.toJson()..remove('revision');
    final legacy = Room.fromJson({
      ...room.toJson(),
      'games': [
        {
          ...room.games.single.toJson(),
          'turns': [turn],
        },
      ],
    });
    expect(legacy.games.single.turns.single.revision, 0);
  });
}
