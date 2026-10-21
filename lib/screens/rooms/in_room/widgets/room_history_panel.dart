import 'package:bidart/core/labels/history_views.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/screens/rooms/in_room/widgets/history/history_game_row.dart';
import 'package:bidart/screens/rooms/in_room/widgets/history/history_game_sheet.dart';
import 'package:flutter/material.dart';

/// One row per game; tapping a row opens its turn timeline.
class RoomHistoryPanel extends StatelessWidget {
  const RoomHistoryPanel({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final games = buildHistoryGames(room);
    final theme = Theme.of(context);
    if (games.isEmpty) {
      return Column(
        key: const ValueKey('room-history'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chưa có ván nào',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return Column(
      key: const ValueKey('room-history'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < games.length; i++) ...[
          HistoryGameRow(
            key: ValueKey('history-game-${games[i].gameNumber}'),
            game: games[i],
            onTap: () => HistoryGameSheet.show(context, games[i]),
          ),
          if (i != games.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}
