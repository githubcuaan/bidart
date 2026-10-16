import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'in_room.dart';
import 'room_presentation.dart';

/// One selected room, never a second room list.
class ChoseRoom extends ConsumerWidget {
  const ChoseRoom({super.key, required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Chi tiết phòng')),
    body: ref
        .watch(roomByIdProvider(roomId))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => RoomLoadError(
            error: error,
            onRetry: () => ref.invalidate(roomByIdProvider(roomId)),
          ),
          data: (room) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FilledButton(
                key: const ValueKey('open-room'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => InRoom(roomId: roomId),
                  ),
                ),
                child: Text(
                  room.status == RoomStatus.active
                      ? 'Vào phòng'
                      : 'Xem kết quả',
                ),
              ),
              const SizedBox(height: 16),
              RoomDetails(room: room),
            ],
          ),
        ),
  );
}
