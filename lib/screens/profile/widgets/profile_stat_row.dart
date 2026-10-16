import 'package:flutter/material.dart';

class ProfileStatRow extends StatelessWidget {
  final int totalMatches;
  final double winRate;
  final int eloRating;

  const ProfileStatRow({
    super.key,
    required this.totalMatches,
    required this.winRate,
    required this.eloRating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatBox(value: '$totalMatches', label: 'Tổng trận')),
        const SizedBox(width: 8),
        Expanded(child: _StatBox(value: '${winRate.toInt()}%', label: 'Thắng')),
        const SizedBox(width: 8),
        Expanded(child: _StatBox(value: '$eloRating', label: 'ELO')),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
