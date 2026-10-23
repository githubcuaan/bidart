import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Bidart brand lockup: the 9-ball icon followed by the "BiDART" wordmark.
///
/// Mirrors `docs/branding/bidart-logo-wordmark.svg`: the mark keeps its dark
/// tile and mint ring in both themes, while the wordmark adapts to the surface.
class BidartLogo extends StatelessWidget {
  const BidartLogo({
    super.key,
    this.markSize = 36,
    this.fontSize = 21,
    this.gap = 10,
  });

  final double markSize;
  final double fontSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BidartLogoMark(size: markSize),
          SizedBox(width: gap),
          BidartWordmark(fontSize: fontSize),
        ],
      ),
    );
  }
}

/// "Bi" in brand green, "DART" in the surface colour (white on dark).
class BidartWordmark extends StatelessWidget {
  const BidartWordmark({super.key, this.fontSize = 21});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Bi', style: TextStyle(color: scheme.primary)),
          TextSpan(text: 'DART', style: TextStyle(color: scheme.onSurface)),
        ],
      ),
      maxLines: 1,
      softWrap: false,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: fontSize * 0.06,
        height: 1.05,
      ),
    );
  }
}

/// Draws the app icon artwork: a mint ring with a pocket gap and the 9 ball.
class BidartLogoMark extends StatelessWidget {
  const BidartLogoMark({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Bidart',
      child: CustomPaint(
        size: Size.square(size),
        painter: const _BidartMarkPainter(),
      ),
    );
  }
}

class _BidartMarkPainter extends CustomPainter {
  const _BidartMarkPainter();

  static const _tile = Color(0xFF0F131D);
  static const _mint = Color(0xFF4EDEA3);
  static const _ink = Color(0xFF10141E);

  @override
  void paint(Canvas canvas, Size size) {
    _paintMark(canvas, size);
  }

  void _paintMark(Canvas canvas, Size size) {
    final scale = size.shortestSide / 512;
    canvas.save();
    canvas.scale(scale);

    final tile = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 512, 512),
      const Radius.circular(115),
    );
    canvas.drawRRect(tile, Paint()..color = _tile);

    // Soft top-left light to keep the flat tile from looking dead.
    canvas.save();
    canvas.clipRRect(tile);
    canvas.drawCircle(
      const Offset(140, 100),
      340,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0x33DFE2F1), Color(0x00DFE2F1)],
        ).createShader(const Rect.fromLTWH(0, 0, 512, 512)),
    );
    canvas.restore();

    _paintRing(canvas);
    _paintBall(canvas, size.shortestSide);

    canvas.restore();
  }

  void _paintRing(Canvas canvas) {
    const center = Offset(256, 256);
    const radius = 140.0;
    final bounds = Rect.fromCircle(center: center, radius: radius);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 44
      ..strokeCap = StrokeCap.round
      ..color = _mint;

    // Opening between 1 and 2 o'clock: the pocket the ball rolls into.
    canvas.drawArc(bounds, _rad(-27.5), _rad(325), false, stroke);

    // Faded motion trail across the opening.
    canvas.drawArc(
      bounds,
      _rad(-27.5),
      _rad(-10.5),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 44
        ..strokeCap = StrokeCap.round
        ..color = _mint.withValues(alpha: 0.45),
    );
  }

  void _paintBall(Canvas canvas, double iconSize) {
    canvas.save();
    canvas.translate(346, 149);
    canvas.scale(1.2);

    const ballRadius = 33.0;
    final ballBounds = Rect.fromCircle(
      center: Offset.zero,
      radius: ballRadius,
    );

    canvas.drawCircle(
      Offset.zero,
      ballRadius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.32, -0.4),
          radius: 0.9,
          colors: [Colors.white, Color(0xFFEDE8DC)],
        ).createShader(ballBounds),
    );

    // Yellow stripe, clipped to the ball.
    canvas.save();
    canvas.clipPath(Path()..addOval(ballBounds));
    final stripe = Rect.fromLTRB(-ballRadius, -13.2, ballRadius, 13.2);
    canvas.drawRect(
      stripe,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD953), Color(0xFFF1A63A)],
        ).createShader(stripe),
    );
    canvas.drawCircle(
      Offset.zero,
      ballRadius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.44),
          radius: 0.92,
          colors: [Color(0x4DFFFFFF), Color(0x00FFFFFF), Color(0x2E000000)],
          stops: [0, 0.45, 1],
        ).createShader(ballBounds),
    );
    canvas.restore();

    // Number circle. The digit only reads at large sizes.
    canvas.drawCircle(
      Offset.zero,
      12.5,
      Paint()..color = const Color(0xFFFAF8F2),
    );
    canvas.drawCircle(
      Offset.zero,
      12.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFFE4DECC),
    );
    if (iconSize >= 64) {
      final digit = TextPainter(
        text: const TextSpan(
          text: '9',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: _ink,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      digit.paint(
        canvas,
        Offset(-digit.width / 2, -digit.height / 2),
      );
    } else {
      canvas.drawCircle(Offset.zero, 7.5, Paint()..color = _ink);
    }

    canvas.drawCircle(
      Offset.zero,
      ballRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = _ink,
    );

    // Specular highlight.
    canvas.drawOval(
      const Rect.fromLTRB(-10, -10.6, -2, -5.4),
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    canvas.restore();
  }

  static double _rad(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(covariant _BidartMarkPainter oldDelegate) => false;
}
