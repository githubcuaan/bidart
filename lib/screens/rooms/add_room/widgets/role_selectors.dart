import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:flutter/material.dart';

/// Starter and payer pickers rendered as a decorated dropdown each.
class RoleSelectors extends StatelessWidget {
  const RoleSelectors({
    super.key,
    required this.players,
    required this.starter,
    required this.payer,
    required this.labelFor,
    required this.starterError,
    required this.payerError,
    required this.enabled,
    required this.onChanged,
  });

  final List<PlayerInGame> players;
  final String starter;
  final String payer;
  final String Function(PlayerInGame player) labelFor;
  final String? starterError;
  final String? payerError;
  final bool enabled;
  final void Function({required bool starter, String? value}) onChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final isStarter in [true, false])
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: isStarter ? 'Người đề-pa' : 'Người trả đầu',
              errorText: isStarter ? starterError : payerError,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                key: ValueKey(
                  isStarter ? 'starter-selector' : 'payer-selector',
                ),
                isExpanded: true,
                value: (isStarter ? starter : payer).isEmpty
                    ? null
                    : (isStarter ? starter : payer),
                hint: const Text('Chọn người chơi'),
                items: [
                  for (final player in players)
                    DropdownMenuItem(
                      value: player.id,
                      child: Text(labelFor(player)),
                    ),
                ],
                onChanged: enabled
                    ? (value) => onChanged(starter: isStarter, value: value)
                    : null,
              ),
            ),
          ),
        ),
    ],
  );
}
