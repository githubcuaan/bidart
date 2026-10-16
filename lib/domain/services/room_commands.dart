import '../models/scoring/ball_point_config.dart';
import '../models/scoring/game_session.dart';
import '../models/scoring/game_status.dart';
import '../models/scoring/player_in_game.dart';
import '../models/scoring/room.dart';
import '../models/scoring/room_event.dart';
import '../models/scoring/room_event_type.dart';
import '../models/scoring/room_status.dart';
import '../models/scoring/rule_config.dart';
import '../models/scoring/turn.dart';
import '../models/scoring/turn_state_snapshot.dart';
import '../repositories/game_repository_interface.dart';
import '../validation/room_validator.dart';
import '../validation/rule_config_validator.dart';
import 'end_condition_policy.dart';
import 'room_service.dart';
import 'score_engine.dart';

/// RAM and durable repositories share this command boundary. Controllers must
/// serialize commands per room; optimistic revision checks protect other callers.
extension RoomCommands on RoomService {
  Future<Room> _command({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required RoomCommandType type,
    required Room Function(Room, DateTime) apply,
  }) async {
    Future<Room?> retry() async {
      final receipt = await repository.getCommandReceipt(commandId);
      if (receipt == null) return null;
      if (receipt.type != type || receipt.room.id != roomId) {
        throw RepositoryValidationFailure(
          'Command ID belongs to another operation',
        );
      }
      return receipt.room;
    }

    final prior = await retry();
    if (prior != null) return prior;
    if (commandId.trim().isEmpty) {
      throw RepositoryValidationFailure('Nonempty command ID required');
    }
    try {
      final room = await repository.getRoom(roomId);
      if (room.revision != expectedRevision) {
        throw StaleRevisionFailure(
          expected: expectedRevision,
          actual: room.revision,
        );
      }
      if (room.status != RoomStatus.active ||
          room.games.isEmpty ||
          room.currentGameId != room.games.last.id) {
        throw RepositoryValidationFailure(
          'Active room and current game required',
        );
      }
      final candidate = apply(
        room,
        clock(),
      ).copyWith(revision: room.revision + 1);
      return (await repository.updateRoom(
        commandId: commandId,
        type: type,
        expectedRevision: expectedRevision,
        room: candidate,
      )).room;
    } catch (_) {
      // A concurrent identical command may have won after the first lookup.
      final committed = await retry();
      if (committed != null) return committed;
      rethrow;
    }
  }

  Future<Room> recordTurn({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required String gameId,
    required TurnInput input,
  }) => _command(
    commandId: commandId,
    roomId: roomId,
    expectedRevision: expectedRevision,
    type: RoomCommandType.recordTurn,
    apply: (original, now) {
      final room = evaluateRoomEnd(original, now);
      final game = room.games.last;
      if (room.status != RoomStatus.active ||
          game.id != gameId ||
          RoomValidator.validateOrder(
            room.activePlayerIds,
            game.playerOrder,
          ).isNotEmpty) {
        throw RepositoryValidationFailure(
          'Current active game and roster required',
        );
      }
      final matches = room.ruleVersions
          .where((r) => r.version == room.currentRuleVersion)
          .toList();
      if (matches.length != 1 ||
          room.games.any((g) => g.turns.any((t) => t.id == input.turnId))) {
        throw RepositoryValidationFailure(
          'Invalid rule version or duplicate turn ID',
        );
      }
      final rules = matches.single;
      final result = const ScoreEngine().evaluate(
        game: game,
        rules: rules,
        scores: room.scores,
        input: input,
        occurredAt: now,
      );
      var candidate = room.copyWith(
        scores: result.scores,
        playerOrder: result.game.playerOrder,
        games: [...room.games.take(room.games.length - 1), result.game],
      );
      candidate = evaluateRoomEnd(candidate, now);
      final turn = Turn(
        id: input.turnId,
        commandId: commandId,
        roomId: roomId,
        gameId: gameId,
        turnNumber: game.turns.length + 1,
        actorId: input.actorId,
        payerIds: result.payerIds,
        ruleConfigId: rules.id,
        ruleVersion: rules.version,
        pottedBalls: result.balls,
        foulClassification: input.foul,
        transactions: result.transactions,
        logs: result.logs,
        beforeSnapshot: _snapshot(room),
        afterSnapshot: _snapshot(candidate),
        createdAt: now,
        revision: room.revision + 1,
      );
      return candidate.copyWith(
        games: [
          ...candidate.games.take(candidate.games.length - 1),
          result.game.copyWith(turns: [...game.turns, turn]),
        ],
      );
    },
  );

  Future<Room> undoLastTurn({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required String gameId,
    bool confirmReopen = false,
  }) => _command(
    commandId: commandId,
    roomId: roomId,
    expectedRevision: expectedRevision,
    type: RoomCommandType.undoLastTurn,
    apply: (original, now) {
      final room = evaluateRoomEnd(original, now);
      if (room.status != RoomStatus.active) {
        throw RepositoryValidationFailure('Room end condition reached');
      }
      final game = room.games.last;
      if (game.id != gameId ||
          (game.status != GameStatus.inProgress &&
              game.status != GameStatus.finished)) {
        throw RepositoryValidationFailure('Only current game can be undone');
      }
      if (game.status == GameStatus.finished && !confirmReopen) {
        throw RepositoryValidationFailure(
          'Confirmation required to reopen game',
        );
      }
      final index = game.turns.lastIndexWhere((t) => !t.isUndone);
      if (index < 0) {
        throw RepositoryValidationFailure('No effective turn to undo');
      }
      final turn = game.turns[index];
      if (room.events.any(
        (e) => e.isUndoBarrier && e.revision > turn.revision,
      )) {
        throw RepositoryValidationFailure('Undo cannot cross an edit');
      }
      final before = turn.beforeSnapshot;
      final turns = [...game.turns];
      turns[index] = turn.copyWith(isUndone: true);
      final restoredGame = game.copyWith(
        currentPlayerId: before.currentPlayerId,
        previousPlayerId: before.previousPlayerId,
        payerId: before.payerId,
        playerOrder: before.playerOrder,
        remainingBalls: before.remainingBalls,
        chainState: before.chainState,
        status: before.gameStatus,
        endedAt: before.gameEndedAt,
        winnerId: before.winnerId,
        finalPayerId: before.finalPayerId,
        isBreakClear: before.isBreakClear,
        turns: turns,
      );
      final restored = room.copyWith(
        scores: before.scores,
        playerOrder: before.playerOrder,
        activePlayerIds: before.activePlayerIds,
        pendingEndReasons: {},
        games: [...room.games.take(room.games.length - 1), restoredGame],
      );
      return evaluateRoomEnd(restored, now);
    },
  );

  Future<Room> finishRoom({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required bool confirmed,
  }) => _closeRoom(commandId, roomId, expectedRevision, confirmed, false);

  Future<Room> cancelRoom({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required bool confirmed,
  }) => _closeRoom(commandId, roomId, expectedRevision, confirmed, true);

  Future<Room> _closeRoom(
    String commandId,
    String roomId,
    int revision,
    bool confirmed,
    bool cancel,
  ) => _command(
    commandId: commandId,
    roomId: roomId,
    expectedRevision: revision,
    type: cancel ? RoomCommandType.cancelRoom : RoomCommandType.finishRoom,
    apply: (room, now) {
      if (!confirmed) {
        throw RepositoryValidationFailure('Confirmation required');
      }
      final evaluated = evaluateRoomEnd(room, now);
      final game = room.games.last;
      return evaluated.copyWith(
        status: cancel ? RoomStatus.cancelled : RoomStatus.finished,
        endedAt: now,
        games: [
          ...room.games.take(room.games.length - 1),
          game.status == GameStatus.inProgress
              ? game.copyWith(
                  status: cancel ? GameStatus.cancelled : GameStatus.incomplete,
                  endedAt: now,
                )
              : game,
        ],
      );
    },
  );

  /// Invoke on load/resume, before actions, and timer expiry. A retry returns
  /// its committed result; each new evaluation must use a new command ID.
  Future<Room> evaluateEndConditions({
    required String commandId,
    required String roomId,
    required int expectedRevision,
  }) => _command(
    commandId: commandId,
    roomId: roomId,
    expectedRevision: expectedRevision,
    type: RoomCommandType.evaluateEndConditions,
    apply: evaluateRoomEnd,
  );

  Future<Room> addPlayer({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required String participantId,
    required String name,
  }) => _edit(
    commandId,
    roomId,
    expectedRevision,
    RoomCommandType.addPlayer,
    RoomEventType.addPlayer,
    (room, now) {
      if (room.participants.any((p) => p.id == participantId) ||
          participantId.trim().isEmpty) {
        throw RepositoryValidationFailure(
          'Participant ID must be new and nonempty',
        );
      }
      final participants = [
        ...room.participants,
        PlayerInGame(
          id: participantId,
          displayName: name.trim(),
          joinedAt: now,
        ),
      ];
      final active = [...room.activePlayerIds, participantId];
      final issues = RoomValidator.validateRoster(participants, active);
      if (issues.isNotEmpty) {
        throw RepositoryValidationFailure('Invalid roster', issues: issues);
      }
      return room.copyWith(
        participants: participants,
        activePlayerIds: active,
        playerOrder: [...room.playerOrder, participantId],
        scores: {...room.scores, participantId: 0},
      );
    },
  );

  Future<Room> removePlayer({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required String participantId,
  }) => _edit(
    commandId,
    roomId,
    expectedRevision,
    RoomCommandType.removePlayer,
    RoomEventType.removePlayer,
    (room, now) {
      if (room.games.last.status != GameStatus.finished ||
          !room.activePlayerIds.contains(participantId) ||
          room.activePlayerIds.length <= 2) {
        throw RepositoryValidationFailure(
          'Remove only between games with at least two remaining',
        );
      }
      return room.copyWith(
        participants: [
          for (final p in room.participants)
            p.id == participantId ? p.copyWith(leftAt: now) : p,
        ],
        activePlayerIds: room.activePlayerIds
            .where((id) => id != participantId)
            .toList(),
        playerOrder: room.playerOrder
            .where((id) => id != participantId)
            .toList(),
      );
    },
  );

  Future<Room> updateRules({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required Map<int, BallPointConfig> ballPoints,
  }) {
    final captured = Map<int, BallPointConfig>.unmodifiable(ballPoints);
    return _edit(
      commandId,
      roomId,
      expectedRevision,
      RoomCommandType.updateRules,
      RoomEventType.updateRules,
      (room, now) {
        final rules = RuleConfig(
          id: 'rules:$commandId',
          version: room.currentRuleVersion + 1,
          ballPoints: captured,
        );
        final issues = RuleConfigValidator.validate(rules);
        if (issues.isNotEmpty) {
          throw RepositoryValidationFailure('Invalid rules', issues: issues);
        }
        return room.copyWith(
          currentRuleVersion: rules.version,
          ruleVersions: [...room.ruleVersions, rules],
        );
      },
    );
  }

  Future<Room> reorderPlayers({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    required List<String> playerOrder,
  }) {
    final captured = List<String>.unmodifiable(playerOrder);
    return _edit(
      commandId,
      roomId,
      expectedRevision,
      RoomCommandType.reorderPlayers,
      RoomEventType.reorderPlayers,
      (room, now) {
        final issues = RoomValidator.validateOrder(
          room.activePlayerIds,
          captured,
        );
        if (issues.isNotEmpty) {
          throw RepositoryValidationFailure('Invalid order', issues: issues);
        }
        return room.copyWith(playerOrder: captured);
      },
    );
  }

  Future<Room> _edit(
    String commandId,
    String roomId,
    int revision,
    RoomCommandType type,
    RoomEventType eventType,
    Room Function(Room, DateTime) edit,
  ) => _command(
    commandId: commandId,
    roomId: roomId,
    expectedRevision: revision,
    type: type,
    apply: (original, now) {
      final room = evaluateRoomEnd(original, now);
      if (room.status != RoomStatus.active) {
        throw RepositoryValidationFailure('Room end condition reached');
      }
      var candidate = edit(room, now);
      // A finished game's order/outcome belongs to history, not the new roster.
      if (room.games.last.status == GameStatus.inProgress) {
        candidate = candidate.copyWith(
          games: [
            ...room.games.take(room.games.length - 1),
            room.games.last.copyWith(playerOrder: candidate.playerOrder),
          ],
        );
      }
      final event = RoomEvent(
        id: 'event:$commandId',
        roomId: room.id,
        commandId: commandId,
        revision: revision + 1,
        type: eventType,
        beforeSnapshot: _snapshot(room),
        afterSnapshot: _snapshot(candidate),
        beforeRules: room.ruleVersions.singleWhere(
          (r) => r.version == room.currentRuleVersion,
        ),
        afterRules: candidate.ruleVersions.singleWhere(
          (r) => r.version == candidate.currentRuleVersion,
        ),
        createdAt: now,
      );
      return candidate.copyWith(events: [...room.events, event]);
    },
  );
}

TurnStateSnapshot _snapshot(Room room) {
  final GameSession game = room.games.last;
  return TurnStateSnapshot(
    roomId: room.id,
    gameId: game.id,
    scores: room.scores,
    activePlayerIds: room.activePlayerIds,
    playerOrder: room.playerOrder,
    currentPlayerId: game.currentPlayerId,
    previousPlayerId: game.previousPlayerId,
    payerId: game.payerId,
    chainState: game.chainState,
    remainingBalls: game.remainingBalls,
    roomStatus: room.status,
    gameStatus: game.status,
    roomCreatedAt: room.createdAt,
    roomEndedAt: room.endedAt,
    gameStartedAt: game.startedAt,
    gameEndedAt: game.endedAt,
    winnerId: game.winnerId,
    finalPayerId: game.finalPayerId,
    isBreakClear: game.isBreakClear,
    pendingEndReasons: room.pendingEndReasons,
  );
}
