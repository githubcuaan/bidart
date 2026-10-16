import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/validation/rule_config_validator.dart';
import 'package:flutter/material.dart';

String playerName(Room room, String id) =>
    room.participants
        .where((p) => p.id == id)
        .map((p) => p.displayName)
        .firstOrNull ??
    id;

class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({super.key, required this.room});
  final Room room;
  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final _name = TextEditingController();
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _name.text.trim();
    final valid =
        name.isNotEmpty &&
        !widget.room.participants.any(
          (p) => p.displayName.toLowerCase() == name.toLowerCase(),
        );
    return AlertDialog(
      title: const Text('Thêm người'),
      content: TextField(
        key: const ValueKey('new-player-name'),
        controller: _name,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(labelText: 'Tên không trùng'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Bỏ qua'),
        ),
        FilledButton(
          key: const ValueKey('save-player'),
          onPressed: valid ? () => Navigator.pop(context, name) : null,
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}

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
    for (var b = 1; b <= 9; b++) b: config.ballPoints[b]!.enabled,
  };
  late final fields = {
    for (var b = 1; b <= 9; b++)
      b: TextEditingController(text: '${config.ballPoints[b]!.points}'),
  };
  @override
  void dispose() {
    for (final field in fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valid =
        enabled.values.any((v) => v) &&
        fields.entries.every(
          (e) => !enabled[e.key]! || (int.tryParse(e.value.text) ?? 0) > 0,
        );
    return AlertDialog(
      title: const Text('Sửa luật'),
      content: SizedBox(
        width: 340,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chỉ áp dụng từ cú tiếp theo; chặn undo các cú trước.',
              ),
              for (var b = 1; b <= 9; b++)
                Row(
                  children: [
                    Checkbox(
                      value: enabled[b],
                      key: ValueKey('rule-enabled-$b'),
                      onChanged: (value) => setState(() => enabled[b] = value!),
                    ),
                    Expanded(
                      child: TextField(
                        controller: fields[b],
                        enabled: enabled[b],
                        key: ValueKey('rule-points-$b'),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Điểm bi $b'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              if (!valid)
                const Text(
                  'Bật ít nhất một bi; điểm bật phải là số nguyên dương.',
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
          onPressed: !valid
              ? null
              : () {
                  final points = {
                    for (var b = 1; b <= 9; b++)
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
}

class OrderDialog extends StatefulWidget {
  const OrderDialog({super.key, required this.room});
  final Room room;
  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  late final order = [...widget.room.playerOrder];
  void move(int index, int delta) => setState(() {
    final id = order.removeAt(index);
    order.insert(index + delta, id);
  });
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Sửa thứ tự'),
    content: SizedBox(
      width: 340,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Giữ người đang đánh và payer; chặn undo các cú trước.'),
            for (var i = 0; i < order.length; i++)
              Row(
                children: [
                  Expanded(child: Text(playerName(widget.room, order[i]))),
                  IconButton(
                    key: ValueKey('order-up-${order[i]}'),
                    onPressed: i > 0 ? () => move(i, -1) : null,
                    tooltip: 'Lên',
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  IconButton(
                    key: ValueKey('order-down-${order[i]}'),
                    onPressed: i < order.length - 1 ? () => move(i, 1) : null,
                    tooltip: 'Xuống',
                    icon: const Icon(Icons.arrow_downward),
                  ),
                ],
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
        key: const ValueKey('save-order'),
        onPressed: () => Navigator.pop(context, order),
        child: const Text('Lưu thứ tự'),
      ),
    ],
  );
}

class ReplacementChoice {
  const ReplacementChoice(this.starter, this.payer);
  final String? starter, payer;
}

class ReplacementDialog extends StatefulWidget {
  const ReplacementDialog({super.key, required this.room});
  final Room room;
  @override
  State<ReplacementDialog> createState() => _ReplacementDialogState();
}

class _ReplacementDialogState extends State<ReplacementDialog> {
  String? starter, payer;
  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final game = room.games.last;
    final needsStarter = !room.activePlayerIds.contains(game.winnerId);
    final needsPayer = !room.activePlayerIds.contains(game.finalPayerId);
    final actualStarter = needsStarter ? starter : game.winnerId;
    final actualPayer = needsPayer ? payer : game.finalPayerId;
    final valid =
        actualStarter != null &&
        actualPayer != null &&
        actualStarter != actualPayer;
    Widget choice(
      String label,
      String key,
      String? selected,
      ValueChanged<String?> onChange,
    ) => DropdownButtonFormField<String>(
      key: ValueKey(key),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final id in room.activePlayerIds)
          DropdownMenuItem(value: id, child: Text(playerName(room, id))),
      ],
      onChanged: onChange,
    );
    return AlertDialog(
      title: const Text('Chọn người thay thế'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chỉ áp dụng ván mới, không sửa lịch sử.'),
            if (needsStarter)
              choice(
                'Người đề-pa thay thế',
                'replacement-starter',
                starter,
                (id) => setState(() => starter = id),
              ),
            if (needsPayer)
              choice(
                'Người trả thay thế',
                'replacement-payer',
                payer,
                (id) => setState(() => payer = id),
              ),
            if (!valid) const Text('Chọn đủ hai vai trò khác nhau.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Bỏ qua'),
        ),
        FilledButton(
          key: const ValueKey('confirm-replacements'),
          onPressed: valid
              ? () => Navigator.pop(context, ReplacementChoice(starter, payer))
              : null,
          child: const Text('Bắt đầu'),
        ),
      ],
    );
  }
}
