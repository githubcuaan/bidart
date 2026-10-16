import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onReload;

  const EmptyState({
    super.key,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sports_soccer_outlined, size: 70, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Đã hết đối thủ quanh khu vực của bạn!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onReload,
            icon: const Icon(Icons.refresh),
            label: const Text('Tìm lại từ đầu'),
          ),
        ],
      ),
    );
  }
}
