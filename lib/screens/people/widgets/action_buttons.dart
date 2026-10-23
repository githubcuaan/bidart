import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onChallenge;

  const ActionButtons({
    super.key,
    required this.onPass,
    required this.onChallenge,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'pass_btn',
            tooltip: 'Bỏ qua',
            backgroundColor: scheme.surfaceContainerHigh,
            foregroundColor: scheme.error,
            elevation: 0,
            onPressed: onPass,
            child: const Icon(Icons.close, size: 30),
          ),
          FloatingActionButton.extended(
            heroTag: 'challenge_btn',
            tooltip: 'Thách đấu',
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            elevation: 0,
            onPressed: onChallenge,
            icon: const Icon(Icons.flash_on),
            label: const Text(
              'Thách đấu',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
