import 'package:freezed_annotation/freezed_annotation.dart';

part 'ball_point_config.freezed.dart';
part 'ball_point_config.g.dart';

/// Points for one ball 1-9. Disabled balls contribute zero.
/// Full roster/rule validation belongs to §4; asserts guard obvious misuse.
@freezed
abstract class BallPointConfig with _$BallPointConfig {
  @Assert('!enabled || points > 0', 'enabled ball must have positive points')
  @Assert('enabled || points == 0', 'disabled ball must contribute zero')
  const factory BallPointConfig({required bool enabled, required int points}) =
      _BallPointConfig;

  factory BallPointConfig.fromJson(Map<String, dynamic> json) =>
      _$BallPointConfigFromJson(json);
}
