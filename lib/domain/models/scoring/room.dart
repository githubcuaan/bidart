import 'package:freezed_annotation/freezed_annotation.dart';

import 'end_conditions.dart';
import 'game_session.dart';
import 'pending_end_reason.dart';
import 'player_in_game.dart';
import 'room_mode.dart';
import 'room_status.dart';
import 'room_event.dart';
import 'rule_config.dart';
import '../base_entity.dart';

part 'room.freezed.dart';
part 'room.g.dart';

/// Room aggregate: many games, cumulative scores. Scores include departed
/// players and must sum to zero. Rule versions immutable; turns reference
/// the version used at confirmation. Templates stay independent.
@freezed
abstract class Room with _$Room implements BaseEntity<String>{
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Room({
    required String id,
    required String name,
    @Default('') String description,
    required String ownerId,
    required RoomMode mode,
    required RoomStatus status,
    required DateTime createdAt,
    DateTime? endedAt,
    required int revision,
    required List<PlayerInGame> participants,
    required List<String> activePlayerIds,
    required List<String> playerOrder,
    required Map<String, int> scores,
    required List<RuleConfig> ruleVersions,
    required int currentRuleVersion,
    required List<GameSession> games,
    String? currentGameId,
    required EndConditions endConditions,
    required Set<PendingEndReason> pendingEndReasons,
    @Default([]) List<RoomEvent> events,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
