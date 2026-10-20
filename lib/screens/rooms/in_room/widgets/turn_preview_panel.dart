import 'package:flutter/material.dart';

/// Score delta preview for the drafted turn; keeps display strings dumb so the
/// engine stays in the screen that owns the draft.
class TurnPreviewPanel extends StatelessWidget {
  const TurnPreviewPanel({
    super.key,
    required this.logs,
    required this.respotted,
    required this.nextPlayerName,
  });

  final List<String> logs;
  final List<int> respotted;
  final String nextPlayerName;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        logs.isEmpty ? 'Preview: không đổi điểm' : 'Preview cộng/trừ:',
        key: const ValueKey('score-preview'),
      ),
      for (final log in logs) Text(log),
      if (respotted.isNotEmpty) Text('Đặt lại: ${respotted.join(', ')}'),
      Text('Sau cú: $nextPlayerName có cơ'),
    ],
  );
}
