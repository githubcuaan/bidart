import 'dart:async';

import 'package:bidart/domain/models/auth/auth_user.dart';
import 'package:bidart/domain/repositories/auth_repository.dart';
import 'package:uuid/uuid.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository({AuthUser? initialUser}) : _currentUser = initialUser {
    _controller = StreamController<AuthUser?>.broadcast(
      onListen: () => _controller.add(_currentUser),
    );
  }

  AuthUser? _currentUser;
  late final StreamController<AuthUser?> _controller;
  final _uuid = const Uuid();

  @override
  Stream<AuthUser?> watchAuthState() => _controller.stream;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    final user = AuthUser(
      id: 'usr_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
      email: email,
      displayName: email.split('@').first,
    );
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }

    final user = AuthUser(
      id: 'usr_${_uuid.v4().substring(0, 8)}',
      email: email,
      displayName: displayName ?? email.split('@').first,
    );
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  @override
  Future<AuthUser> signInAnonymously() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final user = AuthUser(
      id: 'guest_${_uuid.v4().substring(0, 6)}',
      displayName: 'Khách',
      isAnonymous: true,
    );
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _controller.add(null);
  }

  @override
  void dispose() {
    _controller.close();
  }
}