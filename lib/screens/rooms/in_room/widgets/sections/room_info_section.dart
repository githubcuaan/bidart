import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/room_header_section.dart';
import 'package:bidart/widgets/room/room_info_card.dart';
import 'package:flutter/material.dart';

/// Room identity, limits and metadata in one place.
class RoomInfoSection extends StatelessWidget {
  const RoomInfoSection({super.key, required this.room, required this.now});

  final Room room;
  final DateTime Function() now;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      RoomHeaderSection(room: room, now: now),
      const SizedBox(height: 12),
      RoomInfoCard(room: room, collapsible: false),
    ],
  );
}
