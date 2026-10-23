import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:bidart/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App entry point installs a provider scope', (tester) async {
    SharedPreferences.setMockInitialValues({
      onboardingSeenKey: onboardingVersion,
    });

    await app.main();
    await tester.pump();

    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.byType(app.BidartApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
