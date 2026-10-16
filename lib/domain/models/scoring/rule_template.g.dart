// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RuleTemplate _$RuleTemplateFromJson(Map<String, dynamic> json) =>
    _RuleTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      ballPoints: _ballMapFromJson(json['ballPoints'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RuleTemplateToJson(_RuleTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ballPoints': _ballMapToJson(instance.ballPoints),
      'createdAt': instance.createdAt.toIso8601String(),
    };
