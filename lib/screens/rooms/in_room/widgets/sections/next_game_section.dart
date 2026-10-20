import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Primary call to action shown once the current game has finished.
class NextGameSection extends StatelessWidget {
  const NextGameSection({
    super.key,
    required this.gameNumber,
    required this.loading,
    required this.onStart,
  });

  final int gameNumber;
  final bool loading;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.skip_next,
    title: 'Ván tiếp theo',
    description: 'Ván $gameNumber đã kết thúc',
    collapsible: false,
    child: SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: const ValueKey('next-game'),
        onPressed: onStart,
        child: Text(loading ? 'Đang lưu…' : 'Bắt đầu ván tiếp'),
      ),
    ),
  );
}
