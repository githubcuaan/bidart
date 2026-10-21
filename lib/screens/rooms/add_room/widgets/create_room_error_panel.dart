import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:flutter/material.dart';

/// Create failure with a shortcut to the room that is already active.
class CreateRoomErrorPanel extends StatelessWidget {
  const CreateRoomErrorPanel({
    super.key,
    required this.error,
    required this.enabled,
    required this.onOpenExisting,
  });

  final Object error;
  final bool enabled;
  final ValueChanged<String> onOpenExisting;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        roomFailureMessage(error),
        key: const ValueKey('create-error'),
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      if (error is ActiveRoomExistsFailure)
        TextButton(
          key: const ValueKey('open-existing-room'),
          onPressed: enabled
              ? () => onOpenExisting((error as ActiveRoomExistsFailure).roomId)
              : null,
          child: const Text('Mở phòng đang chơi'),
        ),
    ],
  );
}
