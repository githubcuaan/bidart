import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:flutter/material.dart';

/// Per-game and per-event log of the room.
class RoomHistoryPanel extends StatelessWidget {
  const RoomHistoryPanel({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    key: const ValueKey('room-history'),
    title: const Text('Nhật ký'),
    children: [
      for (final history in room.games) ...[
        Text('Ván ${history.gameNumber}'),
        for (final turn in history.turns)
          ListTile(
            title: Text(
              '#${turn.turnNumber} ${playerName(room, turn.actorId)} · ${turn.foulClassification.name}${turn.isUndone ? ' · Đã hoàn tác' : ''}',
            ),
            subtitle: Text(
              'Bi: ${turn.pottedBalls.map((b) => '${b.ballNumber}${b.isRespotted ? ' (đặt lại)' : ''}').join(', ')}\n'
              '${turn.transactions.map((t) => '${playerName(room, t.fromPlayerId)} → ${playerName(room, t.toPlayerId)}: ${t.amount}').join('; ')}',
            ),
          ),
      ],
      for (final event in room.events)
        ListTile(
          title: Text('Edit: ${event.type.name} · revision ${event.revision}'),
          subtitle: const Text('Mốc chặn undo'),
        ),
    ],
  );
}
