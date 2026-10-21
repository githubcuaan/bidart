import 'package:bidart/core/labels/history_views.dart';
import 'package:bidart/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// One turn in the game-detail timeline.
class HistoryTurnTile extends StatelessWidget {
  const HistoryTurnTile({super.key, required this.turn, required this.isLast});

  final HistoryTurnView turn;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                _TurnIndex(turn: turn),
                if (!isLast) ...[
                  const SizedBox(height: 4),
                  Expanded(
                    child: Container(width: 1, color: scheme.outlineVariant),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: _TurnContent(turn: turn),
            ),
          ),
        ],
      ),
    );
  }
}

class _TurnIndex extends StatelessWidget {
  const _TurnIndex({required this.turn});

  final HistoryTurnView turn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final scored = turn.pocketed.isNotEmpty;
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scored
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
      ),
      child: Text(
        '${turn.index}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: scored ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _TurnContent extends StatelessWidget {
  const _TurnContent({required this.turn});

  final HistoryTurnView turn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    final scored = turn.delta != 0;
    final scoreColor = turn.delta > 0 ? colors.live : colors.negative;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                turn.playerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scored ? scheme.onSurface : scheme.onSurfaceVariant,
                  fontWeight: scored ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (scored)
              Text(
                turn.outcomeLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              )
            else
              Text(
                turn.outcomeLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        if (turn.pocketed.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final ball in turn.pocketed) _BallChip(ball: ball)],
          ),
        for (final transfer in turn.transfers)
          _TransferLine(transfer: transfer),
      ],
    );
  }
}

class _BallChip extends StatelessWidget {
  const _BallChip({required this.ball});

  final int ball;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.surfaceContainerHighest,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        '$ball',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _TransferLine extends StatelessWidget {
  const _TransferLine({required this.transfer});

  final TransferView transfer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
      height: 1.35,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: transfer.from,
            style: TextStyle(
              color: colors.negative,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: ' đền '),
          TextSpan(
            text: '${transfer.points} điểm',
            style: TextStyle(
              color: colors.negative,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: ' cho '),
          TextSpan(
            text: transfer.to,
            style: TextStyle(color: colors.live, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      style: style,
    );
  }
}
