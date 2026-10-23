import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// One participant's score movement in the preview.
///
/// Display strings are prepared by the screen that owns the draft, so this
/// widget stays free of scoring rules.
class TurnPreviewDelta {
  const TurnPreviewDelta({
    required this.name,
    required this.action,
    required this.points,
  });

  final String name;

  /// e.g. `ăn Bi 9:` or `chịu đền:`.
  final String action;
  final int points;
}

/// Score delta preview for the drafted turn.
///
/// Outer framed card with a darker inner preview block, followed by the next
/// shooter line. The card header is collapsible via [SectionCard].
class TurnPreviewPanel extends StatelessWidget {
  const TurnPreviewPanel({
    super.key,
    required this.deltas,
    required this.respotted,
    required this.nextPlayerName,
    this.note,
  });

  final List<TurnPreviewDelta> deltas;
  final List<int> respotted;
  final String nextPlayerName;

  /// Optional rule note shown in an amber callout under the deltas.
  final String? note;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inner = SectionCard(
      surface: Color.alphaBlend(
        Colors.black.withValues(alpha: 0.05),
        scheme.surfaceContainerLow,
      ),
      child: _PreviewBody(
        key: const ValueKey('score-preview'),
        deltas: deltas,
        respotted: respotted,
        note: note,
      ),
    );

    return SectionCard(
      title: 'Preview',
      description: 'Xem trước các thay đổi',
      icon: Icons.visibility,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          inner,
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _NextShotLine(nextPlayerName),
          ),
        ],
      ),
    );
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({
    super.key,
    required this.deltas,
    required this.respotted,
    required this.note,
  });

  final List<TurnPreviewDelta> deltas;
  final List<int> respotted;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        if (deltas.isEmpty)
          Text(
            'Không đổi điểm',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          )
        else
          for (final delta in deltas) _DeltaRow(delta: delta),
        if (respotted.isNotEmpty)
          Text(
            'Đặt lại: ${respotted.join(', ')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        if (note case final note?)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: _NoteBox(note),
          ),
      ],
    );
  }
}

class _DeltaRow extends StatelessWidget {
  const _DeltaRow({required this.delta});

  final TurnPreviewDelta delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppSemanticColors.of(context);
    final positive = delta.points >= 0;
    final color = positive ? colors.positive : colors.negative;
    final sign = positive ? '+' : '';
    final points = '$sign${delta.points}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Icon(
            positive ? Icons.add : Icons.remove,
            size: 14,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${delta.name} ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: delta.action,
                  style: TextStyle(color: scheme.onSurface),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: points,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
              ),
              TextSpan(
                text: ' điểm',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

class _NoteBox extends StatelessWidget {
  const _NoteBox(this.note);

  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColor = AppSemanticColors.of(context).warning;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: noteColor.withValues(alpha: 0.10),
        border: Border.all(color: noteColor.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline, size: 18, color: noteColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextShotLine extends StatelessWidget {
  const _NextShotLine(this.nextPlayerName);

  final String nextPlayerName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = Text(
      'Lượt bắn kế tiếp:',
      style: theme.textTheme.bodySmall?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    );
    final name = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.bolt_rounded, size: 16, color: scheme.primary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            nextPlayerName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 280) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: [
              Align(alignment: Alignment.centerLeft, child: label),
              name,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            const SizedBox(width: 8),
            Expanded(
              child: Align(alignment: Alignment.topRight, child: name),
            ),
          ],
        );
      },
    );
  }
}
