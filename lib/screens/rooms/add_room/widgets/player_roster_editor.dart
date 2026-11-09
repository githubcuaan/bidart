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
    required this.onReorder,
    required this.onRemove,
    required this.onAdd,
  });

  static const _fixedRoles = ['Đề-pa', 'Đền đầu'];

  final List<PlayerInGame> players;
  final Map<String, TextEditingController> names;
  final String? Function(int index) errorFor;
  final bool enabled;
  final VoidCallback onChanged;
  final void Function(int index, int offset) onMove;
  final void Function(int oldIndex, int newIndex) onReorder;
  final ValueChanged<String> onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.group_outlined,
    title: 'Người chơi (${players.length}/5)',
    description:
        'Kéo thẻ hoặc dùng nút lên/xuống để đổi thứ tự. '
        'Người đầu đề-pa, người thứ hai đền đầu.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: players.length,
          onReorderItem: onReorder,
          itemBuilder: (context, index) => _playerRow(context, index),
        ),
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
    final hasRole = index < _fixedRoles.length;

    return Container(
      // Keep the switcher attached to the slot so both exchanged cards
      // animate through their destination positions.
      key: ValueKey('player-row-$index'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: hasRole
            ? scheme.primaryContainer.withValues(alpha: 0.28)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        border: Border.all(
          color: hasRole ? scheme.primary : scheme.outlineVariant,
          width: hasRole ? 1.2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        reverseDuration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final slide = Tween<Offset>(
            begin: Offset(0, index.isEven ? 0.85 : -0.85),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: Column(
          key: ValueKey('player-content-${player.id}-$index'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasRole) ...[
              Container(
                key: ValueKey('role-badge-${player.id}'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
                ReorderableDragStartListener(
                  index: index,
                  child: SizedBox(
                    width: 36,
                    height: 48,
                    child: Tooltip(
                      message: 'Kéo để đổi vị trí',
                      child: Icon(
                        Icons.drag_indicator,
                        key: ValueKey('drag-player-${player.id}'),
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
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
                IconButton(
                  key: ValueKey('move-up-${player.id}'),
                  tooltip: 'Đưa lên',
                  onPressed: enabled && index > 0
                      ? () => onMove(index, -1)
                      : null,
                  icon: const Icon(Icons.arrow_upward),
                ),
                IconButton(
                  key: ValueKey('move-down-${player.id}'),
                  tooltip: 'Đưa xuống',
                  onPressed: enabled && index < players.length - 1
                      ? () => onMove(index, 1)
                      : null,
                  icon: const Icon(Icons.arrow_downward),
                ),
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
      ),
    );
  }
}
