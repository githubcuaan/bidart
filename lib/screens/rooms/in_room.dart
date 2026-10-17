import 'dart:async';

import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/services/end_condition_policy.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/features/scoring/provider/next_game_controller.dart';
import 'package:bidart/features/scoring/provider/room_action_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/widgets/async/async_content.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_edit_dialogs.dart';
import 'room_presentation.dart';

class InRoom extends ConsumerStatefulWidget {
  const InRoom({super.key, required this.roomId});
  final String roomId;
  @override
  ConsumerState<InRoom> createState() => _InRoomState();
}

class _InRoomState extends ConsumerState<InRoom> with WidgetsBindingObserver {
  final _balls = <int>{};
  bool _foul = false;
  String? _draftOwner;
  int? _scheduledRevision;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomId != widget.roomId) {
      _timer?.cancel();
      _scheduledRevision = null;
      _draftOwner = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_evaluate());
  }

  bool get _busy =>
      ref.read(roomActionControllerProvider(widget.roomId)).isLoading ||
      ref.read(nextGameControllerProvider(widget.roomId)).isLoading;

  Future<void> _evaluate() async {
    try {
      final room = await ref.read(roomByIdProvider(widget.roomId).future);
      if (!mounted || room.status != RoomStatus.active) return;
      if (_busy) {
        _timer?.cancel();
        _timer = Timer(const Duration(milliseconds: 100), _evaluate);
        return;
      }
      if (evaluateRoomEnd(room, ref.read(clockProvider)()) != room) {
        await _act(room, RoomAction(RoomActionKind.evaluate));
      }
    } catch (_) {
      /* Load errors render through the read provider. */
    }
  }

  void _schedule(Room room) {
    if (_scheduledRevision == room.revision) return;
    _scheduledRevision = room.revision;
    _timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_evaluate());
    });
    final seconds = room.endConditions.durationSeconds;
    if (room.status == RoomStatus.active && seconds != null) {
      final delay = room.createdAt
          .add(Duration(seconds: seconds))
          .difference(ref.read(clockProvider)());
      if (delay > Duration.zero) _timer = Timer(delay, _evaluate);
    }
  }

  Future<Room?> _act(Room room, RoomAction action) => ref
      .read(roomActionControllerProvider(widget.roomId).notifier)
      .submit(action, expectedRevision: room.revision);

  Future<bool> _confirm(String title, String message) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Bỏ qua'),
            ),
            FilledButton(
              key: const ValueKey('confirm-action'),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _next(Room room) async {
    ReplacementChoice? choice;
    final game = room.games.last;
    if (!room.activePlayerIds.contains(game.winnerId) ||
        !room.activePlayerIds.contains(game.finalPayerId)) {
      choice = await showDialog<ReplacementChoice>(
        context: context,
        builder: (_) => ReplacementDialog(room: room),
      );
      if (choice == null || !mounted) return;
    }
    if (!mounted || _busy) return;
    await ref
        .read(nextGameControllerProvider(widget.roomId).notifier)
        .submit(
          expectedRevision: room.revision,
          replacementStarterId: choice?.starter,
          replacementPayerId: choice?.payer,
        );
  }

  Future<void> _edit(Room room, RoomActionKind kind) async {
    RoomAction? action;
    switch (kind) {
      case RoomActionKind.add:
        final name = await showDialog<String>(
          context: context,
          builder: (_) => AddPlayerDialog(room: room),
        );
        if (name != null && mounted) {
          action = RoomAction(
            kind,
            participantId: ref.read(idFactoryProvider)(),
            name: name,
          );
        }
      case RoomActionKind.rules:
        final points = await showDialog<Map<int, BallPointConfig>>(
          context: context,
          builder: (_) => RulesDialog(room: room),
        );
        if (points != null) action = RoomAction(kind, points: points);
      case RoomActionKind.order:
        final order = await showDialog<List<String>>(
          context: context,
          builder: (_) => OrderDialog(room: room),
        );
        if (order != null) action = RoomAction(kind, order: order);
      default:
        return;
    }
    if (mounted && !_busy && action != null) await _act(room, action);
  }

  @override
  Widget build(BuildContext context) {
    final action = ref.watch(roomActionControllerProvider(widget.roomId));
    final next = ref.watch(nextGameControllerProvider(widget.roomId));
    final busy = action.isLoading || next.isLoading;
    return AppScreen(
      appBar: AppBar(title: const Text('Trong phòng')),
      body: AsyncContent<Room>(
        value: ref.watch(roomByIdProvider(widget.roomId)),
        skipLoadingOnRefresh: false,
        errorBuilder: (context, error, _) => RoomLoadError(
          error: error,
          onRetry: () => ref.invalidate(roomByIdProvider(widget.roomId)),
        ),
        dataBuilder: (context, room) {
          if (room.games.isEmpty || room.currentGameId != room.games.last.id) {
            return const Center(child: Text('Dữ liệu phòng không hợp lệ.'));
          }
          _schedule(room);
          final game = room.games.last;
          final owner = '${game.id}:${game.currentPlayerId}';
          if (_draftOwner != owner) {
            _balls.clear();
            _foul = false;
            _draftOwner = owner;
          }
          final active = room.status == RoomStatus.active;
          final playing = active && game.status == GameStatus.inProgress;
          final foul = !_foul
              ? FoulClassification.none
              : _balls.isNotEmpty
              ? FoulClassification.potAndFoul
              : game.chainState.hasLegalPotInChain
              ? FoulClassification.th1
              : FoulClassification.th2;
          ScoreEngineResult? preview;
          Object? previewError;
          if (playing) {
            try {
              preview = const ScoreEngine().evaluate(
                game: game,
                rules: room.ruleVersions.singleWhere(
                  (r) => r.version == room.currentRuleVersion,
                ),
                scores: room.scores,
                input: TurnInput(
                  turnId: 'preview',
                  actorId: game.currentPlayerId,
                  balls: _balls.toList(),
                  foul: foul,
                ),
                occurredAt: ref.read(clockProvider)(),
              );
            } catch (error) {
              previewError = error;
            }
          }
          final last = game.turns.where((t) => !t.isUndone).lastOrNull;
          final canUndo =
              active &&
              last != null &&
              !room.events.any(
                (e) => e.isUndoBarrier && e.revision > last.revision,
              );
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (active &&
                  game.status == GameStatus.finished &&
                  room.pendingEndReasons.isEmpty)
                FilledButton(
                  key: const ValueKey('next-game'),
                  onPressed: busy ? null : () => _next(room),
                  child: Text(
                    next.isLoading ? 'Đang lưu…' : 'Bắt đầu ván tiếp',
                  ),
                ),
              if (busy) const LinearProgressIndicator(),
              if (active && (action.hasError || next.hasError)) ...[
                Text(roomFailureMessage((action.error ?? next.error)!)),
                TextButton(
                  key: const ValueKey('retry-action'),
                  onPressed: busy
                      ? null
                      : () async {
                          if (action.hasError) {
                            final controller = ref.read(
                              roomActionControllerProvider(widget.roomId)
                                  .notifier,
                            );
                            final clearsDraft =
                                controller.lastActionKind ==
                                RoomActionKind.record;
                            final result = await controller.retry();
                            if (result != null && mounted && clearsDraft) {
                              setState(() {
                                _balls.clear();
                                _foul = false;
                              });
                            }
                          } else {
                            await ref
                                .read(
                                  nextGameControllerProvider(widget.roomId)
                                      .notifier,
                                )
                                .retry();
                          }
                        },
                  child: const Text('Thử lưu lại'),
                ),
                TextButton(
                  key: const ValueKey('reload-room'),
                  onPressed: busy
                      ? null
                      : () {
                          _scheduledRevision = null;
                          ref.invalidate(roomByIdProvider(widget.roomId));
                        },
                  child: const Text('Tải lại phòng'),
                ),
              ],
              if (room.pendingEndReasons.isNotEmpty)
                const Text(
                  'Đã đạt điều kiện kết thúc — đánh hết ván rồi đóng phòng.',
                ),
              RoomDetails(room: room),
              if (playing) ...[
                const Divider(),
                Text(
                  game.chainState.isBreakChain
                      ? 'Chuỗi đề-pa: cả làng trả'
                      : 'Chuỗi thường',
                ),
                const Text('Chọn bi đã ăn (bi tắt điểm vẫn ghi nhận):'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final b in game.remainingBalls.toList()..sort())
                      FilterChip(
                        key: ValueKey('pot-ball-$b'),
                        label: Text('Bi $b'),
                        selected: _balls.contains(b),
                        onSelected: busy
                            ? null
                            : (selected) => setState(() {
                                if (selected) {
                                  _balls.add(b);
                                } else {
                                  _balls.remove(b);
                                }
                              }),
                      ),
                  ],
                ),
                SwitchListTile(
                  key: const ValueKey('turn-foul'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Có lỗi trong cú này'),
                  subtitle: Text('Phân loại: ${foul.name}'),
                  value: _foul,
                  onChanged: busy
                      ? null
                      : (value) => setState(() => _foul = value),
                ),
                if (previewError != null)
                  Text(roomFailureMessage(previewError)),
                TextButton(
                  key: const ValueKey('clear-turn-draft'),
                  onPressed: busy
                      ? null
                      : () => setState(() {
                          _balls.clear();
                          _foul = false;
                        }),
                  child: const Text('Xoá bản nháp'),
                ),
                if (preview != null) ...[
                  Text(
                    preview.transactions.isEmpty
                        ? 'Preview: không đổi điểm'
                        : 'Preview cộng/trừ:',
                    key: const ValueKey('score-preview'),
                  ),
                  for (final log in preview.logs)
                    Text(
                      '${playerName(room, log.participantId)}: ${log.newScore - log.previousScore >= 0 ? '+' : ''}${log.newScore - log.previousScore}',
                    ),
                  if (preview.balls.any((b) => b.isRespotted))
                    Text(
                      'Đặt lại: ${preview.balls.where((b) => b.isRespotted).map((b) => b.ballNumber).join(', ')}',
                    ),
                  Text(
                    'Sau cú: ${playerName(room, preview.game.currentPlayerId)} có cơ',
                  ),
                ],
                FilledButton(
                  key: const ValueKey('record-turn'),
                  onPressed: busy || preview == null
                      ? null
                      : () async {
                          final result = await _act(
                            room,
                            RoomAction(
                              RoomActionKind.record,
                              gameId: game.id,
                              actorId: game.currentPlayerId,
                              balls: _balls.toList(),
                              foul: foul,
                            ),
                          );
                          if (result != null && mounted) {
                            setState(() {
                              _balls.clear();
                              _foul = false;
                            });
                          }
                        },
                  child: Text(busy ? 'Đang lưu…' : 'Xác nhận cú đánh'),
                ),
              ],
              if (active) ...[
                OutlinedButton(
                  key: const ValueKey('undo-turn'),
                  onPressed: busy || !canUndo
                      ? null
                      : () async {
                          final reopen = game.status == GameStatus.finished;
                          if (reopen &&
                              !await _confirm(
                                'Mở lại ván?',
                                'Hoàn tác cú thắng bi 9 và phục hồi toàn bộ trạng thái trước cú.',
                              )) {
                            return;
                          }
                          if (mounted && !_busy) {
                            await _act(
                              room,
                              RoomAction(
                                RoomActionKind.undo,
                                gameId: game.id,
                                confirmed: reopen,
                              ),
                            );
                          }
                        },
                  child: const Text('Hoàn tác cú cuối'),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      key: const ValueKey('add-player'),
                      onPressed: busy || room.activePlayerIds.length >= 5
                          ? null
                          : () => _edit(room, RoomActionKind.add),
                      child: const Text('Thêm người'),
                    ),
                    TextButton(
                      key: const ValueKey('edit-rules'),
                      onPressed: busy
                          ? null
                          : () => _edit(room, RoomActionKind.rules),
                      child: const Text('Sửa luật'),
                    ),
                    TextButton(
                      key: const ValueKey('edit-order'),
                      onPressed: busy
                          ? null
                          : () => _edit(room, RoomActionKind.order),
                      child: const Text('Sửa thứ tự'),
                    ),
                  ],
                ),
                if (game.status == GameStatus.finished &&
                    room.activePlayerIds.length > 2)
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final id in room.activePlayerIds)
                        TextButton(
                          key: ValueKey('remove-player-$id'),
                          onPressed: busy
                              ? null
                              : () async {
                                  if (await _confirm(
                                        'Xoá ${playerName(room, id)} khỏi roster?',
                                        'Giữ điểm và lịch sử; chọn người thay nếu cần ở ván mới.',
                                      ) &&
                                      mounted &&
                                      !_busy) {
                                    await _act(
                                      room,
                                      RoomAction(
                                        RoomActionKind.remove,
                                        participantId: id,
                                      ),
                                    );
                                  }
                                },
                          child: Text('Xoá ${playerName(room, id)}'),
                        ),
                    ],
                  ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final cancel in [false, true])
                      OutlinedButton(
                        key: ValueKey(cancel ? 'cancel-room' : 'finish-room'),
                        onPressed: busy
                            ? null
                            : () async {
                                if (await _confirm(
                                      cancel ? 'Huỷ phòng?' : 'Kết thúc phòng?',
                                      'Giữ toàn bộ điểm/lịch sử. Phòng sẽ chỉ đọc, không thể undo.',
                                    ) &&
                                    mounted &&
                                    !_busy) {
                                  await _act(
                                    room,
                                    RoomAction(
                                      cancel
                                          ? RoomActionKind.cancel
                                          : RoomActionKind.finish,
                                      confirmed: true,
                                    ),
                                  );
                                }
                              },
                        child: Text(cancel ? 'Huỷ phòng' : 'Kết thúc phòng'),
                      ),
                  ],
                ),
              ],
              ExpansionTile(
                key: const ValueKey('room-history'),
                title: const Text('Nhật ký'),
                children: [
                  for (final history in room.games) ...[
                    Text('Ván ${history.gameNumber}'),
                    for (final turn in history.turns)
                      ListTile(
                        title: Text(
                          '#${turn.turnNumber} ${playerName(room, turn.actorId)} · ${turn.foulClassification.name}${turn.isUndone ? ' · Đã hoàn tác' : ''}',
                        ),
                        subtitle: Text(
                          'Bi: ${turn.pottedBalls.map((b) => '${b.ballNumber}${b.isRespotted ? ' (đặt lại)' : ''}').join(', ')}\n'
                          '${turn.transactions.map((t) => '${playerName(room, t.fromPlayerId)} → ${playerName(room, t.toPlayerId)}: ${t.amount}').join('; ')}',
                        ),
                      ),
                  ],
                  for (final event in room.events)
                    ListTile(
                      title: Text(
                        'Edit: ${event.type.name} · revision ${event.revision}',
                      ),
                      subtitle: const Text('Mốc chặn undo'),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
