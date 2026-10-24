import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/room_summary.dart';

class HomeSnapshot {
  const HomeSnapshot({
    required this.active,
    required this.recent,
    required this.roomCount,
    required this.gameCount,
    required this.finishedCount,
  });

  factory HomeSnapshot.from(List<RoomSummary> rooms) {
    if (rooms.isEmpty) {
      return const HomeSnapshot(
        active: null,
        recent: [],
        roomCount: 0,
        gameCount: 0,
        finishedCount: 0,
      );
    }

    RoomSummary? activeRoom;
    for (final room in rooms) {
      if (room.status == RoomStatus.active) {
        activeRoom = room;
        break;
      }
    }

    final recentRooms = rooms
        .where((r) => r.id != activeRoom?.id)
        .take(3)
        .toList();

    final roomCount = rooms.length;
    final gameCount = rooms.fold<int>(0, (sum, r) => sum + r.gameCount);
    final finishedCount = rooms
        .where((r) => r.status == RoomStatus.finished)
        .length;

    return HomeSnapshot(
      active: activeRoom,
      recent: recentRooms,
      roomCount: roomCount,
      gameCount: gameCount,
      finishedCount: finishedCount,
    );
  }

  final RoomSummary? active;
  final List<RoomSummary> recent;
  final int roomCount;
  final int gameCount;
  final int finishedCount;
}
