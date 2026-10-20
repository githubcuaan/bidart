import 'package:bidart/screens/rooms/in_room/widgets/room_error_panel.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Retry/reload card for a failed room action.
class RoomErrorSection extends StatelessWidget {
  const RoomErrorSection({
    super.key,
    required this.message,
    required this.enabled,
    required this.fromNextGame,
    required this.onRetry,
    required this.onReload,
  });

  final String message;
  final bool enabled;
  final bool fromNextGame;
  final void Function({required bool fromNextGame}) onRetry;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.error_outline,
    title: 'Không thể lưu thay đổi',
    collapsible: false,
    child: RoomErrorPanel(
      message: message,
      enabled: enabled,
      fromNextGame: fromNextGame,
      onRetry: onRetry,
      onReload: onReload,
    ),
  );
}
