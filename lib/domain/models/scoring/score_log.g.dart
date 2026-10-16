// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScoreLog _$ScoreLogFromJson(Map<String, dynamic> json) => _ScoreLog(
  participantId: json['participantId'] as String,
  previousScore: (json['previousScore'] as num).toInt(),
  newScore: (json['newScore'] as num).toInt(),
);

Map<String, dynamic> _$ScoreLogToJson(_ScoreLog instance) => <String, dynamic>{
  'participantId': instance.participantId,
  'previousScore': instance.previousScore,
  'newScore': instance.newScore,
};
