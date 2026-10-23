import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/widgets/room/ball_rules_editor/pool_ball_icon.dart';
import 'package:flutter/material.dart';

/// Recording page artwork: a 3x3 ball picker with ball 9 selected, a ripple and
/// an undo confirmation.
class RecordingVisual extends StatefulWidget {
  const RecordingVisual({
    super.key,
    required this.isActive,
    required this.enableMotion,
  });

  final bool isActive;
  final bool enableMotion;

  @override
  State<RecordingVisual> createState() => _RecordingVisualState();
}

class _RecordingVisualState extends State<RecordingVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ripple;

  @override
  void initState() {
    super.initState();
    _ripple = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _sync();
  }

  @override
  void didUpdateWidget(covariant RecordingVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.enableMotion != widget.enableMotion) {
      _sync();
    }
  }

  void _sync() {
    if (widget.isActive && widget.enableMotion) {
      _ripple.repeat();
    } else {
      _ripple.stop();
      _ripple.value = 0;
    }
  }

  @override
  void dispose() {
    _ripple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(child: _header()),
            ),
            Positioned(left: 61, top: 52, child: _grid()),
            Positioned(left: 16, right: 16, top: 258, child: _steps()),
            Positioned(left: 32, right: 32, bottom: 6, child: _undoPill()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.darkOnSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Lượt của Tuấn Anh',
            style: TextStyle(
              color: AppColors.darkOnSurface,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Bi 9',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _grid() {
    return Column(
      children: [
        for (var row = 0; row < 3; row++) ...[
          if (row > 0) const SizedBox(height: 12),
          Row(
            children: [
              for (var col = 0; col < 3; col++) ...[
                if (col > 0) const SizedBox(width: 12),
                _ballCell(row * 3 + col + 1),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _ballCell(int ball) {
    final selected = ball == 9;

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.secondary.withValues(alpha: 0.12)
            : AppColors.darkSurfaceContainerHigh.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? AppColors.secondary.withValues(alpha: 0.85)
              : AppColors.darkOnSurface.withValues(alpha: 0.06),
          width: selected ? 1.4 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.32),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          PoolBallIcon(ball: ball, size: 42),
          if (selected)
            AnimatedBuilder(
              animation: _ripple,
              builder: (context, _) {
                final progress = _ripple.value;
                return IgnorePointer(
                  child: Container(
                    width: 42 + progress * 30,
                    height: 42 + progress * 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondary.withValues(
                          alpha: (1 - progress) * 0.55,
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _steps() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _step('1', 'Chọn người', active: true),
          _arrow(),
          _step('2', 'Chọn bi', active: true),
          _arrow(),
          _step('3', 'Xong', active: false),
        ],
      ),
    );
  }

  Widget _step(String number, String label, {required bool active}) {
    final color = active ? AppColors.primary : AppColors.darkOnSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: active ? 0.16 : 0.06),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Text(
            number,
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _arrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 10,
        color: AppColors.darkOnSurfaceVariant,
      ),
    );
  }

  Widget _undoPill() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: widget.isActive ? 1 : 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceContainer.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.undo_rounded, size: 14, color: AppColors.primary),
            SizedBox(width: 6),
            Text(
              'Đã hoàn tác cú trước',
              style: TextStyle(
                color: AppColors.darkOnSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
