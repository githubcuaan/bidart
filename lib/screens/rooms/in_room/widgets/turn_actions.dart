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
    required this.onClear,
    required this.onRecord,
  });

  final bool clearEnabled;
  final bool showClear;
  final bool recordEnabled;
  final bool saving;
  final bool foul;
  final VoidCallback onClear;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      FilledButton(
        key: const ValueKey('record-turn'),
        onPressed: recordEnabled && !saving ? onRecord : null,
        child: Text(
          saving
              ? 'Đang lưu…'
              : foul
              ? 'Xác nhận cú lỗi'
              : 'Cơ tiếp (đánh hụt)',
        ),
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
