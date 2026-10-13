// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_conditions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EndConditions _$EndConditionsFromJson(Map<String, dynamic> json) =>
    _EndConditions(
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      scoreThreshold: (json['scoreThreshold'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EndConditionsToJson(_EndConditions instance) =>
    <String, dynamic>{
      'durationSeconds': instance.durationSeconds,
      'scoreThreshold': instance.scoreThreshold,
    };
