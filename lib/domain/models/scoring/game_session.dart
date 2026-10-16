import 'package:freezed_annotation/freezed_annotation.dart';

import 'chain_state.dart';
import 'game_status.dart';
import 'turn.dart';

part 'game_session.freezed.dart';
part 'game_session.g.dart';

/// One game (van) inside a room. Scores stay authoritative at room level;
/// this aggregate owns order/cards/turns of the current game.
@freezed
abstract class GameSession with _$GameSession {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GameSession({
    required String id,
    required String roomId,
    required int gameNumber,
    required GameStatus status,
    required DateTime startedAt,
    DateTime? endedAt,
    required String currentPlayerId,
    String? previousPlayerId,
    required String payerId,
    required List<String> playerOrder,
    required Set<int> remainingBalls,
    required ChainState chainState,
    String? winnerId,
    String? finalPayerId,
    @Default(false) bool isBreakClear,
    @Default([]) List<Turn> turns,
  }) = _GameSession;

  factory GameSession.fromJson(Map<String, dynamic> json) =>
      _$GameSessionFromJson(json);
}
