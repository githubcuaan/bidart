import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/core/labels/room_labels.dart';
import 'package:bidart/screens/rooms/in_room/widgets/ball_selection_grid.dart';
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
      SizedBox(height: 4),
      BallSelectionGrid(
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
          deltas: _previewDeltas(room, preview!),
          respotted: [
            for (final ball in preview!.balls)
              if (ball.isRespotted) ball.ballNumber,
          ],
          nextPlayerName: playerName(room, preview!.game.currentPlayerId),
        ),
      SizedBox(height: 4),
      TurnActions(
        clearEnabled: !busy,
        recordEnabled: preview != null,
        saving: busy,
        onClear: onClear,
        onRecord: onRecord,
      ),
    ],
  );

  List<TurnPreviewDelta> _previewDeltas(Room room, ScoreEngineResult result) {
    final actorId = result.game.previousPlayerId;
    final potted = result.balls.map((ball) => ball.ballNumber).join(', ');
    return [
      for (final log in result.logs)
        TurnPreviewDelta(
          name: playerName(room, log.participantId),
          action: _previewAction(
            isActor: log.participantId == actorId,
            gainsPoints: log.newScore >= log.previousScore,
            pottedBalls: potted,
          ),
          points: log.newScore - log.previousScore,
        ),
    ];
  }

  String _previewAction({
    required bool isActor,
    required bool gainsPoints,
    required String pottedBalls,
  }) {
    if (gainsPoints) {
      return isActor ? 'ăn Bi $pottedBalls:' : 'nhận đền:';
    }
    return isActor ? 'chịu phạt:' : 'chịu đền:';
  }
}
