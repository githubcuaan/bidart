import 'dart:async';

import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_service.dart';
import 'package:bidart/widgets/room/ball_rules_editor/ball_toggle_dot.dart';
import 'package:bidart/features/scoring/provider/create_room_controller.dart';
import 'package:bidart/features/scoring/provider/room_action_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/screens/rooms/add_room/add_room.dart';
import 'package:bidart/screens/rooms/chose_room.dart';
import 'package:bidart/screens/rooms/in_room/in_room.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_section.dart';
import 'package:bidart/screens/rooms/rooms.dart';
import 'package:bidart/widgets/async/async_content.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class ScreenRepository extends InMemoryGameRepository {
  Completer<void>? saveGate;
  Completer<void>? updateGate;
  Completer<void>? readGate;
  bool failList = false;
  bool failGet = false;
  int creates = 0;

  @override
  Future<CommandReceipt> createRoom({
    required String commandId,
    required Room room,
  }) async {
    creates++;
    await saveGate?.future;
    return super.createRoom(commandId: commandId, room: room);
  }

  @override
  Future<CommandReceipt> updateRoom({
    required String commandId,
    required int expectedRevision,
    required Room room,
    RoomCommandType type = RoomCommandType.update,
  }) async {
    await updateGate?.future;
    return super.updateRoom(
      commandId: commandId,
      expectedRevision: expectedRevision,
      room: room,
      type: type,
    );
  }

  @override
  Future<List<Room>> listRooms({RoomStatus? status}) async {
    await readGate?.future;
    if (failList) throw const PersistenceFailure('list failed');
    return super.listRooms(status: status);
  }

  @override
  Future<Room> getRoom(String roomId) async {
    await readGate?.future;
    if (failGet) throw const PersistenceFailure('get failed');
    return super.getRoom(roomId);
  }

  @override
  Future<List<RuleTemplate>> listRuleTemplates() async {
    await readGate?.future;
    return super.listRuleTemplates();
  }
}

void main() {
  final now = DateTime.utc(2026, 10, 15);
  late ScreenRepository repository;
  late ProviderContainer container;
  var seedSequence = 0;

  setUp(() {
    repository = ScreenRepository();
    var sequence = 0;
    seedSequence = 0;
    container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => now),
        idFactoryProvider.overrideWithValue(() => 'draft-${++sequence}'),
      ],
    );
  });
  tearDown(() => container.dispose());

  Finder key(String value) => find.byKey(ValueKey(value));
  FilledButton submit(WidgetTester tester) =>
      tester.widget<FilledButton>(key('submit-room'));

  Future<void> pump(WidgetTester tester, Widget screen) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: Scaffold(body: screen)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fill(WidgetTester tester) async {
    await tester.enterText(key('room-name'), 'Bàn 1');
    await tester.enterText(key('player-name-draft-1'), 'An');
    await tester.enterText(key('player-name-draft-2'), 'Bình');
    await tester.pump();
  }

  Future<void> choose(WidgetTester tester, String selector, String name) async {
    await tester.tap(key(selector));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name).last);
    await tester.pumpAndSettle();
  }

  Future<void> expandRoomInfo(WidgetTester tester) async {
    await tester.tap(find.text('Thông tin phòng'));
    await tester.pumpAndSettle();
  }

  Future<Room> seed({
    String name = 'Phòng có sẵn',
    RoomStatus status = RoomStatus.active,
    bool finishedGame = false,
  }) async {
    final service = RoomService(
      repository: repository,
      idFactory: () => 'seed-${++seedSequence}',
      clock: () => now,
    );
    final id = await service.createRoom(
      commandId: 'seed-command-${seedSequence + 1}',
      name: name,
      ownerId: 'owner',
      participants: [
        PlayerInGame(id: 'a', displayName: 'An', joinedAt: now),
        PlayerInGame(id: 'b', displayName: 'Bình', joinedAt: now),
      ],
      playerOrder: ['a', 'b'],
      starterId: 'a',
      payerId: 'b',
      ballPoints: {
        for (var ball = 1; ball <= 9; ball++)
          ball: BallPointConfig(enabled: true, points: ball),
      },
    );
    final room = await repository.getRoom(id);
    if (status == RoomStatus.active && !finishedGame) return room;
    final receipt = await repository.updateRoom(
      commandId: 'fixture-$id',
      expectedRevision: 0,
      room: room.copyWith(
        revision: 1,
        status: status,
        endedAt: status == RoomStatus.active ? null : now,
        scores: {'a': 10, 'b': -10},
        games: [
          room.games.single.copyWith(
            status: status == RoomStatus.cancelled
                ? GameStatus.cancelled
                : GameStatus.finished,
            winnerId: 'a',
            finalPayerId: 'b',
            endedAt: now,
          ),
        ],
      ),
    );
    return receipt.room;
  }

  testWidgets('form rejects blank and duplicate names; enforces 2–5 guests', (
    tester,
  ) async {
    await pump(tester, const AddRoom());
    expect(submit(tester).onPressed, isNull);
    expect(
      tester.widget<IconButton>(key('remove-player-draft-1')).onPressed,
      isNull,
    );
    await fill(tester);
    expect(submit(tester).onPressed, isNotNull);
    await tester.enterText(key('player-name-draft-2'), ' AN ');
    await tester.pump();
    expect(find.text('Tên người chơi không được trùng nhau.'), findsOneWidget);
    expect(submit(tester).onPressed, isNull);
    await tester.enterText(key('player-name-draft-2'), 'Bình');
    for (var i = 0; i < 3; i++) {
      await tester.tap(key('add-player'));
      await tester.pump();
    }
    expect(tester.widget<TextButton>(key('add-player')).onPressed, isNull);
    expect(
      container.read(createRoomControllerProvider).draft.participants,
      hasLength(5),
    );
    expect(await repository.listRooms(), isEmpty);
  });

  testWidgets('fixed roles stay first two; only later players can reorder', (
    tester,
  ) async {
    await pump(tester, const AddRoom());
    await fill(tester);
    expect(key('role-badge-draft-1'), findsOneWidget);
    expect(key('role-badge-draft-2'), findsOneWidget);
    expect(key('locked-player-draft-1'), findsOneWidget);
    expect(key('locked-player-draft-2'), findsOneWidget);
    expect(key('move-up-draft-2'), findsNothing);
    expect(key('move-down-draft-1'), findsNothing);
    expect(find.text('Thứ tự lượt chơi tiếp theo'), findsNothing);
    var draft = container.read(createRoomControllerProvider).draft;
    expect(draft.playerOrder, ['draft-1', 'draft-2']);
    expect(draft.starterId, 'draft-1');
    expect(draft.payerId, 'draft-2');

    await tester.tap(key('add-player'));
    await tester.pump();
    await tester.enterText(key('player-name-draft-3'), 'Chi');
    await tester.tap(key('add-player'));
    await tester.pump();
    await tester.enterText(key('player-name-draft-4'), 'Dũng');
    expect(find.text('Thứ tự lượt chơi tiếp theo'), findsOneWidget);
    await tester.tap(key('move-up-draft-4'));
    await tester.pump();
    draft = container.read(createRoomControllerProvider).draft;
    expect(draft.playerOrder, ['draft-1', 'draft-2', 'draft-4', 'draft-3']);
    expect(draft.starterId, 'draft-1');
    expect(draft.payerId, 'draft-2');

    await choose(tester, 'payer-selector', 'Chi');
    draft = container.read(createRoomControllerProvider).draft;
    expect(draft.playerOrder, ['draft-1', 'draft-3', 'draft-2', 'draft-4']);
    expect(draft.payerId, 'draft-3');

    await tester.enterText(key('player-name-draft-1'), 'An mới');
    await tester.tap(key('remove-player-draft-1'));
    await tester.pump();
    draft = container.read(createRoomControllerProvider).draft;
    expect(draft.starterId, isEmpty);
    expect(draft.payerId, 'draft-3');
    expect(find.text('Chọn người đề-pa.'), findsOneWidget);
    expect(submit(tester).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('starter/payer conflict is inline and disables submit', (
    tester,
  ) async {
    await pump(tester, const AddRoom());
    await fill(tester);
    await choose(tester, 'payer-selector', 'An');
    expect(
      find.text('Người đề-pa và người trả phải khác nhau.'),
      findsOneWidget,
    );
    expect(submit(tester).onPressed, isNull);
    await choose(tester, 'payer-selector', 'Bình');
    expect(submit(tester).onPressed, isNotNull);
  });

  testWidgets('five guests create with previewed order and stable IDs', (
    tester,
  ) async {
    await pump(tester, const AddRoom());
    await fill(tester);
    for (var index = 3; index <= 5; index++) {
      await tester.tap(key('add-player'));
      await tester.pump();
      await tester.enterText(key('player-name-draft-$index'), 'Khách $index');
    }
    await tester.tap(key('move-up-draft-5'));
    await tester.pump();
    expect(container.read(createRoomControllerProvider).draft.playerOrder, [
      'draft-1',
      'draft-2',
      'draft-3',
      'draft-5',
      'draft-4',
    ]);
    await tester.ensureVisible(key('order-preview'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(key('order-preview')).data,
      'An → Bình → Khách 3 → Khách 5 → Khách 4',
    );
    await tester.tap(key('submit-room'));
    await tester.pumpAndSettle();
    final room = (await repository.listRooms()).single;
    expect(room.playerOrder, [
      'draft-1',
      'draft-2',
      'draft-3',
      'draft-5',
      'draft-4',
    ]);
    expect(room.participants.map((player) => player.id), room.playerOrder);
    expect(room.games.single.currentPlayerId, 'draft-1');
    expect(room.games.single.payerId, 'draft-2');
    expect(room.scores.values, everyElement(0));
    expect(room.games, hasLength(1));
  });

  testWidgets('ball and optional limit validation prevents invalid submits', (
    tester,
  ) async {
    await pump(tester, const AddRoom());
    await fill(tester);
    for (final value in ['0', '-1', '1.5', 'abc', '']) {
      await tester.enterText(key('ball-points-1'), value);
      await tester.pump();
      expect(submit(tester).onPressed, isNull);
    }
    await tester.enterText(key('ball-points-1'), '10');
    for (var ball = 1; ball <= 9; ball++) {
      await tester.tap(key('ball-enabled-$ball'));
      await tester.pump();
    }
    expect(find.text('Bật tính điểm ít nhất một bi.'), findsOneWidget);
    expect(submit(tester).onPressed, isNull);
    await tester.tap(key('ball-enabled-1'));
    await tester.tap(key('duration-3600'));
    await tester.pump();
    expect(
      container
          .read(createRoomControllerProvider)
          .draft
          .endConditions
          .durationSeconds,
      3600,
    );
    await tester.enterText(key('score-threshold'), 'no');
    await tester.pump();
    expect(submit(tester).onPressed, isNull);
    await tester.enterText(key('score-threshold'), '100');
    await tester.pump();
    expect(submit(tester).onPressed, isNotNull);
    await tester.tap(key('submit-room'));
    await tester.pumpAndSettle();
    final room = (await repository.listRooms()).single;
    expect(room.endConditions.durationSeconds, 3600);
    expect(room.endConditions.scoreThreshold, 100);
    expect(room.ruleVersions.single.ballPoints[1]!.points, 10);
    expect(room.ruleVersions.single.ballPoints[2]!.enabled, false);
    expect(room.ruleVersions.single.ballPoints[2]!.points, 0);
    expect(room.games.single.remainingBalls, hasLength(9));
  });

  testWidgets(
    'saving locks controls; double tap creates one room after commit only',
    (tester) async {
      await pump(tester, const AddRoom());
      await fill(tester);
      repository.saveGate = Completer<void>();
      await tester.tap(key('submit-room'));
      await tester.pump();
      expect(find.byType(ChoseRoom), findsNothing);
      expect(submit(tester).onPressed, isNull);
      expect(tester.widget<TextField>(key('room-name')).enabled, false);
      expect(tester.widget<TextButton>(key('add-player')).onPressed, isNull);
      expect(
        tester
            .widget<DropdownButton<String>>(key('starter-selector'))
            .onChanged,
        isNull,
      );
      expect(
        tester.widget<BallToggleDot>(key('ball-enabled-1')).onToggle,
        isNull,
      );
      await tester.tap(key('submit-room'));
      expect(await repository.listRooms(), isEmpty);
      repository.saveGate!.complete();
      await tester.pumpAndSettle();
      expect(find.byType(ChoseRoom), findsOneWidget);
      expect(repository.creates, 1);
      expect((await repository.listRooms()).single.games, hasLength(1));
    },
  );

  testWidgets(
    'leaving during save does not navigate later; new form is fresh',
    (tester) async {
      await pump(tester, const Rooms());
      await tester.tap(key('create-room'));
      await tester.pumpAndSettle();
      await fill(tester);
      repository.saveGate = Completer<void>();
      await tester.tap(key('submit-room'));
      await tester.pump();
      await tester.pageBack();
      await tester.pumpAndSettle();
      repository.saveGate!.complete();
      await tester.pumpAndSettle();
      expect(find.byType(ChoseRoom), findsNothing);
      expect(find.byType(AddRoom), findsNothing);
      expect(find.text('Bàn 1'), findsOneWidget);
      await tester.tap(key('create-room'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(key('room-name')).controller!.text,
        isEmpty,
      );
      expect(submit(tester).onPressed, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('save failure retains text and retry succeeds', (tester) async {
    await pump(tester, const AddRoom());
    await fill(tester);
    repository.failNextWrite();
    await tester.tap(key('submit-room'));
    await tester.pumpAndSettle();
    expect(key('create-error'), findsOneWidget);
    expect(find.byType(ChoseRoom), findsNothing);
    expect(
      tester.widget<TextField>(key('room-name')).controller!.text,
      'Bàn 1',
    );
    expect(
      tester.widget<TextField>(key('player-name-draft-1')).controller!.text,
      'An',
    );
    expect(await repository.listRooms(), isEmpty);
    await tester.tap(key('submit-room'));
    await tester.pumpAndSettle();
    expect(find.byType(ChoseRoom), findsOneWidget);
    expect(await repository.listRooms(), hasLength(1));
  });

  testWidgets(
    'active-room conflict opens existing room without creating another',
    (tester) async {
      final room = await seed();
      await pump(tester, const AddRoom());
      await fill(tester);
      await tester.tap(key('submit-room'));
      await tester.pumpAndSettle();
      expect(find.text('Đã có một phòng đang chơi.'), findsOneWidget);
      await tester.tap(key('open-existing-room'));
      await tester.pumpAndSettle();
      expect(tester.widget<ChoseRoom>(find.byType(ChoseRoom)).roomId, room.id);
      expect(await repository.listRooms(), hasLength(1));
    },
  );

  testWidgets('list loading, error, retry, empty state', (tester) async {
    repository.readGate = Completer<void>();
    await tester.binding.setSurfaceSize(const Size(1000, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: Rooms())),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.failList = true;
    repository.readGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Thử lại'), findsOneWidget);
    repository.failList = false;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có phòng trong danh sách này.'), findsOneWidget);
  });

  testWidgets('status filters select active, finished, cancelled and all', (
    tester,
  ) async {
    await seed(name: 'Phòng kết thúc', status: RoomStatus.finished);
    await seed(name: 'Phòng hủy', status: RoomStatus.cancelled);
    await seed(name: 'Phòng đang chơi');
    await pump(tester, const Rooms());
    expect(find.byType(ListTile), findsNWidgets(3));
    for (final entry in {
      'Đang chơi': 'Phòng đang chơi',
      'Đã kết thúc': 'Phòng kết thúc',
      'Đã hủy': 'Phòng hủy',
    }.entries) {
      await choose(tester, 'room-status-filter', entry.key);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text(entry.value), findsOneWidget);
    }
    await choose(tester, 'room-status-filter', 'Tất cả');
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('filtered retry shows loading and preserves selected status', (
    tester,
  ) async {
    final finished = await seed(
      name: 'Phòng kết thúc',
      status: RoomStatus.finished,
    );
    await seed(name: 'Phòng đang chơi');
    await pump(tester, const Rooms());
    expect(find.byType(Scaffold), findsOneWidget);

    repository.failList = true;
    await choose(tester, 'room-status-filter', 'Đã kết thúc');
    expect(find.text('Thử lại'), findsOneWidget);

    repository.failList = false;
    repository.readGate = Completer<void>();
    await tester.tap(find.text('Thử lại'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Thử lại'), findsNothing);
    expect(
      tester
          .widget<DropdownButton<RoomStatus?>>(key('room-status-filter'))
          .value,
      RoomStatus.finished,
    );

    repository.readGate!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsOneWidget);
    expect(key('room-${finished.id}'), findsOneWidget);
    expect(find.text('Phòng đang chơi'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(key('room-${finished.id}'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ChoseRoom>(find.byType(ChoseRoom)).roomId,
      finished.id,
    );
  });

  testWidgets('create → gateway → room → back preserves committed aggregate', (
    tester,
  ) async {
    await pump(tester, const Rooms());
    await tester.tap(key('create-room'));
    await tester.pumpAndSettle();
    await fill(tester);
    await tester.tap(key('submit-room'));
    await tester.pumpAndSettle();
    expect(find.byType(AddRoom), findsNothing);
    expect(find.byType(ChoseRoom), findsOneWidget);
    final room = (await repository.listRooms()).single;
    expect(tester.widget<ChoseRoom>(find.byType(ChoseRoom)).roomId, room.id);
    await tester.tap(key('open-room'));
    await tester.pumpAndSettle();
    expect(find.byType(InRoom), findsOneWidget);
    await expandRoomInfo(tester);
    expect(find.text('An'), findsOneWidget);
    expect(find.text('ĐANG CÓ CƠ'), findsOneWidget);
    expect(find.text('Người trả: Bình'), findsOneWidget);
    expect(key('next-game'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(key('room-${room.id}'), findsOneWidget);
    expect(await repository.getRoom(room.id), room);
    await tester.tap(key('room-${room.id}'));
    await tester.pumpAndSettle();
    expect(find.byType(ChoseRoom), findsOneWidget);
    expect(await repository.getRoom(room.id), room);
  });

  testWidgets('AddRoom shell keeps submit bar and template chips', (
    tester,
  ) async {
    final template = await repository.saveRuleTemplate(
      templateId: 'tpl-1',
      name: 'Mẫu chuẩn',
      ballPoints: {
        for (var ball = 1; ball <= 9; ball++)
          ball: BallPointConfig(enabled: true, points: ball),
      },
    );
    await tester.binding.setSurfaceSize(const Size(1000, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    repository.readGate = Completer<void>();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AddRoom()),
      ),
    );
    await tester.pump();
    expect(find.byType(AppScreen), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Tạo phòng'), findsOneWidget);
    expect(submit(tester).onPressed, isNull);
    expect(find.byType(AsyncContent<List<RuleTemplate>>), findsOneWidget);
    // Loading templates hides chips without blocking the form.
    expect(key('apply-template-${template.id}'), findsNothing);

    repository.readGate!.complete();
    await tester.pumpAndSettle();
    expect(key('apply-template-${template.id}'), findsOneWidget);

    await tester.tap(key('apply-template-${template.id}'));
    await tester.pumpAndSettle();
    expect(find.text('Tạo và bắt đầu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final gateway in [true, false]) {
    testWidgets(
      '${gateway ? 'gateway' : 'in-room'} standalone shell preserves load and refresh',
      (tester) async {
        final room = await seed();
        repository.readGate = Completer<void>();
        await tester.binding.setSurfaceSize(const Size(1000, 2600));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: gateway
                  ? ChoseRoom(roomId: room.id)
                  : InRoom(roomId: room.id),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(AppScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AsyncContent<Room>), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(
          find.text(gateway ? 'Chi tiết phòng' : 'Trong phòng'),
          findsOneWidget,
        );

        repository.readGate!.complete();
        await tester.pumpAndSettle();
        expect(find.text(room.name), findsOneWidget);
        final scores = gateway
            ? null
            : tester.element(find.byType(TurnScoresSection));

        repository.readGate = Completer<void>();
        container.invalidate(roomByIdProvider(room.id));
        await tester.pump();
        if (gateway) {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.text(room.name), findsNothing);
        } else {
          expect(find.byType(CircularProgressIndicator), findsNothing);
          expect(find.text(room.name), findsOneWidget);
          expect(tester.element(find.byType(TurnScoresSection)), same(scores));
        }
        repository.readGate!.complete();
        await tester.pumpAndSettle();
        expect(find.text(room.name), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '${gateway ? 'gateway' : 'in-room'} missing ID and failed load/retry',
      (tester) async {
        await pump(
          tester,
          gateway
              ? const ChoseRoom(roomId: 'missing')
              : const InRoom(roomId: 'missing'),
        );
        expect(find.text('Không tìm thấy phòng.'), findsOneWidget);
        expect(key('open-room'), findsNothing);
        final room = await seed();
        repository.failGet = true;
        await pump(
          tester,
          gateway ? ChoseRoom(roomId: room.id) : InRoom(roomId: room.id),
        );
        expect(find.text('Thử lại'), findsOneWidget);
        repository.failGet = false;
        await tester.tap(find.text('Thử lại'));
        await tester.pumpAndSettle();
        expect(find.text(room.name), findsOneWidget);
      },
    );
  }

  testWidgets('in-room keeps turn cards mounted while saving', (tester) async {
    final room = await seed();
    await pump(tester, InRoom(roomId: room.id));

    final scores = tester.element(find.byType(TurnScoresSection));
    final playerRow = tester.element(
      find.byKey(const ValueKey('turn-score-row-a')),
    );

    repository.updateGate = Completer<void>();
    final pending = container
        .read(roomActionControllerProvider(room.id).notifier)
        .submit(
          RoomAction(
            RoomActionKind.record,
            gameId: room.games.single.id,
            actorId: 'a',
            balls: const [1],
          ),
          expectedRevision: room.revision,
        );
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(tester.element(find.byType(TurnScoresSection)), same(scores));
    expect(
      tester.element(find.byKey(const ValueKey('turn-score-row-a'))),
      same(playerRow),
    );

    repository.updateGate!.complete();
    await pending;
    await tester.pumpAndSettle();

    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(tester.element(find.byType(TurnScoresSection)), same(scores));
    expect(
      tester.element(find.byKey(const ValueKey('turn-score-row-a'))),
      same(playerRow),
    );
    expect(tester.takeException(), isNull);
  });

  for (final status in [RoomStatus.finished, RoomStatus.cancelled]) {
    testWidgets('${status.name} room is read-only in gateway and destination', (
      tester,
    ) async {
      final room = await seed(status: status);
      await pump(tester, ChoseRoom(roomId: room.id));
      expect(find.text('Xem kết quả'), findsOneWidget);
      await tester.tap(key('open-room'));
      await tester.pumpAndSettle();
      expect(
        find.text('Phòng chỉ đọc — không thể thay đổi kết quả.'),
        findsOneWidget,
      );
      expect(key('next-game'), findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.text('+10đ'), findsOneWidget);
      expect(find.text('-10đ'), findsOneWidget);
      expect(await repository.getRoom(room.id), room);
    });
  }

  testWidgets('next game UI preserves scores and rules', (tester) async {
    final room = await seed(finishedGame: true);
    await pump(tester, InRoom(roomId: room.id));
    repository.failNextWrite();
    await tester.tap(key('next-game'));
    await tester.pumpAndSettle();
    expect(
      find.text('Không thể đọc hoặc lưu phòng. Vui lòng thử lại.'),
      findsOneWidget,
    );
    expect(await repository.getRoom(room.id), room);
    await tester.tap(key('next-game'));
    await tester.pumpAndSettle();
    final updated = await repository.getRoom(room.id);
    expect(updated.games, hasLength(2));
    expect(updated.scores, room.scores);
    expect(updated.ruleVersions, room.ruleVersions);
    await expandRoomInfo(tester);
    expect(find.text('Ván 2 · Đang chơi'), findsOneWidget);
    expect(key('next-game'), findsNothing);
  });

  testWidgets('form fits a narrow phone and scrolls without layout errors', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 740));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AddRoom()),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(ListView), const Offset(0, -1800));
    await tester.pumpAndSettle();
    expect(key('submit-room'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
