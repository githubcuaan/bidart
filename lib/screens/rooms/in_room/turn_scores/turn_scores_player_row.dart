import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_data.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_motion.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_player_avatar.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_row_meta.dart';
import 'package:flutter/material.dart';

/// One player row in the turn scoreboard.
class TurnScoresPlayerRow extends StatelessWidget {
  const TurnScoresPlayerRow({
    super.key,
    required this.entry,
    required this.data,
  });

  final TurnScoreEntry entry;
  final TurnScoreboardData data;

  bool get _current => entry.role == TurnScoreRole.current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    final name = entry.player.displayName;
    final score = data.scoreOf(entry);

    return AnimatedContainer(
      duration: TurnScoresMotion.turn,
      curve: TurnScoresMotion.curve,
      padding: EdgeInsets.symmetric(
        horizontal: _current ? 12 : 10,
        vertical: _current ? 12 : 10,
      ),
      decoration: BoxDecoration(
        color: _current
            ? colors.currentTurnSurface
            : scheme.surfaceContainerLowest,
        gradient: _current
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.currentTurnSurface,
                  colors.currentTurnSurfaceDeep,
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(_current ? 18 : 14),
        border: Border.all(
          color: _current
              ? colors.currentTurnBorder
              : scheme.outlineVariant.withValues(alpha: 0.6),
          width: _current ? 1.5 : 1,
        ),
        boxShadow: _current
            ? [
                BoxShadow(
                  color: colors.currentTurnAccent.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          TurnScoresPlayerAvatar(
            name: name,
            current: _current,
            warning: entry.role == TurnScoreRole.payer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: TurnScoresMotion.turn,
                      curve: TurnScoresMotion.curve,
                      style:
                          (_current
                                  ? theme.textTheme.titleMedium
                                  : theme.textTheme.bodyMedium)
                              ?.copyWith(
                                color: _current
                                    ? colors.onCurrentTurn
                                    : scheme.onSurface,
                                fontWeight: _current
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ) ??
                          const TextStyle(),
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: TurnScoresMotion.badge,
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        final scale = Tween<double>(
                          begin: 0.86,
                          end: 1,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: scale, child: child),
                        );
                      },
                      child: _roleBadge(scheme, colors),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                TurnScoresSubtitle(
                  text: _subtitle,
                  current: _current,
                  showCue: _current,
                ),
                AnimatedSize(
                  duration: TurnScoresMotion.turn,
                  curve: TurnScoresMotion.curve,
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: TurnScoresMotion.turn,
                    switchInCurve: TurnScoresMotion.curve,
                    switchOutCurve: Curves.easeIn,
                    child: _current && data.payerName != null
                        ? Padding(
                            key: ValueKey('risk-${data.payerName}'),
                            padding: const EdgeInsets.only(top: 3),
                            child: TurnScoresRiskNote(name: data.payerName!),
                          )
                        : const SizedBox.shrink(key: ValueKey('no-risk')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedDefaultTextStyle(
                duration: TurnScoresMotion.turn,
                curve: TurnScoresMotion.curve,
                style:
                    (_current
                            ? theme.textTheme.headlineSmall
                            : theme.textTheme.titleMedium)
                        ?.copyWith(
                          color: _scoreColor(scheme, colors, score),
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ) ??
                    const TextStyle(),
                child: Text(_scoreLabel(score)),
              ),
              if (!_current) ...[
                const SizedBox(height: 3),
                Text(
                  'Hạng ${data.rankOf(entry)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleBadge(ColorScheme scheme, AppSemanticColors colors) =>
      switch (entry.role) {
        TurnScoreRole.current => TurnScoresBadge(
          key: const ValueKey('current-turn-badge'),
          label: 'ĐANG CÓ CƠ',
          background: colors.currentTurnBadge,
          foreground: colors.currentTurnBadgeText,
        ),
        TurnScoreRole.payer => TurnScoresBadge(
          key: const ValueKey('payer-turn-badge'),
          label: 'Bắn trước đó',
          background: scheme.errorContainer.withValues(alpha: 0.45),
          foreground: scheme.error,
        ),
        _ => const SizedBox.shrink(key: ValueKey('no-turn-badge')),
      };

  String get _subtitle => switch (entry.role) {
    TurnScoreRole.current =>
      data.targetBall == null
          ? 'Không còn bi mục tiêu trên bàn'
          : 'Đang nhắm bắn Bi ${data.targetBall}',
    TurnScoreRole.payer => 'Nguy cơ chịu đền nếu ${data.currentName} ăn',
    TurnScoreRole.next when data.currentName != null =>
      'Lượt tiếp: Sau ${data.currentName}',
    TurnScoreRole.waiting when data.currentName != null => 'Chờ vòng mới',
    _ => data.endedLabel,
  };

  String _scoreLabel(int score) => switch (score) {
    > 0 =>
      '+$score'
          'đ',
    _ =>
      '$score'
          'đ',
  };

  Color _scoreColor(ColorScheme scheme, AppSemanticColors colors, int score) {
    if (score < 0) {
      return _current ? colors.currentTurnNegative : colors.negative;
    }
    if (_current) return colors.currentTurnScore;
    if (data.isLeader(entry)) return colors.live;
    if (score > 0) return colors.positive;
    return scheme.onSurfaceVariant;
  }
}
