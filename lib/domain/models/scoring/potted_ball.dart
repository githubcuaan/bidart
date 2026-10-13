import 'package:freezed_annotation/freezed_annotation.dart';

part 'potted_ball.freezed.dart';
part 'potted_ball.g.dart';

/// One ball outcome in a confirmed turn. Disabled-point balls are still
/// recorded (no transaction) so remainingBalls stays correct.
/// [isRespotted] true = placed back (early 9, early ball, ball 9 in foul);
/// false = stays out of the table.
@freezed
abstract class PottedBall with _$PottedBall {
  @Assert('ballNumber >= 1 && ballNumber <= 9', 'ball must be 1-9')
  @Assert('points >= 0', 'points must be non-negative')
  const factory PottedBall({
    required int ballNumber,
    required int points,
    required bool isRespotted,
  }) = _PottedBall;

  factory PottedBall.fromJson(Map<String, dynamic> json) =>
      _$PottedBallFromJson(json);
}
