import 'package:bidart/features/onboarding/onboarding_store.dart';

/// In-memory [OnboardingStore] used by widget and gate tests.
class MemoryOnboardingStore implements OnboardingStore {
  MemoryOnboardingStore({this.seen = 0});

  int seen;
  int markCalls = 0;

  @override
  int get seenVersion => seen;

  @override
  Future<void> markSeen(int version) async {
    markCalls++;
    seen = version;
  }
}
