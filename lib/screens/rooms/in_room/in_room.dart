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
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/end_conditions_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/next_game_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/room_error_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/room_history_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/room_info_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/room_lifecycle_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/room_management_section.dart';
import 'package:bidart/screens/rooms/in_room/widgets/sections/turn_section.dart';
import 'package:bidart/widgets/async/async_content.dart';
import 'package:bidart/widgets/dialog/confirm_dialog.dart';
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
  bool _autoBallPending = false;
  bool _menuOpen = false;
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
    _autoBallPending = false;
  });

  Future<void> _potBall(Room room, int ball) async {
    if (_busy || _autoBallPending) return;
    if (_foul) {
      setState(() => _balls.add(ball));
      return;
    }
    setState(() {
      _balls.add(ball);
      _autoBallPending = true;
    });
    final result = await _act(
      room,
      RoomAction(
        RoomActionKind.record,
        gameId: room.games.last.id,
        actorId: room.games.last.currentPlayerId,
        balls: [ball],
      ),
    );
    if (result != null && mounted) _clearDraft();
  }

  void _showSection(_RoomSection section) {
    setState(() => _menuOpen = false);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) {
          final room = ref.watch(roomByIdProvider(widget.roomId)).asData?.value;
          if (room == null) return const SizedBox.shrink();
          final busy =
              ref
                  .watch(roomActionControllerProvider(widget.roomId))
                  .isLoading ||
              ref.watch(nextGameControllerProvider(widget.roomId)).isLoading;
          final game = room.games.last;
          void closeThen(VoidCallback action) {
            Navigator.of(dialogContext).pop();
            action();
          }

          final content = switch (section) {
            _RoomSection.info => RoomInfoSection(
              room: room,
              now: () => ref.read(clockProvider)(),
            ),
            _RoomSection.management => RoomManagementSection(
              room: room,
              enabled: !busy,
              canAddPlayer: room.activePlayerIds.length < 5,
              canRemovePlayers:
                  game.status == GameStatus.finished &&
                  room.activePlayerIds.length > 2,
              onAddPlayer: () =>
                  closeThen(() => _edit(room, RoomActionKind.add)),
              onEditRules: () =>
                  closeThen(() => _edit(room, RoomActionKind.rules)),
              onEditOrder: () =>
                  closeThen(() => _edit(room, RoomActionKind.order)),
              onRemovePlayer: (id) => closeThen(() => _removePlayer(room, id)),
            ),
            _RoomSection.lifecycle => RoomLifecycleSection(
              enabled: !busy,
              onFinish: () => closeThen(() => _finish(room, cancel: false)),
              onCancel: () => closeThen(() => _finish(room, cancel: true)),
            ),
            _RoomSection.history => RoomHistorySection(room: room),
          };
          return Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip: 'Đóng',
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    Flexible(child: SingleChildScrollView(child: content)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionMenu(bool active) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (_menuOpen) ...[
        for (final section in _RoomSection.values)
          if (active ||
              section != _RoomSection.management &&
                  section != _RoomSection.lifecycle)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ActionChip(
                key: ValueKey('room-menu-${section.name}'),
                avatar: Icon(section.icon, size: 20),
                label: Text(section.label),
                onPressed: () => _showSection(section),
              ),
            ),
      ],
      FloatingActionButton(
        key: const ValueKey('room-sections'),
        tooltip: _menuOpen ? 'Đóng menu phòng' : 'Mở menu phòng',
        onPressed: () => setState(() => _menuOpen = !_menuOpen),
        child: Icon(_menuOpen ? Icons.close : Icons.apps),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final action = ref.watch(roomActionControllerProvider(widget.roomId));
    final next = ref.watch(nextGameControllerProvider(widget.roomId));
    final roomState = ref.watch(roomByIdProvider(widget.roomId));
    final busy = action.isLoading || next.isLoading;

    return AppScreen(
      appBar: AppBar(
        title: Text(
          roomState.maybeWhen(
            data: (room) => room.name,
            orElse: () => 'Trong phòng',
            skipLoadingOnRefresh: true,
          ),
        ),
      ),
      floatingActionButton: roomState.maybeWhen(
        data: (room) => room.games.isEmpty
            ? null
            : _sectionMenu(room.status == RoomStatus.active),
        orElse: () => null,
        skipLoadingOnRefresh: true,
      ),
      body: AsyncContent<Room>(
        value: roomState,
        // Keep the live board mounted while a command refreshes the room, so
        // turn cards can animate instead of being rebuilt from scratch.
        skipLoadingOnRefresh: true,
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
          final last = game.turns.where((t) => !t.isUndone).lastOrNull;
          final canUndo =
              last != null &&
              !room.events.any(
                (e) => e.isUndoBarrier && e.revision > last.revision,
              );
          final error = action.error ?? next.error;

          final owner = '${game.id}:${game.currentPlayerId}';
          if (_draftOwner != owner) {
            _balls.clear();
            _foul = false;
            _autoBallPending = false;
            _draftOwner = owner;
          }
          final foul = _foul
              ? _balls.isNotEmpty && !game.chainState.hasLegalPotInChain
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
          return Column(
            children: [
              SizedBox(
                height: busy ? 4 : 0,
                child: busy ? const LinearProgressIndicator() : null,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (active &&
                        game.status == GameStatus.finished &&
                        room.pendingEndReasons.isEmpty) ...[
                      NextGameSection(
                        gameNumber: game.gameNumber,
                        loading: next.isLoading,
                        onStart: busy ? null : () => _next(room),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (active && error != null) ...[
                      RoomErrorSection(
                        message: roomFailureMessage(error),
                        enabled: !busy,
                        fromNextGame: next.hasError,
                        onRetry: _retry,
                        onReload: () {
                          ref
                              .read(
                                roomActionControllerProvider(room.id).notifier,
                              )
                              .discardFailure();
                          _clearDraft();
                          _endTimer.invalidateSchedule();
                          ref.invalidate(roomByIdProvider(room.id));
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (room.pendingEndReasons.isNotEmpty) ...[
                      const EndConditionsSection(),
                      const SizedBox(height: 16),
                    ],

                    TurnScoresSection(
                      room: room,
                      draftScores:
                          playing &&
                              (_foul || _autoBallPending && action.isLoading)
                          ? preview?.scores
                          : null,
                    ),

                    if (active && !playing) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          key: const ValueKey('undo-turn'),
                          onPressed:
                              canUndo &&
                                  !busy &&
                                  !_autoBallPending &&
                                  !(_foul && _balls.isNotEmpty)
                              ? () => _undo(room)
                              : null,
                          icon: const Icon(Icons.undo),
                          label: const Text('Hoàn tác cú cuối'),
                        ),
                      ),
                    ],

                    if (playing) ...[
                      const SizedBox(height: 16),
                      TurnSection(
                        room: room,
                        remainingBalls: game.remainingBalls.toList()..sort(),
                        selectedBalls: _balls,
                        autoBallPending: _autoBallPending,
                        saveFailed: action.hasError,
                        foul: _foul,
                        foulLabel: foul.name,
                        busy: busy || _autoBallPending,
                        preview: preview,
                        previewError: previewError,
                        onToggleBall: (ball) => _potBall(room, ball),
                        onToggleFoul: (value) => setState(() {
                          _foul = value;
                          if (!value) _balls.clear();
                        }),
                        onClear: _clearDraft,
                        onRecord: () async {
                          if (_busy || _autoBallPending) return;
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
                        undoEnabled:
                            canUndo &&
                            !busy &&
                            !_autoBallPending &&
                            !(_foul && _balls.isNotEmpty),
                        onUndo: () => _undo(room),
                      ),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _RoomSection {
  info(Icons.info_outline, 'Thông tin phòng'),
  management(Icons.tune_outlined, 'Quản lý phòng'),
  lifecycle(Icons.flag_outlined, 'Kết thúc phòng'),
  history(Icons.history, 'Nhật ký');

  const _RoomSection(this.icon, this.label);
  final IconData icon;
  final String label;
}
