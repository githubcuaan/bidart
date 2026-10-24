import 'package:flutter/material.dart';
import '../../rooms/add_room/add_room.dart';

class HomeQuickActions extends StatelessWidget {
  final VoidCallback? onOpenRooms;

  const HomeQuickActions({super.key, this.onOpenRooms});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          key: const ValueKey('home-create-room'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRoom()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Tạo phòng mới'),
        ),
        OutlinedButton.icon(
          key: const ValueKey('home-open-rooms'),
          onPressed: onOpenRooms,
          icon: const Icon(Icons.list_alt),
          label: const Text('Tất cả phòng'),
        ),
      ],
    );
  }
}