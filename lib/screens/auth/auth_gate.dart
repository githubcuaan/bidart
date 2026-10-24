import 'package:bidart/features/auth/provider/auth_providers.dart';
import 'package:bidart/screens/auth/login_screen.dart';
import 'package:bidart/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  final Widget? child;

  const AuthGate({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateStreamProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return child ?? const Mainscreen();
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text('Lỗi xác thực: $e'),
        ),
      ),
    );
  }
}