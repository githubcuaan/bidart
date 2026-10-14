import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/chain_state.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_mode.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/room_validator.dart';

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
