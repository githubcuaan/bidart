import 'package:bidart/screens/rooms/in_room/widgets/room_lifecycle_actions.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Finish/cancel controls that make the room read-only.
class RoomLifecycleSection extends StatelessWidget {
  const RoomLifecycleSection({
    super.key,
    required this.enabled,
    required this.onFinish,
    required this.onCancel,
  });

  final bool enabled;
  final VoidCallback onFinish;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.flag_outlined,
    title: 'Kết thúc phòng',
    description: 'Đóng phòng và chuyển sang chế độ chỉ đọc.',
    child: RoomLifecycleActions(
      enabled: enabled,
      onFinish: onFinish,
      onCancel: onCancel,
    ),
  );
}
