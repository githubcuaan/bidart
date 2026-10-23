import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/features/scoring/provider/create_room_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/features/scoring/provider/rule_template_controller.dart';
import 'package:bidart/screens/profile/rules/rule_template_editor_screen.dart';
import 'package:bidart/screens/rooms/add_room/add_room.dart';
import 'package:bidart/widgets/async/async_content.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteRulesScreen extends ConsumerWidget {
  const FavoriteRulesScreen({super.key});

  void _confirmDelete(BuildContext context, WidgetRef ref, RuleTemplate template) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa bộ luật “${template.name}”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await ref
                  .read(ruleTemplateSaveControllerProvider.notifier)
                  .delete(template.id);
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xóa bộ luật “${template.name}”')),
                );
              }
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  String _formatRuleSummary(RuleTemplate template) {
    final enabledBalls = <String>[];
    for (var i = 1; i <= 9; i++) {
      final config = template.ballPoints[i];
      if (config != null && config.enabled) {
        enabledBalls.add('$i (${config.points}đ)');
      }
    }
    if (enabledBalls.isEmpty) return 'Chưa cấu hình bi';
    return 'Bi tính điểm: ${enabledBalls.join(', ')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(ruleTemplateListProvider);
    final theme = Theme.of(context);

    return AppScreen(
      appBar: AppBar(
        title: const Text('Bộ luật yêu thích'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm bộ luật',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const RuleTemplateEditorScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: AsyncContent<List<RuleTemplate>>(
        value: templatesAsync,
        skipLoadingOnRefresh: false,
        errorBuilder: (context, error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi tải danh sách: $error'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(ruleTemplateListProvider),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        dataBuilder: (context, templates) {
          if (templates.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_outline,
                      size: 64,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chưa có bộ luật yêu thích nào',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lưu các kiểu tính điểm bida thường chơi để tạo phòng nhanh chóng mà không cần thiết lập lại từ đầu.',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm bộ luật đầu tiên'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const RuleTemplateEditorScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              final dateStr =
                  '${template.createdAt.day.toString().padLeft(2, '0')}/${template.createdAt.month.toString().padLeft(2, '0')}/${template.createdAt.year}';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.bookmark_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Tạo ngày $dateStr',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (action) {
                              if (action == 'edit') {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => RuleTemplateEditorScreen(
                                      initialTemplate: template,
                                    ),
                                  ),
                                );
                              } else if (action == 'delete') {
                                _confirmDelete(context, ref, template);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 18),
                                    SizedBox(width: 8),
                                    Text('Sửa'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline,
                                        size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Xóa',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatRuleSummary(template),
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: const Text('Sửa'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => RuleTemplateEditorScreen(
                                    initialTemplate: template,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            icon: const Icon(Icons.add_circle_outline, size: 16),
                            label: const Text('Tạo phòng với luật này'),
                            onPressed: () {
                              ref
                                  .read(createRoomControllerProvider.notifier)
                                  .setDraft(
                                    CreateRoomDraft(
                                      ballPoints: template.ballPoints,
                                    ),
                                  );
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AddRoom(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm bộ luật mới',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const RuleTemplateEditorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
