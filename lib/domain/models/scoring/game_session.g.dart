// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameSession _$GameSessionFromJson(Map<String, dynamic> json) => _GameSession(
  id: json['id'] as String,
  roomId: json['roomId'] as String,
  gameNumber: (json['gameNumber'] as num).toInt(),
  status: $enumDecode(_$GameStatusEnumMap, json['status']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  currentPlayerId: json['currentPlayerId'] as String,
  previousPlayerId: json['previousPlayerId'] as String?,
  payerId: json['payerId'] as String,
  playerOrder: (json['playerOrder'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  remainingBalls: (json['remainingBalls'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toSet(),
  chainState: ChainState.fromJson(json['chainState'] as Map<String, dynamic>),
  winnerId: json['winnerId'] as String?,
  finalPayerId: json['finalPayerId'] as String?,
  isBreakClear: json['isBreakClear'] as bool? ?? false,
  turns:
      (json['turns'] as List<dynamic>?)
          ?.map((e) => Turn.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GameSessionToJson(_GameSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'gameNumber': instance.gameNumber,
      'status': _$GameStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'currentPlayerId': instance.currentPlayerId,
      'previousPlayerId': instance.previousPlayerId,
      'payerId': instance.payerId,
      'playerOrder': instance.playerOrder,
      'remainingBalls': instance.remainingBalls.toList(),
      'chainState': instance.chainState.toJson(),
      'winnerId': instance.winnerId,
      'finalPayerId': instance.finalPayerId,
      'isBreakClear': instance.isBreakClear,
      'turns': instance.turns.map((e) => e.toJson()).toList(),
    };

const _$GameStatusEnumMap = {
  GameStatus.inProgress: 'inProgress',
  GameStatus.finished: 'finished',
  GameStatus.incomplete: 'incomplete',
  GameStatus.cancelled: 'cancelled',
};
