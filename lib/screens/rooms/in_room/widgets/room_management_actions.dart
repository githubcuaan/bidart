import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:flutter/material.dart';

/// Undo, roster edits and rule/order dialogs while a room is active.
class RoomManagementActions extends StatelessWidget {
  const RoomManagementActions({
    super.key,
    required this.room,
    required this.enabled,
    required this.canUndo,
    required this.canAddPlayer,
    required this.canRemovePlayers,
    required this.onUndo,
    required this.onAddPlayer,
    required this.onEditRules,
    required this.onEditOrder,
    required this.onRemovePlayer,
  });

  final Room room;
  final bool enabled;
  final bool canUndo;
  final bool canAddPlayer;
  final bool canRemovePlayers;
  final VoidCallback onUndo;
  final VoidCallback onAddPlayer;
  final VoidCallback onEditRules;
  final VoidCallback onEditOrder;
  final ValueChanged<String> onRemovePlayer;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      OutlinedButton(
        key: const ValueKey('undo-turn'),
        onPressed: enabled && canUndo ? onUndo : null,
        child: const Text('Hoàn tác cú cuối'),
      ),
      Wrap(
        spacing: 8,
        children: [
          TextButton(
            key: const ValueKey('add-player'),
            onPressed: enabled && canAddPlayer ? onAddPlayer : null,
            child: const Text('Thêm người'),
          ),
          TextButton(
            key: const ValueKey('edit-rules'),
            onPressed: enabled ? onEditRules : null,
            child: const Text('Sửa luật'),
          ),
          TextButton(
            key: const ValueKey('edit-order'),
            onPressed: enabled ? onEditOrder : null,
            child: const Text('Sửa thứ tự'),
          ),
        ],
      ),
      if (canRemovePlayers)
        Wrap(
          spacing: 8,
          children: [
            for (final id in room.activePlayerIds)
              TextButton(
                key: ValueKey('remove-player-$id'),
                onPressed: enabled ? () => onRemovePlayer(id) : null,
                child: Text('Xoá ${playerName(room, id)}'),
              ),
          ],
        ),
    ],
  );
}
