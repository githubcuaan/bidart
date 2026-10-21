import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/validation/rule_config_validator.dart';
import 'package:bidart/widgets/room/ball_rules_editor/ball_rules_editor.dart';
import 'package:flutter/material.dart';

/// Edits ball points as a new rule version (applied from the next turn).
class RulesDialog extends StatefulWidget {
  const RulesDialog({super.key, required this.room});
  final Room room;
  @override
  State<RulesDialog> createState() => _RulesDialogState();
}

class _RulesDialogState extends State<RulesDialog> {
  late final config = widget.room.ruleVersions.singleWhere(
    (r) => r.version == widget.room.currentRuleVersion,
  );
  late final enabled = {
    for (var b = BallRulesEditor.minBall; b <= BallRulesEditor.maxBall; b++)
      b: config.ballPoints[b]!.enabled,
  };
  late final fields = {
    for (var b = BallRulesEditor.minBall; b <= BallRulesEditor.maxBall; b++)
      b: TextEditingController(text: '${config.ballPoints[b]!.points}'),
  };

  @override
  void dispose() {
    for (final field in fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  Map<int, String> get _errors => {
    for (var b = BallRulesEditor.minBall; b <= BallRulesEditor.maxBall; b++)
      if (enabled[b]! && (int.tryParse(fields[b]!.text) ?? 0) <= 0)
        b: 'Điểm phải là số nguyên dương.',
  };

  bool get _valid => enabled.values.any((v) => v) && _errors.isEmpty;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Sửa luật'),
    content: SizedBox(
      width: 340,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chỉ áp dụng từ cú tiếp theo; chặn undo các cú trước.'),
            const SizedBox(height: 12),
            BallRulesEditor(
              enabled: enabled,
              fields: fields,
              errors: _errors,
              keyPrefix: 'rule',
              title: 'Bảng điểm bi',
              description:
                  'Chạm ảnh bi để bật/tắt tính điểm; bi tắt vẫn nằm trên bàn.',
              header: enabled.values.any((v) => v)
                  ? null
                  : const Text('Bật ít nhất một bi.'),
              onToggle: (b) => setState(() => enabled[b] = !enabled[b]!),
              onEdit: () => setState(() {}),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Bỏ qua'),
      ),
      FilledButton(
        key: const ValueKey('save-rules'),
        onPressed: !_valid
            ? null
            : () {
                final points = {
                  for (
                    var b = BallRulesEditor.minBall;
                    b <= BallRulesEditor.maxBall;
                    b++
                  )
                    b: BallPointConfig(
                      enabled: enabled[b]!,
                      points: enabled[b]! ? int.parse(fields[b]!.text) : 0,
                    ),
                };
                if (RuleConfigValidator.validateBallPoints(points).isEmpty) {
                  Navigator.pop(context, points);
                }
              },
        child: const Text('Lưu luật'),
      ),
    ],
  );
}
