import 'package:bidart/core/enum/skill_level.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../base_entity.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User implements BaseEntity<String> {
  @JsonSerializable(explicitToJson: true)
  const factory User({
    required String id,
    required String name,
    @Default('') String description, 
    required String phone,
    @Default('') String email,
    String? avatarUrl,
    @Default(25) int age,
    @Default('Nam') String gender,
    @Default('') String address,
    @Default(SkillLevel.kI) SkillLevel selfDeclaredLevel,
    @Default(0) int totalMatches,
    @Default(0.0) double winRate,
    @Default(1500) int eloRating,
    DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
