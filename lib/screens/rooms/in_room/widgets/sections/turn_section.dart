import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/screens/rooms/in_room/widgets/turn_draft_panel.dart';
import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/material.dart';

/// Draft controls for the current shot: ball picker, foul, preview and confirm.
class TurnSection extends StatelessWidget {
  const TurnSection({
    super.key,
    required this.room,
    required this.remainingBalls,
    required this.selectedBalls,
    required this.autoBallPending,
    required this.saveFailed,
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
  final bool autoBallPending;
  final bool saveFailed;
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
  Widget build(BuildContext context) => SectionCard(
    icon: Icons.sports_esports_outlined,
    title: 'Ghi nhận lượt',
    description: 'Chạm bi để lưu; bật lỗi rồi xác nhận cú lỗi.',
    child: TurnDraftPanel(
      room: room,
      remainingBalls: remainingBalls,
      selectedBalls: selectedBalls,
      autoBallPending: autoBallPending,
      saveFailed: saveFailed,
      foul: foul,
      foulLabel: foulLabel,
      busy: busy,
      preview: preview,
      previewError: previewError,
      onToggleBall: onToggleBall,
      onToggleFoul: onToggleFoul,
      onClear: onClear,
      onRecord: onRecord,
    ),
  );
}
