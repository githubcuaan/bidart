import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bidart/domain/models/scoring/room_summary.dart';

import '../../../features/scoring/provider/room_providers.dart';
import '../../rooms/chose_room.dart';
import '../../rooms/in_room/widgets/sections/room_header_section.dart';

class ActiveRoomCard extends ConsumerWidget {
  final RoomSummary activeRoom;

  const ActiveRoomCard({super.key, required this.activeRoom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomByIdProvider(activeRoom.id));

    return Card(
      key: const ValueKey('home-active-room'),
      margin: EdgeInsets.zero,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChoseRoom(roomId: activeRoom.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: roomAsync.when(
            data: (room) => RoomHeaderSection(
              room: room,
              now: () => ref.read(clockProvider)(),
            ),
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Không thể tải thông tin phòng'),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(roomByIdProvider(activeRoom.id)),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
