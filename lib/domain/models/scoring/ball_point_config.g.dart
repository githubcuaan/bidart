// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball_point_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BallPointConfig _$BallPointConfigFromJson(Map<String, dynamic> json) =>
    _BallPointConfig(
      enabled: json['enabled'] as bool,
      points: (json['points'] as num).toInt(),
    );

Map<String, dynamic> _$BallPointConfigToJson(_BallPointConfig instance) =>
    <String, dynamic>{'enabled': instance.enabled, 'points': instance.points};
