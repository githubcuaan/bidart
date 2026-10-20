import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Read-only summary of the draft before the room is created.
class RoomDraftPreview extends StatelessWidget {
  const RoomDraftPreview({
    super.key,
    required this.order,
    required this.starter,
    required this.payer,
    required this.rules,
  });

  final String order;
  final String starter;
  final String payer;

  /// Ball number mapped to its display value (e.g. `1: '1đ'`, `2: 'tắt'`).
  final Map<int, String> rules;

  static const _note =
      'Bi tắt vẫn thuộc bàn chơi, chỉ không tạo điểm. '
      'Đạt thời gian/ngưỡng sẽ chờ hết ván.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SectionCard(
      icon: Icons.fact_check_outlined,
      title: 'Xem trước',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewRow(
            icon: Icons.swap_horiz,
            label: 'Thứ tự',
            value: order,
            valueKey: const ValueKey('order-preview'),
          ),

          const SizedBox(height: 8),
          _PreviewRow(
            icon: Icons.flag_outlined,
            label: 'Đề-pa',
            value: starter,
          ),

          const SizedBox(height: 8),
          _PreviewRow(
            icon: Icons.play_arrow_outlined,
            label: 'Đền đầu',
            value: payer,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: scheme.outlineVariant),
          ),
          Text(
            'Luật điểm',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in rules.entries)
                _BallRuleChip(
                  key: ValueKey('draft-rule-${entry.key}'),
                  ball: entry.key,
                  value: entry.value,
                  enabled: entry.value != 'tắt',
                ),
            ],
          ),

          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _note,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One icon + fixed-width label + bold value row.
class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueKey,
  });

  final IconData icon;
  final String label;
  final String value;
  final Key? valueKey;

  static const _labelWidth = 64.0;

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
          width: _labelWidth,
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

/// Rounded rule chip: numbered dot + point value.
class _BallRuleChip extends StatelessWidget {
  const _BallRuleChip({
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
