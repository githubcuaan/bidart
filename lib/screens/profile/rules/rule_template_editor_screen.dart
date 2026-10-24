import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/features/scoring/provider/rule_template_controller.dart';
import 'package:bidart/widgets/room/ball_rules_editor/ball_rules_editor.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleTemplateEditorScreen extends ConsumerStatefulWidget {
  final RuleTemplate? initialTemplate;

  const RuleTemplateEditorScreen({
    super.key,
    this.initialTemplate,
  });

  @override
  ConsumerState<RuleTemplateEditorScreen> createState() =>
      _RuleTemplateEditorScreenState();
}

class _RuleTemplateEditorScreenState
    extends ConsumerState<RuleTemplateEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final Map<int, bool> _enabled = {};
  final Map<int, TextEditingController> _points = {};

  static final _balls = [
    for (
      var ball = BallRulesEditor.minBall;
      ball <= BallRulesEditor.maxBall;
      ball++
    )
      ball,
  ];

  @override
  void initState() {
    super.initState();
    final template = widget.initialTemplate;
    _nameController = TextEditingController(text: template?.name ?? '');

    for (final ball in _balls) {
      final config = template?.ballPoints[ball];
      _enabled[ball] = config?.enabled ?? true;
      _points[ball] = TextEditingController(
        text: '${config?.enabled == false ? ball : config?.points ?? (ball == 9 ? 2 : 1)}',
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _points.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _applyStandardPreset() {
    setState(() {
      for (final ball in _balls) {
        _enabled[ball] = true;
        _points[ball]!.text = ball == 9 ? '2' : '1';
      }
    });
  }

  void _applyNumberPreset() {
    setState(() {
      for (final ball in _balls) {
        _enabled[ball] = true;
        _points[ball]!.text = '$ball';
      }
    });
  }

  void _applyEqualPreset() {
    setState(() {
      for (final ball in _balls) {
        _enabled[ball] = true;
        _points[ball]!.text = '1';
      }
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên bộ luật')),
      );
      return;
    }

    final hasAnyEnabled = _enabled.values.any((e) => e);
    if (!hasAnyEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bật tính điểm ít nhất một bi')),
      );
      return;
    }

    final ballPoints = <int, BallPointConfig>{};
    for (final ball in _balls) {
      final isEnabled = _enabled[ball] ?? true;
      final parsed = int.tryParse(_points[ball]!.text) ?? 1;
      ballPoints[ball] = BallPointConfig(
        enabled: isEnabled,
        points: isEnabled ? (parsed > 0 ? parsed : 1) : 0,
      );
    }

    final controller = ref.read(ruleTemplateSaveControllerProvider.notifier);
    final saved = await controller.save(
      name: name,
      ballPoints: ballPoints,
      templateId: widget.initialTemplate?.id,
    );

    if (!mounted) return;
    if (saved != null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialTemplate == null
                ? 'Đã tạo bộ luật “$name”'
                : 'Đã cập nhật bộ luật “$name”',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể lưu bộ luật. Vui lòng kiểm tra lại.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(ruleTemplateSaveControllerProvider);
    final isEditing = widget.initialTemplate != null;

    return AppScreen(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa bộ luật' : 'Tạo bộ luật mới'),
        actions: [
          TextButton(
            onPressed: saveState.isLoading ? null : _save,
            child: saveState.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Lưu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên bộ luật',
                hintText: 'Ví dụ: 9 bi chuẩn, Tính điểm tự do...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.bookmark_outline),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Tên bộ luật không được để trống';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Gợi ý mẫu nhanh:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.flash_on, size: 16),
                    label: const Text('9 bi chuẩn (bi 9 = 2đ)'),
                    onPressed: _applyStandardPreset,
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(Icons.format_list_numbered, size: 16),
                    label: const Text('Điểm theo số bi (1-9đ)'),
                    onPressed: _applyNumberPreset,
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    avatar: const Icon(Icons.equalizer, size: 16),
                    label: const Text('Đồng giá (1đ/bi)'),
                    onPressed: _applyEqualPreset,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BallRulesEditor(
              enabled: _enabled,
              fields: _points,
              title: 'Bảng điểm từng bi',
              description: 'Bật/tắt các bi hợp lệ và đặt điểm số khi vào lỗ.',
              onToggle: (ball) {
                setState(() {
                  _enabled[ball] = !(_enabled[ball] ?? true);
                });
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: saveState.isLoading ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(
                saveState.isLoading ? 'Đang lưu...' : 'Lưu bộ luật này',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
