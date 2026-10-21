import 'package:bidart/domain/models/scoring/room_summary.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:flutter/material.dart';

/// One room row in the room list.
class RoomListItem extends StatelessWidget {
  const RoomListItem({super.key, required this.room, required this.onTap});

  final RoomSummary room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    key: ValueKey('room-${room.id}'),
    title: Text(room.name),
    subtitle: Text(
      '${roomStatusLabel(room.status)} · ${room.activePlayerCount} người · ${room.gameCount} ván',
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
