// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  phone: json['phone'] as String,
  email: json['email'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String?,
  age: (json['age'] as num?)?.toInt() ?? 25,
  gender: json['gender'] as String? ?? 'Nam',
  address: json['address'] as String? ?? '',
  selfDeclaredLevel:
      $enumDecodeNullable(_$SkillLevelEnumMap, json['selfDeclaredLevel']) ??
      SkillLevel.kI,
  totalMatches: (json['totalMatches'] as num?)?.toInt() ?? 0,
  winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
  eloRating: (json['eloRating'] as num?)?.toInt() ?? 1500,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'phone': instance.phone,
  'email': instance.email,
  'avatarUrl': instance.avatarUrl,
  'age': instance.age,
  'gender': instance.gender,
  'address': instance.address,
  'selfDeclaredLevel': _$SkillLevelEnumMap[instance.selfDeclaredLevel]!,
  'totalMatches': instance.totalMatches,
  'winRate': instance.winRate,
  'eloRating': instance.eloRating,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$SkillLevelEnumMap = {
  SkillLevel.kI: 'kI',
  SkillLevel.h: 'h',
  SkillLevel.g: 'g',
  SkillLevel.f: 'f',
  SkillLevel.e: 'e',
  SkillLevel.d: 'd',
  SkillLevel.c: 'c',
  SkillLevel.b: 'b',
  SkillLevel.a: 'a',
};
