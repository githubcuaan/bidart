import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/features/scoring/provider/rule_template_controller.dart';
import 'package:bidart/widgets/async/async_content.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Save the current ball table as a reusable template and apply saved ones.
class RuleTemplateSection extends ConsumerWidget {
  const RuleTemplateSection({
    super.key,
    required this.templateName,
    required this.enabled,
    required this.onSave,
    required this.onApply,
  });

  final TextEditingController templateName;
  final bool enabled;

  /// Returns the message to show in the snackbar.
  final Future<String> Function() onSave;
  final ValueChanged<RuleTemplate> onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveState = ref.watch(ruleTemplateSaveControllerProvider);
    return SectionCard(
      title: 'Luật yêu thích',
      description:
          'Lưu bản hiện tại để tái dùng cho phòng mới; không sửa phòng cũ.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const ValueKey('template-name'),
            controller: templateName,
            enabled: enabled,
            decoration: const InputDecoration(labelText: 'Tên mẫu luật'),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            key: const ValueKey('save-template'),
            onPressed: enabled && !saveState.isLoading
                ? () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final message = await onSave();
                    messenger.showSnackBar(SnackBar(content: Text(message)));
                  }
                : null,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: Text(saveState.isLoading ? 'Đang lưu mẫu…' : 'Lưu mẫu luật'),
          ),
          AsyncContent<List<RuleTemplate>>(
            value: ref.watch(ruleTemplateListProvider),
            loadingBuilder: (_) => const SizedBox.shrink(),
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
            dataBuilder: (_, templates) => templates.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 8,
                    children: [
                      for (final template in templates)
                        ActionChip(
                          key: ValueKey('apply-template-${template.id}'),
                          label: Text(template.name),
                          onPressed: enabled ? () => onApply(template) : null,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
