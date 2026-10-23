import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Notice shown when the room reached an end condition mid-game.
class EndConditionsSection extends StatelessWidget {
  const EndConditionsSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionCard(
    icon: Icons.timer_outlined,
    title: 'Điều kiện kết thúc',
    collapsible: false,
    child: Text('Đã đạt điều kiện kết thúc — đánh hết ván rồi đóng phòng.'),
  );
}
