import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/widgets/async/async_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_room.dart';
import 'chose_room.dart';
import 'room_presentation.dart';

class Rooms extends ConsumerStatefulWidget {
  const Rooms({super.key});

  @override
  ConsumerState<Rooms> createState() => _RoomsState();
}

class _RoomsState extends ConsumerState<Rooms> {
  RoomStatus? _status;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Text(
          'Phòng tự lưu local; đóng/mở app vẫn giữ nguyên trạng thái.',
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton.icon(
              key: const ValueKey('create-room'),
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => const AddRoom())),
              icon: const Icon(Icons.add),
              label: const Text('Tạo phòng'),
            ),
            DropdownButton<RoomStatus?>(
              key: const ValueKey('room-status-filter'),
              value: _status,
              hint: const Text('Tất cả'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Tất cả')),
                for (final status in RoomStatus.values)
                  DropdownMenuItem(
                    value: status,
                    child: Text(roomStatusLabel(status)),
                  ),
              ],
              onChanged: (value) => setState(() => _status = value),
            ),
          ],
        ),
      ),
      Expanded(
        child: AsyncContent(
          value: ref.watch(roomListProvider(_status)),
          skipLoadingOnRefresh: false,
          errorBuilder: (context, error, _) => RoomLoadError(
            error: error,
            onRetry: () => ref.invalidate(roomListProvider(_status)),
          ),
          dataBuilder: (context, rooms) => rooms.isEmpty
              ? const Center(child: Text('Chưa có phòng trong danh sách này.'))
              : ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return ListTile(
                      key: ValueKey('room-${room.id}'),
                      title: Text(room.name),
                      subtitle: Text(
                        '${roomStatusLabel(room.status)} · ${room.activePlayerCount} người · ${room.gameCount} ván',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ChoseRoom(roomId: room.id),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    ],
  );
}
