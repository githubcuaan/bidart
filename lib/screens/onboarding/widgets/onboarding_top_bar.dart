import 'package:bidart/widgets/branding/bidart_logo.dart';
import 'package:flutter/material.dart';

/// Brand row at the top of the onboarding: logo on the left, skip/close on
/// the right.
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({
    super.key,
    required this.replay,
    required this.showSkip,
    required this.onSkip,
    required this.onClose,
  });

  final bool replay;
  final bool showSkip;
  final VoidCallback onSkip;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: BidartLogo(markSize: 24, fontSize: 16, gap: 8),
              ),
            ),
            if (replay)
              IconButton(
                key: const ValueKey('onboarding-close'),
                tooltip: 'Đóng',
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
              )
            else if (showSkip)
              TextButton(
                key: const ValueKey('onboarding-skip'),
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
                child: const Text('Bỏ qua'),
              ),
          ],
        ),
      ),
    );
  }
}
