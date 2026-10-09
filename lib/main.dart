import 'package:bidart/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BidartApp());
}

class BidartApp extends StatelessWidget {
  const BidartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Mainscreen());
  }
}
