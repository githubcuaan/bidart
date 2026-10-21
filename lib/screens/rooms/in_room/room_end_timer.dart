import 'dart:async';

import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/services/end_condition_policy.dart';

/// Watches the room clock for end conditions: fires at the configured duration,
/// re-checks after lifecycle resumes, and throttles while a command is running.
class RoomEndTimer {
  RoomEndTimer({
    required this.roomId,
    required this.readRoom,
    required this.now,
    required this.isBusy,
    required this.onEvaluate,
  });

  final String roomId;
  final Future<Room> Function() readRoom;
  final DateTime Function() now;
  final bool Function() isBusy;
  final Future<void> Function(Room room) onEvaluate;

  int? _scheduledRevision;
  Timer? _timer;

  /// Arms the timer for a new revision. Returns true when the caller should
  /// request an immediate re-check after the frame.
  bool schedule(Room room) {
    if (_scheduledRevision == room.revision) return false;
    _scheduledRevision = room.revision;
    _timer?.cancel();
    final seconds = room.endConditions.durationSeconds;
    if (room.status == RoomStatus.active && seconds != null) {
      final delay = room.createdAt
          .add(Duration(seconds: seconds))
          .difference(now());
      if (delay > Duration.zero) _timer = Timer(delay, _evaluate);
    }
    return true;
  }

  void checkNow() => unawaited(_evaluate());

  /// Call after a reload so the next build re-arms the timer.
  void invalidateSchedule() => _scheduledRevision = null;

  void cancel() {
    _timer?.cancel();
    _scheduledRevision = null;
  }

  Future<void> _evaluate() async {
    try {
      final room = await readRoom();
      if (room.status != RoomStatus.active) return;
      if (isBusy()) {
        _timer?.cancel();
        _timer = Timer(const Duration(milliseconds: 100), _evaluate);
        return;
      }
      if (evaluateRoomEnd(room, now()) != room) await onEvaluate(room);
    } catch (_) {
      /* Load errors render through the read provider. */
    }
  }
}
