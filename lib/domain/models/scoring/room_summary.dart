import 'room.dart';
import 'room_status.dart';

/// Lightweight room-list projection; aggregate history stays in getRoom.
class RoomSummary {
  RoomSummary.fromRoom(Room room)
    : id = room.id,
      name = room.name,
      status = room.status,
      createdAt = room.createdAt,
      activePlayerCount = room.activePlayerIds.length,
      gameCount = room.games.length,
      currentGameId = room.currentGameId;

  final String id;
  final String name;
  final RoomStatus status;
  final DateTime createdAt;
  final int activePlayerCount;
  final int gameCount;
  final String? currentGameId;
}
