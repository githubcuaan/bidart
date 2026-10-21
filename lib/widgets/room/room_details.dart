import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/core/labels/room_labels.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Điểm cộng dồn'),
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
        Text('Thứ tự: ${room.playerOrder.map(_name).join(' → ')}'),
        Text('Số ván: ${room.games.length}'),
        if (game != null) ...[
          Text('Ván ${game.gameNumber} · ${gameStatusLabel(game.status)}'),
          Text('Người đánh: ${_name(game.currentPlayerId)}'),
          Text('Người trả: ${_name(game.payerId)}'),
          Text(
            'Bi còn lại: ${(game.remainingBalls.toList()..sort()).join(', ')}',
          ),
        ],
        if (rules != null) ...[
          const SizedBox(height: 16),
          Text('Luật phiên bản ${rules.version}'),
          Text(
            rules.ballPoints.entries
                .map(
                  (entry) =>
                      'Bi ${entry.key}: ${entry.value.enabled ? '${entry.value.points}đ' : 'tắt'}',
                )
                .join(' · '),
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          'Phòng tự lưu local; đóng/mở app vẫn giữ nguyên trạng thái.',
        ),
      ],
    );
  }
}
