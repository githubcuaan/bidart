import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_providers.dart';

/// Immutable input snapshot; player IDs remain owned by the draft/UI.
class CreateRoomDraft {
  CreateRoomDraft({
    this.name = '',
    this.ownerId = 'local-owner',
    List<PlayerInGame> participants = const [],
    List<String> playerOrder = const [],
    this.starterId = '',
    this.payerId = '',
    Map<int, BallPointConfig> ballPoints = const {},
    this.endConditions = const EndConditions(),
  }) : participants = List.unmodifiable(participants),
       playerOrder = List.unmodifiable(playerOrder),
       ballPoints = Map.unmodifiable(ballPoints);

  final String name;
  final String ownerId;
  final List<PlayerInGame> participants;
  final List<String> playerOrder;
  final String starterId;
  final String payerId;
  final Map<int, BallPointConfig> ballPoints;
  final EndConditions endConditions;

  bool sameInput(CreateRoomDraft other) =>
      name == other.name &&
      ownerId == other.ownerId &&
      listEquals(participants, other.participants) &&
      listEquals(playerOrder, other.playerOrder) &&
      starterId == other.starterId &&
      payerId == other.payerId &&
      mapEquals(ballPoints, other.ballPoints) &&
      endConditions == other.endConditions;
}

class CreateRoomState {
  const CreateRoomState(this.draft, this.result);
  final CreateRoomDraft draft;
  final AsyncValue<String?> result;
}

final createRoomControllerProvider =
    NotifierProvider<CreateRoomController, CreateRoomState>(
      CreateRoomController.new,
    );

class CreateRoomController extends Notifier<CreateRoomState> {
  String? _commandId;
  Future<String?>? _pending;

  @override
  CreateRoomState build() =>
      CreateRoomState(CreateRoomDraft(), const AsyncData(null));

  /// Saving locks input. Equivalent replacement keeps the retry command ID.
  void setDraft(CreateRoomDraft draft) {
    if (_pending != null || state.draft.sameInput(draft)) return;
    _commandId = null;
    state = CreateRoomState(draft, const AsyncData(null));
  }

  Future<String?> submit() {
    if (_pending != null) return _pending!;
    _commandId ??= ref.read(idFactoryProvider)();
    final draft = state.draft;
    state = CreateRoomState(draft, const AsyncLoading());
    final pending = _save(draft, _commandId!);
    _pending = pending;
    return pending;
  }

  Future<String?> _save(CreateRoomDraft draft, String commandId) async {
    try {
      final id = await ref
          .read(roomServiceProvider)
          .createRoom(
            commandId: commandId,
            name: draft.name,
            ownerId: draft.ownerId,
            participants: draft.participants,
            playerOrder: draft.playerOrder,
            starterId: draft.starterId,
            payerId: draft.payerId,
            ballPoints: draft.ballPoints,
            endConditions: draft.endConditions,
          );
      if (ref.mounted) {
        ref.invalidate(roomListProvider);
        ref.invalidate(roomByIdProvider(id));
        state = CreateRoomState(draft, AsyncData(id));
      }
      return id;
    } catch (error, stack) {
      if (ref.mounted) {
        state = CreateRoomState(draft, AsyncError(error, stack));
      }
      return null;
    } finally {
      _pending = null;
    }
  }
}
