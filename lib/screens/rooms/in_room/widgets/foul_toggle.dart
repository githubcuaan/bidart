import 'package:flutter/material.dart';

/// Chain label shown above the ball picker.
class ChainLabel extends StatelessWidget {
  const ChainLabel({super.key, required this.isBreakChain});

  final bool isBreakChain;

  @override
  Widget build(BuildContext context) =>
      Text(isBreakChain ? 'Chuỗi đề-pa: cả làng trả' : 'Chuỗi thường');
}

/// Foul switch for the turn being drafted.
class TurnFoulToggle extends StatelessWidget {
  const TurnFoulToggle({
    super.key,
    required this.foul,
    required this.foulLabel,
    required this.enabled,
    required this.onChanged,
  });

  final bool foul;
  final String foulLabel;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SwitchListTile(
      key: const ValueKey('turn-foul'),
      contentPadding: EdgeInsets.zero,
      title: const Text('Có lỗi trong cú này'),
      secondary: Icon(
        foul ? Icons.warning_amber_rounded : Icons.warning_amber_outlined,
        color: foul ? scheme.error : scheme.onSurfaceVariant,
      ),
      subtitle: Text('Phân loại: $foulLabel'),
      value: foul,
      onChanged: enabled ? onChanged : null,
    );
  }
}
