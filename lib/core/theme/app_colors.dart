import 'package:flutter/material.dart';

/// Raw colour values shared by the theme.
///
/// Widgets should not read this class directly. Use [AppSemanticColors] from
/// `app_theme.dart` so light/dark variants resolve through the active theme.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand palette (from docs/ui/ui_description.md).
  // ---------------------------------------------------------------------------

  static const primary = Color(0xFF4EDEA3);
  static const primaryContainer = Color(0xFF10B981);
  static const secondary = Color(0xFFFFB95F);

  static const darkSurface = Color(0xFF0F131D);
  static const darkOnSurface = Color(0xFFDFE2F1);
  static const darkOnSurfaceVariant = Color(0xFFBBCABF);
  static const darkError = Color(0xFFFFB4AB);
  static const darkErrorContainer = Color(0xFF93000A);

  static const darkSurfaceContainerLowest = Color(0xFF0A0E16);
  static const darkSurfaceContainerLow = Color(0xFF161B24);
  static const darkSurfaceContainer = Color(0xFF1A2029);
  static const darkSurfaceContainerHigh = Color(0xFF242A34);
  static const darkSurfaceContainerHighest = Color(0xFF2E343F);
  static const darkOutline = Color(0xFF8B938C);
  static const darkOutlineVariant = Color(0xFF414942);

  static const lightPrimary = Color(0xFF006B4F);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFA8F0D0);
  static const lightOnPrimaryContainer = Color(0xFF002114);
  static const lightSecondary = Color(0xFF8A5000);
  static const lightSurface = Color(0xFFF7F9F7);
  static const lightOnSurface = Color(0xFF171D1A);
  static const lightOnSurfaceVariant = Color(0xFF414942);
  static const lightError = Color(0xFFB3261E);

  // ---------------------------------------------------------------------------
  // Semantic accents.
  // ---------------------------------------------------------------------------

  static const liveLight = Color(0xFF15803D);
  static const liveDark = Color(0xFF4ADE80);

  /// Positive score. Darker in light mode to keep AA text contrast.
  static const positiveLight = Color(0xFFB45309);
  static const positiveDark = Color(0xFFF59E0B);

  static const negativeLight = Color(0xFFB91C1C);
  static const negativeDark = Color(0xFFF87171);

  static const warningLight = Color(0xFFB45309);
  static const warningDark = Color(0xFFF59E0B);

  /// Gold accent used by the 9-ball artwork and its selected states.
  static const ballNine = Color(0xFFFACC15);
  static const ballNineAccentLight = Color(0xFFB45309);
  static const ballNineAccentDark = Color(0xFFFACC15);

  // ---------------------------------------------------------------------------
  // Current-turn card. This card is always dark, independent of the app theme.
  // ---------------------------------------------------------------------------

  static const currentTurnSurface = Color(0xFF103B28);
  static const currentTurnSurfaceDeep = Color(0xFF0B2F20);
  static const currentTurnBorder = Color(0xFF34D399);
  static const currentTurnAccent = Color(0xFF22C55E);
  static const currentTurnScore = Color(0xFF4ADE80);
  static const currentTurnNegative = Color(0xFFFCA5A5);
  static const currentTurnSubtitle = Color(0xFFA7F3D0);
  static const currentTurnAvatar = Color(0xFF1D5C3B);
  static const currentTurnBadge = Color(0xFFDCFCE7);
  static const currentTurnBadgeText = Color(0xFF15803D);
  static const currentTurnRisk = Color(0xFFFCA5A5);
  static const onCurrentTurn = Color(0xFFFFFFFF);
  static const onCurrentTurnGamepad = Color(0xFF052E16);
}
