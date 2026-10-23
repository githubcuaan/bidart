import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/core/theme/app_typography.dart';
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
    final textTheme = AppTypography.textTheme(scheme);
    final hairline = scheme.outlineVariant;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: hairline),
    );

    OutlineInputBorder inputBorder(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [semanticColors],
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        shape: Border(bottom: BorderSide(color: hairline)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        indicatorShape: const StadiumBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall!.copyWith(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: cardShape,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: BorderSide(color: hairline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primary.withValues(alpha: 0.18),
        disabledColor: scheme.surfaceContainer,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelMedium!,
        secondaryLabelStyle: textTheme.labelMedium!.copyWith(
          color: scheme.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.labelMedium?.copyWith(
          color: scheme.primary,
        ),
        border: inputBorder(hairline),
        enabledBorder: inputBorder(hairline),
        focusedBorder: inputBorder(scheme.primary, width: 1.5),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, width: 1.5),
      ),
      dividerTheme: DividerThemeData(color: hairline, thickness: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: scheme.outlineVariant,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        textStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.outlineVariant,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        trackHeight: 4,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.3),
        selectionHandleColor: scheme.primary,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),
    );
  }
}
