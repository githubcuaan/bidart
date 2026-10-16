import 'package:freezed_annotation/freezed_annotation.dart';

part 'end_conditions.freezed.dart';
part 'end_conditions.g.dart';

/// Time runs from room creation, not from the current game's start.
/// Null limits mean that condition is disabled. Validation belongs to §4.
@freezed
abstract class EndConditions with _$EndConditions {
  const factory EndConditions({int? durationSeconds, int? scoreThreshold}) =
      _EndConditions;

  factory EndConditions.fromJson(Map<String, dynamic> json) =>
      _$EndConditionsFromJson(json);
}
