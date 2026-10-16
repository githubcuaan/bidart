import 'package:freezed_annotation/freezed_annotation.dart';

import 'ball_point_config.dart';

part 'rule_config.freezed.dart';
part 'rule_config.g.dart';

Map<int, BallPointConfig> _ballMapFromJson(Map<String, dynamic> json) => json
    .map((k, v) => MapEntry(int.parse(k), BallPointConfig.fromJson(v as Map<String, dynamic>)));

Map<String, dynamic> _ballMapToJson(Map<int, BallPointConfig> map) =>
    map.map((k, v) => MapEntry(k.toString(), v.toJson()));

/// Immutable rule version owned by a room. Turns reference
/// [id]/[version]; edits create a new version, never mutate history.
/// Point/score limits live in EndConditions (room level), not here.
/// P1 pocket multipliers, regional presets and x2 rules excluded.
@freezed
abstract class RuleConfig with _$RuleConfig {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory RuleConfig({
    required String id,
    required int version,
    @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)
    required Map<int, BallPointConfig> ballPoints,
  }) = _RuleConfig;

  factory RuleConfig.fromJson(Map<String, dynamic> json) =>
      _$RuleConfigFromJson(json);
}
