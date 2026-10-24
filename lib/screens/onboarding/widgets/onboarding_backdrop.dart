import 'package:bidart/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Full-bleed onboarding background: dark gradient, two soft glows and a faint
/// table-like grid. The glow colour shifts slightly as pages change.
class OnboardingBackdrop extends StatelessWidget {
  const OnboardingBackdrop({
    super.key,
    required this.controller,
    required this.pageCount,
  });

  final PageController controller;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients ? controller.page ?? 0 : 0.0;
        final progress = pageCount <= 1
            ? 0.0
            : (page / (pageCount - 1)).clamp(0.0, 1.0).toDouble();
        final glow = Color.lerp(
          AppColors.primary,
          AppColors.secondary,
          progress * 0.35,
        )!;

        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkSurface,
                    AppColors.darkSurfaceContainerLowest,
                  ],
                ),
              ),
            ),
            Positioned(
              top: -140,
              right: -100,
              child: _Glow(color: glow, size: 440, opacity: 0.16),
            ),
            Positioned(
              bottom: -160,
              left: -120,
              child: _Glow(
                color: AppColors.secondary,
                size: 380,
                opacity: 0.08,
              ),
            ),
            const Positioned.fill(
              child: IgnorePointer(child: CustomPaint(painter: _GridPainter())),
            ),
          ],
        );
      },
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size, required this.opacity});

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  static const _spacing = 48.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkOnSurface.withValues(alpha: 0.045)
      ..strokeWidth = 1;

    for (var x = 0.0; x <= size.width; x += _spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += _spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
