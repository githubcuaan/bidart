import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/screens/home.dart';
import 'package:bidart/screens/maps.dart';
import 'package:bidart/screens/main_screen.dart';
import 'package:bidart/screens/people/people.dart';
import 'package:bidart/screens/profile.dart';
import 'package:bidart/screens/rooms/rooms.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(InMemoryGameRepository()),
      ],
    );
  });
  tearDown(() => container.dispose());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Mainscreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder appBarTitle(String value) =>
      find.descendant(of: find.byType(AppBar), matching: find.text(value));

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(NavigationDestination, label));
    await tester.pumpAndSettle();
  }

  testWidgets('Single app bar and scaffold host every tab', (tester) async {
    await pumpApp(tester);

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(appBarTitle('Bidart'), findsOneWidget);

    for (final entry in {
      'Room': 'Rooms',
      'Map': 'Map',
      'People': 'People',
      'Home': 'Bidart',
    }.entries) {
      await openTab(tester, entry.key);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(appBarTitle(entry.value), findsOneWidget);
    }
  });

  testWidgets('Switching tabs rebuilds content and keeps its state', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(Rooms), findsNothing);

    await openTab(tester, 'Room');
    expect(find.byType(Rooms), findsOneWidget);
    expect(find.text('Chưa có phòng trong danh sách này.'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('room-status-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đã hủy').last);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DropdownButton<Object?>>(
            find.byKey(const ValueKey('room-status-filter')),
          )
          .value,
      isNotNull,
    );

    await openTab(tester, 'Home');
    expect(find.byType(Home), findsOneWidget);
    expect(find.text('Bidart'), findsOneWidget);

    await openTab(tester, 'Room');
    expect(
      tester
          .widget<DropdownButton<Object?>>(
            find.byKey(const ValueKey('room-status-filter')),
          )
          .value,
      isNotNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Drawer opens profile above the active tab', (tester) async {
    await pumpApp(tester);
    await openTab(tester, 'Map');

    expect(appBarTitle('Map'), findsOneWidget);
    await tester.tap(find.byTooltip('Mở hồ sơ'));
    await tester.pumpAndSettle();
    expect(find.byType(Profile), findsOneWidget);
    expect(find.text('Tuấn Anh'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    await tester.tapAt(const Offset(10, 400));
    await tester.pumpAndSettle();
    expect(find.byType(Profile), findsNothing);
    expect(appBarTitle('Map'), findsOneWidget);
  });

  testWidgets('Placeholder tabs render without extra shells', (tester) async {
    await pumpApp(tester);

    for (final tab in [Home(), Maps(), People()]) {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: Scaffold(body: tab)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppScreen), findsNothing);
    }
  });
}
