import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/rule_config_validator.dart';

/// Favorite rules stored independently. Applying a template copies its
/// config into a new room; it never mutates existing rooms or histories.
abstract interface class RuleTemplateRepository {
  Future<RuleTemplate> saveRuleTemplate({
    required String templateId,
    required String name,
    required Map<int, BallPointConfig> ballPoints,
  });

  Future<List<RuleTemplate>> listRuleTemplates();

  Future<RuleTemplate> getRuleTemplate(String templateId);

  Future<void> deleteRuleTemplate(String templateId);
}

/// Shared validation so RAM and Drift backends reject the same inputs.
RuleTemplate buildRuleTemplate({
  required String templateId,
  required String name,
  required Map<int, BallPointConfig> ballPoints,
  required DateTime now,
}) {
  if (templateId.trim().isEmpty) {
    throw RepositoryValidationFailure('Nonempty template ID required');
  }
  final trimmedName = name.trim();
  if (trimmedName.isEmpty) {
    throw RepositoryValidationFailure('Nonempty template name required');
  }
  final captured = Map<int, BallPointConfig>.unmodifiable(
    Map<int, BallPointConfig>.from(ballPoints),
  );
  final issues = RuleConfigValidator.validate(
    RuleConfig(id: 'template:$templateId', version: 1, ballPoints: captured),
  );
  if (issues.isNotEmpty) {
    throw RepositoryValidationFailure('Invalid template rules',
        issues: issues);
  }
  // Detach caller-owned map; Freezed views alone do not copy it.
  return RuleTemplate(
    id: templateId,
    name: trimmedName,
    ballPoints: Map<int, BallPointConfig>.from(captured),
    createdAt: now,
  );
}
