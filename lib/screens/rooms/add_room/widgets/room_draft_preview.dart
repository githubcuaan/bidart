import 'package:bidart/widgets/card/section_card.dart';
import 'package:bidart/widgets/room/ball_rule_chip.dart';
import 'package:bidart/widgets/room/room_info_note.dart';
import 'package:bidart/widgets/room/room_info_row.dart';
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
          RoomInfoRow(
            icon: Icons.swap_horiz,
            label: 'Thứ tự',
            value: order,
            valueKey: const ValueKey('order-preview'),
          ),

          const SizedBox(height: 8),
          RoomInfoRow(
            icon: Icons.flag_outlined,
            label: 'Đề-pa',
            value: starter,
          ),

          const SizedBox(height: 8),
          RoomInfoRow(
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
                BallRuleChip(
                  key: ValueKey('draft-rule-${entry.key}'),
                  ball: entry.key,
                  value: entry.value,
                  enabled: entry.value != 'tắt',
                ),
            ],
          ),

          const SizedBox(height: 14),
          const RoomInfoNote(message: _note),
        ],
      ),
    );
  }
}
