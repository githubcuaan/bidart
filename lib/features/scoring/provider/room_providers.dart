import 'package:bidart/data/repositories/in_memory_game_repository.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/room_summary.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/room_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => InMemoryGameRepository(),
);
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
final idFactoryProvider = Provider<String Function()>((ref) => const Uuid().v4);
final roomServiceProvider = Provider<RoomService>(
  (ref) => RoomService(
    repository: ref.watch(gameRepositoryProvider),
    clock: ref.watch(clockProvider),
    idFactory: ref.watch(idFactoryProvider),
  ),
);
final roomListProvider = FutureProvider.family<List<RoomSummary>, RoomStatus?>(
  (ref, status) => ref.watch(roomServiceProvider).listRooms(status: status),
);
final roomByIdProvider = FutureProvider.family<Room, String>(
  (ref, id) => ref.watch(roomServiceProvider).getRoom(id),
);

/// Shared by all command controllers, including different commands on one room.
final roomCommandQueueProvider = Provider((ref) => RoomCommandQueue());

class RoomCommandQueue {
  final Map<String, Future<void>> _tails = {};

  Future<T> run<T>(String roomId, Future<T> Function() command) {
    final previous = _tails[roomId] ?? Future<void>.value();
    final result = previous.then((_) => command());
    final tail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    _tails[roomId] = tail;
    tail.then((_) {
      if (identical(_tails[roomId], tail)) _tails.remove(roomId);
    });
    return result;
  }
}
