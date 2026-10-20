import 'package:flutter/material.dart';

/// Error state with retry/reload for a failed room action.
class RoomErrorPanel extends StatelessWidget {
  const RoomErrorPanel({
    super.key,
    required this.message,
    required this.enabled,
    required this.fromNextGame,
    required this.onRetry,
    required this.onReload,
  });

  final String message;
  final bool enabled;

  /// The pending failure belongs to the next-game controller, not the turn one.
  final bool fromNextGame;
  final void Function({required bool fromNextGame}) onRetry;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(message),
      TextButton(
        key: const ValueKey('retry-action'),
        onPressed: enabled ? () => onRetry(fromNextGame: fromNextGame) : null,
        child: const Text('Thử lưu lại'),
      ),
      TextButton(
        key: const ValueKey('reload-room'),
        onPressed: enabled ? onReload : null,
        child: const Text('Tải lại phòng'),
      ),
    ],
  );
}
