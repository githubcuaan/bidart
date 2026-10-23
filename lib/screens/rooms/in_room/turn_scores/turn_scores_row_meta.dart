import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_motion.dart';
import 'package:flutter/material.dart';

/// Small uppercase badge used by a player row.
class TurnScoresBadge extends StatelessWidget {
  const TurnScoresBadge({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: foreground,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        height: 1.2,
      ),
    ),
  );
}

/// One-line explanation under the player name.
class TurnScoresSubtitle extends StatelessWidget {
  const TurnScoresSubtitle({
    super.key,
    required this.text,
    required this.current,
    required this.showCue,
  });

  final String text;
  final bool current;
  final bool showCue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppSemanticColors.of(context);
    final color = current
        ? colors.currentTurnSubtitle
        : theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        if (showCue) ...[
          Icon(
            Icons.sports_martial_arts,
            size: 13,
            color: colors.currentTurnScore,
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: TurnScoresMotion.turn,
            curve: TurnScoresMotion.curve,
            style:
                theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                ) ??
                const TextStyle(),
            child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}

/// Warning line shown on the current shooter row.
class TurnScoresRiskNote extends StatelessWidget {
  const TurnScoresRiskNote({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.of(context);
    return Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 13,
          color: colors.currentTurnRisk,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Nếu ăn: $name chịu đền',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.currentTurnRisk,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
