import 'package:bidart/core/labels/room_labels.dart';
import 'package:flutter/material.dart';

/// Error state shared by every async room query.
class RoomLoadError extends StatelessWidget {
  const RoomLoadError({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(roomFailureMessage(error), textAlign: TextAlign.center),
        TextButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}
