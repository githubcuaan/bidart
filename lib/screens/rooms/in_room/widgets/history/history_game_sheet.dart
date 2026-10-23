import 'package:bidart/core/labels/history_views.dart';
import 'package:bidart/screens/rooms/in_room/widgets/history/history_turn_tile.dart';
import 'package:flutter/material.dart';

/// Resizable bottom sheet with the full turn timeline of one game.
class HistoryGameSheet extends StatelessWidget {
  const HistoryGameSheet({
    super.key,
    required this.game,
    required this.scrollController,
  });

  final HistoryGameView game;
  final ScrollController scrollController;

  static Future<void> show(BuildContext context, HistoryGameView game) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => HistoryGameSheet(
          key: const ValueKey('history-game-sheet'),
          game: game,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${game.turns.length} lượt',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('close-history-game'),
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: scheme.outlineVariant),
            Expanded(
              child: game.turns.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        controller: scrollController,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: Center(
                              child: Text(
                                'Ván này chưa có lượt nào',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: game.turns.length,
                      itemBuilder: (context, index) => HistoryTurnTile(
                        turn: game.turns[index],
                        isLast: index == game.turns.length - 1,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
