import 'package:freezed_annotation/freezed_annotation.dart';

part 'chain_state.freezed.dart';
part 'chain_state.g.dart';

/// Payer is stored on the game and remains fixed through a holding chain.
/// A legal pot includes a ball with scoring disabled.
@freezed
abstract class ChainState with _$ChainState {
  const factory ChainState({
    required bool isBreakChain,
    required bool hasLegalPotInChain,
  }) = _ChainState;

  factory ChainState.fromJson(Map<String, dynamic> json) =>
      _$ChainStateFromJson(json);
}
