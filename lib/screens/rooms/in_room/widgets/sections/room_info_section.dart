import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/widgets/room/room_info_card.dart';
import 'package:flutter/material.dart';

/// Collapsed room metadata block on the live room screen.
class RoomInfoSection extends StatelessWidget {
  const RoomInfoSection({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) =>
      RoomInfoCard(room: room, initiallyExpanded: false);
}
