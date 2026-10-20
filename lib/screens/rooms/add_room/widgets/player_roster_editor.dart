import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:flutter/material.dart';

/// Editable participant list with reorder/remove plus the add button.
class PlayerRosterEditor extends StatelessWidget {
  const PlayerRosterEditor({
    super.key,
    required this.players,
    required this.names,
    required this.errorFor,
    required this.enabled,
    required this.onChanged,
    required this.onMove,
    required this.onRemove,
    required this.onAdd,
  });

  final List<PlayerInGame> players;
  final Map<String, TextEditingController> names;
  final String? Function(int index) errorFor;
  final bool enabled;
  final VoidCallback onChanged;
  final void Function(int index, int offset) onMove;
  final ValueChanged<String> onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Người chơi (${players.length}/5)',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      for (var index = 0; index < players.length; index++)
        Row(
          key: ValueKey('player-row-${players[index].id}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                key: ValueKey('player-name-${players[index].id}'),
                controller: names[players[index].id],
                enabled: enabled,
                decoration: InputDecoration(
                  labelText: 'Người chơi ${index + 1}',
                  errorText: errorFor(index),
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
            IconButton(
              key: ValueKey('move-up-${players[index].id}'),
              tooltip: 'Đưa lên',
              onPressed: enabled && index != 0 ? () => onMove(index, -1) : null,
              icon: const Icon(Icons.arrow_upward),
            ),
            IconButton(
              key: ValueKey('move-down-${players[index].id}'),
              tooltip: 'Đưa xuống',
              onPressed: enabled && index != players.length - 1
                  ? () => onMove(index, 1)
                  : null,
              icon: const Icon(Icons.arrow_downward),
            ),
            IconButton(
              key: ValueKey('remove-player-${players[index].id}'),
              tooltip: 'Xóa người chơi',
              onPressed: enabled && players.length > 2
                  ? () => onRemove(players[index].id)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      TextButton.icon(
        key: const ValueKey('add-player'),
        onPressed: enabled && players.length < 5 ? onAdd : null,
        icon: const Icon(Icons.person_add),
        label: const Text('Thêm người chơi'),
      ),
    ],
  );
}
