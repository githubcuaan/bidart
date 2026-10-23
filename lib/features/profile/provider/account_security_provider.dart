import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSecurityController extends Notifier<String> {
  @override
  String build() => '123456';

  bool verifyPassword(String password) => state == password;

  bool changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    if (!verifyPassword(currentPassword)) return false;
    state = newPassword;
    return true;
  }

  bool deleteAccount({required String password}) {
    if (!verifyPassword(password)) return false;
    state = '123456';
    return true;
  }
}

final accountSecurityProvider =
    NotifierProvider<AccountSecurityController, String>(
  AccountSecurityController.new,
);
