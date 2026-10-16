import 'package:freezed_annotation/freezed_annotation.dart';

import 'room_event_type.dart';
import 'turn_state_snapshot.dart';
import 'rule_config.dart';

part 'room_event.freezed.dart';
part 'room_event.g.dart';

/// Roster/rules/order edit. Carries revision, before/after edit data and
/// is always an undo barrier: turn undo cannot cross it.
@freezed
abstract class RoomEvent with _$RoomEvent {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory RoomEvent({
    required String id,
    required String roomId,
    required String commandId,
    required int revision,
    required RoomEventType type,
    required TurnStateSnapshot beforeSnapshot,
    required TurnStateSnapshot afterSnapshot,
    required DateTime createdAt,
    RuleConfig? beforeRules,
    RuleConfig? afterRules,
    @Default(true) bool isUndoBarrier,
  }) = _RoomEvent;

  factory RoomEvent.fromJson(Map<String, dynamic> json) =>
      _$RoomEventFromJson(json);
}
