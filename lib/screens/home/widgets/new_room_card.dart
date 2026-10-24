import 'package:flutter/material.dart';
import '../../rooms/add_room/add_room.dart';

class NewRoomCard extends StatelessWidget {
  const NewRoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home-start-card'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.play_circle_outline_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Chưa có trận nào đang chơi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRoom()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tạo phòng mới'),
          ),
        ],
      ),
    );
  }
}