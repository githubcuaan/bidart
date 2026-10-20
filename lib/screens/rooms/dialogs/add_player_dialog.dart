import 'package:bidart/domain/models/scoring/room.dart';
import 'package:flutter/material.dart';

/// Adds one participant; duplicates are rejected before returning.
class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({super.key, required this.room});
  final Room room;
  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _name = TextEditingController();
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _name.text.trim();
    final valid =
        name.isNotEmpty &&
        !widget.room.participants.any(
          (p) => p.displayName.toLowerCase() == name.toLowerCase(),
        );
    return AlertDialog(
      title: const Text('Thêm người'),
      content: TextField(
        key: const ValueKey('new-player-name'),
        controller: _name,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(labelText: 'Tên không trùng'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Bỏ qua'),
        ),
        FilledButton(
          key: const ValueKey('save-player'),
          onPressed: valid ? () => Navigator.pop(context, name) : null,
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
