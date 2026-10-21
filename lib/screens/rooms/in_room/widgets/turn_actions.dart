import 'package:flutter/material.dart';

/// Clear-draft and confirm-turn buttons. Clearing stays available while the
/// preview is invalid; confirming needs a valid preview.
class TurnActions extends StatelessWidget {
  const TurnActions({
    super.key,
    required this.clearEnabled,
    required this.recordEnabled,
    required this.saving,
    required this.onClear,
    required this.onRecord,
  });

  final bool clearEnabled;
  final bool recordEnabled;
  final bool saving;
  final VoidCallback onClear;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        key: const ValueKey('clear-turn-draft'),
        onPressed: clearEnabled ? onClear : null,
        child: const Text('Xoá bản nháp'),
      ),
      FilledButton(
        key: const ValueKey('record-turn'),
        onPressed: recordEnabled && !saving ? onRecord : null,
        child: Text(saving ? 'Đang lưu…' : 'Xác nhận cú đánh'),
      ),
    ],
  );
}
