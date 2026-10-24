import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:bidart/features/onboarding/provider/onboarding_provider.dart';
import 'package:bidart/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/onboarding_test_support.dart';

void main() {
  Widget buildApp({int seen = onboardingVersion}) {
    return ProviderScope(
      overrides: [
        onboardingStoreProvider.overrideWithValue(
          MemoryOnboardingStore(seen: seen),
        ),
      ],
      child: const BidartApp(),
    );
  }

  testWidgets('App starts with an empty scaffold', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Bidart');
    expect(app.theme?.brightness, Brightness.light);
    expect(app.darkTheme?.brightness, Brightness.dark);
    expect(app.themeMode, ThemeMode.system);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Theme toggle switches between light and dark', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

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
