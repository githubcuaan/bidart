part of 'in_room.dart';

/// Room-level commands that open dialogs or confirm destructive actions.
/// Split out so [InRoom] only wires providers to widgets.
extension _InRoomCommands on _InRoomState {
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

  Future<void> _undo(Room room) async {
    final game = room.games.last;
    final reopen = game.status == GameStatus.finished;
    if (reopen &&
        !await confirmAction(
          context,
          title: 'Mở lại ván?',
          message:
              'Hoàn tác cú thắng bi 9 và phục hồi toàn bộ trạng thái trước cú.',
        )) {
      return;
    }
    if (mounted && !_busy) {
      await _act(
        room,
        RoomAction(RoomActionKind.undo, gameId: game.id, confirmed: reopen),
      );
    }
  }

  Future<void> _removePlayer(Room room, String id) async {
    final ok = await confirmAction(
      context,
      title: 'Xoá ${playerName(room, id)} khỏi roster?',
      message: 'Giữ điểm và lịch sử; chọn người thay nếu cần ở ván mới.',
    );
    if (ok && mounted && !_busy) {
      await _act(room, RoomAction(RoomActionKind.remove, participantId: id));
    }
  }

  Future<void> _finish(Room room, {required bool cancel}) async {
    final ok = await confirmAction(
      context,
      title: cancel ? 'Huỷ phòng?' : 'Kết thúc phòng?',
      message: 'Giữ toàn bộ điểm/lịch sử. Phòng sẽ chỉ đọc, không thể undo.',
    );
    if (ok && mounted && !_busy) {
      await _act(
        room,
        RoomAction(
          cancel ? RoomActionKind.cancel : RoomActionKind.finish,
          confirmed: true,
        ),
      );
    }
  }

  void _retry({required bool fromNextGame}) {
    if (fromNextGame) {
      ref.read(nextGameControllerProvider(widget.roomId).notifier).retry();
      return;
    }
    final controller = ref.read(
      roomActionControllerProvider(widget.roomId).notifier,
    );
    final clearsDraft = controller.lastActionKind == RoomActionKind.record;
    controller.retry().then((result) {
      if (result != null && mounted && clearsDraft) _clearDraft();
    });
  }
}
