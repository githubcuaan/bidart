import 'package:bidart/domain/models/auth/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> watchAuthState();

  AuthUser? get currentUser;

  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  Future<AuthUser> signInAnonymously();

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();

  void dispose();
}