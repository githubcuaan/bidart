import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';

// Storage fixtures intentionally omit gameplay: business validation is service
// responsibility, while these tests exercise the atomic storage boundary.
Room fixture(String id, {RoomStatus status = RoomStatus.active}) => Room(
  id: id,
  name: id,
  ownerId: 'local-owner',
  mode: RoomMode.local,
  status: status,
  createdAt: DateTime.utc(2026, 10, 14),
  revision: 0,
  participants: [],
  activePlayerIds: [],
  playerOrder: [],
  scores: {},
  ruleVersions: [],
  currentRuleVersion: 1,
  games: [],
  endConditions: const EndConditions(),
  pendingEndReasons: {},
);

void main() {
  late InMemoryGameRepository repository;
  setUp(() => repository = InMemoryGameRepository());

  test('empty reads and explicit not-found', () async {
    expect(await repository.listRooms(), isEmpty);
    expect(await repository.getCommandReceipt('missing'), isNull);
    await expectLater(
      repository.getRoom('missing'),
      throwsA(isA<RoomNotFoundFailure>()),
    );
  });

  test('create, filter and deterministic date/ID sorting', () async {
    final b = fixture('b', status: RoomStatus.finished);
    final a = fixture('a', status: RoomStatus.cancelled);
    final c = fixture('c').copyWith(createdAt: DateTime.utc(2026, 10, 15));
    for (final room in [b, a, c]) {
      await repository.createRoom(commandId: room.id, room: room);
    }
    expect((await repository.listRooms()).map((r) => r.id), ['c', 'a', 'b']);
    expect(await repository.listRooms(status: RoomStatus.active), [c]);
    expect(await repository.getRoom('b'), b);
    expect(() => (repository.listRooms()), returnsNormally);
  });

  test('concurrent creates allow exactly one active room', () async {
    final outcomes = await Future.wait([
      for (final id in ['a', 'b'])
        repository
            .createRoom(commandId: id, room: fixture(id))
            .then<Object>((r) => r, onError: (Object error) => error),
    ]);
    expect(outcomes.whereType<CommandReceipt>(), hasLength(1));
    expect(outcomes.whereType<ActiveRoomExistsFailure>(), hasLength(1));
    expect(await repository.listRooms(), hasLength(1));
    expect(await repository.getCommandReceipt('b'), isNull);
  });

  test(
    'create retry returns original result even after later update',
    () async {
      final initial = fixture('a');
      await repository.createRoom(commandId: 'create', room: initial);
      final updated = initial.copyWith(revision: 1, name: 'changed');
      await repository.updateRoom(
        commandId: 'update',
        expectedRevision: 0,
        room: updated,
      );
      final retry = await repository.createRoom(
        commandId: 'create',
        room: initial,
      );
      expect(retry.room, initial);
      expect(await repository.getRoom('a'), updated);
    },
  );

  test(
    'update receipt wins over stale revision and remains historical',
    () async {
      final initial = fixture('a');
      await repository.createRoom(commandId: 'create', room: initial);
      final updated = initial.copyWith(revision: 1);
      await repository.updateRoom(
        commandId: 'update',
        expectedRevision: 0,
        room: updated,
      );
      await repository.updateRoom(
        commandId: 'later',
        expectedRevision: 1,
        room: updated.copyWith(revision: 2),
      );
      expect(
        (await repository.updateRoom(
          commandId: 'update',
          expectedRevision: 0,
          room: updated,
        )).room,
        updated,
      );
      expect((await repository.getCommandReceipt('update'))!.room, updated);
      await expectLater(
        repository.updateRoom(
          commandId: 'stale',
          expectedRevision: 0,
          room: updated,
        ),
        throwsA(isA<StaleRevisionFailure>()),
      );
      expect(await repository.getCommandReceipt('stale'), isNull);
    },
  );

  test(
    'failed create and update leave room and receipts untouched; retry works',
    () async {
      final initial = fixture('a');
      repository.failNextWrite();
      await expectLater(
        repository.createRoom(commandId: 'create', room: initial),
        throwsA(isA<PersistenceFailure>()),
      );
      expect(await repository.listRooms(), isEmpty);
      expect(await repository.getCommandReceipt('create'), isNull);
      await repository.createRoom(commandId: 'create', room: initial);
      final updated = initial.copyWith(revision: 1);
      repository.failNextWrite();
      await expectLater(
        repository.updateRoom(
          commandId: 'update',
          expectedRevision: 0,
          room: updated,
        ),
        throwsA(isA<PersistenceFailure>()),
      );
      expect(await repository.getRoom('a'), initial);
      expect(await repository.getCommandReceipt('update'), isNull);
      await repository.updateRoom(
        commandId: 'update',
        expectedRevision: 0,
        room: updated,
      );
      expect(await repository.getRoom('a'), updated);
    },
  );

  test('storage rejects invalid IDs, duplicate rooms, revision jumps and missing updates', () async {
    final initial = fixture('a');
    await expectLater(
      repository.createRoom(commandId: ' ', room: initial),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await repository.createRoom(commandId: 'create', room: initial);
    await expectLater(
      repository.createRoom(commandId: 'duplicate', room: initial),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await expectLater(
      repository.updateRoom(
        commandId: 'jump',
        expectedRevision: 0,
        room: initial.copyWith(revision: 2),
      ),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await expectLater(
      repository.updateRoom(
        commandId: 'missing',
        expectedRevision: 0,
        room: fixture('missing'),
      ),
      throwsA(isA<RoomNotFoundFailure>()),
    );
    await expectLater(
      repository.updateRoom(
        commandId: 'create',
        expectedRevision: 0,
        room: initial,
      ),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    await expectLater(
      repository.createRoom(commandId: 'create', room: fixture('other')),
      throwsA(isA<RepositoryValidationFailure>()),
    );
    expect(await repository.getRoom('a'), initial);
  });

  test(
    'closing releases active slot; reactivation cannot bypass constraint',
    () async {
      final a = fixture('a');
      await repository.createRoom(commandId: 'a', room: a);
      await repository.updateRoom(
        commandId: 'close',
        expectedRevision: 0,
        room: a.copyWith(status: RoomStatus.finished, revision: 1),
      );
      await repository.createRoom(commandId: 'b', room: fixture('b'));
      await expectLater(
        repository.updateRoom(
          commandId: 'reopen',
          expectedRevision: 1,
          room: a.copyWith(revision: 2),
        ),
        throwsA(isA<ActiveRoomExistsFailure>()),
      );
      expect((await repository.getRoom('a')).status, RoomStatus.finished);
      expect(await repository.getCommandReceipt('reopen'), isNull);
    },
  );

  test(
    'caller-owned collections cannot mutate committed rooms or receipts',
    () async {
      final scores = <String, int>{'a': 0};
      final input = fixture('a').copyWith(scores: scores);
      final receipt = await repository.createRoom(
        commandId: 'create',
        room: input,
      );
      scores['a'] = 100;
      expect((await repository.getRoom('a')).scores, {'a': 0});
      expect(receipt.room.scores, {'a': 0});
      expect(() => receipt.room.scores['a'] = 20, throwsUnsupportedError);
      expect(() => receipt.room.games.clear(), throwsUnsupportedError);
      final rooms = await repository.listRooms();
      expect(() => rooms.clear(), throwsUnsupportedError);
    },
  );
}
