import 'package:flutter/material.dart';

import 'ball_point_field.dart';
import 'ball_toggle_dot.dart';

/// Ball table editor: a 3x3 grid of mini-cards inside one framed block.
/// Each card holds an on/off ball image and a compact point box.
///
/// Keys are `'$keyPrefix-enabled-$ball'` / `'$keyPrefix-points-$ball'` so the
/// same widget serves both the create-room form and the in-room rule dialog.
/// Columns collapse to one on narrow dialogs so nothing overflows.
class BallRulesEditor extends StatelessWidget {
  const BallRulesEditor({
    super.key,
    required this.enabled,
    required this.fields,
    required this.onToggle,
    this.onEdit,
    this.keyPrefix = 'ball',
    this.errors = const {},
    this.editable = true,
    this.title,
    this.description,
    this.header,
  });

  static const minBall = 1;
  static const maxBall = 9;

  /// Base card height without an error line. When a validation error appears
  /// the card grows by [_errorBlock] so the ball and point box do not move.
  static const _cellHeight = 138.0;
  static const _errorBlock = 14.0;

  /// Horizontal inset used by the point box and the error line.
  static const _cellPadding = 8.0;
  static const _dotSize = 50.0;
  static const _dotBox = 56.0;
  static const _fieldHeight = 30.0;
  static const _errorHeight = 12.0;
  static const _spacing = 10.0;
  static const _framePadding = 12.0;
  static const _minCellWidth = 88.0;
  static const _maxColumns = 3;

  final Map<int, bool> enabled;
  final Map<int, TextEditingController> fields;
  final ValueChanged<int> onToggle;
  final VoidCallback? onEdit;
  final String keyPrefix;
  final Map<int, String> errors;
  final bool editable;
  final String? title;
  final String? description;

  /// Rendered inside the card, between the description and the grid
  /// (e.g. "Bật tính điểm ít nhất một bi.").
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(_framePadding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (header != null) ...[const SizedBox(height: 6), header!],
          if (title != null || description != null || header != null)
            const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              var columns =
                  ((constraints.maxWidth + _spacing) ~/
                          (_minCellWidth + _spacing))
                      .clamp(1, _maxColumns);
              final cellWidth =
                  (constraints.maxWidth - _spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: _spacing,
                runSpacing: _spacing,
                children: [
                  for (var ball = minBall; ball <= maxBall; ball++)
                    SizedBox(
                      width: cellWidth,
                      child: BallRuleCell(
                        ball: ball,
                        enabled: enabled[ball] ?? true,
                        controller: fields[ball]!,
                        editable: editable,
                        errorText: errors[ball],
                        keyPrefix: keyPrefix,
                        onToggle: editable ? onToggle : null,
                        onEdit: onEdit ?? () {},
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// One ball mini-card: the ball is centred, the point box sits at the bottom,
/// and the card only grows when an inline error line is needed.
class BallRuleCell extends StatelessWidget {
  const BallRuleCell({
    super.key,
    required this.ball,
    required this.enabled,
    required this.controller,
    required this.editable,
    required this.keyPrefix,
    required this.onToggle,
    required this.onEdit,
    this.errorText,
  });

  final int ball;
  final bool enabled;
  final TextEditingController controller;
  final bool editable;
  final String keyPrefix;
  final ValueChanged<int>? onToggle;
  final VoidCallback onEdit;
  final String? errorText;

  /// Ball 9 decides the game, so it gets a gold accent.
  bool get _special => ball == BallRulesEditor.maxBall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasError = errorText != null;
    final accent = _special ? Colors.amber.shade800 : scheme.primary;

    final Color background;
    final Color borderColor;
    final double borderWidth;
    if (hasError) {
      background = scheme.errorContainer.withValues(alpha: 0.15);
      borderColor = scheme.error;
      borderWidth = 1.5;
    } else if (!enabled) {
      background = scheme.surfaceContainerHighest.withValues(alpha: 0.35);
      borderColor = Colors.transparent;
      borderWidth = 1;
    } else if (_special) {
      background = Colors.amber.withValues(alpha: 0.08);
      borderColor = Colors.amber;
      borderWidth = 1.5;
    } else {
      background = scheme.surface;
      borderColor = scheme.outlineVariant;
      borderWidth = 1;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      height:
          BallRulesEditor._cellHeight +
          (hasError ? BallRulesEditor._errorBlock : 0),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: BallRulesEditor._dotBox,
                height: BallRulesEditor._dotBox,
                child: Container(
                  width: BallRulesEditor._dotBox - 4,
                  height: BallRulesEditor._dotBox - 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: enabled
                        ? Border.all(color: accent, width: 2)
                        : null,
                  ),
                  child: BallToggleDot(
                    key: ValueKey('$keyPrefix-enabled-$ball'),
                    ball: ball,
                    enabled: enabled,
                    size: BallRulesEditor._dotSize,
                    onToggle: onToggle,
                    semanticLabel: 'Tính điểm bi $ball',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BallRulesEditor._cellPadding,
            ),
            child: SizedBox(
              height: BallRulesEditor._fieldHeight,
              child: BallPointField(
                key: ValueKey('$keyPrefix-points-$ball'),
                ball: ball,
                controller: controller,
                enabled: enabled,
                editable: editable,
                accentColor: accent,
                onChanged: onEdit,
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                BallRulesEditor._cellPadding,
                2,
                BallRulesEditor._cellPadding,
                0,
              ),
              child: SizedBox(
                height: BallRulesEditor._errorHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorText!,
                    key: ValueKey('$keyPrefix-error-$ball'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      height: 1.1,
                      color: scheme.error,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: BallRulesEditor._cellPadding),
        ],
      ),
    );
  }
}
