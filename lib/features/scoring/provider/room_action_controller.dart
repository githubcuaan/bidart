import 'dart:convert';

import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/services/room_commands.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_providers.dart';

enum RoomActionKind {
  record,
  undo,
  finish,
  cancel,
  evaluate,
  add,
  remove,
  rules,
  order,
}

/// Captured UI intent. Stable signature preserves IDs on unchanged-input retry.
class RoomAction {
  RoomAction(
    this.kind, {
    this.gameId,
    this.actorId,
    List<int> balls = const [],
    this.foul = FoulClassification.none,
    this.confirmed = false,
    this.participantId,
    this.name,
    Map<int, BallPointConfig> points = const {},
    List<String> order = const [],
  }) : balls = List.unmodifiable([...balls]..sort()),
       points = Map.unmodifiable(points),
       order = List.unmodifiable(order);
  final RoomActionKind kind;
  final String? gameId, actorId, participantId, name;
  final List<int> balls;
  final FoulClassification foul;
  final bool confirmed;
  final Map<int, BallPointConfig> points;
  final List<String> order;
  String get signature => jsonEncode([
    kind.name,
    gameId,
    actorId,
    balls,
    foul.name,
    confirmed,
    participantId,
    name,
    [
      for (final key in points.keys.toList()..sort())
        [key, points[key]!.toJson()],
    ],
    order,
  ]);
}

final roomActionControllerProvider =
    NotifierProvider.family<RoomActionController, AsyncValue<Room?>, String>(
      RoomActionController.new,
    );

class RoomActionController extends Notifier<AsyncValue<Room?>> {
  RoomActionController(this.roomId);
  final String roomId;
  String? _key, _commandId;
  RoomAction? _lastAction;
  int? _lastRevision;
  RoomActionKind? get lastActionKind => _lastAction?.kind;
  Future<Room?> retry() => _lastAction == null
      ? Future.value(null)
      : submit(_lastAction!, expectedRevision: _lastRevision!);
  Future<Room?>? _pending;
  @override
  AsyncValue<Room?> build() => const AsyncData(null);

  Future<Room?> submit(RoomAction action, {required int expectedRevision}) {
    if (_pending != null) return _pending!;
    _lastAction = action;
    _lastRevision = expectedRevision;
    final key = '$expectedRevision:${action.signature}';
    if (key != _key) {
      _key = key;
      _commandId = ref.read(idFactoryProvider)();
    }
    state = const AsyncLoading();
    return _pending = _save(action, expectedRevision, _commandId!);
  }

  Future<Room?> _save(RoomAction action, int revision, String commandId) async {
    try {
      final service = ref.read(roomServiceProvider);
      final room = await ref.read(roomCommandQueueProvider).run(roomId, () {
        return switch (action.kind) {
          RoomActionKind.record => service.recordTurn(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            gameId: action.gameId!,
            input: TurnInput(
              turnId: 'turn:$commandId',
              actorId: action.actorId!,
              balls: action.balls,
              foul: action.foul,
            ),
          ),
          RoomActionKind.undo => service.undoLastTurn(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            gameId: action.gameId!,
            confirmReopen: action.confirmed,
          ),
          RoomActionKind.finish => service.finishRoom(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            confirmed: action.confirmed,
          ),
          RoomActionKind.cancel => service.cancelRoom(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            confirmed: action.confirmed,
          ),
          RoomActionKind.evaluate => service.evaluateEndConditions(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
          ),
          RoomActionKind.add => service.addPlayer(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            participantId: action.participantId!,
            name: action.name!,
          ),
          RoomActionKind.remove => service.removePlayer(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            participantId: action.participantId!,
          ),
          RoomActionKind.rules => service.updateRules(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            ballPoints: action.points,
          ),
          RoomActionKind.order => service.reorderPlayers(
            commandId: commandId,
            roomId: roomId,
            expectedRevision: revision,
            playerOrder: action.order,
          ),
        };
      });
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
