import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/screens/onboarding/onboarding_content.dart';
import 'package:bidart/screens/onboarding/widgets/onboarding_dots.dart';
import 'package:flutter/material.dart';

/// Sticky bottom area: page dots, primary CTA and the optional secondary CTA.
class OnboardingBottomBar extends StatelessWidget {
  const OnboardingBottomBar({
    super.key,
    required this.content,
    required this.index,
    required this.count,
    required this.replay,
    required this.enabled,
    required this.onPrimary,
    required this.onSecondary,
    required this.onDotTap,
  });

  final OnboardingPageContent content;
  final int index;
  final int count;
  final bool replay;
  final bool enabled;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final ValueChanged<int> onDotTap;

  bool get _isLast => index == count - 1;

  @override
  Widget build(BuildContext context) {
    final label = replay && _isLast ? 'Đã hiểu' : content.ctaLabel;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingDots(
            count: count,
            index: index,
            onTap: onDotTap,
            enabled: enabled,
          ),
          const SizedBox(height: 10),
          _PrimaryCta(
            label: label,
            icon: _isLast
                ? Icons.play_circle_fill_rounded
                : Icons.arrow_forward_rounded,
            enabled: enabled,
            onTap: onPrimary,
          ),
          if (_isLast && !replay)
            TextButton(
              key: const ValueKey('onboarding-secondary-cta'),
              onPressed: enabled ? onSecondary : null,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkOnSurfaceVariant,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Khám phá ứng dụng'),
            )
          else
            const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatefulWidget {
  const _PrimaryCta({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_PrimaryCta> createState() => _PrimaryCtaState();
}

class _PrimaryCtaState extends State<_PrimaryCta> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Semantics(
        button: true,
        enabled: widget.enabled,
        label: widget.label,
        onTap: widget.enabled ? widget.onTap : null,
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.32),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const ValueKey('onboarding-primary-cta'),
              borderRadius: BorderRadius.circular(16),
              onTap: widget.enabled ? widget.onTap : null,
              onHighlightChanged: (value) {
                if (_pressed != value) setState(() => _pressed = value);
              },
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 160),
                          child: Text(
                            widget.label,
                            key: ValueKey(widget.label),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF002114),
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          widget.icon,
                          size: 20,
                          color: const Color(0xFF002114),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
