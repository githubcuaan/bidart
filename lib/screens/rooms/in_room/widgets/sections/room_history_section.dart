import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_history_panel.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Turn/event history for every game in the room.
class RoomHistorySection extends StatelessWidget {
  const RoomHistorySection({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.history,
    title: 'Nhật ký',
    description: 'Các cú đánh, sự kiện và mốc hoàn tác.',
    child: RoomHistoryPanel(room: room),
  );
}
