import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/end_conditions.dart';
import 'package:bidart/domain/models/scoring/player_in_game.dart';
import 'package:bidart/domain/models/scoring/rule_config.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/room_validator.dart';
import 'package:bidart/domain/validation/validation_issue.dart';
import 'package:bidart/features/scoring/provider/create_room_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/features/scoring/provider/rule_template_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chose_room.dart';
import 'room_presentation.dart';

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
    for (var ball = 1; ball <= 9; ball++) {
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
      for (var ball = 1; ball <= 9; ball++)
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

  Future<void> _submit() async {
    final controller = ref.read(createRoomControllerProvider.notifier);
    controller.setDraft(_draft);
    final id = await controller.submit();
    if (!mounted || id == null || _navigating) return;
    // A completed save must not navigate after the user has left this route.
    if (ModalRoute.of(context)?.isCurrent != true) return;
    setState(() => _navigating = true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => ChoseRoom(roomId: id)),
    );
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
    final invalidPoints = [
      for (var ball = 1; ball <= 9; ball++)
        if (_enabled[ball]! && _positive(_points[ball]!.text) == null) ball,
    ];
    final invalidDuration =
        _duration.text.trim().isNotEmpty && _positive(_duration.text) == null;
    final invalidThreshold =
        _threshold.text.trim().isNotEmpty && _positive(_threshold.text) == null;
    final valid =
        _name.text.trim().isNotEmpty &&
        issues.isEmpty &&
        invalidPoints.isEmpty &&
        !invalidDuration &&
        !invalidThreshold;
    final error = state.result.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Tạo phòng')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          key: const ValueKey('submit-room'),
          onPressed: valid && !saving ? _submit : null,
          child: Text(saving ? 'Đang lưu…' : 'Tạo và bắt đầu'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Phòng local · 2–5 người · điểm cộng dồn qua các ván'),
          const Text(
            'Tự lưu sau mỗi thao tác; mở lại app để tiếp tục đúng trạng thái.',
          ),
          if (error != null) ...[
            Text(
              roomFailureMessage(error),
              key: const ValueKey('create-error'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            if (error is ActiveRoomExistsFailure)
              TextButton(
                key: const ValueKey('open-existing-room'),
                onPressed: saving
                    ? null
                    : () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => ChoseRoom(roomId: error.roomId),
                        ),
                      ),
                child: const Text('Mở phòng đang chơi'),
              ),
          ],
          TextField(
            key: const ValueKey('room-name'),
            controller: _name,
            enabled: !saving,
            decoration: InputDecoration(
              labelText: 'Tên phòng',
              errorText: _name.text.trim().isEmpty ? 'Nhập tên phòng.' : null,
            ),
            onChanged: (_) => _changed(),
          ),
          const SizedBox(height: 16),
          Text(
            'Người chơi (${_players.length}/5)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (var index = 0; index < _players.length; index++)
            Row(
              key: ValueKey('player-row-${_players[index].id}'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    key: ValueKey('player-name-${_players[index].id}'),
                    controller: _names[_players[index].id],
                    enabled: !saving,
                    decoration: InputDecoration(
                      labelText: 'Người chơi ${index + 1}',
                      errorText: issueFor('participants[$index].displayName'),
                    ),
                    onChanged: (_) => _changed(),
                  ),
                ),
                IconButton(
                  key: ValueKey('move-up-${_players[index].id}'),
                  tooltip: 'Đưa lên',
                  onPressed: saving || index == 0
                      ? null
                      : () => _move(index, -1),
                  icon: const Icon(Icons.arrow_upward),
                ),
                IconButton(
                  key: ValueKey('move-down-${_players[index].id}'),
                  tooltip: 'Đưa xuống',
                  onPressed: saving || index == _players.length - 1
                      ? null
                      : () => _move(index, 1),
                  icon: const Icon(Icons.arrow_downward),
                ),
                IconButton(
                  key: ValueKey('remove-player-${_players[index].id}'),
                  tooltip: 'Xóa người chơi',
                  onPressed: saving || _players.length <= 2
                      ? null
                      : () => _remove(_players[index].id),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          TextButton.icon(
            key: const ValueKey('add-player'),
            onPressed: saving || _players.length >= 5
                ? null
                : () => _changed(() {
                    final player = _newPlayer();
                    _players.add(player);
                    _names[player.id] = TextEditingController();
                  }),
            icon: const Icon(Icons.person_add),
            label: const Text('Thêm người chơi'),
          ),
          for (final starter in [true, false])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: starter ? 'Người đề-pa' : 'Người trả đầu',
                  errorText: issueFor(starter ? 'starterId' : 'payerId'),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: ValueKey(
                      starter ? 'starter-selector' : 'payer-selector',
                    ),
                    isExpanded: true,
                    value: (starter ? _starter : _payer).isEmpty
                        ? null
                        : (starter ? _starter : _payer),
                    hint: const Text('Chọn người chơi'),
                    items: [
                      for (final player in _players)
                        DropdownMenuItem(
                          value: player.id,
                          child: Text(_label(player)),
                        ),
                    ],
                    onChanged: saving
                        ? null
                        : (value) => _changed(() {
                            if (starter) {
                              _starter = value ?? '';
                            } else {
                              _payer = value ?? '';
                            }
                          }),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text('Điểm bi 1–9', style: Theme.of(context).textTheme.titleMedium),
          if (issues.any((issue) => issue.code == ValidationCode.noEnabledBall))
            Text(validationMessage(ValidationCode.noEnabledBall)),
          for (var ball = 1; ball <= 9; ball++)
            Row(
              children: [
                Semantics(
                  label: 'Tính điểm bi $ball',
                  child: Switch(
                    key: ValueKey('ball-enabled-$ball'),
                    value: _enabled[ball]!,
                    onChanged: saving
                        ? null
                        : (value) => _changed(() => _enabled[ball] = value),
                  ),
                ),
                Expanded(
                  child: TextField(
                    key: ValueKey('ball-points-$ball'),
                    controller: _points[ball],
                    enabled: !saving && _enabled[ball]!,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Điểm bi $ball',
                      helperText: _enabled[ball]!
                          ? null
                          : 'Không tính điểm (0đ)',
                      errorText: invalidPoints.contains(ball)
                          ? 'Nhập số nguyên dương.'
                          : null,
                    ),
                    onChanged: (_) => _changed(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('duration-seconds'),
            controller: _duration,
            enabled: !saving,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Thời lượng (giây, tùy chọn)',
              errorText: invalidDuration
                  ? 'Nhập số nguyên dương hoặc để trống.'
                  : null,
            ),
            onChanged: (_) => _changed(),
          ),
          TextField(
            key: const ValueKey('score-threshold'),
            controller: _threshold,
            enabled: !saving,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Ngưỡng điểm (tùy chọn)',
              errorText: invalidThreshold
                  ? 'Nhập số nguyên dương hoặc để trống.'
                  : null,
            ),
            onChanged: (_) => _changed(),
          ),
          const SizedBox(height: 16),
          const Text('Xem trước'),
          Text(
            'Thứ tự: ${_players.map(_label).join(' → ')}',
            key: const ValueKey('order-preview'),
          ),
          Text(
            'Đề-pa: ${_players.where((p) => p.id == _starter).map(_label).firstOrNull ?? 'Chưa chọn'}',
          ),
          Text(
            'Trả đầu: ${_players.where((p) => p.id == _payer).map(_label).firstOrNull ?? 'Chưa chọn'}',
          ),
          Text(
            'Luật: ${[for (var ball = 1; ball <= 9; ball++) 'Bi $ball: ${_enabled[ball]! ? '${_points[ball]!.text}đ' : 'tắt'}'].join(' · ')}',
          ),
          const Text(
            'Bi tắt vẫn thuộc bàn chơi, chỉ không tạo điểm. Đạt thời gian/ngưỡng sẽ chờ hết ván.',
          ),
          const SizedBox(height: 16),
          Text('Luật yêu thích', style: Theme.of(context).textTheme.titleMedium),
          const Text(
            'Lưu bản hiện tại để tái dùng cho phòng mới; không sửa phòng cũ.',
          ),
          TextField(
            key: const ValueKey('template-name'),
            controller: _templateName,
            enabled: !saving,
            decoration: const InputDecoration(labelText: 'Tên mẫu luật'),
          ),
          Consumer(
            builder: (context, ref, _) {
              final saveState = ref.watch(ruleTemplateSaveControllerProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    key: const ValueKey('save-template'),
                    onPressed: saving || saveState.isLoading
                        ? null
                        : () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final template = await ref
                                .read(ruleTemplateSaveControllerProvider.notifier)
                                .save(
                                  name: _templateName.text,
                                  ballPoints: draft.ballPoints,
                                );
                            if (!context.mounted) return;
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  template == null
                                      ? roomFailureMessage(
                                          saveState.error ??
                                              const PersistenceFailure(
                                                  'Không lưu được mẫu.'),
                                        )
                                      : 'Đã lưu mẫu “${template.name}”.',
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: Text(
                      saveState.isLoading ? 'Đang lưu mẫu…' : 'Lưu mẫu luật',
                    ),
                  ),
                  ref.watch(ruleTemplateListProvider).when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (templates) => templates.isEmpty
                            ? const SizedBox.shrink()
                            : Wrap(
                                spacing: 8,
                                children: [
                                  for (final template in templates)
                                    ActionChip(
                                      key: ValueKey(
                                          'apply-template-${template.id}'),
                                      label: Text(template.name),
                                      onPressed: saving
                                          ? null
                                          : () => _changed(() {
                                                for (var ball = 1;
                                                    ball <= 9;
                                                    ball++) {
                                                  final config = template
                                                      .ballPoints[ball];
                                                  _enabled[ball] =
                                                      config?.enabled ?? true;
                                                  _points[ball]!.text =
                                                      '${config?.enabled == false ? ball : config?.points ?? ball}';
                                                }
                                              }),
                                    ),
                                ],
                              ),
                      ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
