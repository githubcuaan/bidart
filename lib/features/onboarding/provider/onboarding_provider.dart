import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Injected in `main()` once shared preferences have been loaded.
final onboardingStoreProvider = Provider<OnboardingStore>(
  (ref) => throw UnimplementedError(
    'onboardingStoreProvider must be overridden in main()',
  ),
);

/// Whether the introduction should be shown instead of the main screen.
final showOnboardingProvider = NotifierProvider<ShowOnboardingController, bool>(
  ShowOnboardingController.new,
);

class ShowOnboardingController extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(onboardingStoreProvider).seenVersion < onboardingVersion;

  /// Marks the current version as seen and closes the introduction.
  ///
  /// A persistence failure must not trap the user in onboarding, so the UI is
  /// released either way and the error is only logged.
  Future<void> complete() async {
    try {
      await ref.read(onboardingStoreProvider).markSeen(onboardingVersion);
    } catch (error) {
      debugPrint('Could not persist onboarding progress: $error');
    } finally {
      state = false;
    }
  }
}
