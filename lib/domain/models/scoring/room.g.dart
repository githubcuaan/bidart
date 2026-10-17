// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  ownerId: json['ownerId'] as String,
  mode: $enumDecode(_$RoomModeEnumMap, json['mode']),
  status: $enumDecode(_$RoomStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  revision: (json['revision'] as num).toInt(),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => PlayerInGame.fromJson(e as Map<String, dynamic>))
      .toList(),
  activePlayerIds: (json['activePlayerIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  playerOrder: (json['playerOrder'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  scores: Map<String, int>.from(json['scores'] as Map),
  ruleVersions: (json['ruleVersions'] as List<dynamic>)
      .map((e) => RuleConfig.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentRuleVersion: (json['currentRuleVersion'] as num).toInt(),
  games: (json['games'] as List<dynamic>)
      .map((e) => GameSession.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentGameId: json['currentGameId'] as String?,
  endConditions: EndConditions.fromJson(
    json['endConditions'] as Map<String, dynamic>,
  ),
  pendingEndReasons: (json['pendingEndReasons'] as List<dynamic>)
      .map((e) => $enumDecode(_$PendingEndReasonEnumMap, e))
      .toSet(),
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => RoomEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'ownerId': instance.ownerId,
  'mode': _$RoomModeEnumMap[instance.mode]!,
  'status': _$RoomStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'revision': instance.revision,
  'participants': instance.participants.map((e) => e.toJson()).toList(),
  'activePlayerIds': instance.activePlayerIds,
  'playerOrder': instance.playerOrder,
  'scores': instance.scores,
  'ruleVersions': instance.ruleVersions.map((e) => e.toJson()).toList(),
  'currentRuleVersion': instance.currentRuleVersion,
  'games': instance.games.map((e) => e.toJson()).toList(),
  'currentGameId': instance.currentGameId,
  'endConditions': instance.endConditions.toJson(),
  'pendingEndReasons': instance.pendingEndReasons
      .map((e) => _$PendingEndReasonEnumMap[e]!)
      .toList(),
  'events': instance.events.map((e) => e.toJson()).toList(),
};

const _$RoomModeEnumMap = {RoomMode.local: 'local', RoomMode.online: 'online'};

const _$RoomStatusEnumMap = {
  RoomStatus.active: 'active',
  RoomStatus.finished: 'finished',
  RoomStatus.cancelled: 'cancelled',
};

const _$PendingEndReasonEnumMap = {
  PendingEndReason.timeLimit: 'timeLimit',
  PendingEndReason.scoreThreshold: 'scoreThreshold',
};
