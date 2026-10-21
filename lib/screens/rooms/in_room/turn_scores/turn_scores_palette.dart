import 'package:flutter/material.dart';

/// Colours shared by the turn scoreboard widgets.
///
/// The current-turn card is always dark, so its text and accent colours are
/// intentionally fixed instead of following the light/dark [ColorScheme].
abstract final class TurnScoresPalette {
  static const greenLight = Color(0xFF15803D);
  static const greenBright = Color(0xFF22C55E);
  static const greenOnDark = Color(0xFF4ADE80);
  static const currentSurface = Color(0xFF103B28);
  static const currentSurfaceDeep = Color(0xFF0B2F20);
  static const currentBorder = Color(0xFF34D399);
  static const currentSubtitle = Color(0xFFA7F3D0);
  static const currentAvatar = Color(0xFF1D5C3B);
  static const currentBadge = Color(0xFFDCFCE7);
  static const currentBadgeText = Color(0xFF15803D);
  static const positive = Color(0xFFF59E0B);
  static const negative = Color(0xFFEF4444);
  static const riskOnDark = Color(0xFFFCA5A5);
  static const onGamepad = Color(0xFF052E16);
}
