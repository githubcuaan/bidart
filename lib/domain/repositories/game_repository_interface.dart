import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/validation/validation_issue.dart';

enum RoomCommandType {
  create,
  update,
  startNextGame,
  recordTurn,
  undoLastTurn,
  finishRoom,
  cancelRoom,
  evaluateEndConditions,
  addPlayer,
  removePlayer,
  updateRules,
  reorderPlayers,
}

/// Immutable result at commit time, not the room's latest state.
class CommandReceipt {
  const CommandReceipt({
    required this.commandId,
    required this.type,
    required this.room,
  });

  final String commandId;
  final RoomCommandType type;
  final Room room;
}

/// Storage boundary. Services validate business rules before submitting rooms.
/// Implementations must detach caller-owned collections on writes and reads.
abstract interface class GameRepository {
  /// Newest created first, then ascending ID for timestamp ties.
  Future<List<Room>> listRooms({RoomStatus? status});
  Future<Room> getRoom(String roomId);
  Future<CommandReceipt?> getCommandReceipt(String commandId);

  /// Command IDs are global to this repository. Unchanged-input retries return
  /// the original receipt before any revision/active-room checks.
  Future<CommandReceipt> createRoom({
    required String commandId,
    required Room room,
  });

  /// Candidate revision must equal expectedRevision + 1. Aggregate and receipt
  /// commit together; failures leave both unchanged. Only one active room may
  /// exist, including after updates.
  Future<CommandReceipt> updateRoom({
    required String commandId,
    required int expectedRevision,
    required Room room,
    RoomCommandType type = RoomCommandType.update,
  });
}

sealed class RepositoryFailure implements Exception {
  const RepositoryFailure();
}

class RepositoryValidationFailure extends RepositoryFailure {
  RepositoryValidationFailure(
    this.message, {
    List<ValidationIssue> issues = const [],
  }) : issues = List.unmodifiable(issues);

  final String message;
  final List<ValidationIssue> issues;
}

class RoomNotFoundFailure extends RepositoryFailure {
  const RoomNotFoundFailure(this.roomId);
  final String roomId;
}

class ActiveRoomExistsFailure extends RepositoryFailure {
  const ActiveRoomExistsFailure(this.roomId);
  final String roomId;
}

class StaleRevisionFailure extends RepositoryFailure {
  const StaleRevisionFailure({required this.expected, required this.actual});
  final int expected;
  final int actual;
}

class PersistenceFailure extends RepositoryFailure {
  const PersistenceFailure(this.message);
  final String message;
}
