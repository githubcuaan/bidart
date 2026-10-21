import 'package:flutter/material.dart';

/// Rounded rule chip: numbered dot + point value.
class BallRuleChip extends StatelessWidget {
  const BallRuleChip({
    super.key,
    required this.ball,
    required this.value,
    required this.enabled,
  });

  final int ball;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dotColor = enabled ? scheme.primary : scheme.outlineVariant;
    final dotTextColor = enabled ? scheme.onPrimary : scheme.onSurfaceVariant;
    final valueColor = enabled ? scheme.onSurface : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            child: Text(
              '$ball',
              style: theme.textTheme.labelSmall?.copyWith(
                color: dotTextColor,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
