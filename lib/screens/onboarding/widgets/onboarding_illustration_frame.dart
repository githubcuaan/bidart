import 'package:bidart/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Rounded stage that frames every onboarding illustration.
class OnboardingIllustrationFrame extends StatelessWidget {
  const OnboardingIllustrationFrame({
    super.key,
    required this.accent,
    required this.child,
  });

  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: RepaintBoundary(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.darkOnSurface.withValues(alpha: 0.07),
            ),
            gradient: RadialGradient(
              center: const Alignment(0.25, -0.4),
              radius: 1,
              colors: [
                accent.withValues(alpha: 0.16),
                AppColors.darkSurfaceContainerLow.withValues(alpha: 0.4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CustomPaint(painter: _FrameGridPainter()),
                Padding(padding: const EdgeInsets.all(10), child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FrameGridPainter extends CustomPainter {
  const _FrameGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkOnSurface.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    for (var x = 24.0; x < size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 24.0; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FrameGridPainter oldDelegate) => false;
}
