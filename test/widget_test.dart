import 'package:bidart/main.dart';
import 'package:bidart/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App starts with an empty scaffold', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BidartApp()));

    expect(find.byType(Scaffold), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Bidart');
    expect(app.theme?.brightness, Brightness.light);
    expect(app.darkTheme?.brightness, Brightness.dark);
    expect(app.themeMode, ThemeMode.system);
    expect(tester.takeException(), isNull);
  });

  testWidgets('App entry point installs a provider scope', (tester) async {
    app.main();
    await tester.pump();

    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.byType(BidartApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Theme toggle switches between light and dark', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BidartApp()));

    MaterialApp materialApp() =>
        tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp().themeMode, ThemeMode.system);
    expect(
      Theme.of(tester.element(find.byKey(const ValueKey('theme-mode-toggle'))))
          .brightness,
      Brightness.light,
    );

    await tester.tap(find.byKey(const ValueKey('theme-mode-toggle')));
    await tester.pumpAndSettle();
    expect(materialApp().themeMode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byKey(const ValueKey('theme-mode-toggle'))))
          .brightness,
      Brightness.dark,
    );

    await tester.tap(find.byKey(const ValueKey('theme-mode-toggle')));
    await tester.pumpAndSettle();
    expect(materialApp().themeMode, ThemeMode.light);
    expect(tester.takeException(), isNull);
  });
}
