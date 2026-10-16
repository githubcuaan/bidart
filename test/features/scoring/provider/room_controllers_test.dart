import 'dart:async';

import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/features/scoring/provider/create_room_controller.dart';
import 'package:bidart/features/scoring/provider/next_game_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class ControlledRepository extends InMemoryGameRepository {
  Completer<void>? gate;
  bool fail = false;
  final commands = <String>[];

  @override
  Future<CommandReceipt> createRoom({
    required String commandId,
    required Room room,
  }) async {
    commands.add(commandId);
    await gate?.future;
    if (fail) throw StateError('save failed');
    return super.createRoom(commandId: commandId, room: room);
  }
}

void main() {
  final now = DateTime.utc(2026, 10, 14);
  CreateRoomDraft draft({String name = 'Table'}) => CreateRoomDraft(
    name: name,
    participants: [
      PlayerInGame(id: 'a', displayName: 'A', joinedAt: now),
      PlayerInGame(id: 'b', displayName: 'B', joinedAt: now),
    ],
    playerOrder: ['a', 'b'],
    starterId: 'a',
    payerId: 'b',
    ballPoints: {
      for (var i = 1; i <= 9; i++) i: BallPointConfig(enabled: true, points: i),
    },
  );
  late ControlledRepository repository;
  late ProviderContainer container;
  setUp(() {
    repository = ControlledRepository();
    var sequence = 0;
    container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => now),
        idFactoryProvider.overrideWithValue(() => 'id-${++sequence}'),
      ],
    );
  });
  tearDown(() => container.dispose());

  test(
    'loading locks draft and double submit; success refreshes reads',
    () async {
      final subscription = container.listen(roomListProvider(null), (_, _) {});
      addTearDown(subscription.close);
      expect(await container.read(roomListProvider(null).future), isEmpty);
      repository.gate = Completer<void>();
      final controller = container.read(createRoomControllerProvider.notifier);
      controller.setDraft(draft());
      final first = controller.submit();
      expect(
        container.read(createRoomControllerProvider).result.isLoading,
        true,
      );
      expect(identical(first, controller.submit()), true);
      controller.setDraft(draft(name: 'Ignored'));
      expect(container.read(createRoomControllerProvider).draft.name, 'Table');
      expect(await repository.listRooms(), isEmpty);
      repository.gate!.complete();
      final id = await first;
      expect(
        container.read(createRoomControllerProvider).result.requireValue,
        id,
      );
      expect(
        (await container.read(roomListProvider(null).future)).single.id,
        id,
      );
      expect((await container.read(roomByIdProvider(id!).future)).id, id);
      expect(repository.commands, hasLength(1));
    },
  );

  test(
    'failed save retains draft, publishes nothing, retry keeps ID',
    () async {
      repository.fail = true;
      final controller = container.read(createRoomControllerProvider.notifier);
      final input = draft();
      controller.setDraft(input);
      expect(await controller.submit(), isNull);
      expect(
        container.read(createRoomControllerProvider).result.hasError,
        true,
      );
      expect(
        identical(container.read(createRoomControllerProvider).draft, input),
        true,
      );
      expect(await container.read(roomListProvider(null).future), isEmpty);
      controller.setDraft(draft());
      repository.fail = false;
      expect(await controller.submit(), isNotNull);
      expect(repository.commands[0], repository.commands[1]);
    },
  );

  test('changed input gets a new command ID', () async {
    repository.fail = true;
    final controller = container.read(createRoomControllerProvider.notifier);
    controller.setDraft(draft());
    await controller.submit();
    controller.setDraft(draft(name: 'Changed'));
    await controller.submit();
    expect(repository.commands[0], isNot(repository.commands[1]));
  });

  test(
    'next game commits, refreshes reads and unchanged retry is idempotent',
    () async {
      final create = container.read(createRoomControllerProvider.notifier);
      create.setDraft(draft());
      final id = (await create.submit())!;
      final room = await repository.getRoom(id);
      await repository.updateRoom(
        commandId: 'finish-fixture',
        expectedRevision: 0,
        room: room.copyWith(
          revision: 1,
          games: [
            room.games.single.copyWith(
              status: GameStatus.finished,
              winnerId: 'a',
              finalPayerId: 'b',
            ),
          ],
        ),
      );
      final list = container.listen(roomListProvider(null), (_, _) {});
      final read = container.listen(roomByIdProvider(id), (_, _) {});
      addTearDown(list.close);
      addTearDown(read.close);
      await container.read(roomByIdProvider(id).future);
      final next = container.read(nextGameControllerProvider(id).notifier);
      final committed = await next.submit(expectedRevision: 1);
      expect(committed!.games, hasLength(2));
      expect(
        container.read(nextGameControllerProvider(id)).requireValue,
        committed,
      );
      expect(await container.read(roomByIdProvider(id).future), committed);
      expect(
        (await container.read(roomListProvider(null).future)).single.id,
        id,
      );
      expect(await next.submit(expectedRevision: 1), committed);
      expect((await repository.getRoom(id)).games, hasLength(2));
    },
  );

  test('next game double submit and error do not publish candidate', () async {
    final controller = container.read(createRoomControllerProvider.notifier);
    controller.setDraft(draft());
    final id = (await controller.submit())!;
    final before = await container.read(roomByIdProvider(id).future);
    final next = container.read(nextGameControllerProvider(id).notifier);
    final pending = next.submit(expectedRevision: 0);
    expect(container.read(nextGameControllerProvider(id)).isLoading, true);
    expect(identical(pending, next.submit(expectedRevision: 0)), true);
    expect(await pending, isNull); // Current game is not finished.
    expect(container.read(nextGameControllerProvider(id)).hasError, true);
    expect(await container.read(roomByIdProvider(id).future), before);
  });

  test(
    'queue serializes same room, isolates rooms, recovers after error',
    () async {
      final queue = RoomCommandQueue();
      final gate = Completer<void>();
      final events = <String>[];
      final first = queue.run('a', () async {
        events.add('first');
        await gate.future;
        throw StateError('failed');
      });
      final failure = expectLater(first, throwsStateError);
      final second = queue.run('a', () async => events.add('second'));
      await queue.run('b', () async => events.add('independent'));
      expect(events, ['first', 'independent']);
      gate.complete();
      await failure;
      await second;
      expect(events, ['first', 'independent', 'second']);
    },
  );
}
