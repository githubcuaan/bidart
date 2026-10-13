import 'package:freezed_annotation/freezed_annotation.dart';

import 'chain_state.dart';
import 'game_status.dart';
import 'pending_end_reason.dart';
import 'room_status.dart';

part 'turn_state_snapshot.freezed.dart';
part 'turn_state_snapshot.g.dart';

/// Restorable gameplay state, not a recursive copy of the room aggregate.
/// Undo does not restore command revisions, receipts, history or the clock.
/// Pending-end reasons must be reevaluated against effective history and now.
@freezed
abstract class TurnStateSnapshot with _$TurnStateSnapshot {
  // Freezed forwards this annotation to the generated implementation class.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory TurnStateSnapshot({
    required String roomId,
    required String gameId,
    required Map<String, int> scores,
    required List<String> activePlayerIds,
    required List<String> playerOrder,
    required String currentPlayerId,
    String? previousPlayerId,
    required String payerId,
    required ChainState chainState,
    required Set<int> remainingBalls,
    required RoomStatus roomStatus,
    required GameStatus gameStatus,
    required DateTime roomCreatedAt,
    DateTime? roomEndedAt,
    required DateTime gameStartedAt,
    DateTime? gameEndedAt,
    String? winnerId,
    String? finalPayerId,
    required bool isBreakClear,
    required Set<PendingEndReason> pendingEndReasons,
  }) = _TurnStateSnapshot;

  factory TurnStateSnapshot.fromJson(Map<String, dynamic> json) =>
      _$TurnStateSnapshotFromJson(json);
}
