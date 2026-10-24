import 'package:bidart/screens/profile.dart';
import 'package:bidart/screens/profile/widgets/profile_edit_screen.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> openEditor(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Host')),
          endDrawer: const Drawer(child: Profile()),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Tuấn Anh'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppScreen), findsNothing);

    await tester.tap(find.byTooltip('Chỉnh sửa hồ sơ'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileEditScreen), findsOneWidget);
    expect(find.byType(AppScreen), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppScreen),
        matching: find.byType(Scaffold),
      ),
      findsOneWidget,
    );
  }

  Finder field(String label) =>
      find.ancestor(of: find.text(label), matching: find.byType(TextFormField));

  testWidgets('Drawer opens editor; validation preserves entered values', (
    tester,
  ) async {
    await openEditor(tester);
    await tester.enterText(field('Tên hiển thị *'), '   ');
    await tester.enterText(field('Số điện thoại'), 'abc');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pump();

    expect(find.text('Nhập tên'), findsOneWidget);
    expect(find.text('SĐT chưa đúng'), findsOneWidget);
    expect(find.byType(ProfileEditScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      tester.widget<TextFormField>(field('Số điện thoại')).controller!.text,
      'abc',
    );
  });

  testWidgets('Save locks buttons then returns and shows confirmation', (
    tester,
  ) async {
    await openEditor(tester);
    await tester.enterText(field('Tên hiển thị *'), 'Tên mới');
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileEditScreen), findsNothing);
    expect(find.text('Đã lưu thay đổi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cancel disposes editor; reopening creates a fresh form', (
    tester,
  ) async {
    await openEditor(tester);
    await tester.enterText(field('Tên hiển thị *'), 'Bản nháp');
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileEditScreen), findsNothing);

    await tester.tap(find.byTooltip('Chỉnh sửa hồ sơ'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextFormField>(field('Tên hiển thị *')).controller!.text,
      'Tuấn Anh',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Disposing during save does not navigate or notify later', (
    tester,
  ) async {
    await openEditor(tester);
    await tester.tap(find.text('Lưu thay đổi'));
    await tester.pump();
    await tester.pumpWidget(
      MaterialApp(
        key: UniqueKey(),
        home: const Scaffold(body: Text('Other page')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileEditScreen), findsNothing);
    expect(find.text('Other page'), findsOneWidget);
    expect(find.byType(AppScreen), findsNothing);
    expect(find.text('Đã lưu thay đổi'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
