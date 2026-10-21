import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('is open by default and toggles from its header', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SectionCard(title: 'Thông tin phòng', child: Text('Nội dung')),
      ),
    );

    expect(find.text('Nội dung'), findsOneWidget);
    expect(find.byTooltip('Thu gọn'), findsOneWidget);

    await tester.tap(find.text('Thông tin phòng'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung'), findsNothing);
    expect(find.byTooltip('Mở rộng'), findsOneWidget);

    await tester.tap(find.text('Thông tin phòng'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung'), findsOneWidget);
    expect(find.byTooltip('Thu gọn'), findsOneWidget);
  });

  testWidgets('toggle button collapses and expands the card', (tester) async {
    await tester.pumpWidget(
      wrap(const SectionCard(title: 'Cấu hình', child: Text('Nội dung'))),
    );

    await tester.tap(find.byTooltip('Thu gọn'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung'), findsNothing);

    await tester.tap(find.byTooltip('Mở rộng'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung'), findsOneWidget);
  });

  testWidgets('can start collapsed', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SectionCard(
          title: 'Đóng sẵn',
          initiallyExpanded: false,
          child: Text('Nội dung'),
        ),
      ),
    );

    expect(find.text('Nội dung'), findsNothing);
    await tester.tap(find.text('Đóng sẵn'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung'), findsOneWidget);
  });

  testWidgets('non-collapsible cards hide the toggle', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SectionCard(
          title: 'Cố định',
          collapsible: false,
          child: Text('Nội dung'),
        ),
      ),
    );

    expect(find.text('Nội dung'), findsOneWidget);
    expect(find.byTooltip('Thu gọn'), findsNothing);
    expect(find.byTooltip('Mở rộng'), findsNothing);
  });
}
