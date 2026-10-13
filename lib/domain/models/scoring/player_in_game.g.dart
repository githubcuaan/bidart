// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_in_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerInGame _$PlayerInGameFromJson(Map<String, dynamic> json) =>
    _PlayerInGame(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      leftAt: json['leftAt'] == null
          ? null
          : DateTime.parse(json['leftAt'] as String),
    );

Map<String, dynamic> _$PlayerInGameToJson(_PlayerInGame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'leftAt': instance.leftAt?.toIso8601String(),
    };
