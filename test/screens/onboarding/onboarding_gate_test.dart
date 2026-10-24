import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:bidart/features/onboarding/provider/onboarding_provider.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/main.dart';
import 'package:bidart/screens/main_screen.dart';
import 'package:bidart/screens/onboarding/onboarding_screen.dart';
import 'package:bidart/screens/rooms/add_room/add_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/onboarding_test_support.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    required MemoryOnboardingStore store,
  }) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingStoreProvider.overrideWithValue(store),
          gameRepositoryProvider.overrideWithValue(InMemoryGameRepository()),
        ],
        child: const BidartApp(),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> goToLastPage(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byKey(const ValueKey('onboarding-primary-cta')));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('first launch shows onboarding instead of the main screen', (
    tester,
  ) async {
    await pumpApp(tester, store: MemoryOnboardingStore());

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(Mainscreen), findsNothing);
    expect(find.text('Ghi điểm chuẩn.\nChơi hết mình.'), findsOneWidget);
  });

  testWidgets('a seen version skips onboarding', (tester) async {
    await pumpApp(
      tester,
      store: MemoryOnboardingStore(seen: onboardingVersion),
    );

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(Mainscreen), findsOneWidget);
  });

  testWidgets('finishing persists the version and opens create room', (
    tester,
  ) async {
    final store = MemoryOnboardingStore();
    await pumpApp(tester, store: store);
    await goToLastPage(tester);

    await tester.tap(find.byKey(const ValueKey('onboarding-primary-cta')));
    await tester.pumpAndSettle();

    expect(store.seenVersion, onboardingVersion);
    expect(store.markCalls, 1);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(Mainscreen, skipOffstage: false), findsOneWidget);
    expect(find.byType(AddRoom), findsOneWidget);
  });

  testWidgets('exploring from the last page stays on the main screen', (
    tester,
  ) async {
    final store = MemoryOnboardingStore();
    await pumpApp(tester, store: store);
    await goToLastPage(tester);

    await tester.tap(find.byKey(const ValueKey('onboarding-secondary-cta')));
    await tester.pumpAndSettle();

    expect(store.seenVersion, onboardingVersion);
    expect(find.byType(Mainscreen), findsOneWidget);
    expect(find.byType(AddRoom), findsNothing);
  });

  testWidgets('skipping persists the version and does not open create room', (
    tester,
  ) async {
    final store = MemoryOnboardingStore();
    await pumpApp(tester, store: store);

    await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
    await tester.pumpAndSettle();

    expect(store.seenVersion, onboardingVersion);
    expect(store.markCalls, 1);
    expect(find.byType(Mainscreen), findsOneWidget);
    expect(find.byType(AddRoom), findsNothing);
  });
}
