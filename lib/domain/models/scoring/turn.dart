import 'package:freezed_annotation/freezed_annotation.dart';

import 'foul_classification.dart';
import 'potted_ball.dart';
import 'score_log.dart';
import 'score_transaction.dart';
import 'turn_state_snapshot.dart';

part 'turn.freezed.dart';
part 'turn.g.dart';

/// One confirmed turn. UI selection is only a draft; confirmation creates
/// exactly one Turn. References are stable IDs, never names or nested
/// mutable player objects. Undo marks [isUndone], never deletes history.
@freezed
abstract class Turn with _$Turn {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Turn({
    required String id,
    required String commandId,
    required String roomId,
    required String gameId,
    required int turnNumber,
    required String actorId,
    required List<String> payerIds,
    required String ruleConfigId,
    required int ruleVersion,
    required List<PottedBall> pottedBalls,
    required FoulClassification foulClassification,
    required List<ScoreTransaction> transactions,
    required List<ScoreLog> logs,
    required TurnStateSnapshot beforeSnapshot,
    required TurnStateSnapshot afterSnapshot,
    required DateTime createdAt,
    @Default(0) int revision,
    @Default(false) bool isUndone,
  }) = _Turn;

  factory Turn.fromJson(Map<String, dynamic> json) => _$TurnFromJson(json);
}
