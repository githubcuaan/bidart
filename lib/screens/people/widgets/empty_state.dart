import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onReload;

  const EmptyState({
    super.key,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_2_outlined,
                size: 56,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Đã hết đối thủ quanh khu vực của bạn!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Thử mở rộng khoảng cách hoặc quay lại sau nhé.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onReload,
              icon: const Icon(Icons.refresh),
              label: const Text('Tìm lại từ đầu'),
            ),
          ],
        ),
      ),
    );
  }
}
