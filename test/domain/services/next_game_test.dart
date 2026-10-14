import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/turn.dart';
import 'package:bidart/domain/models/scoring/turn_state_snapshot.dart';
import 'package:bidart/domain/models/scoring/pending_end_reason.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 10, 14);
  late InMemoryGameRepository repository;
  late RoomService service;
  late Room room;
  setUp(() async {
    repository = InMemoryGameRepository();
    var ids = 0;
    service = RoomService(
      repository: repository,
      idFactory: () => 'id-${++ids}',
      clock: () => now,
    );
    final id = await service.createRoom(
      commandId: 'create',
      name: 'Table',
      ownerId: 'owner',
      participants: [
        for (final id in ['A', 'B', 'C', 'D', 'E'])
          PlayerInGame(id: id, displayName: id, joinedAt: now),
      ],
      playerOrder: ['A', 'B', 'C', 'D', 'E'],
      starterId: 'A',
      payerId: 'B',
      ballPoints: {
        for (var i = 1; i <= 9; i++)
          i: BallPointConfig(enabled: true, points: i),
      },
    );
    room = await service.getRoom(id);
    room = room.copyWith(
      revision: 1,
      games: [
        room.games.single.copyWith(
          status: GameStatus.finished,
          endedAt: now,
          winnerId: 'C',
          finalPayerId: 'B',
          remainingBalls: {},
        ),
      ],
      scores: {'A': -20, 'B': -10, 'C': 30, 'D': 0, 'E': 0},
    );
    await repository.updateRoom(
      commandId: 'finish',
      expectedRevision: 0,
      room: room,
    );
  });

  Future<Room> start({String command = 'next', int revision = 1}) =>
      service.startNextGame(
        commandId: command,
        roomId: room.id,
        expectedRevision: revision,
      );
  Future<void> edit(Room candidate) async {
    room = candidate.copyWith(revision: room.revision + 1);
    await repository.updateRoom(
      commandId: 'edit',
      expectedRevision: room.revision - 1,
      room: room,
    );
  }

  test('reads summaries, filters and explicit not-found', () async {
    final summaries = await service.listRooms(status: RoomStatus.active);
    expect(summaries.single.id, room.id);
    expect(summaries.single.activePlayerCount, 5);
    expect(summaries.single.gameCount, 1);
    expect(await service.listRooms(status: RoomStatus.finished), isEmpty);
    expect(
      () => service.getRoom('missing'),
      throwsA(isA<RoomNotFoundFailure>()),
    );
  });
  test(
    'next game initializes setup and preserves scores/history/rules',
    () async {
      final result = await start();
      expect(result.revision, 2);
      expect(result.games.length, 2);
      expect(result.games.first, room.games.first);
      expect(result.scores, room.scores);
      expect(result.ruleVersions, room.ruleVersions);
      expect(result.playerOrder, ['C', 'B', 'D', 'E', 'A']);
      final game = result.games.last;
      expect(game.gameNumber, 2);
      expect(game.currentPlayerId, 'C');
      expect(game.payerId, 'B');
      expect(game.status, GameStatus.inProgress);
      expect(game.remainingBalls, {1, 2, 3, 4, 5, 6, 7, 8, 9});
      expect(game.chainState.isBreakChain, isTrue);
      expect(game.turns, isEmpty);
      expect(await start(revision: -1), result);
    },
  );
  test('concurrent retry commits once', () async {
    final results = await Future.wait([start(), start()]);
    expect(results.first, results.last);
    expect((await service.getRoom(room.id)).games.length, 2);
  });
  test('break-clear preserves order', () async {
    await edit(
      room.copyWith(
        games: [room.games.single.copyWith(isBreakClear: true, winnerId: 'A')],
      ),
    );
    expect((await start(revision: 2)).playerOrder, room.playerOrder);
  });
  test('stale revision rejected', () async {
    expect(() => start(revision: 0), throwsA(isA<StaleRevisionFailure>()));
  });
  test('active game rejected', () async {
    await start();
    expect(
      () => start(command: 'another', revision: 2),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  test('closed room rejected', () async {
    await edit(room.copyWith(status: RoomStatus.finished));
    expect(
      () => start(revision: 2),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  test('timer boundary rejected', () async {
    await edit(
      room.copyWith(
        createdAt: now.subtract(const Duration(seconds: 60)),
        endConditions: const EndConditions(durationSeconds: 60),
      ),
    );
    expect(
      () => start(revision: 2),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  test('score threshold rejected', () async {
    await edit(
      room.copyWith(endConditions: const EndConditions(scoreThreshold: 30)),
    );
    expect(
      () => start(revision: 2),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  test('pending-end rejected', () async {
    await edit(
      room.copyWith(pendingEndReasons: {PendingEndReason.values.first}),
    );
    expect(
      () => start(revision: 2),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  for (final undone in [false, true]) {
    test('historical threshold respects undone=$undone', () async {
      final game = room.games.single;
      final snapshot = TurnStateSnapshot(
        roomId: room.id,
        gameId: game.id,
        scores: {'A': -110, 'B': 0, 'C': 110, 'D': 0, 'E': 0},
        activePlayerIds: room.activePlayerIds,
        playerOrder: room.playerOrder,
        currentPlayerId: 'C',
        payerId: 'B',
        chainState: game.chainState,
        remainingBalls: {},
        roomStatus: room.status,
        gameStatus: game.status,
        roomCreatedAt: now,
        gameStartedAt: now,
        isBreakClear: false,
        pendingEndReasons: {},
      );
      final turn = Turn(
        id: 'turn',
        commandId: 'turn-command',
        roomId: room.id,
        gameId: game.id,
        turnNumber: 1,
        actorId: 'C',
        payerIds: ['B'],
        ruleConfigId: room.ruleVersions.single.id,
        ruleVersion: 1,
        pottedBalls: [],
        foulClassification: FoulClassification.none,
        transactions: [],
        logs: [],
        beforeSnapshot: snapshot.copyWith(scores: room.scores),
        afterSnapshot: snapshot,
        createdAt: now,
        isUndone: undone,
      );
      await edit(
        room.copyWith(
          endConditions: const EndConditions(scoreThreshold: 100),
          games: [
            game.copyWith(turns: [turn]),
          ],
        ),
      );
      if (undone) {
        expect((await start(revision: 2)).games.length, 2);
      } else {
        expect(
          () => start(revision: 2),
          throwsA(isA<RepositoryValidationFailure>()),
        );
      }
    });
  }
  test('removed payer rejected without replacement', () async {
    await edit(
      room.copyWith(
        activePlayerIds: ['A', 'C', 'D', 'E'],
        playerOrder: ['A', 'C', 'D', 'E'],
      ),
    );
    expect(
      () => start(revision: 2),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  test('missing winner and roster edits rejected', () async {
    await edit(
      room.copyWith(games: [room.games.single.copyWith(winnerId: null)]),
    );
    expect(
      () => start(revision: 2),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
  test('failure rolls back and retry succeeds', () async {
    repository.failNextWrite();
    expect(() => start(), throwsA(isA<PersistenceFailure>()));
    await pumpEventQueue();
    expect(await repository.getCommandReceipt('next'), isNull);
    expect(await service.getRoom(room.id), room);
    expect((await start()).games.length, 2);
  });
  test('command belonging to other operation rejected', () async {
    expect(
      () => start(command: 'finish'),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    expect(
      () => start(command: 'create'),
      throwsA(isA<RepositoryValidationFailure>()),
    );
  });
}
