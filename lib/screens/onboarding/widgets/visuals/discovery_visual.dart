import 'dart:math' as math;

import 'package:bidart/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Discovery page artwork: a swipe card over a small map with venue pins.
class DiscoveryVisual extends StatefulWidget {
  const DiscoveryVisual({
    super.key,
    required this.isActive,
    required this.enableMotion,
  });

  final bool isActive;
  final bool enableMotion;

  @override
  State<DiscoveryVisual> createState() => _DiscoveryVisualState();
}

class _DiscoveryVisualState extends State<DiscoveryVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ping;

  @override
  void initState() {
    super.initState();
    _ping = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _sync();
  }

  @override
  void didUpdateWidget(covariant DiscoveryVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.enableMotion != widget.enableMotion) {
      _sync();
    }
  }

  void _sync() {
    if (widget.isActive && widget.enableMotion) {
      _ping.repeat();
    } else {
      _ping.stop();
      _ping.value = 0;
    }
  }

  @override
  void dispose() {
    _ping.dispose();
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
              left: 34,
              top: 28,
              child: Transform.rotate(angle: 0.07, child: _cardShell()),
            ),
            Positioned(
              left: 50,
              top: 42,
              child: Transform.rotate(angle: -0.035, child: _playerCard()),
            ),
            Positioned(left: 30, top: 202, child: _mapCard()),
            Positioned(
              right: 6,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.45),
                  ),
                ),
                child: const Text(
                  'SẮP CÓ',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardShell() {
    return Container(
      width: 236,
      height: 144,
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceContainerHigh.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.darkOnSurface.withValues(alpha: 0.07),
        ),
      ),
    );
  }

  Widget _playerCard() {
    return Container(
      width: 236,
      height: 144,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryContainer.withValues(alpha: 0.4),
            AppColors.darkSurfaceContainer,
          ],
        ),
        border: Border.all(
          color: AppColors.darkOnSurface.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
                  ),
                  border: Border.all(
                    color: AppColors.darkOnSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: const Text(
                  'Đ',
                  style: TextStyle(
                    color: Color(0xFF002114),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đức “Cơ Điên”',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.darkOnSurface,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Hạng B+ • Cách 1.8 km',
                      style: TextStyle(
                        color: AppColors.darkOnSurfaceVariant,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 11,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '94%',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const Row(
            children: [
              _Tag('9 Bi'),
              SizedBox(width: 5),
              _Tag('Bắn đền'),
              SizedBox(width: 5),
              _Tag('Tối nay'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mapCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 260,
        height: 92,
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceContainerLow,
          border: Border.all(
            color: AppColors.darkOnSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _MapRoutePainter()),
            ),
            _pin(left: 48, top: 38, color: AppColors.primary),
            _pin(left: 124, top: 26, color: AppColors.secondary, ping: true),
            _pin(left: 204, top: 44, color: AppColors.darkOnSurface),
            Positioned(
              left: 10,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.darkSurfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '3 quán gần đây',
                  style: TextStyle(
                    color: AppColors.darkOnSurfaceVariant,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pin({
    required double left,
    required double top,
    required Color color,
    bool ping = false,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (ping)
              AnimatedBuilder(
                animation: _ping,
                builder: (context, _) {
                  final progress = _ping.value;
                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      for (final offset in const [0.0, 0.5])
                        _pingRing((progress + offset) % 1, color),
                    ],
                  );
                },
              ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.darkSurface, width: 2),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 12,
                color: AppColors.darkSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pingRing(double progress, Color color) {
    return IgnorePointer(
      child: Container(
        width: 20 + progress * 26,
        height: 20 + progress * 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: (1 - progress) * 0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.darkOnSurfaceVariant,
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  const _MapRoutePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.darkOnSurface.withValues(alpha: 0.035)
      ..strokeWidth = 1;
    for (var x = 20.0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 16.0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final route = Path()
      ..moveTo(40, 72)
      ..quadraticBezierTo(120, 18, 220, 58);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primary.withValues(alpha: 0.5);

    for (final metric in route.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + 6, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapRoutePainter oldDelegate) => false;
}
