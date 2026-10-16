// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'potted_ball.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PottedBall _$PottedBallFromJson(Map<String, dynamic> json) => _PottedBall(
  ballNumber: (json['ballNumber'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  isRespotted: json['isRespotted'] as bool,
);

Map<String, dynamic> _$PottedBallToJson(_PottedBall instance) =>
    <String, dynamic>{
      'ballNumber': instance.ballNumber,
      'points': instance.points,
      'isRespotted': instance.isRespotted,
    };
