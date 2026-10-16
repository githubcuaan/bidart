import 'package:bidart/domain/models/scoring/room.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_providers.dart';

final nextGameControllerProvider =
    NotifierProvider.family<NextGameController, AsyncValue<Room?>, String>(
      NextGameController.new,
    );

class NextGameController extends Notifier<AsyncValue<Room?>> {
  NextGameController(this.roomId);
  final String roomId;
  String? _commandId;
  int? _revision;
  Future<Room?>? _pending;

  @override
  AsyncValue<Room?> build() => const AsyncData(null);

  Future<Room?> submit({required int expectedRevision}) {
    if (_pending != null) return _pending!;
    if (_revision != expectedRevision) {
      _commandId = null;
      _revision = expectedRevision;
    }
    _commandId ??= ref.read(idFactoryProvider)();
    state = const AsyncLoading();
    final pending = _save(_commandId!, expectedRevision);
    _pending = pending;
    return pending;
  }

  Future<Room?> _save(String commandId, int revision) async {
    try {
      final service = ref.read(roomServiceProvider);
      final room = await ref
          .read(roomCommandQueueProvider)
          .run(
            roomId,
            () => service.startNextGame(
              commandId: commandId,
              roomId: roomId,
              expectedRevision: revision,
            ),
          );
      if (ref.mounted) {
        ref.invalidate(roomListProvider);
        ref.invalidate(roomByIdProvider(roomId));
        state = AsyncData(room);
      }
      return room;
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return null;
    } finally {
      _pending = null;
    }
  }
}
