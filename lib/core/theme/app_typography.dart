import 'package:flutter/material.dart';

/// Brand type scale.
///
/// [Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans) is
/// bundled in `assets/fonts` (SIL OFL) so the app renders the same offline.
/// Every style uses tabular figures: scores, timers and dates keep a stable
/// width while they animate, which matters on the scoring screens.
abstract final class AppTypography {
  static const fontFamily = 'PlusJakartaSans';

  static const tabularFigures = <FontFeature>[FontFeature.tabularFigures()];

  /// Builds the full Material text theme for [scheme].
  static TextTheme textTheme(ColorScheme scheme) {
    TextStyle style(
      double size,
      FontWeight weight, {
      Color? color,
      double height = 1.35,
      double letterSpacing = 0,
    }) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color ?? scheme.onSurface,
        fontFeatures: tabularFigures,
      );
    }

    final muted = scheme.onSurfaceVariant;

    return TextTheme(
      displayLarge: style(
        56,
        FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.6,
      ),
      displayMedium: style(
        45,
        FontWeight.w800,
        height: 1.08,
        letterSpacing: -1.2,
      ),
      displaySmall: style(
        36,
        FontWeight.w800,
        height: 1.12,
        letterSpacing: -0.9,
      ),
      headlineLarge: style(
        32,
        FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.6,
      ),
      headlineMedium: style(
        28,
        FontWeight.w700,
        height: 1.18,
        letterSpacing: -0.4,
      ),
      headlineSmall: style(
        24,
        FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.3,
      ),
      titleLarge: style(
        22,
        FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      titleMedium: style(
        16,
        FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.1,
      ),
      titleSmall: style(14, FontWeight.w600, height: 1.3),
      bodyLarge: style(16, FontWeight.w400, height: 1.45, letterSpacing: 0.1),
      bodyMedium: style(
        14,
        FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.1,
      ),
      bodySmall: style(
        12,
        FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.15,
        color: muted,
      ),
      labelLarge: style(14, FontWeight.w600, height: 1.2, letterSpacing: 0.1),
      labelMedium: style(
        12,
        FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
        color: muted,
      ),
      labelSmall: style(
        11,
        FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.3,
        color: muted,
      ),
    );
  }
}
