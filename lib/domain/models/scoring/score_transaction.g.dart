// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScoreTransaction _$ScoreTransactionFromJson(Map<String, dynamic> json) =>
    _ScoreTransaction(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      turnId: json['turnId'] as String,
      fromPlayerId: json['fromPlayerId'] as String,
      toPlayerId: json['toPlayerId'] as String,
      amount: (json['amount'] as num).toInt(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      transactionGroupId: json['transactionGroupId'] as String?,
    );

Map<String, dynamic> _$ScoreTransactionToJson(_ScoreTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameId': instance.gameId,
      'turnId': instance.turnId,
      'fromPlayerId': instance.fromPlayerId,
      'toPlayerId': instance.toPlayerId,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'transactionGroupId': instance.transactionGroupId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.legalPot: 'legalPot',
  TransactionType.foulReversal: 'foulReversal',
};
