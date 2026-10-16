import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/room_validator.dart';

/// Pure setup policy. Departed outcome roles require explicit user choices;
/// historical outcomes never change. Room order supplies the next-game cycle.
class NextGameSetup {
  NextGameSetup._(this.starterId, this.payerId, List<String> order)
    : playerOrder = List.unmodifiable(order);

  final String starterId;
  final String payerId;
  final List<String> playerOrder;

  static NextGameSetup derive({
    required GameSession previous,
    required List<String> activePlayerIds,
    required List<String> roomOrder,
    String? replacementStarterId,
    String? replacementPayerId,
  }) {
    final originalWinner = previous.winnerId;
    final originalPayer = previous.finalPayerId;
    final winnerPresent = activePlayerIds.contains(originalWinner);
    final payerPresent = activePlayerIds.contains(originalPayer);
    final winner = winnerPresent ? originalWinner : replacementStarterId;
    final payer = payerPresent ? originalPayer : replacementPayerId;
    final order = roomOrder;

    if (originalWinner == null ||
        originalPayer == null ||
        (winnerPresent && replacementStarterId != null) ||
        (payerPresent && replacementPayerId != null) ||
        winner == null ||
        payer == null ||
        RoomValidator.validateOrder(activePlayerIds, order).isNotEmpty ||
        RoomValidator.validateStarterPayer(
          activePlayerIds: activePlayerIds,
          starterId: winner,
          payerId: payer,
        ).isNotEmpty) {
      throw RepositoryValidationFailure(
        'Valid next-game roster and explicit replacements required',
      );
    }

    if (previous.isBreakClear) {
      final index = order.indexOf(winner);
      return NextGameSetup._(winner, payer, [
        ...order.skip(index),
        ...order.take(index),
      ]);
    }

    final index = order.indexOf(winner);
    final rotated = [...order.skip(index + 1), ...order.take(index)];

    return NextGameSetup._(winner, payer, [
      winner,
      payer,
      ...rotated.where((id) => id != payer),
    ]);
  }
}
