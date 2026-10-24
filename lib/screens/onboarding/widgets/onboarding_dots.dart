import 'package:bidart/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Tappable page indicator used at the bottom of the onboarding.
class OnboardingDots extends StatelessWidget {
  const OnboardingDots({
    super.key,
    required this.count,
    required this.index,
    required this.onTap,
    this.enabled = true,
  });

  final int count;
  final int index;
  final ValueChanged<int> onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Semantics(
            button: true,
            selected: i == index,
            label: 'Trang ${i + 1}',
            onTap: enabled ? () => onTap(i) : null,
            excludeSemantics: true,
            child: GestureDetector(
              key: ValueKey('onboarding-dot-$i'),
              behavior: HitTestBehavior.opaque,
              onTap: enabled ? () => onTap(i) : null,
              child: SizedBox(
                width: 32,
                height: 48,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: i == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index
                          ? AppColors.primary
                          : AppColors.darkOnSurface.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: i == index
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
