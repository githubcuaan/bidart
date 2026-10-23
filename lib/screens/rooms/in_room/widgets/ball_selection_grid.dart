import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/widgets/room/ball_rules_editor/ball_toggle_dot.dart';
import 'package:flutter/material.dart';

/// Framed ball picker for the turn draft.
///
/// Mirrors the look of the rules ball grid: same 3-column wrap, same
/// [BallToggleDot] ball artwork. Selected balls keep their colour; raw balls
/// stay grayscale, so one glance shows what is about to be potted.
class BallSelectionGrid extends StatelessWidget {
  const BallSelectionGrid({
    super.key,
    required this.remainingBalls,
    required this.selected,
    required this.onToggle,
    required this.enabled,
  });

  static const _spacing = 10.0;
  static const _minCellWidth = 64.0;
  static const _maxColumns = 3;
  static const _dotSize = 46.0;
  static const _cellHeight = 66.0;
  static const _cellPadding = 6.0;

  final List<int> remainingBalls;
  final Set<int> selected;
  final ValueChanged<int> onToggle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns =
              ((constraints.maxWidth + _spacing) ~/ (_minCellWidth + _spacing))
                  .clamp(1, _maxColumns);
          final cellWidth =
              (constraints.maxWidth - _spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: _spacing,
            runSpacing: _spacing,
            children: [
              for (final ball in remainingBalls)
                SizedBox(
                  width: cellWidth,
                  child: _BallChoiceCell(
                    ball: ball,
                    selected: selected.contains(ball),
                    enabled: enabled,
                    onToggle: onToggle,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// One selectable ball: a tappable ball dot inside a tinted rounded cell.
class _BallChoiceCell extends StatelessWidget {
  const _BallChoiceCell({
    required this.ball,
    required this.selected,
    required this.enabled,
    required this.onToggle,
  });

  final int ball;
  final bool selected;
  final bool enabled;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    // Ball 9 decides the game, so it keeps the gold accent from the rules grid.
    final special = ball == 9;
    final accent = special ? colors.ballNineAccent : scheme.primary;

    final Color background;
    final Color borderColor;
    final double borderWidth;
    if (selected && special) {
      background = colors.ballNine.withValues(alpha: 0.12);
      borderColor = colors.ballNine;
      borderWidth = 1.5;
    } else if (selected) {
      background = scheme.primaryContainer.withValues(alpha: 0.35);
      borderColor = accent;
      borderWidth = 1.5;
    } else {
      background = scheme.surfaceContainerHighest.withValues(alpha: 0.35);
      borderColor = Colors.transparent;
      borderWidth = 1;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      height: BallSelectionGrid._cellHeight,
      padding: const EdgeInsets.all(BallSelectionGrid._cellPadding),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: BallToggleDot(
          key: ValueKey('pot-ball-$ball'),
          ball: ball,
          enabled: selected,
          size: BallSelectionGrid._dotSize,
          onToggle: enabled ? onToggle : null,
          semanticLabel: 'Chọn bi $ball',
          activeTooltip: 'Bỏ chọn bi $ball',
          inactiveTooltip: 'Chọn bi $ball',
        ),
      ),
    );
  }
}
