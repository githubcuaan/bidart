import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/scoring/provider/room_providers.dart';
import 'home_snapshot.dart';
import 'widgets/active_room_card.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/home_quick_actions.dart';
import 'widgets/home_stats_row.dart';
import 'widgets/new_room_card.dart';
import 'widgets/recent_rooms_section.dart';

class Home extends ConsumerWidget {
  final VoidCallback? onOpenRooms;

  const Home({super.key, this.onOpenRooms});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomListProvider(null));

    return RefreshIndicator(
      onRefresh: () async {
        try {
          ref.invalidate(roomListProvider(null));
          await ref.read(roomListProvider(null).future);
        } catch (_) {}
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Sẵn sàng vào bàn?',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Trận đấu tự lưu trên máy...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          roomsAsync.when(
            data: (rooms) {
              final snapshot = HomeSnapshot.from(rooms);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (snapshot.active != null)
                    ActiveRoomCard(activeRoom: snapshot.active!)
                  else
                    const NewRoomCard(),

                  const SizedBox(height: 12),

                  HomeQuickActions(onOpenRooms: onOpenRooms),

                  const SizedBox(height: 20),

                  if (rooms.isEmpty)
                    const HomeEmptyState()
                  else ...[
                    HomeStatsRow(
                      roomCount: snapshot.roomCount,
                      gameCount: snapshot.gameCount,
                      finishedCount: snapshot.finishedCount,
                    ),
                    const SizedBox(height: 20),
                    RecentRoomsSection(
                      recentRooms: snapshot.recent,
                      onOpenRooms: onOpenRooms,
                    ),
                  ],
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              key: const ValueKey('home-load-error'),
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  const Text('Không thể tải danh sách phòng'),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(roomListProvider(null)),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
