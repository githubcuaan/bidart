import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:bidart/widgets/room/room_info_card.dart';
import 'package:flutter/material.dart';

/// Committed state only; draft/command controls live in InRoom.
class RoomDetails extends StatelessWidget {
  const RoomDetails({super.key, required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          collapsible: false,
          icon: Icons.leaderboard_outlined,
          title: 'Điểm trong phòng',
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
        RoomInfoCard(room: room),
      ],
    );
  }
}
