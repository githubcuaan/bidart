import 'package:bidart/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: BidartApp()));
}

class BidartApp extends StatelessWidget {
  const BidartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Bidart', home: Mainscreen());
  }
}
