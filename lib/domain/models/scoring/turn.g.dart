// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Turn _$TurnFromJson(Map<String, dynamic> json) => _Turn(
  id: json['id'] as String,
  commandId: json['commandId'] as String,
  roomId: json['roomId'] as String,
  gameId: json['gameId'] as String,
  turnNumber: (json['turnNumber'] as num).toInt(),
  actorId: json['actorId'] as String,
  payerIds: (json['payerIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  ruleConfigId: json['ruleConfigId'] as String,
  ruleVersion: (json['ruleVersion'] as num).toInt(),
  pottedBalls: (json['pottedBalls'] as List<dynamic>)
      .map((e) => PottedBall.fromJson(e as Map<String, dynamic>))
      .toList(),
  foulClassification: $enumDecode(
    _$FoulClassificationEnumMap,
    json['foulClassification'],
  ),
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => ScoreTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  logs: (json['logs'] as List<dynamic>)
      .map((e) => ScoreLog.fromJson(e as Map<String, dynamic>))
      .toList(),
  beforeSnapshot: TurnStateSnapshot.fromJson(
    json['beforeSnapshot'] as Map<String, dynamic>,
  ),
  afterSnapshot: TurnStateSnapshot.fromJson(
    json['afterSnapshot'] as Map<String, dynamic>,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isUndone: json['isUndone'] as bool? ?? false,
);

Map<String, dynamic> _$TurnToJson(_Turn instance) => <String, dynamic>{
  'id': instance.id,
  'commandId': instance.commandId,
  'roomId': instance.roomId,
  'gameId': instance.gameId,
  'turnNumber': instance.turnNumber,
  'actorId': instance.actorId,
  'payerIds': instance.payerIds,
  'ruleConfigId': instance.ruleConfigId,
  'ruleVersion': instance.ruleVersion,
  'pottedBalls': instance.pottedBalls.map((e) => e.toJson()).toList(),
  'foulClassification':
      _$FoulClassificationEnumMap[instance.foulClassification]!,
  'transactions': instance.transactions.map((e) => e.toJson()).toList(),
  'logs': instance.logs.map((e) => e.toJson()).toList(),
  'beforeSnapshot': instance.beforeSnapshot.toJson(),
  'afterSnapshot': instance.afterSnapshot.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'isUndone': instance.isUndone,
};

const _$FoulClassificationEnumMap = {
  FoulClassification.none: 'none',
  FoulClassification.th1: 'th1',
  FoulClassification.th2: 'th2',
  FoulClassification.potAndFoul: 'potAndFoul',
};
