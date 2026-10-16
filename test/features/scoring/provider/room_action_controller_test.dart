import 'dart:async';

import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_commands.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/features/scoring/provider/next_game_controller.dart';
import 'package:bidart/features/scoring/provider/room_action_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class GatedRepository extends InMemoryGameRepository {
  Completer<void>? gate;
  final commands = <String>[];
  @override
  Future<CommandReceipt> updateRoom({
    required String commandId,
    required int expectedRevision,
    required Room room,
    RoomCommandType type = RoomCommandType.update,
  }) async {
    commands.add(commandId);
    await gate?.future;
    return super.updateRoom(
      commandId: commandId,
      expectedRevision: expectedRevision,
      room: room,
      type: type,
    );
  }
}

void main() {
  late ProviderContainer container;
  late GatedRepository repo;
  late Room room;
  final now = DateTime.utc(2026, 10, 15);
  setUp(() async {
    repo = GatedRepository();
    var ids = 0;
    container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(repo),
        clockProvider.overrideWithValue(() => now),
        idFactoryProvider.overrideWithValue(() => 'id-${++ids}'),
      ],
    );
    final service = container.read(roomServiceProvider);
    final id = await service.createRoom(
      commandId: 'create',
      name: 'Table',
      ownerId: 'owner',
      participants: [
        for (final id in ['A', 'B', 'C'])
          PlayerInGame(id: id, displayName: id, joinedAt: now),
      ],
      playerOrder: ['A', 'B', 'C'],
      starterId: 'A',
      payerId: 'B',
      ballPoints: {
        for (var b = 1; b <= 9; b++)
          b: const BallPointConfig(enabled: true, points: 10),
      },
    );
    room = await service.getRoom(id);
  });
  tearDown(() => container.dispose());
  RoomAction record([List<int> balls = const [1]]) => RoomAction(
    RoomActionKind.record,
    gameId: room.currentGameId,
    actorId: 'A',
    balls: balls,
  );

  test(
    'double submit shares future; state/read caches change only after commit',
    () async {
      final sub = container.listen(roomByIdProvider(room.id), (_, _) {});
      final list = container.listen(roomListProvider(null), (_, _) {});
      addTearDown(sub.close);
      addTearDown(list.close);
      await container.read(roomByIdProvider(room.id).future);
      await container.read(roomListProvider(null).future);
      repo.gate = Completer<void>();
      final controller = container.read(
        roomActionControllerProvider(room.id).notifier,
      );
      final first = controller.submit(record(), expectedRevision: 0);
      expect(
        identical(first, controller.submit(record(), expectedRevision: 0)),
        isTrue,
      );
      expect(
        container.read(roomActionControllerProvider(room.id)).isLoading,
        isTrue,
      );
      await pumpEventQueue();
      expect((await repo.getRoom(room.id)).revision, 0);
      expect(
        container.read(roomByIdProvider(room.id)).requireValue.revision,
        0,
      );
      repo.gate!.complete();
      final result = (await first)!;
      expect(result.revision, 1);
      expect((await container.read(roomByIdProvider(room.id).future)), result);
      expect(
        (await container.read(roomListProvider(null).future)).single.id,
        room.id,
      );
      expect(repo.commands.length, 1);
    },
  );
  test(
    'failed command retains ID and intent for retry including add-player ID',
    () async {
      final controller = container.read(
        roomActionControllerProvider(room.id).notifier,
      );
      repo.failNextWrite();
      final action = RoomAction(
        RoomActionKind.add,
        participantId: 'D',
        name: 'D',
      );
      expect(await controller.submit(action, expectedRevision: 0), isNull);
      expect(
        container.read(roomActionControllerProvider(room.id)).hasError,
        isTrue,
      );
      expect((await repo.getRoom(room.id)).events, isEmpty);
      expect((await controller.retry())!.activePlayerIds, ['A', 'B', 'C', 'D']);
      expect(repo.commands[0], repo.commands[1]);
      expect((await repo.getRoom(room.id)).events.length, 1);
    },
  );
  test('changed draft or revision gets new command ID', () async {
    final controller = container.read(
      roomActionControllerProvider(room.id).notifier,
    );
    repo.failNextWrite();
    await controller.submit(record(), expectedRevision: 0);
    repo.failNextWrite();
    await controller.submit(record([2]), expectedRevision: 0);
    expect(repo.commands.toSet().length, 2);
    final committed = (await controller.retry())!;
    await controller.submit(record([2]), expectedRevision: committed.revision);
    expect(repo.commands.last, isNot(repo.commands.first));
    expect(repo.commands.toSet().length, 3);
  });
  test(
    'same ID retry returns original committed result without second turn',
    () async {
      final controller = container.read(
        roomActionControllerProvider(room.id).notifier,
      );
      final result = await controller.submit(record(), expectedRevision: 0);
      expect(await controller.retry(), result);
      expect((await repo.getRoom(room.id)).games.single.turns.length, 1);
    },
  );
  test('shared queue orders action and next-game controllers', () async {
    final service = container.read(roomServiceProvider);
    room = await service.recordTurn(
      commandId: 'win',
      roomId: room.id,
      expectedRevision: 0,
      gameId: room.currentGameId!,
      input: recordAll(room),
    );
    repo.commands.clear();
    repo.gate = Completer<void>();
    final actions = container.read(
      roomActionControllerProvider(room.id).notifier,
    );
    final next = container.read(nextGameControllerProvider(room.id).notifier);
    final edit = actions.submit(
      RoomAction(RoomActionKind.order, order: ['A', 'C', 'B']),
      expectedRevision: 1,
    );
    final begin = next.submit(expectedRevision: 2);
    await pumpEventQueue();
    expect(repo.commands.length, 1);
    repo.gate!.complete();
    expect(await edit, isNotNull);
    expect((await begin)!.games.length, 2);
    expect(repo.commands.length, 2);
  });
  test(
    'next-game replacement changes ID and failed retry preserves choices',
    () async {
      final service = container.read(roomServiceProvider);
      room = await service.recordTurn(
        commandId: 'win',
        roomId: room.id,
        expectedRevision: 0,
        gameId: room.currentGameId!,
        input: recordAll(room),
      );
      room = await service.removePlayer(
        commandId: 'remove',
        roomId: room.id,
        expectedRevision: room.revision,
        participantId: 'A',
      );
      repo.commands.clear();
      final next = container.read(nextGameControllerProvider(room.id).notifier);
      expect(
        await next.submit(
          expectedRevision: room.revision,
          replacementStarterId: 'B',
        ),
        isNull,
      ); // same as payer.
      repo.failNextWrite();
      expect(
        await next.submit(
          expectedRevision: room.revision,
          replacementStarterId: 'C',
        ),
        isNull,
      );
      final result = (await next.retry())!;
      expect(result.games.last.currentPlayerId, 'C');
      expect(result.games.last.payerId, 'B');
      expect(repo.commands.first, repo.commands.last);
    },
  );
  test('signature detaches mutable collections and sorts balls', () {
    final balls = [2, 1];
    final order = ['A', 'B'];
    final action = RoomAction(
      RoomActionKind.record,
      balls: balls,
      order: order,
    );
    final signature = action.signature;
    balls.clear();
    order.clear();
    expect(action.signature, signature);
    expect(action.balls, [1, 2]);
    expect(() => action.balls.add(3), throwsUnsupportedError);
  });
  test('undo and lifecycle commands use typed intents', () async {
    final controller = container.read(
      roomActionControllerProvider(room.id).notifier,
    );
    final first = (await controller.submit(record(), expectedRevision: 0))!;
    final undone = (await controller.submit(
      RoomAction(RoomActionKind.undo, gameId: first.currentGameId),
      expectedRevision: first.revision,
    ))!;
    expect(undone.games.single.turns.single.isUndone, isTrue);
    final evaluated = (await controller.submit(
      RoomAction(RoomActionKind.evaluate),
      expectedRevision: undone.revision,
    ))!;
    final closed = await controller.submit(
      RoomAction(RoomActionKind.finish, confirmed: true),
      expectedRevision: evaluated.revision,
    );
    expect(closed, isNotNull);
  });
}

TurnInput recordAll(Room room) => TurnInput(
  turnId: 'win',
  actorId: room.games.last.currentPlayerId,
  balls: [1, 2, 3, 4, 5, 6, 7, 8, 9],
);
