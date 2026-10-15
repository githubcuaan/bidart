import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'room_providers.dart';

/// Saves favorite rules independently. The saved copy never mutates rooms.
final ruleTemplateSaveControllerProvider =
    NotifierProvider<RuleTemplateSaveController, AsyncValue<RuleTemplate?>>(
  RuleTemplateSaveController.new,
);

class RuleTemplateSaveController extends Notifier<AsyncValue<RuleTemplate?>> {
  @override
  AsyncValue<RuleTemplate?> build() => const AsyncData(null);

  Future<RuleTemplate?> save({
    required String name,
    required Map<int, BallPointConfig> ballPoints,
    String? templateId,
  }) async {
    state = const AsyncLoading();
    try {
      final id = templateId ?? const Uuid().v4();
      final template = await ref
          .read(ruleTemplateRepositoryProvider)
          .saveRuleTemplate(
            templateId: id,
            name: name,
            ballPoints: ballPoints,
          );
      ref.invalidate(ruleTemplateListProvider);
      state = AsyncData(template);
      return template;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }
}
