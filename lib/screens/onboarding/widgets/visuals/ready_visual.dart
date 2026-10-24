import 'dart:math' as math;

import 'package:bidart/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Final page artwork: a ready room card, a check ring and a single confetti
/// burst when the page becomes active.
class ReadyVisual extends StatefulWidget {
  const ReadyVisual({
    super.key,
    required this.isActive,
    required this.enableMotion,
  });

  final bool isActive;
  final bool enableMotion;

  @override
  State<ReadyVisual> createState() => _ReadyVisualState();
}

class _ReadyVisualState extends State<ReadyVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _sync();
  }

  @override
  void didUpdateWidget(covariant ReadyVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.enableMotion != widget.enableMotion) {
      _sync();
    }
  }

  void _sync() {
    if (!widget.enableMotion) {
      _controller
        ..stop()
        ..value = 1;
      return;
    }
    if (widget.isActive) {
      _controller.forward(from: 0);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 320,
        height: 320,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            final check = Curves.easeOutCubic.transform(
              ((t - 0.25) / 0.5).clamp(0.0, 1.0).toDouble(),
            );
            final badge = Curves.easeOutBack.transform(
              ((t - 0.55) / 0.35).clamp(0.0, 1.0).toDouble(),
            );

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CheckRingPainter(progress: check),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(painter: _ConfettiPainter(progress: t)),
                ),
                Positioned(left: 35, top: 96, child: _roomCard()),
                Positioned(
                  left: 232,
                  top: 78,
                  child: Transform.scale(
                    scale: 0.6 + badge * 0.4,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.darkSurface,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.45),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: Color(0xFF002114),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _roomCard() {
    return Container(
      width: 250,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceContainer.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.darkOnSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                'PHÒNG #01',
                style: TextStyle(
                  color: AppColors.darkOnSurfaceVariant,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Sẵn sàng',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Text(
            '9 Bi Bắn Đền',
            style: TextStyle(
              color: AppColors.darkOnSurface,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '4 người • Tuấn Anh đề-pa',
            style: TextStyle(
              color: AppColors.darkOnSurfaceVariant,
              fontSize: 9.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const _Avatar('TA'),
              const _Avatar('HB'),
              const _Avatar('MR'),
              const _Avatar('+1'),
              const Spacer(),
              Text(
                'Vào bàn',
                style: TextStyle(
                  color: AppColors.primary.withValues(alpha: 0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(right: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkSurface, width: 2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.darkOnSurfaceVariant,
          fontSize: 7.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CheckRingPainter extends CustomPainter {
  const _CheckRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const center = Offset(160, 122);
    const radius = 112.0;
    final bounds = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.primary.withValues(alpha: 0.1),
    );

    canvas.drawArc(
      bounds,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primary.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant _CheckRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.progress});

  final double progress;

  static const _particles = <_Particle>[
    _Particle(angle: -2.5, distance: 110, size: 3.5, color: AppColors.primary),
    _Particle(
      angle: -2.1,
      distance: 132,
      size: 2.5,
      color: AppColors.secondary,
    ),
    _Particle(
      angle: -1.7,
      distance: 118,
      size: 3,
      color: AppColors.darkOnSurface,
    ),
    _Particle(angle: -1.25, distance: 138, size: 3.5, color: AppColors.primary),
    _Particle(
      angle: -0.8,
      distance: 122,
      size: 2.5,
      color: AppColors.secondary,
    ),
    _Particle(angle: -0.35, distance: 130, size: 3, color: AppColors.primary),
    _Particle(
      angle: 0.1,
      distance: 112,
      size: 2.5,
      color: AppColors.darkOnSurface,
    ),
    _Particle(
      angle: 0.55,
      distance: 136,
      size: 3.5,
      color: AppColors.secondary,
    ),
    _Particle(angle: 1.0, distance: 120, size: 3, color: AppColors.primary),
    _Particle(
      angle: 1.45,
      distance: 128,
      size: 2.5,
      color: AppColors.darkOnSurface,
    ),
    _Particle(angle: 1.9, distance: 116, size: 3.5, color: AppColors.secondary),
    _Particle(angle: 2.35, distance: 134, size: 3, color: AppColors.primary),
    _Particle(
      angle: 2.8,
      distance: 120,
      size: 2.5,
      color: AppColors.darkOnSurface,
    ),
    _Particle(angle: 3.2, distance: 126, size: 3, color: AppColors.primary),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    const center = Offset(160, 120);
    final eased = Curves.easeOutCubic.transform(progress);
    final fade = (1 - ((progress - 0.5) / 0.5)).clamp(0.0, 1.0).toDouble();

    for (final particle in _particles) {
      final distance = 24 + eased * particle.distance;
      final point =
          center +
          Offset(math.cos(particle.angle), math.sin(particle.angle)) * distance;
      canvas.drawCircle(
        point,
        particle.size * fade,
        Paint()..color = particle.color.withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  const _Particle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.color,
  });

  final double angle;
  final double distance;
  final double size;
  final Color color;
}
