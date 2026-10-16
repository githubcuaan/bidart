import 'package:freezed_annotation/freezed_annotation.dart';

import 'transaction_type.dart';

part 'score_transaction.freezed.dart';
part 'score_transaction.g.dart';

/// Zero-sum movement: from (payer) -> to (receiver), amount always > 0.
/// Break-chain pots produce one row per payer sharing [transactionGroupId].
@freezed
abstract class ScoreTransaction with _$ScoreTransaction {
  @Assert('fromPlayerId != toPlayerId', 'transaction needs distinct parties')
  @Assert('amount > 0', 'amount must be positive')
  const factory ScoreTransaction({
    required String id,
    required String gameId,
    required String turnId,
    required String fromPlayerId,
    required String toPlayerId,
    required int amount,
    required TransactionType type,
    String? transactionGroupId,
  }) = _ScoreTransaction;

  factory ScoreTransaction.fromJson(Map<String, dynamic> json) =>
      _$ScoreTransactionFromJson(json);
}
