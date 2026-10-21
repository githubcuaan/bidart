import 'package:flutter/animation.dart';

/// Shared timing for turn-score transitions.
abstract final class TurnScoresMotion {
  static const turn = Duration(milliseconds: 360);
  static const badge = Duration(milliseconds: 220);
  static const curve = Curves.easeOutCubic;
}
