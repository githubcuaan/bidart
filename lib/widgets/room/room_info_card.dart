import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:bidart/widgets/room/ball_rule_chip.dart';
import 'package:bidart/widgets/room/room_info_note.dart';
import 'package:bidart/widgets/room/room_info_row.dart';
import 'package:flutter/material.dart';

/// Room metadata that is not part of the live turn scoreboard: rotation,
/// game count, current game context and the active rule version.
///
/// Shared by the gateway detail page and [InRoom] so both render the committed
/// room with the same rows, rule chips and note.
class RoomInfoCard extends StatelessWidget {
  const RoomInfoCard({
    super.key,
    required this.room,
    this.initiallyExpanded = true,
    this.collapsible = true,
  });

  final Room room;
  final bool initiallyExpanded;
  final bool collapsible;

  String _name(String id) => playerName(room, id);

  static const _labelWidth = 80.0;
  static const _note =
      'Phòng tự lưu local; đóng/mở app vẫn giữ nguyên trạng thái.';

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
      initiallyExpanded: initiallyExpanded,
      collapsible: collapsible,
      icon: Icons.meeting_room_outlined,
      title: 'Thông tin phòng',
      description: 'Thứ tự, ván hiện tại và luật đang áp dụng.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoomInfoRow(
            icon: Icons.sync_alt,
            label: 'Thứ tự',
            value: room.playerOrder.map(_name).join(' → '),
            valueKey: const ValueKey('room-info-order'),
            labelWidth: _labelWidth,
          ),
          const SizedBox(height: 8),
          RoomInfoRow(
            icon: Icons.calendar_view_day_outlined,
            label: 'Số ván',
            value: '${room.games.length}',
            valueKey: const ValueKey('room-info-game-count'),
            labelWidth: _labelWidth,
          ),
          if (game != null) ...[
            const SizedBox(height: 8),
            RoomInfoRow(
              icon: Icons.sports_score_outlined,
              label: 'Ván',
              value: '${game.gameNumber} · ${gameStatusLabel(game.status)}',
              valueKey: const ValueKey('room-info-game'),
              labelWidth: _labelWidth,
            ),
            const SizedBox(height: 8),
            RoomInfoRow(
              icon: Icons.sports_esports_outlined,
              label: 'Người đánh',
              value: _name(game.currentPlayerId),
              valueKey: const ValueKey('room-info-current-player'),
              labelWidth: _labelWidth,
            ),
            const SizedBox(height: 8),
            RoomInfoRow(
              icon: Icons.payments_outlined,
              label: 'Người trả',
              value: _name(game.payerId),
              valueKey: const ValueKey('room-info-payer'),
              labelWidth: _labelWidth,
            ),
            const SizedBox(height: 8),
            RoomInfoRow(
              icon: Icons.circle_outlined,
              label: 'Bi còn lại',
              value: (game.remainingBalls.toList()..sort()).join(', '),
              valueKey: const ValueKey('room-info-remaining'),
              labelWidth: _labelWidth,
            ),
          ],
          if (rules != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Divider(height: 1, color: dividerColor),
            ),
            Text(
              'Luật điểm',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Phiên bản ${rules.version}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in rules.ballPoints.entries)
                  BallRuleChip(
                    key: ValueKey('room-info-rule-${entry.key}'),
                    ball: entry.key,
                    value: entry.value.enabled
                        ? '${entry.value.points}đ'
                        : 'tắt',
                    enabled: entry.value.enabled,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          const RoomInfoNote(message: _note),
        ],
      ),
    );
  }
}
