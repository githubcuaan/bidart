import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Optional time/score limits; empty means "no limit".
class EndConditionsFields extends StatelessWidget {
  const EndConditionsFields({
    super.key,
    required this.duration,
    required this.threshold,
    required this.enabled,
    required this.durationError,
    required this.thresholdError,
    required this.onChanged,
  });

  final TextEditingController duration;
  final TextEditingController threshold;
  final bool enabled;
  final String? durationError;
  final String? thresholdError;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => SectionCard(
    title: 'Kết thúc sớm',
    description: 'Để trống nếu không giới hạn thời gian hoặc điểm.',
    child: Column(
      children: [
        TextField(
          key: const ValueKey('duration-seconds'),
          controller: duration,
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Thời lượng (giây, tùy chọn)',
            errorText: durationError,
          ),
          onChanged: (_) => onChanged(),
        ),
        TextField(
          key: const ValueKey('score-threshold'),
          controller: threshold,
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Ngưỡng điểm (tùy chọn)',
            errorText: thresholdError,
          ),
          onChanged: (_) => onChanged(),
        ),
      ],
    ),
  );
}
