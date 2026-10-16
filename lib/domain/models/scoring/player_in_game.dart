import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_in_game.freezed.dart';
part 'player_in_game.g.dart';

/// Stable roster entry. Linked by ID, never by name.
/// Scores live authoritatively at room level, not here.
@freezed
abstract class PlayerInGame with _$PlayerInGame {
  const factory PlayerInGame({
    required String id,
    required String displayName,
    required DateTime joinedAt,
    DateTime? leftAt,
  }) = _PlayerInGame;

  factory PlayerInGame.fromJson(Map<String, dynamic> json) =>
      _$PlayerInGameFromJson(json);
}
