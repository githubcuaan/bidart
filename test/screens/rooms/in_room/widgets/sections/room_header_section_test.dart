import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/room_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final startedAt = DateTime.utc(2026, 10, 15, 12);

  Room room({required RoomStatus status}) => Room(
    id: 'room-1',
    name: 'Phòng #09',
    ownerId: 'a',
    mode: RoomMode.local,
    status: status,
    createdAt: startedAt,
    revision: 1,
    participants: const [],
    activePlayerIds: const [],
    playerOrder: const [],
    scores: const {},
    ruleVersions: const [],
    currentRuleVersion: 1,
    games: const [],
    endConditions: const EndConditions(
      durationSeconds: 5400,
      scoreThreshold: 100,
    ),
    pendingEndReasons: const {},
  );

  Widget harness(Room room) => MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 360,
        child: RoomHeaderSection(
          room: room,
          now: () => startedAt.add(const Duration(minutes: 30)),
        ),
      ),
    ),
  );

  testWidgets('live room shows status, clock and score target', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness(room(status: RoomStatus.active)));

    expect(find.text('LIVE MATCH'), findsOneWidget);
    expect(find.text('Phòng #09'), findsOneWidget);
    expect(find.text('1:00:00'), findsOneWidget);
    expect(find.text('Mục tiêu'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('finished room shows read-only label and configured limit', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness(room(status: RoomStatus.finished)));

    expect(
      find.text('Phòng chỉ đọc — không thể thay đổi kết quả.'),
      findsOneWidget,
    );
    expect(find.text('LIVE MATCH'), findsNothing);
    expect(find.text('Thời lượng'), findsOneWidget);
    expect(find.text('1:30:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
