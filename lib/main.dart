import 'package:bidart/data/local/app_database.dart';
import 'package:bidart/data/repositories/game_repository.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        gameRepositoryProvider.overrideWithValue(
          DriftGameRepository(database: database),
        ),
      ],
      child: const BidartApp(),
    ),
  );
}

class BidartApp extends StatelessWidget {
  const BidartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Bidart', home: Mainscreen());
  }
}
