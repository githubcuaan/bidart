import 'package:flutter/material.dart';
import 'package:bidart/domain/models/scoring/room_summary.dart';

import '../../rooms/chose_room.dart';
import '../../rooms/widgets/room_list_item.dart';

class RecentRoomsSection extends StatelessWidget {
  final List<RoomSummary> recentRooms;
  final VoidCallback? onOpenRooms;

  const RecentRoomsSection({
    super.key,
    required this.recentRooms,
    this.onOpenRooms,
  });

  @override
  Widget build(BuildContext context) {
    if (recentRooms.isEmpty) return const SizedBox.shrink();

    return Column(
      key: const ValueKey('home-recent-list'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phòng gần đây',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: onOpenRooms, child: const Text('Xem tất cả')),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentRooms.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final room = recentRooms[index];
            return RoomListItem(
              key: ValueKey('room-${room.id}'),
              room: room,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChoseRoom(roomId: room.id),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
