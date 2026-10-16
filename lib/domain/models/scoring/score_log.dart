import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_log.freezed.dart';
part 'score_log.g.dart';

/// Before/after score of one affected participant, for history/undo.
@freezed
abstract class ScoreLog with _$ScoreLog {
  const factory ScoreLog({
    required String participantId,
    required int previousScore,
    required int newScore,
  }) = _ScoreLog;

  factory ScoreLog.fromJson(Map<String, dynamic> json) =>
      _$ScoreLogFromJson(json);
}
