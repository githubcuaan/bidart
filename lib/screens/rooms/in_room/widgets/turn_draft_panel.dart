import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/score_log.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/screens/rooms/in_room/widgets/ball_selection_chips.dart';
import 'package:bidart/screens/rooms/in_room/widgets/foul_toggle.dart';
import 'package:bidart/screens/rooms/in_room/widgets/turn_actions.dart';
import 'package:bidart/screens/rooms/in_room/widgets/turn_preview_panel.dart';
import 'package:flutter/material.dart';

/// Everything the shooter sees for the turn being drafted: chain label, ball
/// picker, foul switch, score preview and the confirm/clear buttons.
class TurnDraftPanel extends StatelessWidget {
  const TurnDraftPanel({
    super.key,
    required this.room,
    required this.remainingBalls,
    required this.selectedBalls,
    required this.foul,
    required this.foulLabel,
    required this.busy,
    required this.preview,
    required this.previewError,
    required this.onToggleBall,
    required this.onToggleFoul,
    required this.onClear,
    required this.onRecord,
  });

  final Room room;
  final List<int> remainingBalls;
  final Set<int> selectedBalls;
  final bool foul;
  final String foulLabel;
  final bool busy;
  final ScoreEngineResult? preview;
  final Object? previewError;
  final ValueChanged<int> onToggleBall;
  final ValueChanged<bool> onToggleFoul;
  final VoidCallback onClear;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(),
      ChainLabel(isBreakChain: preview?.game.chainState.isBreakChain ?? false),
      const Text('Chọn bi đã ăn (bi tắt điểm vẫn ghi nhận):'),
      BallSelectionChips(
        remainingBalls: remainingBalls,
        selected: selectedBalls,
        enabled: !busy,
        onToggle: onToggleBall,
      ),
      TurnFoulToggle(
        foul: foul,
        foulLabel: foulLabel,
        enabled: !busy,
        onChanged: onToggleFoul,
      ),
      if (previewError != null) Text(roomFailureMessage(previewError!)),
      if (preview != null)
        TurnPreviewPanel(
          logs: _previewLogs(room, preview!),
          respotted: [
            for (final ball in preview!.balls)
              if (ball.isRespotted) ball.ballNumber,
          ],
          nextPlayerName: playerName(room, preview!.game.currentPlayerId),
        ),
      TurnActions(
        clearEnabled: !busy,
        recordEnabled: preview != null,
        saving: busy,
        onClear: onClear,
        onRecord: onRecord,
      ),
    ],
  );

  List<String> _previewLogs(Room room, ScoreEngineResult result) => [
    for (final ScoreLog log in result.logs)
      '${playerName(room, log.participantId)}: '
          '${log.newScore - log.previousScore >= 0 ? '+' : ''}'
          '${log.newScore - log.previousScore}',
  ];
}
