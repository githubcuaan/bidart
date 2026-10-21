import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/core/theme/app_theme.dart';
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
}

double _contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}
