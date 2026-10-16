import 'dart:async';

import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  InMemoryUserRepository({User? initialUser})
      : _currentUser = initialUser ??
            User(
              id: 'usr_tuananh',
              name: 'Tuấn Anh',
              phone: '0901 234 567',
              email: 'tuananh@example.com',
              age: 27,
              gender: 'Nam',
              address: 'Cầu Giấy, Hà Nội',
              selfDeclaredLevel: SkillLevel.b,
              totalMatches: 142,
              winRate: 68.0,
              eloRating: 1680,
              createdAt: DateTime.now(),
            ) {
    _controller = StreamController<User>.broadcast(
      onListen: () => _controller.add(_currentUser),
    );
  }

  User _currentUser;
  late final StreamController<User> _controller;

  @override
  Future<User> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> updateProfile(User user) async {
    _currentUser = user;
    _controller.add(_currentUser);
  }

  @override
  Stream<User> watchCurrentUser() => _controller.stream;

  void dispose() {
    _controller.close();
  }
}