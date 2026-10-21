import 'package:flutter/material.dart';

/// Finish/cancel controls; both end the room and make it read-only.
class RoomLifecycleActions extends StatelessWidget {
  const RoomLifecycleActions({
    super.key,
    required this.enabled,
    required this.onFinish,
    required this.onCancel,
  });

  final bool enabled;
  final VoidCallback onFinish;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    children: [
      OutlinedButton(
        key: const ValueKey('finish-room'),
        onPressed: enabled ? onFinish : null,
        child: const Text('Kết thúc phòng'),
      ),
      OutlinedButton(
        key: const ValueKey('cancel-room'),
        onPressed: enabled ? onCancel : null,
        child: const Text('Huỷ phòng'),
      ),
    ],
  );
}
