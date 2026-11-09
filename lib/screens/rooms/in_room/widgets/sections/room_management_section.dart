import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_management_actions.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Roster, rule and order controls for an active room.
class RoomManagementSection extends StatelessWidget {
  const RoomManagementSection({
    super.key,
    required this.room,
    required this.enabled,
    required this.canAddPlayer,
    required this.canRemovePlayers,
    required this.onAddPlayer,
    required this.onEditRules,
    required this.onEditOrder,
    required this.onRemovePlayer,
  });

  final Room room;
  final bool enabled;
  final bool canAddPlayer;
  final bool canRemovePlayers;
  final VoidCallback onAddPlayer;
  final VoidCallback onEditRules;
  final VoidCallback onEditOrder;
  final ValueChanged<String> onRemovePlayer;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.tune_outlined,
    title: 'Quản lý phòng',
    description: 'Người chơi, luật và thứ tự.',
    child: RoomManagementActions(
      room: room,
      enabled: enabled,
      canAddPlayer: canAddPlayer,
      canRemovePlayers: canRemovePlayers,
      onAddPlayer: onAddPlayer,
      onEditRules: onEditRules,
      onEditOrder: onEditOrder,
      onRemovePlayer: onRemovePlayer,
    ),
  );
}
