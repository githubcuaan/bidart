import 'package:bidart/screens/rooms/add_room/widgets/end_conditions_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController duration;
  late TextEditingController threshold;

  setUp(() {
    duration = TextEditingController();
    threshold = TextEditingController();
  });

  tearDown(() {
    duration.dispose();
    threshold.dispose();
  });

  Widget harness({
    bool enabled = true,
    String? durationError,
    String? thresholdError,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: EndConditionsFields(
              duration: duration,
              threshold: threshold,
              enabled: enabled,
              durationError: durationError,
              thresholdError: thresholdError,
              onChanged: () => setState(() {}),
            ),
          ),
        ),
      ),
    );
  }

  ChoiceChip chip(WidgetTester tester, String key) => tester.widget<ChoiceChip>(
    find.descendant(
      of: find.byKey(ValueKey(key)),
      matching: find.byType(ChoiceChip),
    ),
  );

  testWidgets('duration starts unlimited and presets write seconds', (
    tester,
  ) async {
    await tester.pumpWidget(harness());

    expect(chip(tester, 'duration-unlimited').selected, isTrue);
    expect(chip(tester, 'duration-3600').selected, isFalse);
    expect(chip(tester, 'duration-custom').selected, isFalse);

    await tester.tap(find.byKey(const ValueKey('duration-3600')));
    await tester.pump();

    expect(duration.text, '3600');
    expect(chip(tester, 'duration-unlimited').selected, isFalse);
    expect(chip(tester, 'duration-3600').selected, isTrue);
  });

  testWidgets('custom duration shows its value and keeps it on dismiss', (
    tester,
  ) async {
    duration.text = '4500';
    await tester.pumpWidget(harness());

    expect(chip(tester, 'duration-custom').selected, isTrue);
    expect(find.text('1 giờ 15 phút'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('duration-custom')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn thời lượng chơi'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(duration.text, '4500');
  });

  testWidgets('disabled state blocks chips and score input', (tester) async {
    duration.text = '3600';
    await tester.pumpWidget(harness(enabled: false));

    expect(chip(tester, 'duration-3600').onSelected, isNull);
    expect(chip(tester, 'duration-custom').onSelected, isNull);
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('score-threshold')))
          .enabled,
      isFalse,
    );
  });

  testWidgets('shows score validation below the field', (tester) async {
    await tester.pumpWidget(harness(thresholdError: 'Nhập số nguyên dương.'));

    expect(find.text('Ngưỡng điểm (tùy chọn)'), findsOneWidget);
    expect(find.text('Nhập số nguyên dương.'), findsOneWidget);
  });
}
