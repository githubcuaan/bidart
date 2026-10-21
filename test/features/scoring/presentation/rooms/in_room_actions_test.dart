import 'dart:async';

import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_commands.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/screens/rooms/in_room/in_room.dart';
import 'package:bidart/widgets/room/ball_rules_editor/ball_toggle_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class UiRepository extends InMemoryGameRepository {
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
  final start = DateTime.utc(2026, 10, 15);
  late DateTime now;
  late UiRepository repo;
  late ProviderContainer container;
  late Room room;
  var ids = 0;
  setUp(() async {
    now = start;
    ids = 0;
    repo = UiRepository();
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
        for (final id in ['A', 'B', 'C', 'D'])
          PlayerInGame(id: id, displayName: id, joinedAt: start),
      ],
      playerOrder: ['A', 'B', 'C', 'D'],
      starterId: 'A',
      payerId: 'B',
      ballPoints: {
        for (var b = 1; b <= 9; b++)
          b: BallPointConfig(enabled: b != 2, points: b == 2 ? 0 : 10),
      },
    );
    room = await service.getRoom(id);
  });
  tearDown(() => container.dispose());
  Finder key(String name) => find.byKey(ValueKey(name));
  Future<void> show(
    WidgetTester tester, {
    Size size = const Size(400, 900),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: InRoom(roomId: room.id)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> visible(WidgetTester tester, String name) async {
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable).first);
    scroll.position.jumpTo(0);
    await tester.pump();
    await tester.scrollUntilVisible(
      key(name),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String name) async {
    await visible(tester, name);
    await tester.tap(key(name));
    await tester.pumpAndSettle();
  }

  Future<Room> latest() => repo.getRoom(room.id);
  Future<void> win() async {
    room = await container
        .read(roomServiceProvider)
        .recordTurn(
          commandId: 'win',
          roomId: room.id,
          expectedRevision: room.revision,
          gameId: room.currentGameId!,
          input: TurnInput(
            turnId: 'win',
            actorId: 'A',
            balls: [1, 2, 3, 4, 5, 6, 7, 8, 9],
          ),
        );
  }

  Future<void> limits(EndConditions conditions) async {
    room = room.copyWith(
      revision: room.revision + 1,
      endConditions: conditions,
    );
    await repo.updateRoom(
      commandId: 'fixture-limit',
      expectedRevision: room.revision - 1,
      room: room,
    );
  }

  testWidgets(
    'selection only changes draft/preview; confirmation writes exactly one turn',
    (tester) async {
      await show(tester);
      await tap(tester, 'pot-ball-1');
      expect((await latest()).games.single.turns, isEmpty);
      expect(find.text('A: +30'), findsOneWidget);
      expect(find.text('B: -10'), findsOneWidget);
      await tap(tester, 'record-turn');
      final committed = await latest();
      expect(committed.games.single.turns.length, 1);
      expect(committed.scores['A'], 30);
      expect(key('pot-ball-1'), findsNothing);
      await visible(tester, 'pot-ball-2');
      expect(tester.widget<BallToggleDot>(key('pot-ball-2')).enabled, isFalse);
      await tap(tester, 'room-history');
      expect(find.textContaining('#1 A'), findsOneWidget);
    },
  );
  testWidgets(
    'save failure preserves draft, retry keeps command ID and clears draft on commit',
    (tester) async {
      await show(tester);
      await tap(
        tester,
        'pot-ball-9',
      ); // Early nine stays selectable after commit.
      repo.failNextWrite();
      await tap(tester, 'record-turn');
      expect((await latest()).games.single.turns, isEmpty);
      await visible(tester, 'pot-ball-9');
      expect(tester.widget<BallToggleDot>(key('pot-ball-9')).enabled, isTrue);
      final id = repo.commands.last;
      await tap(tester, 'retry-action');
      expect(repo.commands.last, id);
      expect((await latest()).games.single.turns.length, 1);
      await visible(tester, 'pot-ball-9');
      expect(tester.widget<BallToggleDot>(key('pot-ball-9')).enabled, isFalse);
    },
  );
  testWidgets(
    'in-flight save disables ball picker and confirm; double tap cannot duplicate',
    (tester) async {
      await show(tester);
      await tap(tester, 'pot-ball-1');
      await visible(tester, 'record-turn');
      repo.gate = Completer<void>();
      await tester.tap(key('record-turn'));
      await tester.pump();
      expect(tester.widget<FilledButton>(key('record-turn')).onPressed, isNull);
      expect(tester.widget<BallToggleDot>(key('pot-ball-1')).onToggle, isNull);
      await tester.tap(key('record-turn'));
      await tester.pump();
      expect((await latest()).revision, 0);
      repo.gate!.complete();
      await tester.pumpAndSettle();
      expect((await latest()).games.single.turns.length, 1);
      expect(repo.commands.length, 1);
    },
  );
  testWidgets(
    'disabled ball can be recorded without score; miss changes current player',
    (tester) async {
      await show(tester);
      await tap(tester, 'pot-ball-1');
      await tap(tester, 'pot-ball-2');
      await tap(tester, 'record-turn');
      final turn = (await latest()).games.single.turns.single;
      expect(turn.pottedBalls.last.points, 0);
      expect(turn.pottedBalls.last.isRespotted, isFalse);
      expect((await latest()).scores['A'], 30);
      await tap(tester, 'record-turn'); // empty draft = miss.
      expect((await latest()).games.single.currentPlayerId, 'B');
    },
  );
  testWidgets('foul derives TH2 and undo restores real order and payer', (
    tester,
  ) async {
    await show(tester);
    await tap(tester, 'turn-foul');
    await tap(tester, 'record-turn');
    expect((await latest()).playerOrder, ['B', 'A', 'C', 'D']);
    expect(
      (await latest()).games.single.turns.single.foulClassification,
      FoulClassification.th2,
    );
    await tap(tester, 'undo-turn');
    expect((await latest()).playerOrder, ['A', 'B', 'C', 'D']);
    expect((await latest()).games.single.currentPlayerId, 'A');
    expect((await latest()).games.single.turns.single.isUndone, isTrue);
  });
  testWidgets('undo winning turn asks confirmation and reopens game', (
    tester,
  ) async {
    await win();
    await show(tester);
    await tap(tester, 'undo-turn');
    expect(find.text('Mở lại ván?'), findsOneWidget);
    expect((await latest()).games.single.remainingBalls, isEmpty);
    await tester.tap(key('confirm-action'));
    await tester.pumpAndSettle();
    expect((await latest()).games.single.remainingBalls, {
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
    });
    expect(key('next-game'), findsNothing);
  });
  testWidgets(
    'add and reorder controls create barriers and preserve current/payer',
    (tester) async {
      await show(tester);
      await tap(tester, 'pot-ball-1');
      await tap(tester, 'record-turn');
      await tap(tester, 'add-player');
      await tester.enterText(key('new-player-name'), 'E');
      await tester.pumpAndSettle();
      await tester.tap(key('save-player'));
      await tester.pumpAndSettle();
      expect((await latest()).activePlayerIds.last, isNotNull);
      expect((await latest()).participants.last.displayName, 'E');
      await visible(tester, 'undo-turn');
      expect(tester.widget<OutlinedButton>(key('undo-turn')).onPressed, isNull);
      await tap(tester, 'edit-order');
      await tester.tap(key('order-down-A'));
      await tester.pumpAndSettle();
      await tester.tap(key('save-order'));
      await tester.pumpAndSettle();
      expect((await latest()).playerOrder.take(2), ['B', 'A']);
      expect((await latest()).games.single.currentPlayerId, 'A');
      expect((await latest()).games.single.payerId, 'B');
    },
  );
  testWidgets(
    'rule editor validates, creates new version and preview uses new points',
    (tester) async {
      await show(tester);
      await tap(tester, 'edit-rules');
      await tester.enterText(key('rule-points-1'), '0');
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(key('save-rules')).onPressed, isNull);
      await tester.enterText(key('rule-points-1'), '25');
      await tester.pumpAndSettle();
      await tester.tap(key('save-rules'));
      await tester.pumpAndSettle();
      expect((await latest()).currentRuleVersion, 2);
      await tap(tester, 'pot-ball-1');
      expect(find.text('A: +75'), findsOneWidget);
    },
  );
  testWidgets(
    'remove winner and payer then explicitly choose distinct replacements',
    (tester) async {
      await win();
      await show(tester);
      for (final id in ['A', 'B']) {
        await tap(tester, 'remove-player-$id');
        await tester.tap(key('confirm-action'));
        await tester.pumpAndSettle();
      }
      expect((await latest()).activePlayerIds, ['C', 'D']);
      await tap(tester, 'next-game');
      expect(find.text('Chọn người thay thế'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(key('confirm-replacements')).onPressed,
        isNull,
      );
      await tester.tap(key('replacement-starter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C').last);
      await tester.pumpAndSettle();
      await tester.tap(key('replacement-payer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C').last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(key('confirm-replacements')).onPressed,
        isNull,
      );
      await tester.tap(key('replacement-payer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('D').last);
      await tester.pumpAndSettle();
      repo.failNextWrite();
      await tester.tap(key('confirm-replacements'));
      await tester.pumpAndSettle();
      expect((await latest()).games.length, 1);
      final failedCommand = repo.commands.last;
      await tap(tester, 'retry-action');
      expect(repo.commands.last, failedCommand);
      final result = await latest();
      expect(result.games.last.currentPlayerId, 'C');
      expect(result.games.last.payerId, 'D');
      expect(result.games.first.winnerId, 'A');
      expect(result.games.first.finalPayerId, 'B');
    },
  );
  for (final cancel in [false, true]) {
    testWidgets(
      'manual ${cancel ? 'cancel' : 'finish'} confirmation then read-only UI',
      (tester) async {
        await show(tester);
        await tap(tester, cancel ? 'cancel-room' : 'finish-room');
        expect((await latest()).status, RoomStatus.active);
        await tester.tap(key('confirm-action'));
        await tester.pumpAndSettle();
        expect(
          (await latest()).status,
          cancel ? RoomStatus.cancelled : RoomStatus.finished,
        );
        expect(key('record-turn'), findsNothing);
        expect(key('undo-turn'), findsNothing);
        expect(key('edit-rules'), findsNothing);
        expect(key('next-game'), findsNothing);
      },
    );
  }
  testWidgets('timer marks pending without ending unfinished game', (
    tester,
  ) async {
    await limits(const EndConditions(durationSeconds: 2));
    await show(tester);
    now = start.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect((await latest()).pendingEndReasons, isNotEmpty);
    expect((await latest()).status, RoomStatus.active);
    expect(find.textContaining('Đã đạt điều kiện kết thúc'), findsOneWidget);
  });
  testWidgets(
    'resume after deadline evaluates state; completed game closes on load',
    (tester) async {
      await limits(const EndConditions(durationSeconds: 60));
      await win();
      now = start.add(const Duration(seconds: 61));
      await show(tester);
      expect((await latest()).status, RoomStatus.finished);
      expect(key('next-game'), findsNothing);
    },
  );
  testWidgets(
    'actual lifecycle resume reevaluates clock without losing draft',
    (tester) async {
      await limits(const EndConditions(durationSeconds: 60));
      await show(tester);
      await tap(tester, 'pot-ball-9');
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      now = start.add(const Duration(seconds: 61));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect((await latest()).pendingEndReasons, isNotEmpty);
      await visible(tester, 'pot-ball-9');
      expect(tester.widget<BallToggleDot>(key('pot-ball-9')).enabled, isTrue);
    },
  );
  testWidgets(
    'leaving during save does not update disposed screen or navigate',
    (tester) async {
      await show(tester);
      await tap(tester, 'pot-ball-1');
      await visible(tester, 'record-turn');
      repo.gate = Completer<void>();
      await tester.tap(key('record-turn'));
      await tester.pump();
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Other screen'))),
      );
      repo.gate!.complete();
      await tester.pumpAndSettle();
      expect((await latest()).games.single.turns.length, 1);
      expect(find.text('Other screen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'failed add can retry original participant/name without reopening dialog',
    (tester) async {
      await show(tester);
      await tap(tester, 'add-player');
      await tester.enterText(key('new-player-name'), 'E');
      await tester.pumpAndSettle();
      repo.failNextWrite();
      await tester.tap(key('save-player'));
      await tester.pumpAndSettle();
      expect((await latest()).activePlayerIds.length, 4);
      final command = repo.commands.last;
      await tap(tester, 'retry-action');
      expect(repo.commands.last, command);
      expect((await latest()).participants.last.displayName, 'E');
      expect((await latest()).activePlayerIds.length, 5);
    },
  );
  testWidgets(
    'external committed change invalidates preview; clear draft recovers',
    (tester) async {
      await show(tester);
      await tap(tester, 'pot-ball-1');
      await container
          .read(roomServiceProvider)
          .recordTurn(
            commandId: 'external',
            roomId: room.id,
            expectedRevision: 0,
            gameId: room.currentGameId!,
            input: TurnInput(turnId: 'external', actorId: 'A', balls: [1]),
          );
      container.invalidate(roomByIdProvider(room.id));
      await tester.pumpAndSettle();
      await visible(tester, 'record-turn');
      expect(tester.widget<FilledButton>(key('record-turn')).onPressed, isNull);
      await tap(tester, 'clear-turn-draft');
      expect(
        tester.widget<FilledButton>(key('record-turn')).onPressed,
        isNotNull,
      );
      expect((await latest()).games.single.turns.length, 1);
    },
  );
  testWidgets('narrow room and edit dialogs scroll without overflow', (
    tester,
  ) async {
    await show(tester, size: const Size(320, 640));
    await tap(tester, 'pot-ball-9');
    await tap(tester, 'turn-foul');
    await tap(tester, 'edit-rules');
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Bỏ qua'));
    await tester.pumpAndSettle();
    await tap(tester, 'edit-order');
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Bỏ qua'));
    await tester.pumpAndSettle();
    await tap(tester, 'room-history');
    expect(tester.takeException(), isNull);
  });
}
