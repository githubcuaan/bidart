import 'package:flutter/material.dart';

/// Balls still on the table that may be potted this turn.
class BallSelectionChips extends StatelessWidget {
  const BallSelectionChips({
    super.key,
    required this.remainingBalls,
    required this.selected,
    required this.onToggle,
    required this.enabled,
  });

  final List<int> remainingBalls;
  final Set<int> selected;
  final ValueChanged<int> onToggle;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    children: [
      for (final ball in remainingBalls)
        FilterChip(
          key: ValueKey('pot-ball-$ball'),
          label: Text('Bi $ball'),
          selected: selected.contains(ball),
          onSelected: enabled ? (isSelected) => onToggle(ball) : null,
        ),
    ],
  );
}
