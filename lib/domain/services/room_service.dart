import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/chain_state.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/room_summary.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/room_validator.dart';

import 'next_game_setup.dart';
import 'end_condition_policy.dart';

/// Creates committed aggregates only. Draft participant IDs belong to callers:
/// preserve them across rename/reorder, and use a new command ID if input changes.
class RoomService {
  RoomService({
    required this.repository,
    required this.idFactory,
    required this.clock,
  });

  final GameRepository repository;
  final String Function() idFactory;
  final DateTime Function() clock;
  final Map<String, Future<String>> _pendingCreates = {};

  /// Newest created first, then ascending ID for timestamp ties.
  Future<List<RoomSummary>> listRooms({RoomStatus? status}) async {
    final rooms = [...await repository.listRooms(status: status)]
      ..sort((a, b) {
        final timestamp = b.createdAt.compareTo(a.createdAt);
        return timestamp == 0 ? a.id.compareTo(b.id) : timestamp;
      });
    return List.unmodifiable(rooms.map(RoomSummary.fromRoom));
  }

  Future<Room> getRoom(String roomId) => repository.getRoom(roomId);

  Future<Room> startNextGame({
    required String commandId,
    required String roomId,
    required int expectedRevision,
    String? replacementStarterId,
    String? replacementPayerId,
  }) async {
    final prior = await repository.getCommandReceipt(commandId);
    if (prior != null) {
      if (prior.type != RoomCommandType.startNextGame ||
          prior.room.id != roomId) {
        throw RepositoryValidationFailure(
          'Command ID belongs to another operation',
        );
      }
      return prior.room;
    }

    if (commandId.trim().isEmpty) {
      throw RepositoryValidationFailure('Nonempty command ID required');
    }

    final room = await repository.getRoom(roomId);
    if (room.revision != expectedRevision) {
      // A concurrent service may commit after the initial receipt lookup.
      final committed = await repository.getCommandReceipt(commandId);
      if (committed?.type == RoomCommandType.startNextGame &&
          committed?.room.id == roomId) {
        return committed!.room;
      }
      throw StaleRevisionFailure(
        expected: expectedRevision,
        actual: room.revision,
      );
    }

    if (room.status != RoomStatus.active ||
        room.games.isEmpty ||
        room.currentGameId != room.games.last.id ||
        room.games.last.status != GameStatus.finished) {
      throw RepositoryValidationFailure(
        'Active room and finished current game required',
      );
    }

    final now = clock();
    final evaluated = evaluateRoomEnd(room, now);
    if (room.pendingEndReasons.isNotEmpty ||
        evaluated.pendingEndReasons.isNotEmpty) {
      throw RepositoryValidationFailure('Room end condition reached');
    }

    final issues = [
      ...RoomValidator.validateRoster(room.participants, room.activePlayerIds),
      ...RoomValidator.validateEndConditions(room.endConditions),
    ];

    if (issues.isNotEmpty) {
      throw RepositoryValidationFailure(
        'Invalid next-game roster or limits',
        issues: issues,
      );
    }

    final previous = room.games.last;
    final setup = NextGameSetup.derive(
      previous: previous,
      activePlayerIds: room.activePlayerIds,
      roomOrder: room.playerOrder,
      replacementStarterId: replacementStarterId,
      replacementPayerId: replacementPayerId,
    );

    final gameId = idFactory();
    if (room.games.any((game) => game.id == gameId)) {
      throw RepositoryValidationFailure('Game ID already exists');
    }

    final game = GameSession(
      id: gameId,
      roomId: room.id,
      gameNumber: previous.gameNumber + 1,
      status: GameStatus.inProgress,
      startedAt: now,
      currentPlayerId: setup.starterId,
      payerId: setup.payerId,
      playerOrder: setup.playerOrder,
      remainingBalls: {for (var ball = 1; ball <= 9; ball++) ball},
      chainState: const ChainState(
        isBreakChain: true,
        hasLegalPotInChain: false,
      ),
    );

    final receipt = await repository.updateRoom(
      commandId: commandId,
      type: RoomCommandType.startNextGame,
      expectedRevision: expectedRevision,
      room: room.copyWith(
        revision: room.revision + 1,
        games: [...room.games, game],
        currentGameId: game.id,
        playerOrder: setup.playerOrder,
      ),
    );
    return receipt.room;
  }

  Future<String> createRoom({
    required String commandId,
    required String name,
    required String ownerId,
    required List<PlayerInGame> participants,
    required List<String> playerOrder,
    required String starterId,
    required String payerId,
    required Map<int, BallPointConfig> ballPoints,
    EndConditions endConditions = const EndConditions(),
  }) {
    final pending = _pendingCreates[commandId];
    if (pending != null) return pending;

    // Capture collections before the first await; caller edits stay in draft.
    final result = _createRoom(
      commandId: commandId,
      name: name,
      ownerId: ownerId,
      participants: RoomValidator.normalizeParticipants(participants),
      playerOrder: List.unmodifiable(playerOrder),
      starterId: starterId,
      payerId: payerId,
      ballPoints: Map.unmodifiable(ballPoints),
      endConditions: endConditions,
    );

    final tracked = result.whenComplete(() {
      _pendingCreates.remove(commandId);
    });

    _pendingCreates[commandId] = tracked;
    return tracked;
  }

  Future<String> _createRoom({
    required String commandId,
    required String name,
    required String ownerId,
    required List<PlayerInGame> participants,
    required List<String> playerOrder,
    required String starterId,
    required String payerId,
    required Map<int, BallPointConfig> ballPoints,
    required EndConditions endConditions,
  }) async {
    final prior = await repository.getCommandReceipt(commandId);

    if (prior != null) {
      if (prior.type != RoomCommandType.create) {
        throw RepositoryValidationFailure(
          'Command ID belongs to another operation',
        );
      }
      return prior.room.id;
    }

    if (commandId.trim().isEmpty || ownerId.trim().isEmpty) {
      throw RepositoryValidationFailure(
        'Nonempty command and owner IDs required',
      );
    }

    final issues = RoomValidator.validate(
      participants: participants,
      playerOrder: playerOrder,
      starterId: starterId,
      payerId: payerId,
      ruleConfig: RuleConfig(id: '', version: 1, ballPoints: ballPoints),
      endConditions: endConditions,
    );

    if (issues.isNotEmpty) {
      throw RepositoryValidationFailure('Invalid room setup', issues: issues);
    }

    final roomId = idFactory();
    final gameId = idFactory();
    final ruleId = idFactory();
    final now = clock();
    final room = Room(
      id: roomId,
      name: name.trim(),
      ownerId: ownerId,
      mode: RoomMode.local,
      status: RoomStatus.active,
      createdAt: now,
      revision: 0,
      participants: participants,
      activePlayerIds: participants.map((player) => player.id).toList(),
      playerOrder: playerOrder,
      scores: {for (final player in participants) player.id: 0},
      ruleVersions: [
        RuleConfig(id: ruleId, version: 1, ballPoints: ballPoints),
      ],
      currentRuleVersion: 1,
      games: [
        GameSession(
          id: gameId,
          roomId: roomId,
          gameNumber: 1,
          status: GameStatus.inProgress,
          startedAt: now,
          currentPlayerId: starterId,
          payerId: payerId,
          playerOrder: playerOrder,
          remainingBalls: {for (var ball = 1; ball <= 9; ball++) ball},
          chainState: const ChainState(
            isBreakChain: true,
            hasLegalPotInChain: false,
          ),
        ),
      ],
      currentGameId: gameId,
      endConditions: endConditions,
      pendingEndReasons: {},
    );

    try {
      final receipt = await repository.createRoom(
        commandId: commandId,
        room: room,
      );
      return receipt.room.id;
    } on RepositoryValidationFailure {
      // Another service instance may have committed this command while IDs
      // were being generated. The original receipt still wins the retry.
      final committed = await repository.getCommandReceipt(commandId);
      if (committed?.type == RoomCommandType.create) return committed!.room.id;
      rethrow;
    }
  }
}
