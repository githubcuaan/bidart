import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/widgets/room/ball_rules_editor/ball_toggle_dot.dart';
import 'package:flutter/material.dart';

/// Framed ball picker for the turn draft.
///
/// Bright balls still on the table; drafted balls disappear until cleared.
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
        color: scheme.primaryContainer.withValues(alpha: 0.32),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.45)),
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
                IgnorePointer(
                  ignoring: selected.contains(ball),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    ),
                    child: selected.contains(ball)
                        ? SizedBox.shrink(key: ValueKey('drafted-ball-$ball'))
                        : SizedBox(
                            key: ValueKey('available-ball-$ball'),
                            width: cellWidth,
                            child: _BallChoiceCell(
                              ball: ball,
                              enabled: enabled,
                              onToggle: onToggle,
                            ),
                          ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// One selectable ball: a vivid dot inside a lightly tinted cell.
class _BallChoiceCell extends StatelessWidget {
  const _BallChoiceCell({
    required this.ball,
    required this.enabled,
    required this.onToggle,
  });

  final int ball;
  final bool enabled;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    final accent = ball == 9 ? colors.ballNineAccent : scheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      height: BallSelectionGrid._cellHeight,
      padding: const EdgeInsets.all(BallSelectionGrid._cellPadding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        border: Border.all(color: accent.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: BallToggleDot(
          key: ValueKey('pot-ball-$ball'),
          ball: ball,
          enabled: false,
          bright: true,
          size: BallSelectionGrid._dotSize,
          onToggle: enabled ? onToggle : null,
          semanticLabel: 'Chọn bi $ball',
          inactiveTooltip: 'Chọn bi $ball',
        ),
      ),
    );
  }
}
