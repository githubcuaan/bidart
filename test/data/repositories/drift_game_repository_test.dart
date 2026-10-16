import 'package:bidart/data/local/app_database.dart';
import 'package:bidart/data/repositories/game_repository.dart';
import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

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

Map<int, BallPointConfig> validPoints() => {
  for (var ball = 1; ball <= 9; ball++)
    ball: BallPointConfig(enabled: true, points: ball),
};

void main() {
  group('DriftGameRepository storage boundary', () {
    late AppDatabase db;
    late DriftGameRepository repository;

    setUp(() {
      db = AppDatabase.memory();
      repository = DriftGameRepository(
        database: db,
        clock: () => DateTime.utc(2026, 10, 15),
      );
    });

    tearDown(() => db.close());

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
    });

    test('restart on same database keeps rooms and receipts', () async {
      final initial = fixture('a');
      await repository.createRoom(commandId: 'create', room: initial);
      await repository.updateRoom(
        commandId: 'update',
        expectedRevision: 0,
        room: initial.copyWith(revision: 1, name: 'changed'),
      );
      // Repository recreation only; file close/reopen is covered separately.
      final reopened = DriftGameRepository(database: db);
      expect((await reopened.getRoom('a')).name, 'changed');
      expect((await reopened.getCommandReceipt('create'))!.room, initial);
      expect(
        (await reopened.updateRoom(
          commandId: 'update',
          expectedRevision: 0,
          room: initial.copyWith(revision: 1, name: 'changed'),
        )).room.name,
        'changed',
      );
    });

    test(
      'failed writes leave rooms and receipts untouched; retry works',
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
        repository.failNextWrite();
        await expectLater(
          repository.updateRoom(
            commandId: 'update',
            expectedRevision: 0,
            room: initial.copyWith(revision: 1),
          ),
          throwsA(isA<PersistenceFailure>()),
        );
        expect(await repository.getRoom('a'), initial);
        await repository.updateRoom(
          commandId: 'update',
          expectedRevision: 0,
          room: initial.copyWith(revision: 1),
        );
        expect((await repository.getRoom('a')).revision, 1);
      },
    );

    test('receipt SQL failure rolls back room insert and update', () async {
      await db.customStatement('''
        CREATE TRIGGER reject_receipt BEFORE INSERT ON command_receipts
        BEGIN SELECT RAISE(ABORT, 'receipt failure'); END
      ''');
      final initial = fixture('a');
      await expectLater(
        repository.createRoom(commandId: 'create', room: initial),
        throwsA(isA<Exception>()),
      );
      expect(await repository.listRooms(), isEmpty);
      expect(await repository.getCommandReceipt('create'), isNull);
      await db.customStatement('DROP TRIGGER reject_receipt');
      await repository.createRoom(commandId: 'create', room: initial);
      await db.customStatement('''
        CREATE TRIGGER reject_receipt BEFORE INSERT ON command_receipts
        BEGIN SELECT RAISE(ABORT, 'receipt failure'); END
      ''');
      Future<CommandReceipt> update() => repository.updateRoom(
        commandId: 'update',
        expectedRevision: 0,
        room: initial.copyWith(revision: 1, name: 'Updated'),
      );
      await expectLater(update(), throwsA(isA<Exception>()));
      expect(await repository.getRoom('a'), initial);
      expect(await repository.getCommandReceipt('update'), isNull);
      await db.customStatement('DROP TRIGGER reject_receipt');
      await update();
      await update();
      expect((await repository.getRoom('a')).revision, 1);
      expect(await db.select(db.receiptRows).get(), hasLength(2));
    });

    test(
      'corrupted payload surfaces explicit error, not silent new game',
      () async {
        await repository.createRoom(commandId: 'create', room: fixture('a'));
        await (db.update(db.roomRows)..where((t) => t.id.equals('a'))).write(
          const RoomRowsCompanion(payload: Value('not-json{')),
        );
        await expectLater(
          repository.getRoom('a'),
          throwsA(
            isA<PersistenceFailure>().having(
              (e) => e.message,
              'message',
              contains('hỏng'),
            ),
          ),
        );
        await expectLater(
          repository.listRooms(),
          throwsA(isA<PersistenceFailure>()),
        );
      },
    );

    test(
      'update guards: stale revision, revision jump, single active',
      () async {
        await repository.createRoom(commandId: 'a', room: fixture('a'));
        await expectLater(
          repository.updateRoom(
            commandId: 'stale',
            expectedRevision: 5,
            room: fixture('a').copyWith(revision: 6),
          ),
          throwsA(isA<StaleRevisionFailure>()),
        );
        await expectLater(
          repository.updateRoom(
            commandId: 'jump',
            expectedRevision: 0,
            room: fixture('a').copyWith(revision: 2),
          ),
          throwsA(isA<RepositoryValidationFailure>()),
        );
        await expectLater(
          repository.createRoom(commandId: 'b', room: fixture('b')),
          throwsA(isA<ActiveRoomExistsFailure>()),
        );
      },
    );

    test('templates save/list/get independent from rooms', () async {
      final points = validPoints();
      final saved = await repository.saveRuleTemplate(
        templateId: 't1',
        name: '  Yêu thích  ',
        ballPoints: points,
      );
      expect(saved.name, 'Yêu thích');
      points[1] = const BallPointConfig(enabled: false, points: 0);
      expect(
        (await repository.getRuleTemplate('t1')).ballPoints[1]!.points,
        isNot(0),
      );
      await repository.saveRuleTemplate(
        templateId: 't2',
        name: 'Hai',
        ballPoints: validPoints(),
      );
      expect(
        (await repository.listRuleTemplates()).map((t) => t.id),
        containsAll(['t1', 't2']),
      );
      // Templates survive "restart" and do not touch rooms.
      final reopened = DriftGameRepository(database: db);
      await expectLater(
        reopened.getRoom('missing'),
        throwsA(isA<RoomNotFoundFailure>()),
      );
      expect((await reopened.getRuleTemplate('t1')).name, 'Yêu thích');
      await expectLater(
        repository.getRuleTemplate('missing'),
        throwsA(isA<RuleTemplateNotFoundFailure>()),
      );
      await expectLater(
        repository.saveRuleTemplate(
          templateId: 'bad',
          name: ' ',
          ballPoints: validPoints(),
        ),
        throwsA(isA<RepositoryValidationFailure>()),
      );
    });
  });

  group('InMemory templates parity', () {
    test('save/list/get with caller detachment', () async {
      final repository = InMemoryGameRepository();
      final points = validPoints();
      await repository.saveRuleTemplate(
        templateId: 't1',
        name: 'Mẫu',
        ballPoints: points,
      );
      points.clear();
      expect((await repository.getRuleTemplate('t1')).ballPoints, hasLength(9));
      expect(await repository.listRuleTemplates(), hasLength(1));
    });
  });
}
