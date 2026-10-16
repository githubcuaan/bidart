// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RuleConfig _$RuleConfigFromJson(Map<String, dynamic> json) => _RuleConfig(
  id: json['id'] as String,
  version: (json['version'] as num).toInt(),
  ballPoints: _ballMapFromJson(json['ballPoints'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RuleConfigToJson(_RuleConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'ballPoints': _ballMapToJson(instance.ballPoints),
    };
