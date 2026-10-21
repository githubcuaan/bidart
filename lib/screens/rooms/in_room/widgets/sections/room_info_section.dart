import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Room metadata that is not part of the live turn scoreboard: rotation,
/// game count, current game context and the active rule version.
class RoomInfoSection extends StatelessWidget {
  const RoomInfoSection({super.key, required this.room});

  final Room room;

  String _name(String id) => playerName(room, id);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final game = room.games
        .where((game) => game.id == room.currentGameId)
        .firstOrNull;
    final rules = room.ruleVersions
        .where((rule) => rule.version == room.currentRuleVersion)
        .firstOrNull;
    final dividerColor = theme.colorScheme.outlineVariant;

    return SectionCard(
      initiallyExpanded: false,
      icon: Icons.meeting_room_outlined,
      title: 'Thông tin phòng',
      description: 'Thứ tự, ván hiện tại và luật đang áp dụng.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoLine(
            icon: Icons.sync_alt,
            text: 'Thứ tự: ${room.playerOrder.map(_name).join(' → ')}',
          ),
          const SizedBox(height: 6),
          _InfoLine(
            icon: Icons.calendar_view_day_outlined,
            text: 'Số ván: ${room.games.length}',
          ),
          if (game != null) ...[
            const SizedBox(height: 6),
            _InfoLine(
              icon: Icons.sports_score_outlined,
              text: 'Ván ${game.gameNumber} · ${gameStatusLabel(game.status)}',
            ),
            const SizedBox(height: 6),
            _InfoLine(
              icon: Icons.payments_outlined,
              text: 'Người trả: ${_name(game.payerId)}',
            ),
            const SizedBox(height: 6),
            _InfoLine(
              icon: Icons.circle_outlined,
              text:
                  'Bi còn lại: ${(game.remainingBalls.toList()..sort()).join(', ')}',
            ),
          ],
          if (rules != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: dividerColor),
            ),
            Text(
              'Luật phiên bản ${rules.version}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              rules.ballPoints.entries
                  .map(
                    (entry) =>
                        'Bi ${entry.key}: ${entry.value.enabled ? '${entry.value.points}đ' : 'tắt'}',
                  )
                  .join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: dividerColor),
          ),
          Text(
            'Phòng tự lưu local; đóng/mở app vẫn giữ nguyên trạng thái.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
