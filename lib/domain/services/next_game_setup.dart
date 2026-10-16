import 'package:bidart/domain/models/scoring/game_session.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/room_validator.dart';

/// Pure setup policy. Roster/order edits between games remain unsupported until
/// replacement-payer and edited-order precedence are explicitly settled.
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
  }) {
    final winner = previous.winnerId;
    final payer = previous.finalPayerId;
    final order = previous.playerOrder;

    if (winner == null ||
        payer == null ||
        RoomValidator.validateOrder(activePlayerIds, order).isNotEmpty ||
        roomOrder.length != order.length ||
        !List.generate(
          order.length,
          (i) => roomOrder[i] == order[i],
        ).every((same) => same) ||
        RoomValidator.validateStarterPayer(
          activePlayerIds: activePlayerIds,
          starterId: winner,
          payerId: payer,
        ).isNotEmpty) {
      throw RepositoryValidationFailure(
        'Unsupported or invalid next-game setup',
      );
    }

    if (previous.isBreakClear) {
      return NextGameSetup._(winner, payer, order);
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
