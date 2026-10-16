import '../models/scoring/game_status.dart';
import '../models/scoring/pending_end_reason.dart';
import '../models/scoring/room.dart';
import '../models/scoring/room_status.dart';

/// Recompute from effective history, not a sticky flag. Clock never rolls back
/// with turn snapshots. An already closed room is immutable.
Room evaluateRoomEnd(Room room, DateTime now) {
  if (room.status != RoomStatus.active) return room;
  final reasons = <PendingEndReason>{};
  final duration = room.endConditions.durationSeconds;
  final threshold = room.endConditions.scoreThreshold;
  bool reached(Map<String, int> scores) =>
      threshold != null && scores.values.any((s) => s >= threshold);
  if (duration != null &&
      !now.isBefore(room.createdAt.add(Duration(seconds: duration)))) {
    reasons.add(PendingEndReason.timeLimit);
  }
  if (reached(room.scores) ||
      room.games.any(
        (game) => game.turns.any(
          (turn) =>
              !turn.isUndone &&
              (reached(turn.beforeSnapshot.scores) ||
                  reached(turn.afterSnapshot.scores)),
        ),
      )) {
    reasons.add(PendingEndReason.scoreThreshold);
  }
  final finished =
      reasons.isNotEmpty &&
      room.games.isNotEmpty &&
      room.games.last.status == GameStatus.finished;
  return room.copyWith(
    pendingEndReasons: reasons,
    status: finished ? RoomStatus.finished : RoomStatus.active,
    endedAt: finished ? now : null,
  );
}
