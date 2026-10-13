// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomEvent _$RoomEventFromJson(Map<String, dynamic> json) => _RoomEvent(
  id: json['id'] as String,
  roomId: json['roomId'] as String,
  commandId: json['commandId'] as String,
  revision: (json['revision'] as num).toInt(),
  type: $enumDecode(_$RoomEventTypeEnumMap, json['type']),
  beforeSnapshot: TurnStateSnapshot.fromJson(
    json['beforeSnapshot'] as Map<String, dynamic>,
  ),
  afterSnapshot: TurnStateSnapshot.fromJson(
    json['afterSnapshot'] as Map<String, dynamic>,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isUndoBarrier: json['isUndoBarrier'] as bool? ?? true,
);

Map<String, dynamic> _$RoomEventToJson(_RoomEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'commandId': instance.commandId,
      'revision': instance.revision,
      'type': _$RoomEventTypeEnumMap[instance.type]!,
      'beforeSnapshot': instance.beforeSnapshot.toJson(),
      'afterSnapshot': instance.afterSnapshot.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'isUndoBarrier': instance.isUndoBarrier,
    };

const _$RoomEventTypeEnumMap = {
  RoomEventType.addPlayer: 'addPlayer',
  RoomEventType.removePlayer: 'removePlayer',
  RoomEventType.updateRules: 'updateRules',
  RoomEventType.reorderPlayers: 'reorderPlayers',
};
