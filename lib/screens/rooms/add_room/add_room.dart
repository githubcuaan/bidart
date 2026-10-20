import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/room_validator.dart';
import 'package:bidart/domain/validation/validation_issue.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/screens/rooms/add_room/widgets/create_room_error_panel.dart';
import 'package:bidart/screens/rooms/add_room/widgets/end_conditions_fields.dart';
import 'package:bidart/screens/rooms/add_room/widgets/player_roster_editor.dart';
import 'package:bidart/screens/rooms/add_room/widgets/role_selectors.dart';
import 'package:bidart/screens/rooms/add_room/widgets/room_draft_preview.dart';
import 'package:bidart/screens/rooms/add_room/widgets/rule_template_section.dart';
import 'package:bidart/screens/rooms/chose_room.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:bidart/widgets/room/ball_rules_editor/ball_rules_editor.dart';
import 'package:bidart/features/scoring/provider/create_room_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/features/scoring/provider/rule_template_controller.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Create-room form. Holds the draft state; every block is its own widget.
class AddRoom extends ConsumerStatefulWidget {
  const AddRoom({super.key});

  @override
  ConsumerState<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends ConsumerState<AddRoom> {
  late final TextEditingController _name;
  late final TextEditingController _duration;
  late final TextEditingController _threshold;
  late final TextEditingController _templateName;
  final _names = <String, TextEditingController>{};
  final _points = <int, TextEditingController>{};
  final _enabled = <int, bool>{};
  late List<PlayerInGame> _players;
  late String _starter;
  late String _payer;
  late String _ownerId;
  bool _navigating = false;

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
    final state = ref.read(createRoomControllerProvider);
    final saved = state.result.asData?.value == null
        ? state.draft
        : CreateRoomDraft();
    _ownerId = saved.ownerId;
    _name = TextEditingController(text: saved.name);
    _templateName = TextEditingController();
    _duration = TextEditingController(
      text: saved.endConditions.durationSeconds?.toString() ?? '',
    );
    _threshold = TextEditingController(
      text: saved.endConditions.scoreThreshold?.toString() ?? '',
    );
    _players = saved.participants.isEmpty
        ? [_newPlayer(), _newPlayer()]
        : [
            for (final id in saved.playerOrder)
              saved.participants.firstWhere((player) => player.id == id),
          ];
    for (final player in _players) {
      _names[player.id] = TextEditingController(text: player.displayName);
    }
    _starter = saved.participants.isEmpty ? _players.first.id : saved.starterId;
    _payer = saved.participants.isEmpty ? _players.last.id : saved.payerId;
    for (final ball in _balls) {
      final config = saved.ballPoints[ball];
      _enabled[ball] = config?.enabled ?? true;
      _points[ball] = TextEditingController(
        text: '${config?.enabled == false ? ball : config?.points ?? ball}',
      );
    }
  }

  PlayerInGame _newPlayer() => PlayerInGame(
    id: ref.read(idFactoryProvider)(),
    displayName: '',
    joinedAt: ref.read(clockProvider)(),
  );

  @override
  void dispose() {
    for (final controller in [
      _name,
      _templateName,
      _duration,
      _threshold,
      ..._names.values,
      ..._points.values,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Raw invalid number strings stay in text controllers, not asserted models.
  CreateRoomDraft get _draft => CreateRoomDraft(
    name: _name.text,
    ownerId: _ownerId,
    participants: [
      for (final player in _players)
        player.copyWith(displayName: _names[player.id]!.text),
    ],
    playerOrder: _players.map((player) => player.id).toList(),
    starterId: _starter,
    payerId: _payer,
    ballPoints: {
      for (final ball in _balls)
        ball: BallPointConfig(
          enabled: _enabled[ball]!,
          points: _enabled[ball]! ? (_positive(_points[ball]!.text) ?? 1) : 0,
        ),
    },
    endConditions: EndConditions(
      durationSeconds: _positive(_duration.text),
      scoreThreshold: _positive(_threshold.text),
    ),
  );

  int? _positive(String value) {
    final number = int.tryParse(value.trim());
    return number != null && number > 0 ? number : null;
  }

  void _changed([VoidCallback? update]) {
    setState(() => update?.call());
    ref.read(createRoomControllerProvider.notifier).setDraft(_draft);
  }

  void _move(int index, int offset) => _changed(() {
    final player = _players.removeAt(index);
    _players.insert(index + offset, player);
  });

  void _remove(String id) => _changed(() {
    _players.removeWhere((player) => player.id == id);
    if (_starter == id) _starter = '';
    if (_payer == id) _payer = '';
  });

  String _label(PlayerInGame player) {
    final name = _names[player.id]!.text.trim();
    return name.isEmpty ? 'Người chơi ${_players.indexOf(player) + 1}' : name;
  }

  void _applyTemplate(RuleTemplate template) => _changed(() {
    for (final ball in _balls) {
      final config = template.ballPoints[ball];
      _enabled[ball] = config?.enabled ?? true;
      _points[ball]!.text =
          '${config?.enabled == false ? ball : config?.points ?? ball}';
    }
  });

  Future<String> _saveTemplate() async {
    final controller = ref.read(ruleTemplateSaveControllerProvider.notifier);
    final state = ref.read(ruleTemplateSaveControllerProvider);
    final template = await controller.save(
      name: _templateName.text,
      ballPoints: _draft.ballPoints,
    );
    return template == null
        ? roomFailureMessage(
            state.error ?? const PersistenceFailure('Không lưu được mẫu.'),
          )
        : 'Đã lưu mẫu “${template.name}”.';
  }

  void _openExisting(String roomId) => Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(builder: (_) => ChoseRoom(roomId: roomId)),
  );

  Future<void> _submit() async {
    final controller = ref.read(createRoomControllerProvider.notifier);
    controller.setDraft(_draft);
    final id = await controller.submit();
    if (!mounted || id == null || _navigating) return;
    // A completed save must not navigate after the user has left this route.
    if (ModalRoute.of(context)?.isCurrent != true) return;
    setState(() => _navigating = true);
    _openExisting(id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRoomControllerProvider);
    final saving = state.result.isLoading || _navigating;
    final draft = _draft;
    final issues = RoomValidator.validate(
      participants: draft.participants,
      playerOrder: draft.playerOrder,
      starterId: draft.starterId,
      payerId: draft.payerId,
      ruleConfig: RuleConfig(
        id: 'draft',
        version: 1,
        ballPoints: draft.ballPoints,
      ),
      endConditions: draft.endConditions,
    );
    String? issueFor(String path) => issues
        .where((issue) => issue.fieldPath == path)
        .map((issue) => validationMessage(issue.code))
        .firstOrNull;
    final ballErrors = {
      for (final ball in _balls)
        if (_enabled[ball]! && _positive(_points[ball]!.text) == null)
          ball: 'Nhập số nguyên dương.',
    };
    final invalidDuration =
        _duration.text.trim().isNotEmpty && _positive(_duration.text) == null;
    final invalidThreshold =
        _threshold.text.trim().isNotEmpty && _positive(_threshold.text) == null;
    final error = state.result.error;

    return AppScreen(
      appBar: AppBar(title: const Text('Tạo phòng')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          key: const ValueKey('submit-room'),
          onPressed:
              issues.isEmpty &&
                  ballErrors.isEmpty &&
                  !invalidDuration &&
                  !invalidThreshold &&
                  _name.text.trim().isNotEmpty &&
                  !saving
              ? _submit
              : null,
          child: Text(saving ? 'Đang lưu…' : 'Tạo và bắt đầu'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Cài đặt & Tạo phòng bắn đền',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Phòng local · 2–5 người · điểm cộng dồn qua các ván. '
            'Tự lưu sau mỗi thao tác; mở lại app để tiếp tục đúng trạng thái.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          SectionCard(
            title: 'Thông tin phòng',
            description: 'Nhập tên phòng',
            child: TextField(
              key: const ValueKey('room-name'),
              controller: _name,
              enabled: !saving,
              decoration: InputDecoration(
                labelText: 'Tên phòng',
                errorText: _name.text.trim().isEmpty ? 'Nhận tên phòng.' : null,
              ),
              onChanged: (_) => _changed(),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            CreateRoomErrorPanel(
              error: error,
              enabled: !saving,
              onOpenExisting: _openExisting,
            ),
          ],
          const SizedBox(height: 16),
          PlayerRosterEditor(
            players: _players,
            names: _names,
            errorFor: (index) => issueFor('participants[$index].displayName'),
            enabled: !saving,
            onChanged: _changed,
            onMove: _move,
            onRemove: _remove,
            onAdd: () => _changed(() {
              final player = _newPlayer();
              _players.add(player);
              _names[player.id] = TextEditingController();
            }),
          ),
          const SizedBox(height: 16),
          RoleSelectors(
            players: _players,
            starter: _starter,
            payer: _payer,
            labelFor: _label,
            starterError: issueFor('starterId'),
            payerError: issueFor('payerId'),
            enabled: !saving,
            onChanged: ({required bool starter, String? value}) => _changed(() {
              if (starter) {
                _starter = value ?? '';
              } else {
                _payer = value ?? '';
              }
            }),
          ),
          const SizedBox(height: 16),
          BallRulesEditor(
            enabled: _enabled,
            fields: _points,
            errors: ballErrors,
            editable: !saving,
            onToggle: (ball) =>
                _changed(() => _enabled[ball] = !_enabled[ball]!),
            onEdit: _changed,
            title: 'Điểm bi 1–9',
            description: 'Chạm ảnh bi để bật/tắt; bi tắt không tạo điểm.',
            header:
                issues.any(
                  (issue) => issue.code == ValidationCode.noEnabledBall,
                )
                ? Text(validationMessage(ValidationCode.noEnabledBall))
                : null,
          ),
          const SizedBox(height: 16),
          EndConditionsFields(
            duration: _duration,
            threshold: _threshold,
            enabled: !saving,
            durationError: invalidDuration
                ? 'Nhập số nguyên dương hoặc để trống.'
                : null,
            thresholdError: invalidThreshold
                ? 'Nhập số nguyên dương hoặc để trống.'
                : null,
            onChanged: _changed,
          ),
          const SizedBox(height: 16),
          RoomDraftPreview(
            order: _players.map(_label).join(' → '),
            starter:
                _players
                    .where((p) => p.id == _starter)
                    .map(_label)
                    .firstOrNull ??
                'Chưa chọn',
            payer:
                _players.where((p) => p.id == _payer).map(_label).firstOrNull ??
                'Chưa chọn',
            rules: [
              for (final ball in _balls)
                'Bi $ball: ${_enabled[ball]! ? '${_points[ball]!.text}đ' : 'tắt'}',
            ].join(' · '),
          ),
          const SizedBox(height: 16),
          RuleTemplateSection(
            templateName: _templateName,
            enabled: !saving,
            onSave: _saveTemplate,
            onApply: _applyTemplate,
          ),
        ],
      ),
    );
  }
}
