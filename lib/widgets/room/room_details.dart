import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:bidart/widgets/room/ball_rule_chip.dart';
import 'package:bidart/widgets/room/room_info_note.dart';
import 'package:bidart/widgets/room/room_info_row.dart';
import 'package:flutter/material.dart';

/// Committed state only; draft/command controls live in InRoom.
class RoomDetails extends StatelessWidget {
  const RoomDetails({super.key, required this.room});
  final Room room;

  String _name(String id) => playerName(room, id);

  @override
  Widget build(BuildContext context) {
    final game = room.games
        .where((game) => game.id == room.currentGameId)
        .firstOrNull;
    final rules = room.ruleVersions
        .where((rule) => rule.version == room.currentRuleVersion)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          collapsible: false,
          icon: Icons.leaderboard_outlined,
          title: 'Điểm cộng dồn',
          child: Column(
            children: [
              for (final player in room.participants)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(player.displayName),
                  subtitle: room.activePlayerIds.contains(player.id)
                      ? null
                      : const Text('Đã rời phòng'),
                  trailing: Text(
                    '${room.scores[player.id] ?? 0}',
                    key: ValueKey('score-${player.id}'),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          collapsible: false,
          icon: Icons.casino_outlined,
          title: 'Bàn chơi',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoomInfoRow(
                icon: Icons.format_list_numbered,
                label: 'Thứ tự',
                value: room.playerOrder.map(_name).join(' → '),
                labelWidth: 80,
              ),
              const SizedBox(height: 8),
              RoomInfoRow(
                icon: Icons.layers_outlined,
                label: 'Số ván',
                value: '${room.games.length}',
                labelWidth: 80,
              ),
              if (game != null) ...[
                const SizedBox(height: 8),
                RoomInfoRow(
                  icon: Icons.play_circle_outline,
                  label: 'Ván',
                  value: '${game.gameNumber} · ${gameStatusLabel(game.status)}',
                  labelWidth: 80,
                ),
                const SizedBox(height: 8),
                RoomInfoRow(
                  icon: Icons.sports_esports_outlined,
                  label: 'Người đánh',
                  value: _name(game.currentPlayerId),
                  labelWidth: 80,
                ),
                const SizedBox(height: 8),
                RoomInfoRow(
                  icon: Icons.payments_outlined,
                  label: 'Người trả',
                  value: _name(game.payerId),
                  labelWidth: 80,
                ),
                const SizedBox(height: 8),
                RoomInfoRow(
                  icon: Icons.circle_outlined,
                  label: 'Bi còn lại',
                  value: (game.remainingBalls.toList()..sort()).join(', '),
                  labelWidth: 80,
                ),
              ],
            ],
          ),
        ),
        if (rules != null) ...[
          const SizedBox(height: 16),
          SectionCard(
            collapsible: false,
            icon: Icons.rule,
            title: 'Luật điểm',
            description: 'Phiên bản ${rules.version}',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in rules.ballPoints.entries)
                  BallRuleChip(
                    key: ValueKey('room-rule-${entry.key}'),
                    ball: entry.key,
                    value: entry.value.enabled
                        ? '${entry.value.points}đ'
                        : 'tắt',
                    enabled: entry.value.enabled,
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        const RoomInfoNote(
          message: 'Phòng tự lưu local; đóng/mở app vẫn giữ nguyên trạng thái.',
        ),
      ],
    );
  }
}
