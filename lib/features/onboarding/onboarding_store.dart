import 'package:shared_preferences/shared_preferences.dart';

/// Version of the onboarding content. Increase it to show the introduction
/// again after a meaningful content update.
const onboardingVersion = 1;

/// Persisted key holding the last onboarding version the user completed.
const onboardingSeenKey = 'onboarding.seen_version';

/// Reads and writes the onboarding progress flag.
abstract interface class OnboardingStore {
  int get seenVersion;

  Future<void> markSeen(int version);
}

/// [OnboardingStore] backed by shared preferences.
class PrefsOnboardingStore implements OnboardingStore {
  PrefsOnboardingStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  int get seenVersion => _prefs.getInt(onboardingSeenKey) ?? 0;

  @override
  Future<void> markSeen(int version) =>
      _prefs.setInt(onboardingSeenKey, version);
}

/// Fallback used when preferences cannot be opened.
///
/// Treats onboarding as already seen so the app still opens and the
/// introduction does not reappear on every launch.
class SeenOnboardingStore implements OnboardingStore {
  const SeenOnboardingStore();

  @override
  int get seenVersion => onboardingVersion;

  @override
  Future<void> markSeen(int version) async {}
}
