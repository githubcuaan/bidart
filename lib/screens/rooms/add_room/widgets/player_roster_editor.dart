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
  static const _fixedRoles = ['Đề-pa', 'Đền đầu'];

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
        for (var index = 0; index < players.length; index++) ...[
          if (index == lockedCount && players.length > lockedCount)
            _NextOrderSeparator(key: const ValueKey('next-order-label')),
          _playerRow(context, index),
        ],
        const SizedBox(height: 4),
        TextButton.icon(
          key: const ValueKey('add-player'),
          onPressed: enabled && players.length < 5 ? onAdd : null,
          icon: const Icon(Icons.person_add),
          label: const Text('Thêm người chơi'),
        ),
      ],
    ),
  );

  Widget _playerRow(BuildContext context, int index) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final player = players[index];
    final fixed = index < lockedCount;

    return Container(
      key: ValueKey('player-row-${player.id}'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: fixed
            ? scheme.primaryContainer.withValues(alpha: 0.28)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        border: Border.all(
          color: fixed ? scheme.primary : scheme.outlineVariant,
          width: fixed ? 1.2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fixed) ...[
            Container(
              key: ValueKey('role-badge-${player.id}'),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _fixedRoles[index],
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: ValueKey('player-name-${player.id}'),
                  controller: names[player.id],
                  enabled: enabled,
                  decoration: InputDecoration(
                    labelText: 'Người chơi ${index + 1}',
                    errorText: errorFor(index),
                  ),
                  onChanged: (_) => onChanged(),
                ),
              ),
              if (fixed)
                SizedBox(
                  width: 44,
                  height: 48,
                  child: Center(
                    child: Tooltip(
                      message: 'Cố định theo vai trò ${_fixedRoles[index]}',
                      child: Icon(
                        Icons.lock_outline,
                        key: ValueKey('locked-player-${player.id}'),
                        color: scheme.primary,
                      ),
                    ),
                  ),
                )
              else ...[
                IconButton(
                  key: ValueKey('move-up-${player.id}'),
                  tooltip: 'Đưa lên',
                  onPressed: enabled && index > lockedCount
                      ? () => onMove(index, -1)
                      : null,
                  icon: const Icon(Icons.arrow_upward),
                ),
                IconButton(
                  key: ValueKey('move-down-${player.id}'),
                  tooltip: 'Đưa xuống',
                  onPressed:
                      enabled &&
                          index >= lockedCount &&
                          index != players.length - 1
                      ? () => onMove(index, 1)
                      : null,
                  icon: const Icon(Icons.arrow_downward),
                ),
              ],
              IconButton(
                key: ValueKey('remove-player-${player.id}'),
                tooltip: 'Xóa người chơi',
                onPressed: enabled && players.length > 2
                    ? () => onRemove(player.id)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Divider label between the fixed opening pair and reorderable players.
class _NextOrderSeparator extends StatelessWidget {
  const _NextOrderSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: scheme.outlineVariant)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Thứ tự lượt chơi tiếp theo',
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Divider(color: scheme.outlineVariant)),
        ],
      ),
    );
  }
}
