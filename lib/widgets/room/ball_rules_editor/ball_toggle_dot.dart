import 'package:flutter/material.dart';

import 'pool_ball_icon.dart';

/// Round on/off toggle for one ball, drawn as a widget (no image assets).
class BallToggleDot extends StatelessWidget {
  const BallToggleDot({
    super.key,
    required this.ball,
    required this.enabled,
    required this.size,
    this.onToggle,
    this.semanticLabel,
    this.activeTooltip,
    this.inactiveTooltip,
  });

  final int ball;
  final bool enabled;
  final double size;
  final ValueChanged<int>? onToggle;
  final String? semanticLabel;

  /// Tooltips for the toggled/untoggled state. Default to the scoring wording;
  /// other pickers (e.g. the turn ball picker) override them.
  final String? activeTooltip;
  final String? inactiveTooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: enabled,
      label: semanticLabel ?? 'Bi $ball',
      child: Tooltip(
        message: enabled
            ? (activeTooltip ?? 'Tắt tính điểm bi $ball')
            : (inactiveTooltip ?? 'Bật tính điểm bi $ball'),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onToggle == null ? null : () => onToggle!(ball),
          child: ClipOval(
            child: AnimatedOpacity(
              opacity: enabled ? 1 : 0.4,
              duration: const Duration(milliseconds: 150),
              child: PoolBallIcon(ball: ball, size: size, enabled: enabled),
            ),
          ),
        ),
      ),
    );
  }
}
