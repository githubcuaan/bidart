import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/widgets/card/section_card.dart';
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

  /// First break player, second initial payer. Their rows never move.
  static const lockedCount = 2;

  final List<PlayerInGame> players;
  final Map<String, TextEditingController> names;
  final String? Function(int index) errorFor;
  final bool enabled;
  final VoidCallback onChanged;
  final void Function(int index, int offset) onMove;
  final ValueChanged<String> onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.group_outlined,
    title: 'Người chơi (${players.length}/5)',
    description:
        'Người 1 đề-pa, người 2 đền đầu. Chỉ đổi thứ tự từ người 3 trở đi.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                tooltip: index < lockedCount
                    ? 'Cố định theo vai trò'
                    : 'Đưa lên',
                onPressed: enabled && index > lockedCount
                    ? () => onMove(index, -1)
                    : null,
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                key: ValueKey('move-down-${players[index].id}'),
                tooltip: index < lockedCount
                    ? 'Cố định theo vai trò'
                    : 'Đưa xuống',
                onPressed:
                    enabled &&
                        index >= lockedCount &&
                        index != players.length - 1
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
        SizedBox(height: 10),
        TextButton.icon(
          key: const ValueKey('add-player'),
          onPressed: enabled && players.length < 5 ? onAdd : null,
          icon: const Icon(Icons.person_add),
          label: const Text('Thêm người chơi'),
        ),
      ],
    ),
  );
}
