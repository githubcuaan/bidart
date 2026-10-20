import 'package:flutter/material.dart';

/// Compact point box under a ball toggle. Disabled balls keep their value but
/// show it struck through: the ball stays on the table but scores nothing.
///
/// Input is intentionally not filtered to digits: the surrounding form
/// validates every value (`0`, `-1`, `1.5`, `abc`, empty) so the user sees the
/// error instead of having characters silently dropped.
class BallPointField extends StatelessWidget {
  const BallPointField({
    super.key,
    required this.ball,
    required this.controller,
    required this.enabled,
    required this.onChanged,
    this.editable = true,
    this.accentColor,
  });

  final int ball;
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onChanged;

  /// False while the surrounding form is busy; distinct from a disabled ball.
  final bool editable;

  /// Ball accent (gold for ball 9); defaults to the theme primary color.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final disabled = !enabled;
    final accent = accentColor ?? scheme.primary;
    return TextField(
      controller: controller,
      enabled: enabled && editable,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        decoration: disabled ? TextDecoration.lineThrough : null,
        decorationColor: scheme.onSurfaceVariant,
        color: disabled ? scheme.onSurfaceVariant : accent,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: disabled
            ? scheme.surfaceContainerHighest
            : accent.withValues(alpha: 0.08),
        hintText: disabled ? '—' : null,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}
