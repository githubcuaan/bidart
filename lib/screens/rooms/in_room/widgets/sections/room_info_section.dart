import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:bidart/widgets/room/room_details.dart';
import 'package:flutter/material.dart';

/// Room metadata, scoreboard, order and active rule summary.
class RoomInfoSection extends StatelessWidget {
  const RoomInfoSection({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.meeting_room_outlined,
    title: 'Thông tin phòng',
    description: 'Điểm số, thứ tự và luật áp dụng.',
    child: RoomDetails(room: room),
  );
}
