import 'package:bidart/core/enum/skill_level.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final SkillLevel level;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.phone = '',
    this.level = SkillLevel.kI,
  });

  User copyWith({
    String? name,
    String? email,
    String? avatar,
    String? phone,
    SkillLevel? level,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      level: level ?? this.level,
    );
  }
}