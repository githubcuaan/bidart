import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:bidart/features/onboarding/provider/onboarding_provider.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/screens/onboarding/onboarding_screen.dart';
import 'package:bidart/screens/profile/settings/account_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/onboarding_test_support.dart';

void main() {
  testWidgets('settings can replay onboarding without changing the flag', (
    tester,
  ) async {
    final store = MemoryOnboardingStore(seen: onboardingVersion);
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
        child: const MaterialApp(home: AccountSettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('onboarding-replay-tile')));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding-close')), findsOneWidget);
    expect(store.markCalls, 0);

    await tester.tap(find.byKey(const ValueKey('onboarding-close')));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(store.seenVersion, onboardingVersion);
    expect(store.markCalls, 0);
  });
}
