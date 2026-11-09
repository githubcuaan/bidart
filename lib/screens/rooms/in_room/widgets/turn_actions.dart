import 'package:flutter/material.dart';

/// Clear-draft and confirm-turn buttons. Clearing stays available while the
/// preview is invalid; confirming needs a valid preview.
class TurnActions extends StatelessWidget {
  const TurnActions({
    super.key,
    required this.clearEnabled,
    required this.showClear,
    required this.recordEnabled,
    required this.saving,
    required this.foul,
    required this.undoEnabled,
    required this.onUndo,
    required this.onClear,
    required this.onRecord,
  });

  final bool clearEnabled;
  final bool showClear;
  final bool recordEnabled;
  final bool saving;
  final bool foul;
  final bool undoEnabled;
  final VoidCallback onUndo;
  final VoidCallback onClear;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: FilledButton(
              key: const ValueKey('record-turn'),
              onPressed: recordEnabled && !saving ? onRecord : null,
              child: Text(
                saving
                    ? 'Đang lưu…'
                    : foul
                    ? 'Xác nhận lỗi'
                    : 'Cơ tiếp',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              key: const ValueKey('undo-turn'),
              onPressed: undoEnabled ? onUndo : null,
              icon: const Icon(Icons.undo, size: 18),
              label: const Text('Hoàn tác'),
            ),
          ),
        ],
      ),
      if (showClear)
        TextButton(
          key: const ValueKey('clear-turn-draft'),
          onPressed: clearEnabled ? onClear : null,
          child: const Text('Bỏ chọn bi lỗi'),
        ),
    ],
  );
}
