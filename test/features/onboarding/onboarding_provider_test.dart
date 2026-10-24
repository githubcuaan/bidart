import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:bidart/features/onboarding/provider/onboarding_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _ThrowingStore implements OnboardingStore {
  @override
  int get seenVersion => 0;

  @override
  Future<void> markSeen(int version) async {
    throw StateError('preferences unavailable');
  }
}

void main() {
  test('persistence failure still releases the onboarding gate', () async {
    final container = ProviderContainer(
      overrides: [onboardingStoreProvider.overrideWithValue(_ThrowingStore())],
    );
    addTearDown(container.dispose);

    expect(container.read(showOnboardingProvider), isTrue);

    await container.read(showOnboardingProvider.notifier).complete();

    expect(container.read(showOnboardingProvider), isFalse);
  });

  test('a seen version starts behind the onboarding gate', () {
    final container = ProviderContainer(
      overrides: [
        onboardingStoreProvider.overrideWithValue(const SeenOnboardingStore()),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(showOnboardingProvider), isFalse);
  });
}
