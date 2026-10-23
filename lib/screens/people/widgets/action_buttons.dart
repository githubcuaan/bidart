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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'pass_btn',
            backgroundColor: Colors.white,
            onPressed: onPass,
            child: const Icon(Icons.close, color: Colors.red, size: 30),
          ),
          FloatingActionButton.extended(
            heroTag: 'challenge_btn',
            backgroundColor: Colors.green,
            onPressed: onChallenge,
            icon: const Icon(Icons.flash_on, color: Colors.white),
            label: const Text(
              'Thách đấu',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
