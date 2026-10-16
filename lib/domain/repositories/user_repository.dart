import 'package:bidart/domain/models/user/user.dart';

abstract interface class UserRepository {
  Future<User> getCurrentUser();
  Future<void> updateProfile(User user);
  Stream<User> watchCurrentUser();
}