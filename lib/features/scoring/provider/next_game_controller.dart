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
  String? _starter, _payer;
  Future<Room?>? _pending;

  @override
  AsyncValue<Room?> build() => const AsyncData(null);

  Future<Room?> retry() => _revision == null
      ? Future.value(null)
      : submit(
          expectedRevision: _revision!,
          replacementStarterId: _starter,
          replacementPayerId: _payer,
        );

  Future<Room?> submit({
    required int expectedRevision,
    String? replacementStarterId,
    String? replacementPayerId,
  }) {
    if (_pending != null) return _pending!;
    if (_revision != expectedRevision ||
        _starter != replacementStarterId ||
        _payer != replacementPayerId) {
      _commandId = null;
      _revision = expectedRevision;
      _starter = replacementStarterId;
      _payer = replacementPayerId;
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
              replacementStarterId: _starter,
              replacementPayerId: _payer,
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
