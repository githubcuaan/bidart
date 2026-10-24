import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light and dark themes expose semantic colours', () {
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.dark.brightness, Brightness.dark);

    final light = AppTheme.light.extension<AppSemanticColors>();
    final dark = AppTheme.dark.extension<AppSemanticColors>();

    expect(light, AppSemanticColors.light);
    expect(dark, AppSemanticColors.dark);
    expect(light!.positive, isNot(dark!.positive));
    expect(dark.positive, AppColors.positiveDark);
  });

  test('dark theme follows the documented brand palette', () {
    final scheme = AppTheme.dark.colorScheme;

    expect(scheme.surface, AppColors.darkSurface);
    expect(scheme.primary, AppColors.primary);
    expect(scheme.secondary, AppColors.secondary);
    expect(scheme.error, AppColors.darkError);
  });

  test('light semantic text colours keep AA contrast on white', () {
    final colors = AppSemanticColors.light;

    expect(_contrast(colors.positive, Colors.white), greaterThanOrEqualTo(4.5));
    expect(_contrast(colors.negative, Colors.white), greaterThanOrEqualTo(4.5));
  });

  test('brand type scale is bundled with tabular figures', () {
    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final textTheme = theme.textTheme;

      expect(theme.textTheme.bodyMedium?.fontFamily, AppTypography.fontFamily);
      expect(textTheme.headlineSmall?.fontFamily, AppTypography.fontFamily);
      expect(
        textTheme.headlineSmall?.fontFeatures?.first.feature,
        'tnum',
      );
      expect(
        textTheme.bodyMedium?.fontFeatures?.first.feature,
        'tnum',
      );
    }
  });

  test('shared component themes keep the chrome flat and bordered', () {
    final theme = AppTheme.dark;
    final scheme = theme.colorScheme;

    expect(theme.appBarTheme.elevation, 0);
    expect(theme.appBarTheme.scrolledUnderElevation, 0);
    expect(theme.appBarTheme.shape, isA<Border>());

    expect(theme.navigationBarTheme.height, 72);
    expect(theme.navigationBarTheme.elevation, 0);
    expect(theme.navigationBarTheme.indicatorShape, isA<StadiumBorder>());

    expect(theme.cardTheme.elevation, 0);
    expect(theme.cardTheme.color, scheme.surfaceContainerLow);
    expect(
      (theme.cardTheme.shape as RoundedRectangleBorder).side.color,
      isNot(Colors.transparent),
    );

    expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
  });
}

double _contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}
