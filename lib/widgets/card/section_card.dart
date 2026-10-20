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
    this.icon,
    this.description,
    this.header,
    this.trailing,
  });

  static const padding = 12.0;

  final IconData? icon;
  final Widget child;
  final String? title;
  final String? description;

  /// Optional widget on the right side of the header row (e.g. a badge or action).
  final Widget? trailing;

  /// Rendered between the top header row and [child] (e.g. a validation error).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasTopRow =
        icon != null ||
        title != null ||
        description != null ||
        trailing != null;

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
          if (hasTopRow)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 22, color: scheme.primary),
                  ),
                  if (title != null || description != null)
                    const SizedBox(width: 12),
                ],
                if (title != null || description != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (title != null && description != null)
                          const SizedBox(height: 2),
                        if (description != null)
                          Text(
                            description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          if (header != null) ...[
            if (hasTopRow) const SizedBox(height: 6),
            header!,
          ],
          if (hasTopRow || header != null) const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
