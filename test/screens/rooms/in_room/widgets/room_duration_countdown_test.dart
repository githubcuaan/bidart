import 'package:bidart/screens/rooms/in_room/widgets/room_duration_countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final startedAt = DateTime.utc(2026, 10, 15, 12);

  Widget harness({
    required int durationSeconds,
    required bool active,
    required DateTime Function() now,
  }) => MaterialApp(
    home: Scaffold(
      body: RoomDurationCountdown(
        startedAt: startedAt,
        durationSeconds: durationSeconds,
        active: active,
        now: now,
      ),
    ),
  );

  testWidgets('counts down hours/minutes, then switches to minutes/seconds', (
    tester,
  ) async {
    var now = startedAt.add(const Duration(minutes: 30));
    await tester.pumpWidget(
      harness(durationSeconds: 5400, active: true, now: () => now),
    );
    expect(find.text('Thời lượng còn lại: 1 giờ 00 phút'), findsOneWidget);

    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Thời lượng còn lại: 59 phút 59 giây'), findsOneWidget);

    now = now.add(const Duration(minutes: 25));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Thời lượng còn lại: 34 phút 59 giây'), findsOneWidget);

    now = startedAt.add(const Duration(minutes: 90));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Thời lượng còn lại: 0 phút 00 giây'), findsOneWidget);
  });

  testWidgets('inactive room shows the configured duration', (tester) async {
    await tester.pumpWidget(
      harness(
        durationSeconds: 5400,
        active: false,
        now: () => startedAt.add(const Duration(hours: 3)),
      ),
    );

    expect(find.text('Thời lượng: 1 giờ 30 phút'), findsOneWidget);
  });

  testWidgets('compact countdown ticks every second over an hour', (
    tester,
  ) async {
    var now = startedAt.add(const Duration(minutes: 30));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomDurationCountdown(
            startedAt: startedAt,
            durationSeconds: 5400,
            active: true,
            now: () => now,
            compact: true,
          ),
        ),
      ),
    );
    expect(find.text('1:00:00'), findsOneWidget);

    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('59:59'), findsOneWidget);
  });
}
