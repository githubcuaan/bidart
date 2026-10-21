import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_duration_countdown.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Room status, name and the limits that apply to the current room.
class RoomHeaderSection extends StatelessWidget {
  const RoomHeaderSection({super.key, required this.room, required this.now});

  final Room room;
  final DateTime Function() now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = room.status == RoomStatus.active;
    final duration = room.endConditions.durationSeconds;
    final threshold = room.endConditions.scoreThreshold;
    final hasLimits = duration != null || threshold != null;

    return SectionCard(
      collapsible: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusLabel(active: active),
                const SizedBox(height: 4),
                Text(
                  room.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),

          if (hasLimits) ...[
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (duration case final int seconds)
                  _MetricTile(
                    icon: Icons.timer_outlined,
                    label: active ? 'Còn lại' : 'Thời lượng',
                    value: RoomDurationCountdown(
                      startedAt: room.createdAt,
                      durationSeconds: seconds,
                      active: active,
                      now: now,
                      compact: true,
                    ),
                  ),
                if (duration != null && threshold != null)
                  const SizedBox(width: 4),
                if (threshold case final int score)
                  _MetricTile(
                    key: const ValueKey('room-score-threshold'),
                    icon: Icons.emoji_events_outlined,
                    label: 'Mục tiêu',
                    value: Text('$score'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active
        ? AppSemanticColors.of(context).live
        : theme.colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            active
                ? 'LIVE MATCH'
                : 'Phòng chỉ đọc — không thể thay đổi kết quả.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: active ? 1.2 : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 1),
              DefaultTextStyle.merge(
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                child: value,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
