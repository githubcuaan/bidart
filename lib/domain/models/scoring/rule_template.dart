import 'package:freezed_annotation/freezed_annotation.dart';

import 'ball_point_config.dart';

part 'rule_template.freezed.dart';
part 'rule_template.g.dart';

Map<int, BallPointConfig> _ballMapFromJson(Map<String, dynamic> json) => json
    .map((k, v) => MapEntry(int.parse(k), BallPointConfig.fromJson(v as Map<String, dynamic>)));

Map<String, dynamic> _ballMapToJson(Map<int, BallPointConfig> map) =>
    map.map((k, v) => MapEntry(k.toString(), v.toJson()));

/// Favorite rule saved independently. Applying it to a new room copies
/// the config; it never mutates existing rooms or their history.
@freezed
abstract class RuleTemplate with _$RuleTemplate {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory RuleTemplate({
    required String id,
    required String name,
    @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)
    required Map<int, BallPointConfig> ballPoints,
    required DateTime createdAt,
  }) = _RuleTemplate;

  factory RuleTemplate.fromJson(Map<String, dynamic> json) =>
      _$RuleTemplateFromJson(json);
}
