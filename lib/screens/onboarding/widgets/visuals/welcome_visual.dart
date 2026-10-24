import 'dart:math' as math;

import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/widgets/branding/bidart_logo.dart';
import 'package:bidart/widgets/room/ball_rules_editor/pool_ball_icon.dart';
import 'package:flutter/material.dart';

/// Welcome page artwork: the brand mark inside a pocket ring with three balls
/// slowly drifting around it.
class WelcomeVisual extends StatefulWidget {
  const WelcomeVisual({
    super.key,
    required this.isActive,
    required this.enableMotion,
  });

  final bool isActive;
  final bool enableMotion;

  @override
  State<WelcomeVisual> createState() => _WelcomeVisualState();
}

class _WelcomeVisualState extends State<WelcomeVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5600),
    );
    _sync();
  }

  @override
  void didUpdateWidget(covariant WelcomeVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.enableMotion != widget.enableMotion) {
      _sync();
    }
  }

  void _sync() {
    if (widget.isActive && widget.enableMotion) {
      _float.repeat();
    } else {
      _float.stop();
      _float.value = 0.15;
    }
  }

  @override
  void dispose() {
    _float.dispose();
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
          animation: _float,
          builder: (context, _) {
            final phase = _float.value * 2 * math.pi;
            final drift = math.sin(phase) * 4;
            final driftTwo = math.cos(phase) * 3;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _OrbitPainter(
                      rotation: _float.value * 2 * math.pi * (5.6 / 24),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: CustomPaint(painter: _RingPainter()),
                ),
                Center(
                  child: Transform.translate(
                    offset: Offset(0, drift),
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.24),
                            blurRadius: 36,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(child: BidartLogoMark(size: 112)),
                    ),
                  ),
                ),
                Positioned(
                  left: 218,
                  top: 54 + driftTwo,
                  child: const PoolBallIcon(ball: 9, size: 30),
                ),
                Positioned(
                  left: 52,
                  top: 188 - drift,
                  child: const PoolBallIcon(ball: 3, size: 22),
                ),
                Positioned(
                  left: 222,
                  top: 236 + drift,
                  child: const PoolBallIcon(ball: 1, size: 20),
                ),
                Positioned(
                  left: 96,
                  top: 76,
                  child: _sparkle(AppColors.primary, 4),
                ),
                Positioned(
                  left: 252,
                  top: 172,
                  child: _sparkle(AppColors.secondary, 3),
                ),
                Positioned(
                  left: 74,
                  top: 268,
                  child: _sparkle(AppColors.darkOnSurface, 2),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sparkle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter({required this.rotation});

  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    const center = Offset(160, 160);
    const radius = 112.0;
    final paint = Paint()
      ..color = AppColors.darkOnSurface.withValues(alpha: 0.14);

    for (var i = 0; i < 40; i++) {
      final angle = rotation + (i * 2 * math.pi / 40);
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawCircle(point, i % 5 == 0 ? 2.2 : 1.4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}

class _RingPainter extends CustomPainter {
  const _RingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const center = Offset(160, 160);
    const radius = 92.0;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    const start = -27.5 * math.pi / 180;
    const sweep = 325 * math.pi / 180;

    canvas.drawArc(
      bounds,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..color = AppColors.primary.withValues(alpha: 0.55),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 7),
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.primary.withValues(alpha: 0.12),
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => false;
}
