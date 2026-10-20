import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:flutter/material.dart';

class ReplacementChoice {
  const ReplacementChoice(this.starter, this.payer);
  final String? starter, payer;
}

/// Starter and payer picked for the next game when a player left the room.
class ReplacementDialog extends StatefulWidget {
  const ReplacementDialog({super.key, required this.room});
  final Room room;
  @override
  State<ReplacementDialog> createState() => _ReplacementDialogState();
}

class _ReplacementDialogState extends State<ReplacementDialog> {
  String? starter, payer;
  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final game = room.games.last;
    final needsStarter = !room.activePlayerIds.contains(game.winnerId);
    final needsPayer = !room.activePlayerIds.contains(game.finalPayerId);
    final actualStarter = needsStarter ? starter : game.winnerId;
    final actualPayer = needsPayer ? payer : game.finalPayerId;
    final valid =
        actualStarter != null &&
        actualPayer != null &&
        actualStarter != actualPayer;
    Widget choice(
      String label,
      String key,
      String? selected,
      ValueChanged<String?> onChange,
    ) => DropdownButtonFormField<String>(
      key: ValueKey(key),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final id in room.activePlayerIds)
          DropdownMenuItem(value: id, child: Text(playerName(room, id))),
      ],
      onChanged: onChange,
    );
    return AlertDialog(
      title: const Text('Chọn người thay thế'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chỉ áp dụng ván mới, không sửa lịch sử.'),
            if (needsStarter)
              choice(
                'Người đề-pa thay thế',
                'replacement-starter',
                starter,
                (id) => setState(() => starter = id),
              ),
            if (needsPayer)
              choice(
                'Người trả thay thế',
                'replacement-payer',
                payer,
                (id) => setState(() => payer = id),
              ),
            if (!valid) const Text('Chọn đủ hai vai trò khác nhau.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Bỏ qua'),
        ),
        FilledButton(
          key: const ValueKey('confirm-replacements'),
          onPressed: valid
              ? () => Navigator.pop(context, ReplacementChoice(starter, payer))
              : null,
          child: const Text('Bắt đầu'),
        ),
      ],
    );
  }
}
