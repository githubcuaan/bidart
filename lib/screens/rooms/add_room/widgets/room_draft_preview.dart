import 'package:flutter/material.dart';

/// Read-only summary of the draft before the room is created.
class RoomDraftPreview extends StatelessWidget {
  const RoomDraftPreview({
    super.key,
    required this.order,
    required this.starter,
    required this.payer,
    required this.rules,
  });

  final String order;
  final String starter;
  final String payer;
  final String rules;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Xem trước'),
      Text('Thứ tự: $order', key: const ValueKey('order-preview')),
      Text('Đề-pa: $starter'),
      Text('Trả đầu: $payer'),
      Text('Luật: $rules'),
      const Text(
        'Bi tắt vẫn thuộc bàn chơi, chỉ không tạo điểm. Đạt thời gian/ngưỡng sẽ chờ hết ván.',
      ),
    ],
  );
}
