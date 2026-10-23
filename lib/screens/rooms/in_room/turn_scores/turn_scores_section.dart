import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_data.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_reorder_column.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Current shooter plus the live scoreboard, ordered by the rotation.
///
/// The first row is the player holding the turn, followed by the rotation.
/// The payer keeps its natural place with the red risk badge.
class TurnScoresSection extends StatelessWidget {
  const TurnScoresSection({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    final green = colors.live;
    final data = TurnScoreboardData.fromRoom(room);

    return SectionCard(
      collapsible: false,
      child: Column(
        key: const ValueKey('turn-scores-section'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'LƯỢT ĐÁNH & ĐIỂM SỐ HIỆN TẠI',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Thứ tự bắn đến xoay vòng',
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: green,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          TurnScoresReorderColumn(entries: data.entries, data: data),
        ],
      ),
    );
  }
}
