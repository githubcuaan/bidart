import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/chain_state.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 10, 14);
  late InMemoryGameRepository repository;
  late RoomService service;
  late int idCalls;
  late int clockCalls;
  late List<PlayerInGame> players;
  late Map<int, BallPointConfig> balls;

  setUp(() {
    repository = InMemoryGameRepository();
    idCalls = 0;
    clockCalls = 0;
    service = RoomService(
      repository: repository,
      idFactory: () => 'id-${++idCalls}',
      clock: () {
        clockCalls++;
        return now;
      },
    );
    players = [
      PlayerInGame(id: 'a', displayName: ' An ', joinedAt: now),
      PlayerInGame(id: 'b', displayName: 'Binh', joinedAt: now),
    ];
    balls = {
      for (var ball = 1; ball <= 9; ball++)
        ball: BallPointConfig(enabled: ball != 2, points: ball == 2 ? 0 : ball),
    };
  });

  Future<String> create({
    String commandId = 'create-1',
    List<PlayerInGame>? participants,
    List<String>? order,
    String payerId = 'b',
    EndConditions endConditions = const EndConditions(),
  }) => service.createRoom(
    commandId: commandId,
    name: ' Table 1 ',
    ownerId: 'local-owner',
    participants: participants ?? players,
    playerOrder: order ?? ['b', 'a'],
    starterId: 'a',
    payerId: payerId,
    ballPoints: balls,
    endConditions: endConditions,
  );

  test(
    'initializes one local room and first game with normalized stable IDs',
    () async {
      const limits = EndConditions(durationSeconds: 600, scoreThreshold: 100);
      final id = await create(endConditions: limits);
      final room = await repository.getRoom(id);
      expect(id, 'id-1');
      expect(room.name, 'Table 1');
      expect(room.ownerId, 'local-owner');
      expect(room.mode, RoomMode.local);
      expect(room.status, RoomStatus.active);
      expect(room.revision, 0);
      expect(room.createdAt, now);
      expect(room.endedAt, isNull);
      expect(room.participants.map((p) => p.id), ['a', 'b']);
      expect(room.participants.first.displayName, 'An');
      expect(players.first.displayName, ' An ');
      expect(room.activePlayerIds, ['a', 'b']);
      expect(room.playerOrder, ['b', 'a']);
      expect(room.scores, {'a': 0, 'b': 0});
      expect(room.scores.values.reduce((a, b) => a + b), 0);
      expect(room.ruleVersions.single.id, 'id-3');
      expect(room.ruleVersions.single.version, 1);
      expect(room.ruleVersions.single.ballPoints, balls);
      expect(room.currentRuleVersion, 1);
      expect(room.endConditions, limits);
      expect(room.pendingEndReasons, isEmpty);
      final game = room.games.single;
      expect(room.currentGameId, game.id);
      expect(game.id, 'id-2');
      expect(game.roomId, id);
      expect(game.gameNumber, 1);
      expect(game.status, GameStatus.inProgress);
      expect(game.startedAt, now);
      expect(game.currentPlayerId, 'a');
      expect(game.payerId, 'b');
      expect(game.playerOrder, room.playerOrder);
      expect(game.remainingBalls, {1, 2, 3, 4, 5, 6, 7, 8, 9});
      expect(
        game.chainState,
        const ChainState(isBreakChain: true, hasLegalPotInChain: false),
      );
      expect(game.previousPlayerId, isNull);
      expect(game.winnerId, isNull);
      expect(game.finalPayerId, isNull);
      expect(game.endedAt, isNull);
      expect(game.isBreakClear, isFalse);
      expect(game.turns, isEmpty);
      expect(idCalls, 3);
      expect(clockCalls, 1);
      expect((await repository.getCommandReceipt('create-1'))!.room, room);
    },
  );

  test('validation fails before allocating IDs, clock or storage', () async {
    await expectLater(
      create(payerId: 'a'),
      throwsA(
        isA<RepositoryValidationFailure>().having(
          (e) => e.issues,
          'issues',
          isNotEmpty,
        ),
      ),
    );
    expect(idCalls, 0);
    expect(clockCalls, 0);
    expect(await repository.listRooms(), isEmpty);
    expect(await repository.getCommandReceipt('create-1'), isNull);
  });

  test(
    'rejects duplicate normalized names, malformed rules and end limits',
    () async {
      await expectLater(
        create(
          participants: [
            players.first,
            players.last.copyWith(displayName: 'an'),
          ],
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      balls.remove(9);
      await expectLater(create(), throwsA(isA<RepositoryValidationFailure>()));
      balls[9] = const BallPointConfig(enabled: true, points: 9);
      await expectLater(
        create(endConditions: const EndConditions(durationSeconds: 0)),
        throwsA(isA<RepositoryValidationFailure>()),
      );
      expect(idCalls, 0);
      expect(await repository.listRooms(), isEmpty);
    },
  );

  test(
    'active room rejection keeps the original room and no new receipt',
    () async {
      final id = await create();
      final original = await repository.getRoom(id);
      await expectLater(
        create(commandId: 'create-2'),
        throwsA(
          isA<ActiveRoomExistsFailure>().having((e) => e.roomId, 'roomId', id),
        ),
      );
      expect(await repository.listRooms(), [original]);
      expect(await repository.getCommandReceipt('create-2'), isNull);
    },
  );

  test(
    'failed save commits nothing; same command can retry successfully',
    () async {
      repository.failNextWrite();
      await expectLater(create(), throwsA(isA<PersistenceFailure>()));
      expect(await repository.listRooms(), isEmpty);
      expect(await repository.getCommandReceipt('create-1'), isNull);
      final id = await create();
      expect((await repository.listRooms()).single.id, id);
    },
  );

  test(
    'committed retry precedes validation and does not allocate IDs',
    () async {
      final id = await create();
      expect(await create(payerId: 'a'), id);
      expect(idCalls, 3);
      expect(clockCalls, 1);
      expect(await repository.listRooms(), hasLength(1));
    },
  );

  test('concurrent duplicate submits return one committed room', () async {
    final ids = await Future.wait([create(), create()]);
    expect(ids[0], ids[1]);
    expect(idCalls, 3);
    expect(await repository.listRooms(), hasLength(1));
  });

  test(
    'independent service instances resolve concurrent committed retry',
    () async {
      final other = RoomService(
        repository: repository,
        idFactory: () => 'other-${++idCalls}',
        clock: () => now,
      );
      final ids = await Future.wait([
        create(),
        other.createRoom(
          commandId: 'create-1',
          name: 'Table',
          ownerId: 'owner',
          participants: players,
          playerOrder: ['a', 'b'],
          starterId: 'a',
          payerId: 'b',
          ballPoints: balls,
        ),
      ]);
      expect(ids[0], ids[1]);
      expect(await repository.listRooms(), hasLength(1));
    },
  );

  test(
    'captures draft collections before asynchronous receipt lookup',
    () async {
      final order = ['b', 'a'];
      final pending = create(order: order);
      players.clear();
      order.clear();
      balls.clear();
      final room = await repository.getRoom(await pending);
      expect(room.participants, hasLength(2));
      expect(room.playerOrder, ['b', 'a']);
      expect(room.ruleVersions.single.ballPoints, hasLength(9));
    },
  );

  test('five-player roster keeps identity and caller-selected order', () async {
    players.addAll([
      for (final id in ['c', 'd', 'e'])
        PlayerInGame(id: id, displayName: id, joinedAt: now),
    ]);
    final id = await create(order: ['c', 'b', 'd', 'e', 'a']);
    final room = await repository.getRoom(id);
    expect(room.scores, {'a': 0, 'b': 0, 'c': 0, 'd': 0, 'e': 0});
    expect(room.playerOrder, ['c', 'b', 'd', 'e', 'a']);
    expect(room.games.single.playerOrder, room.playerOrder);
  });

  test('distinct concurrent commands cannot create two active rooms', () async {
    final outcomes = await Future.wait([
      for (final command in ['create-1', 'create-2'])
        create(commandId: command)
            .then<Object>((id) => id, onError: (Object error) => error),
    ]);
    expect(outcomes.whereType<String>(), hasLength(1));
    expect(outcomes.whereType<ActiveRoomExistsFailure>(), hasLength(1));
    expect(await repository.listRooms(), hasLength(1));
  });

  test('command belonging to an update cannot be used to create', () async {
    final id = await create();
    final room = await repository.getRoom(id);
    await repository.updateRoom(
      commandId: 'update-1',
      expectedRevision: 0,
      room: room.copyWith(revision: 1),
    );
    await expectLater(
      create(commandId: 'update-1'),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    expect(idCalls, 3);
  });
}
