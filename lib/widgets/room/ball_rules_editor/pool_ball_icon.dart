import 'package:flutter/material.dart';

/// Flat, asset-free pool ball icon.
///
/// Balls 1-8 are a coloured disc with the number in the centre; ball 9 is the
/// classic striped ball (white base, yellow band, dark number disc). Everything
/// is drawn with plain widgets, so nothing depends on bundled images.
class PoolBallIcon extends StatelessWidget {
  const PoolBallIcon({
    super.key,
    required this.ball,
    required this.size,
    this.enabled = true,
  });

  final int ball;
  final double size;
  final bool enabled;

  /// Palette follows the design mock (Bi 1 vàng … Bi 8 đen).
  static const colors = <int, Color>{
    1: Color(0xFFFACC15),
    2: Color(0xFF2563EB),
    3: Color(0xFFEF4444),
    4: Color(0xFF9333EA),
    5: Color(0xFFF97316),
    6: Color(0xFF16A34A),
    7: Color(0xFF854D0E),
    8: Color(0xFF18181B),
    9: Color(0xFFFACC15),
  };

  static const _dark = Color(0xFF0F131D);

  static const _grayscale = <double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ];

  Color get _color => colors[ball] ?? colors[1]!;

  bool get _striped => ball == 9;

  Color get _base => _striped ? Colors.white : _color;

  Color get _numberColor {
    if (_striped) return _color;
    return _color.computeLuminance() > 0.5 ? _dark : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final icon = SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.45),
            radius: 0.95,
            colors: [
              Color.lerp(_base, Colors.white, 0.35)!,
              _base,
              Color.lerp(_base, Colors.black, 0.18)!,
            ],
            stops: const [0, 0.55, 1],
          ),
          border: ball == 8
              ? Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: size * 0.14,
              offset: Offset(0, size * 0.04),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              if (_striped)
                Center(
                  child: Container(height: size * 0.44, color: _color),
                ),
              Center(
                child: Container(
                  width: size * 0.56,
                  height: size * 0.56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _striped ? _dark : Colors.transparent,
                  ),
                  child: Text(
                    '$ball',
                    style: TextStyle(
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      color: _numberColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (enabled) return icon;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(_grayscale),
      child: icon,
    );
  }
}
