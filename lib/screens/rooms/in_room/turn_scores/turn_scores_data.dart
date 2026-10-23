import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';

/// Role of one row in the turn scoreboard.
enum TurnScoreRole { current, payer, next, waiting }

/// One player row, already ordered by the live rotation.
class TurnScoreEntry {
  const TurnScoreEntry({required this.player, required this.role});

  final PlayerInGame player;
  final TurnScoreRole role;
}

/// Presentation data for [TurnScoresSection], derived once from [Room].
class TurnScoreboardData {
  const TurnScoreboardData({
    required this.entries,
    required this.scores,
    required this.ranks,
    required this.leaderScore,
    required this.currentName,
    required this.payerName,
    required this.targetBall,
    required this.endedLabel,
  });

  factory TurnScoreboardData.fromRoom(Room room) {
    final game = room.games
        .where((game) => game.id == room.currentGameId)
        .firstOrNull;
    final live = game != null && game.status == GameStatus.inProgress;
    final entries = _entries(room, game: game, live: live);
    final leaderScore = room.scores.values.fold<int?>(
      null,
      (max, score) => max == null || score > max ? score : max,
    );

    return TurnScoreboardData(
      entries: entries,
      scores: room.scores,
      ranks: _ranks(room),
      leaderScore: leaderScore,
      currentName: live ? playerName(room, game.currentPlayerId) : null,
      payerName: live && game.payerId != game.currentPlayerId
          ? playerName(room, game.payerId)
          : null,
      targetBall: live && game.remainingBalls.isNotEmpty
          ? game.remainingBalls.reduce((a, b) => a < b ? a : b)
          : null,
      endedLabel: _endedLabel(room, game),
    );
  }

  final List<TurnScoreEntry> entries;
  final Map<String, int> scores;
  final Map<String, int> ranks;
  final int? leaderScore;
  final String? currentName;
  final String? payerName;
  final int? targetBall;
  final String endedLabel;

  int scoreOf(TurnScoreEntry entry) => scores[entry.player.id] ?? 0;

  int rankOf(TurnScoreEntry entry) => ranks[entry.player.id] ?? entries.length;

  bool isLeader(TurnScoreEntry entry) => scoreOf(entry) == leaderScore;

  static String _endedLabel(Room room, GameSession? game) {
    if (game == null || game.status == GameStatus.inProgress) {
      return 'Chờ ván mới';
    }
    if (room.status == RoomStatus.finished ||
        room.status == RoomStatus.cancelled) {
      return 'Phòng đã kết thúc';
    }
    return 'Chờ ván mới';
  }

  static List<TurnScoreEntry> _entries(
    Room room, {
    required GameSession? game,
    required bool live,
  }) {
    final order = game != null && game.playerOrder.isNotEmpty
        ? game.playerOrder
        : room.playerOrder;
    final activeIds = room.activePlayerIds.isEmpty
        ? order.toSet()
        : room.activePlayerIds.toSet();
    final players = <String, PlayerInGame>{
      for (final player in room.participants) player.id: player,
    };
    final ids = <String>[
      for (final id in order)
        if (activeIds.contains(id) && players.containsKey(id)) id,
      for (final player in room.participants)
        if (activeIds.contains(player.id) && !order.contains(player.id))
          player.id,
    ];

    final current = live ? game?.currentPlayerId : null;
    final entries = <TurnScoreEntry>[];
    void add(String? id, TurnScoreRole role) {
      final player = id == null ? null : players[id];
      if (player == null ||
          !activeIds.contains(id) ||
          entries.any((entry) => entry.player.id == id)) {
        return;
      }
      entries.add(TurnScoreEntry(player: player, role: role));
    }

    final start = current == null ? -1 : ids.indexOf(current);
    if (start < 0) {
      for (final id in ids) {
        add(id, TurnScoreRole.waiting);
      }
      return entries;
    }

    add(current, TurnScoreRole.current);
    final nextId = ids[(start + 1) % ids.length];
    TurnScoreRole roleFor(String id) {
      if (id == game?.payerId) return TurnScoreRole.payer;
      if (id == nextId) return TurnScoreRole.next;
      return TurnScoreRole.waiting;
    }

    for (var offset = 1; offset < ids.length; offset++) {
      final id = ids[(start + offset) % ids.length];
      add(id, roleFor(id));
    }
    return entries;
  }

  static Map<String, int> _ranks(Room room) {
    final players = [...room.participants]
      ..sort(
        (a, b) => (room.scores[b.id] ?? 0).compareTo(room.scores[a.id] ?? 0),
      );
    final ranks = <String, int>{};
    int? previousScore;
    var rank = 0;
    for (var index = 0; index < players.length; index++) {
      final score = room.scores[players[index].id] ?? 0;
      if (score != previousScore) {
        rank = index + 1;
        previousScore = score;
      }
      ranks[players[index].id] = rank;
    }
    return ranks;
  }
}
