import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_management_actions.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Undo, roster, rule and order controls for an active room.
class RoomManagementSection extends StatelessWidget {
  const RoomManagementSection({
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
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.tune_outlined,
    title: 'Quản lý phòng',
    description: 'Hoàn tác, người chơi, luật và thứ tự.',
    child: RoomManagementActions(
      room: room,
      enabled: enabled,
      canUndo: canUndo,
      canAddPlayer: canAddPlayer,
      canRemovePlayers: canRemovePlayers,
      onUndo: onUndo,
      onAddPlayer: onAddPlayer,
      onEditRules: onEditRules,
      onEditOrder: onEditOrder,
      onRemovePlayer: onRemovePlayer,
    ),
  );
}
