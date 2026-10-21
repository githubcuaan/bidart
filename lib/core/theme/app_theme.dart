import 'package:bidart/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Semantic colours that are not covered by [ColorScheme].
///
/// These values change with the active theme, so widgets must resolve them via
/// [AppSemanticColors.of] instead of hard-coding a [Color].
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.live,
    required this.positive,
    required this.negative,
    required this.warning,
    required this.ballNine,
    required this.ballNineAccent,
    required this.currentTurnSurface,
    required this.currentTurnSurfaceDeep,
    required this.currentTurnBorder,
    required this.currentTurnAccent,
    required this.currentTurnScore,
    required this.currentTurnNegative,
    required this.currentTurnSubtitle,
    required this.currentTurnAvatar,
    required this.currentTurnBadge,
    required this.currentTurnBadgeText,
    required this.currentTurnRisk,
    required this.onCurrentTurn,
    required this.onCurrentTurnGamepad,
  });

  /// Status dot and "LIVE MATCH" label.
  final Color live;

  /// Positive score / score movement.
  final Color positive;

  /// Negative score / score movement.
  final Color negative;

  /// Informational callout (rule note).
  final Color warning;

  /// 9-ball outline and tint.
  final Color ballNine;

  /// 9-ball text and field accent.
  final Color ballNineAccent;

  /// Current-turn card tokens. The card stays dark in both themes.
  final Color currentTurnSurface;
  final Color currentTurnSurfaceDeep;
  final Color currentTurnBorder;
  final Color currentTurnAccent;
  final Color currentTurnScore;
  final Color currentTurnNegative;
  final Color currentTurnSubtitle;
  final Color currentTurnAvatar;
  final Color currentTurnBadge;
  final Color currentTurnBadgeText;
  final Color currentTurnRisk;
  final Color onCurrentTurn;
  final Color onCurrentTurnGamepad;

  static const light = AppSemanticColors(
    live: AppColors.liveLight,
    positive: AppColors.positiveLight,
    negative: AppColors.negativeLight,
    warning: AppColors.warningLight,
    ballNine: AppColors.ballNine,
    ballNineAccent: AppColors.ballNineAccentLight,
    currentTurnSurface: AppColors.currentTurnSurface,
    currentTurnSurfaceDeep: AppColors.currentTurnSurfaceDeep,
    currentTurnBorder: AppColors.currentTurnBorder,
    currentTurnAccent: AppColors.currentTurnAccent,
    currentTurnScore: AppColors.currentTurnScore,
    currentTurnNegative: AppColors.currentTurnNegative,
    currentTurnSubtitle: AppColors.currentTurnSubtitle,
    currentTurnAvatar: AppColors.currentTurnAvatar,
    currentTurnBadge: AppColors.currentTurnBadge,
    currentTurnBadgeText: AppColors.currentTurnBadgeText,
    currentTurnRisk: AppColors.currentTurnRisk,
    onCurrentTurn: AppColors.onCurrentTurn,
    onCurrentTurnGamepad: AppColors.onCurrentTurnGamepad,
  );

  static const dark = AppSemanticColors(
    live: AppColors.liveDark,
    positive: AppColors.positiveDark,
    negative: AppColors.negativeDark,
    warning: AppColors.warningDark,
    ballNine: AppColors.ballNine,
    ballNineAccent: AppColors.ballNineAccentDark,
    currentTurnSurface: AppColors.currentTurnSurface,
    currentTurnSurfaceDeep: AppColors.currentTurnSurfaceDeep,
    currentTurnBorder: AppColors.currentTurnBorder,
    currentTurnAccent: AppColors.currentTurnAccent,
    currentTurnScore: AppColors.currentTurnScore,
    currentTurnNegative: AppColors.currentTurnNegative,
    currentTurnSubtitle: AppColors.currentTurnSubtitle,
    currentTurnAvatar: AppColors.currentTurnAvatar,
    currentTurnBadge: AppColors.currentTurnBadge,
    currentTurnBadgeText: AppColors.currentTurnBadgeText,
    currentTurnRisk: AppColors.currentTurnRisk,
    onCurrentTurn: AppColors.onCurrentTurn,
    onCurrentTurnGamepad: AppColors.onCurrentTurnGamepad,
  );

  /// Resolves the semantic palette for [context].
  ///
  /// Falls back to [light] so widgets still render inside a bare `MaterialApp`
  /// (for example in widget tests) without registering the extension.
  static AppSemanticColors of(BuildContext context) =>
      Theme.of(context).extension<AppSemanticColors>() ?? light;

  @override
  AppSemanticColors copyWith({
    Color? live,
    Color? positive,
    Color? negative,
    Color? warning,
    Color? ballNine,
    Color? ballNineAccent,
    Color? currentTurnSurface,
    Color? currentTurnSurfaceDeep,
    Color? currentTurnBorder,
    Color? currentTurnAccent,
    Color? currentTurnScore,
    Color? currentTurnNegative,
    Color? currentTurnSubtitle,
    Color? currentTurnAvatar,
    Color? currentTurnBadge,
    Color? currentTurnBadgeText,
    Color? currentTurnRisk,
    Color? onCurrentTurn,
    Color? onCurrentTurnGamepad,
  }) {
    return AppSemanticColors(
      live: live ?? this.live,
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      warning: warning ?? this.warning,
      ballNine: ballNine ?? this.ballNine,
      ballNineAccent: ballNineAccent ?? this.ballNineAccent,
      currentTurnSurface: currentTurnSurface ?? this.currentTurnSurface,
      currentTurnSurfaceDeep:
          currentTurnSurfaceDeep ?? this.currentTurnSurfaceDeep,
      currentTurnBorder: currentTurnBorder ?? this.currentTurnBorder,
      currentTurnAccent: currentTurnAccent ?? this.currentTurnAccent,
      currentTurnScore: currentTurnScore ?? this.currentTurnScore,
      currentTurnNegative: currentTurnNegative ?? this.currentTurnNegative,
      currentTurnSubtitle: currentTurnSubtitle ?? this.currentTurnSubtitle,
      currentTurnAvatar: currentTurnAvatar ?? this.currentTurnAvatar,
      currentTurnBadge: currentTurnBadge ?? this.currentTurnBadge,
      currentTurnBadgeText: currentTurnBadgeText ?? this.currentTurnBadgeText,
      currentTurnRisk: currentTurnRisk ?? this.currentTurnRisk,
      onCurrentTurn: onCurrentTurn ?? this.onCurrentTurn,
      onCurrentTurnGamepad: onCurrentTurnGamepad ?? this.onCurrentTurnGamepad,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      live: Color.lerp(live, other.live, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      ballNine: Color.lerp(ballNine, other.ballNine, t)!,
      ballNineAccent: Color.lerp(ballNineAccent, other.ballNineAccent, t)!,
      currentTurnSurface: Color.lerp(
        currentTurnSurface,
        other.currentTurnSurface,
        t,
      )!,
      currentTurnSurfaceDeep: Color.lerp(
        currentTurnSurfaceDeep,
        other.currentTurnSurfaceDeep,
        t,
      )!,
      currentTurnBorder: Color.lerp(
        currentTurnBorder,
        other.currentTurnBorder,
        t,
      )!,
      currentTurnAccent: Color.lerp(
        currentTurnAccent,
        other.currentTurnAccent,
        t,
      )!,
      currentTurnScore: Color.lerp(
        currentTurnScore,
        other.currentTurnScore,
        t,
      )!,
      currentTurnNegative: Color.lerp(
        currentTurnNegative,
        other.currentTurnNegative,
        t,
      )!,
      currentTurnSubtitle: Color.lerp(
        currentTurnSubtitle,
        other.currentTurnSubtitle,
        t,
      )!,
      currentTurnAvatar: Color.lerp(
        currentTurnAvatar,
        other.currentTurnAvatar,
        t,
      )!,
      currentTurnBadge: Color.lerp(
        currentTurnBadge,
        other.currentTurnBadge,
        t,
      )!,
      currentTurnBadgeText: Color.lerp(
        currentTurnBadgeText,
        other.currentTurnBadgeText,
        t,
      )!,
      currentTurnRisk: Color.lerp(currentTurnRisk, other.currentTurnRisk, t)!,
      onCurrentTurn: Color.lerp(onCurrentTurn, other.onCurrentTurn, t)!,
      onCurrentTurnGamepad: Color.lerp(
        onCurrentTurnGamepad,
        other.onCurrentTurnGamepad,
        t,
      )!,
    );
  }
}

/// App-wide [ThemeData] factory.
abstract final class AppTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    scheme: _lightScheme,
    semanticColors: AppSemanticColors.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    scheme: _darkScheme,
    semanticColors: AppSemanticColors.dark,
  );

  static final ColorScheme _lightScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primaryContainer,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        error: AppColors.lightError,
      );

  static final ColorScheme _darkScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primaryContainer,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: const Color(0xFF002114),
        secondary: AppColors.secondary,
        onSecondary: const Color(0xFF452B00),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        error: AppColors.darkError,
        errorContainer: AppColors.darkErrorContainer,
        onError: const Color(0xFF690005),
        onErrorContainer: const Color(0xFFFFDAD6),
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
        surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
        surfaceContainerLow: AppColors.darkSurfaceContainerLow,
        surfaceContainer: AppColors.darkSurfaceContainer,
        surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required AppSemanticColors semanticColors,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [semanticColors],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primaryContainer.withValues(alpha: 0.35),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
