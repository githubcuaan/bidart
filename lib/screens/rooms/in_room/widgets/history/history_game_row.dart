import 'package:bidart/core/labels/history_views.dart';
import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:flutter/material.dart';

/// Tappable one-line summary of a game in the room history card.
class HistoryGameRow extends StatelessWidget {
  const HistoryGameRow({super.key, required this.game, required this.onTap});

  final HistoryGameView game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final surface = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.05),
      scheme.surfaceContainerLow,
    );

    return Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            game.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(game: game),
                      ],
                    ),
                    _SummaryLine(game: game),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.game});

  final HistoryGameView game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = game.isLive
        ? AppSemanticColors.of(context).live
        : game.status == GameStatus.cancelled
        ? AppSemanticColors.of(context).negative
        : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        game.statusLabel,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.game});

  final HistoryGameView game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final winner = base?.copyWith(
      color: AppSemanticColors.of(context).live,
      fontWeight: FontWeight.w700,
    );
    final winnerName = game.winnerName;
    final winnerScore = game.winnerScore;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${game.turns.length} lượt'),
          if (winnerName != null) ...[
            const TextSpan(text: ' · '),
            TextSpan(text: '🏆 $winnerName thắng', style: winner),
            if (winnerScore != null)
              TextSpan(
                text: ' (${winnerScore >= 0 ? '+' : ''}$winnerScore)',
                style: winner,
              ),
          ],
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base,
    );
  }
}
