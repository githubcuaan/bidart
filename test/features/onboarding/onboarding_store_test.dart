import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<PrefsOnboardingStore> storeWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return PrefsOnboardingStore(await SharedPreferences.getInstance());
  }

  test('missing key means onboarding has not been seen', () async {
    final store = await storeWith({});
    expect(store.seenVersion, 0);
    expect(store.seenVersion, lessThan(onboardingVersion));
  });

  test('reads the persisted version', () async {
    final store = await storeWith({onboardingSeenKey: 1});
    expect(store.seenVersion, 1);
    expect(store.seenVersion, greaterThanOrEqualTo(onboardingVersion));
  });

  test('markSeen persists the current version', () async {
    final store = await storeWith({});
    await store.markSeen(onboardingVersion);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(onboardingSeenKey), onboardingVersion);
    expect(store.seenVersion, onboardingVersion);
  });

  test('marking twice is idempotent', () async {
    final store = await storeWith({});
    await store.markSeen(onboardingVersion);
    await store.markSeen(onboardingVersion);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(onboardingSeenKey), onboardingVersion);
  });

  test('a future version also counts as seen', () async {
    final store = await storeWith({onboardingSeenKey: onboardingVersion + 1});
    expect(store.seenVersion, greaterThan(onboardingVersion));
  });

  test('negative stored values still show onboarding', () async {
    final store = await storeWith({onboardingSeenKey: -1});
    expect(store.seenVersion, lessThan(onboardingVersion));
  });
}
