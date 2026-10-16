import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/features/scoring/provider/next_game_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_presentation.dart';

class InRoom extends ConsumerWidget {
  const InRoom({super.key, required this.roomId});
  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Trong phòng')),
    body: ref
        .watch(roomByIdProvider(roomId))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => RoomLoadError(
            error: error,
            onRetry: () => ref.invalidate(roomByIdProvider(roomId)),
          ),
          data: (room) {
            final next = ref.watch(nextGameControllerProvider(roomId));
            final game = room.games
                .where((game) => game.id == room.currentGameId)
                .firstOrNull;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (room.status == RoomStatus.active &&
                    game?.status == GameStatus.finished)
                  FilledButton(
                    key: const ValueKey('next-game'),
                    onPressed: next.isLoading
                        ? null
                        : () => ref
                              .read(nextGameControllerProvider(roomId).notifier)
                              .submit(expectedRevision: room.revision),
                    child: Text(
                      next.isLoading ? 'Đang lưu…' : 'Bắt đầu ván tiếp',
                    ),
                  ),
                if (next.hasError && room.status == RoomStatus.active)
                  Column(
                    children: [
                      Text(roomFailureMessage(next.error!)),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(roomByIdProvider(roomId)),
                        child: const Text('Tải lại phòng'),
                      ),
                    ],
                  ),
                RoomDetails(room: room),
                if (room.status == RoomStatus.active)
                  const Text('Ghi lượt, tính điểm và hoàn tác sẽ có ở bước 3.'),
              ],
            );
          },
        ),
  );
}
