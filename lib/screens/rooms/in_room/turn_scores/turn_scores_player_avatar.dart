import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_motion.dart';
import 'package:flutter/material.dart';

/// Circular initials avatar with a status badge.
class TurnScoresPlayerAvatar extends StatelessWidget {
  const TurnScoresPlayerAvatar({
    super.key,
    required this.name,
    required this.current,
    required this.warning,
  });

  final String name;
  final bool current;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    final size = current ? 46.0 : 38.0;

    return AnimatedContainer(
      duration: TurnScoresMotion.turn,
      curve: TurnScoresMotion.curve,
      width: size + 4,
      height: size + 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: TurnScoresMotion.turn,
            curve: TurnScoresMotion.curve,
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: current
                  ? colors.currentTurnAvatar
                  : scheme.primaryContainer,
              border: Border.all(
                color: current
                    ? colors.currentTurnScore
                    : scheme.outlineVariant,
                width: current ? 2 : 1,
              ),
            ),
            child: Text(
              _initials(name),
              style: theme.textTheme.labelLarge?.copyWith(
                color: current
                    ? colors.onCurrentTurn
                    : scheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),
          if (current || warning)
            Positioned(
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: TurnScoresMotion.turn,
                curve: TurnScoresMotion.curve,
                width: current ? 18 : 16,
                height: current ? 18 : 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: current ? colors.currentTurnAccent : colors.negative,
                  border: Border.all(
                    color: current
                        ? colors.currentTurnSurface
                        : scheme.surfaceContainerLowest,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  current ? Icons.sports_esports : Icons.priority_high,
                  size: current ? 12 : 11,
                  color: current ? colors.onCurrentTurnGamepad : scheme.onError,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
