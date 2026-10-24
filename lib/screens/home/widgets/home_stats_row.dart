import 'package:flutter/material.dart';

class HomeStatsRow extends StatelessWidget {
  final int roomCount;
  final int gameCount;
  final int finishedCount;

  const HomeStatsRow({
    super.key,
    required this.roomCount,
    required this.gameCount,
    required this.finishedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('home-stats'),
      children: [
        Expanded(child: _MetricTile(label: 'Phòng', value: '$roomCount')),
        const SizedBox(width: 8),
        Expanded(child: _MetricTile(label: 'Ván', value: '$gameCount')),
        const SizedBox(width: 8),
        Expanded(child: _MetricTile(label: 'Đã xong', value: '$finishedCount')),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}