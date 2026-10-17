import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/domain/models/user/user.dart';

export 'package:bidart/domain/models/user/user.dart';

extension UserCompatibility on User {
  String get avatar => avatarUrl ?? '';
  SkillLevel get level => selfDeclaredLevel;
}
