import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/core/theme/theme_mode_controller.dart';
import 'package:bidart/data/local/app_database.dart';
import 'package:bidart/data/repositories/game_repository.dart';
import 'package:bidart/features/onboarding/onboarding_store.dart';
import 'package:bidart/features/onboarding/provider/onboarding_provider.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/screens/auth/auth_gate.dart';
import 'package:bidart/screens/main_screen.dart';
import 'package:bidart/screens/onboarding/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bidart/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<OnboardingStore> _openOnboardingStore() async {
  try {
    return PrefsOnboardingStore(await SharedPreferences.getInstance());
  } catch (error) {
    debugPrint('Could not read onboarding preferences: $error');
    return const SeenOnboardingStore();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
  if (!isTest) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Firebase init: $e');
    }
  }
  final onboardingStore = await _openOnboardingStore();
  final database = AppDatabase();
  runApp(
    ProviderScope(
      overrides: [
        onboardingStoreProvider.overrideWithValue(onboardingStore),
        appDatabaseProvider.overrideWithValue(database),
        gameRepositoryProvider.overrideWithValue(
          DriftGameRepository(database: database),
        ),
      ],
      child: const BidartApp(),
    ),
  );
}

class BidartApp extends ConsumerStatefulWidget {
  const BidartApp({super.key});

  @override
  ConsumerState<BidartApp> createState() => _BidartAppState();
}

class _BidartAppState extends ConsumerState<BidartApp> {
  bool _openCreateRoom = false;

  Future<void> _finishOnboarding(OnboardingExit exit) async {
    setState(() => _openCreateRoom = exit == OnboardingExit.createRoom);
    await ref.read(showOnboardingProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final showOnboarding = ref.watch(showOnboardingProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bidart',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      home: showOnboarding
          ? OnboardingScreen(onFinish: _finishOnboarding)
          : AuthGate(
              child: Mainscreen(openCreateRoomOnStart: _openCreateRoom),
            ),
    );
  }
}
