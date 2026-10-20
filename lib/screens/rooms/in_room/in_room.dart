import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/foul_classification.dart';
import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/features/scoring/provider/next_game_controller.dart';
import 'package:bidart/features/scoring/provider/room_action_controller.dart';
import 'package:bidart/features/scoring/provider/room_providers.dart';
import 'package:bidart/screens/rooms/dialogs/add_player_dialog.dart';
import 'package:bidart/screens/rooms/dialogs/order_dialog.dart';
import 'package:bidart/screens/rooms/dialogs/replacement_dialog.dart';
import 'package:bidart/screens/rooms/dialogs/rules_dialog.dart';
import 'package:bidart/screens/rooms/in_room/room_end_timer.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_error_panel.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_history_panel.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_lifecycle_actions.dart';
import 'package:bidart/screens/rooms/in_room/widgets/room_management_actions.dart';
import 'package:bidart/screens/rooms/in_room/widgets/turn_draft_panel.dart';
import 'package:bidart/widgets/async/async_content.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:bidart/widgets/dialog/confirm_dialog.dart';
import 'package:bidart/widgets/room/room_details.dart';
import 'package:bidart/widgets/room/room_load_error.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'in_room_commands.dart';

/// Live room: records turns and exposes every room-level command.
/// The draft (`_balls`, `_foul`) belongs here; each visual block is a widget.
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
  late final RoomEndTimer _endTimer = RoomEndTimer(
    roomId: widget.roomId,
    readRoom: () => ref.read(roomByIdProvider(widget.roomId).future),
    now: () => ref.read(clockProvider)(),
    isBusy: () => _busy,
    onEvaluate: (room) => _act(room, RoomAction(RoomActionKind.evaluate)),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _endTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomId != widget.roomId) {
      _endTimer.cancel();
      _draftOwner = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _endTimer.checkNow();
  }

  bool get _busy =>
      ref.read(roomActionControllerProvider(widget.roomId)).isLoading ||
      ref.read(nextGameControllerProvider(widget.roomId)).isLoading;

  Future<Room?> _act(Room room, RoomAction action) => ref
      .read(roomActionControllerProvider(widget.roomId).notifier)
      .submit(action, expectedRevision: room.revision);

  void _clearDraft() => setState(() {
    _balls.clear();
    _foul = false;
  });

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
          if (_endTimer.schedule(room)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _endTimer.checkNow();
            });
          }
          final game = room.games.last;
          final active = room.status == RoomStatus.active;
          final playing = active && game.status == GameStatus.inProgress;
          final error = action.error ?? next.error;

          final owner = '${game.id}:${game.currentPlayerId}';
          if (_draftOwner != owner) {
            _balls.clear();
            _foul = false;
            _draftOwner = owner;
          }
          final foul = _foul
              ? _balls.isNotEmpty
                    ? FoulClassification.potAndFoul
                    : game.chainState.hasLegalPotInChain
                    ? FoulClassification.th1
                    : FoulClassification.th2
              : FoulClassification.none;
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
            } catch (failure) {
              previewError = failure;
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
                  room.pendingEndReasons.isEmpty) ...[
                SectionCard(
                  icon: Icons.skip_next,
                  title: 'Ván tiếp theo',
                  description: 'Ván ${game.gameNumber} đã kết thúc',
                  collapsible: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const ValueKey('next-game'),
                      onPressed: busy ? null : () => _next(room),
                      child: Text(
                        next.isLoading ? 'Đang lưu…' : 'Bắt đầu ván tiếp',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (busy) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 16),
              ],

              if (active && error != null) ...[
                SectionCard(
                  icon: Icons.error_outline,
                  title: 'Không thể lưu thay đổi',
                  collapsible: false,
                  child: RoomErrorPanel(
                    message: roomFailureMessage(error),
                    enabled: !busy,
                    fromNextGame: next.hasError,
                    onRetry: _retry,
                    onReload: () {
                      _endTimer.invalidateSchedule();
                      ref.invalidate(roomByIdProvider(room.id));
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (room.pendingEndReasons.isNotEmpty) ...[
                SectionCard(
                  icon: Icons.timer_outlined,
                  title: 'Điều kiện kết thúc',
                  collapsible: false,
                  child: const Text(
                    'Đã đạt điều kiện kết thúc — đánh hết ván rồi đóng phòng.',
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SectionCard(
                icon: Icons.meeting_room_outlined,
                title: 'Thông tin phòng',
                description: 'Điểm số, thứ tự và luật áp dụng.',
                child: RoomDetails(room: room),
              ),

              if (playing) ...[
                const SizedBox(height: 16),
                SectionCard(
                  icon: Icons.sports_esports_outlined,
                  title: 'Ghi nhận lượt',
                  description: 'Chọn bi đã ăn, thêm lỗi nếu có rồi xác nhận.',
                  child: TurnDraftPanel(
                    room: room,
                    remainingBalls: game.remainingBalls.toList()..sort(),
                    selectedBalls: _balls,
                    foul: _foul,
                    foulLabel: foul.name,
                    busy: busy,
                    preview: preview,
                    previewError: previewError,
                    onToggleBall: (ball) => setState(
                      () => _balls.contains(ball)
                          ? _balls.remove(ball)
                          : _balls.add(ball),
                    ),
                    onToggleFoul: (value) => setState(() => _foul = value),
                    onClear: _clearDraft,
                    onRecord: () async {
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
                      if (result != null && mounted) _clearDraft();
                    },
                  ),
                ),
              ],

              if (active) ...[
                const SizedBox(height: 16),
                SectionCard(
                  icon: Icons.tune_outlined,
                  title: 'Quản lý phòng',
                  description: 'Hoàn tác, người chơi, luật và thứ tự.',
                  child: RoomManagementActions(
                    room: room,
                    enabled: !busy,
                    canUndo: canUndo,
                    canAddPlayer: room.activePlayerIds.length < 5,
                    canRemovePlayers:
                        game.status == GameStatus.finished &&
                        room.activePlayerIds.length > 2,
                    onUndo: () => _undo(room),
                    onAddPlayer: () => _edit(room, RoomActionKind.add),
                    onEditRules: () => _edit(room, RoomActionKind.rules),
                    onEditOrder: () => _edit(room, RoomActionKind.order),
                    onRemovePlayer: (id) => _removePlayer(room, id),
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  icon: Icons.flag_outlined,
                  title: 'Kết thúc phòng',
                  description: 'Đóng phòng và chuyển sang chế độ chỉ đọc.',
                  child: RoomLifecycleActions(
                    enabled: !busy,
                    onFinish: () => _finish(room, cancel: false),
                    onCancel: () => _finish(room, cancel: true),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              SectionCard(
                icon: Icons.history,
                title: 'Nhật ký',
                description: 'Các cú đánh, sự kiện và mốc hoàn tác.',
                child: RoomHistoryPanel(room: room),
              ),
            ],
          );
        },
      ),
    );
  }
}
