import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/turn.dart';

/// One game row shown by the room history card.
class HistoryGameView {
  const HistoryGameView({
    required this.gameNumber,
    required this.title,
    required this.status,
    required this.turns,
    this.winnerName,
    this.winnerScore,
  });

  final int gameNumber;
  final String title;
  final GameStatus status;
  final List<HistoryTurnView> turns;

  /// Stored winner of the game, never derived from the highest score.
  final String? winnerName;

  /// Net score the winner gained during this game.
  final int? winnerScore;

  bool get isLive => status == GameStatus.inProgress;
  String get statusLabel => historyGameStatusLabel(status);
}

/// One confirmed turn in the game timeline.
class HistoryTurnView {
  const HistoryTurnView({
    required this.index,
    required this.playerName,
    required this.pocketed,
    required this.transfers,
    required this.delta,
    required this.outcomeLabel,
  });

  final int index;
  final String playerName;
  final List<int> pocketed;
  final List<TransferView> transfers;
  final int delta;
  final String outcomeLabel;
}

/// One payer -> receiver movement inside a turn.
class TransferView {
  const TransferView({
    required this.from,
    required this.to,
    required this.points,
  });

  final String from;
  final String to;
  final int points;
}

/// Builds the history view, newest game first and undone turns omitted.
List<HistoryGameView> buildHistoryGames(Room room) => [
  for (final game in room.games.reversed) _gameView(room, game),
];

HistoryGameView _gameView(Room room, GameSession game) {
  final turns = game.turns.where((turn) => !turn.isUndone).toList();
  final winnerId = game.winnerId;
  return HistoryGameView(
    gameNumber: game.gameNumber,
    title: 'Ván ${game.gameNumber}',
    status: game.status,
    turns: [
      for (var i = 0; i < turns.length; i++)
        _turnView(room, turns[i], index: i + 1),
    ],
    winnerName: winnerId == null ? null : playerName(room, winnerId),
    winnerScore: winnerId == null ? null : _gameScore(turns, winnerId),
  );
}

HistoryTurnView _turnView(Room room, Turn turn, {required int index}) {
  final pocketed = [for (final ball in turn.pottedBalls) ball.ballNumber];
  final delta = _turnDelta(turn);
  return HistoryTurnView(
    index: index,
    playerName: playerName(room, turn.actorId),
    pocketed: pocketed,
    transfers: [
      for (final transaction in turn.transactions)
        TransferView(
          from: playerName(room, transaction.fromPlayerId),
          to: playerName(room, transaction.toPlayerId),
          points: transaction.amount,
        ),
    ],
    delta: delta,
    outcomeLabel: switch (delta) {
      > 0 => '+$delta',
      < 0 => '$delta',
      _ when pocketed.isEmpty => 'Hụt',
      _ => '0',
    },
  );
}

int _turnDelta(Turn turn) => _turnDeltaFor(turn, turn.actorId);

int _gameScore(List<Turn> turns, String playerId) =>
    turns.fold(0, (sum, turn) => sum + _turnDeltaFor(turn, playerId));

int _turnDeltaFor(Turn turn, String playerId) => turn.transactions.fold(0, (
  sum,
  transaction,
) {
  final received = transaction.toPlayerId == playerId ? transaction.amount : 0;
  final paid = transaction.fromPlayerId == playerId ? transaction.amount : 0;
  return sum + received - paid;
});
