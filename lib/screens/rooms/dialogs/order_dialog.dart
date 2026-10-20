import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:flutter/material.dart';

/// Reorders participants while keeping the current shooter and payer.
class OrderDialog extends StatefulWidget {
  const OrderDialog({super.key, required this.room});
  final Room room;
  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  late final order = [...widget.room.playerOrder];
  void move(int index, int delta) => setState(() {
    final id = order.removeAt(index);
    order.insert(index + delta, id);
  });
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Sửa thứ tự'),
    content: SizedBox(
      width: 340,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Giữ người đang đánh và payer; chặn undo các cú trước.'),
            for (var i = 0; i < order.length; i++)
              Row(
                children: [
                  Expanded(child: Text(playerName(widget.room, order[i]))),
                  IconButton(
                    key: ValueKey('order-up-${order[i]}'),
                    onPressed: i > 0 ? () => move(i, -1) : null,
                    tooltip: 'Lên',
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  IconButton(
                    key: ValueKey('order-down-${order[i]}'),
                    onPressed: i < order.length - 1 ? () => move(i, 1) : null,
                    tooltip: 'Xuống',
                    icon: const Icon(Icons.arrow_downward),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Bỏ qua'),
      ),
      FilledButton(
        key: const ValueKey('save-order'),
        onPressed: () => Navigator.pop(context, order),
        child: const Text('Lưu thứ tự'),
      ),
    ],
  );
}
