import 'package:flutter/material.dart';

/// Rounded, outlined block used to group one section of a form.
///
/// Matches the frame of [BallRulesEditor] so every large block on a page reads
/// as the same kind of card.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.header,
  });

  static const padding = 12.0;

  final Widget child;
  final String? title;
  final String? description;

  /// Rendered between the description and [child] (e.g. a validation error).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(padding),
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
          child,
        ],
      ),
    );
  }
}
