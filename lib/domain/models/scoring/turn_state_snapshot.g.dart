// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn_state_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TurnStateSnapshot _$TurnStateSnapshotFromJson(Map<String, dynamic> json) =>
    _TurnStateSnapshot(
      roomId: json['roomId'] as String,
      gameId: json['gameId'] as String,
      scores: Map<String, int>.from(json['scores'] as Map),
      activePlayerIds: (json['activePlayerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      playerOrder: (json['playerOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      currentPlayerId: json['currentPlayerId'] as String,
      previousPlayerId: json['previousPlayerId'] as String?,
      payerId: json['payerId'] as String,
      chainState: ChainState.fromJson(
        json['chainState'] as Map<String, dynamic>,
      ),
      remainingBalls: (json['remainingBalls'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toSet(),
      roomStatus: $enumDecode(_$RoomStatusEnumMap, json['roomStatus']),
      gameStatus: $enumDecode(_$GameStatusEnumMap, json['gameStatus']),
      roomCreatedAt: DateTime.parse(json['roomCreatedAt'] as String),
      roomEndedAt: json['roomEndedAt'] == null
          ? null
          : DateTime.parse(json['roomEndedAt'] as String),
      gameStartedAt: DateTime.parse(json['gameStartedAt'] as String),
      gameEndedAt: json['gameEndedAt'] == null
          ? null
          : DateTime.parse(json['gameEndedAt'] as String),
      winnerId: json['winnerId'] as String?,
      finalPayerId: json['finalPayerId'] as String?,
      isBreakClear: json['isBreakClear'] as bool,
      pendingEndReasons: (json['pendingEndReasons'] as List<dynamic>)
          .map((e) => $enumDecode(_$PendingEndReasonEnumMap, e))
          .toSet(),
    );

Map<String, dynamic> _$TurnStateSnapshotToJson(_TurnStateSnapshot instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'gameId': instance.gameId,
      'scores': instance.scores,
      'activePlayerIds': instance.activePlayerIds,
      'playerOrder': instance.playerOrder,
      'currentPlayerId': instance.currentPlayerId,
      'previousPlayerId': instance.previousPlayerId,
      'payerId': instance.payerId,
      'chainState': instance.chainState.toJson(),
      'remainingBalls': instance.remainingBalls.toList(),
      'roomStatus': _$RoomStatusEnumMap[instance.roomStatus]!,
      'gameStatus': _$GameStatusEnumMap[instance.gameStatus]!,
      'roomCreatedAt': instance.roomCreatedAt.toIso8601String(),
      'roomEndedAt': instance.roomEndedAt?.toIso8601String(),
      'gameStartedAt': instance.gameStartedAt.toIso8601String(),
      'gameEndedAt': instance.gameEndedAt?.toIso8601String(),
      'winnerId': instance.winnerId,
      'finalPayerId': instance.finalPayerId,
      'isBreakClear': instance.isBreakClear,
      'pendingEndReasons': instance.pendingEndReasons
          .map((e) => _$PendingEndReasonEnumMap[e]!)
          .toList(),
    };

const _$RoomStatusEnumMap = {
  RoomStatus.active: 'active',
  RoomStatus.finished: 'finished',
  RoomStatus.cancelled: 'cancelled',
};

const _$GameStatusEnumMap = {
  GameStatus.inProgress: 'inProgress',
  GameStatus.finished: 'finished',
  GameStatus.incomplete: 'incomplete',
  GameStatus.cancelled: 'cancelled',
};

const _$PendingEndReasonEnumMap = {
  PendingEndReason.timeLimit: 'timeLimit',
  PendingEndReason.scoreThreshold: 'scoreThreshold',
};
