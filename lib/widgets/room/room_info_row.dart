import 'package:flutter/material.dart';

/// One icon + fixed-width label + bold value row.
class RoomInfoRow extends StatelessWidget {
  const RoomInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueKey,
    this.labelWidth = 64,
  });

  final IconData icon;
  final String label;
  final String value;
  final Key? valueKey;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: 8),
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            key: valueKey,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
