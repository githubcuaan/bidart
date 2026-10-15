import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/validation/validation_issue.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:flutter/material.dart';

String roomStatusLabel(RoomStatus status) => switch (status) {
  RoomStatus.active => 'Đang chơi',
  RoomStatus.finished => 'Đã kết thúc',
  RoomStatus.cancelled => 'Đã hủy',
};

String gameStatusLabel(GameStatus status) => switch (status) {
  GameStatus.inProgress => 'Đang chơi',
  GameStatus.finished => 'Đã hoàn tất',
  GameStatus.incomplete => 'Chưa hoàn tất',
  GameStatus.cancelled => 'Đã hủy',
};

String validationMessage(ValidationCode code) => switch (code) {
  ValidationCode.rosterSize => 'Cần từ 2 đến 5 người chơi.',
  ValidationCode.emptyName => 'Nhập tên người chơi.',
  ValidationCode.duplicateName => 'Tên người chơi không được trùng nhau.',
  ValidationCode.starterNotInRoster => 'Chọn người đề-pa.',
  ValidationCode.payerNotInRoster => 'Chọn người trả đầu.',
  ValidationCode.starterEqualsPayer =>
    'Người đề-pa và người trả phải khác nhau.',
  ValidationCode.noEnabledBall => 'Bật tính điểm ít nhất một bi.',
  ValidationCode.invalidBallPoints => 'Điểm bi phải là số nguyên dương.',
  ValidationCode.invalidDisabledBallPoints => 'Bi tắt phải có điểm bằng 0.',
  ValidationCode.invalidDuration => 'Thời lượng phải là số nguyên dương.',
  ValidationCode.invalidScoreThreshold =>
    'Ngưỡng điểm phải là số nguyên dương.',
  ValidationCode.invalidOrder => 'Thứ tự phải chứa đủ người chơi, không trùng.',
  _ => 'Cấu hình phòng không hợp lệ (${code.name}).',
};

String roomFailureMessage(Object error) => switch (error) {
  RoomNotFoundFailure() => 'Không tìm thấy phòng.',
  ActiveRoomExistsFailure() => 'Đã có một phòng đang chơi.',
  StaleRevisionFailure() => 'Phòng đã thay đổi. Tải lại trước khi thử tiếp.',
  PersistenceFailure(:final message) when message.contains('hỏng') =>
    'Dữ liệu đã lưu bị hỏng. Không tạo trận mới thay thế; thử lại hoặc xóa dữ liệu hỏng.',
  PersistenceFailure() => 'Không thể đọc hoặc lưu phòng. Vui lòng thử lại.',
  ScoreEngineFailure(:final code) => switch (code) {
    ScoreEngineError.wrongActor => 'Người đánh đã thay đổi. Tải lại phòng.',
    ScoreEngineError.invalidBalls =>
      'Bi đã chọn không còn trên bàn hoặc bị trùng.',
    ScoreEngineError.invalidFoul => 'Loại lỗi không khớp trạng thái chuỗi.',
    _ => 'Trạng thái ván hoặc luật không hợp lệ.',
  },
  RepositoryValidationFailure(:final issues) when issues.isNotEmpty =>
    issues.map((issue) => validationMessage(issue.code)).toSet().join('\n'),
  RepositoryValidationFailure() => 'Phòng chưa đủ điều kiện cho thao tác này.',
  _ => 'Không thể đọc hoặc lưu phòng. Vui lòng thử lại.',
};

class RoomLoadError extends StatelessWidget {
  const RoomLoadError({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(roomFailureMessage(error), textAlign: TextAlign.center),
        TextButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}

/// Committed state only; draft/command controls live in InRoom.
class RoomDetails extends StatelessWidget {
  const RoomDetails({super.key, required this.room});
  final Room room;

  String _name(String id) =>
      room.participants
          .where((player) => player.id == id)
          .map((player) => player.displayName)
          .firstOrNull ??
      id;

  @override
  Widget build(BuildContext context) {
    final game = room.games
        .where((game) => game.id == room.currentGameId)
        .firstOrNull;
    final rules = room.ruleVersions
        .where((rule) => rule.version == room.currentRuleVersion)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(room.name, style: Theme.of(context).textTheme.headlineSmall),
        Text(roomStatusLabel(room.status)),
        if (room.status != RoomStatus.active)
          const Text('Phòng chỉ đọc — không thể thay đổi kết quả.'),
        const SizedBox(height: 16),
        const Text('Điểm cộng dồn'),
        for (final player in room.participants)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(player.displayName),
            subtitle: room.activePlayerIds.contains(player.id)
                ? null
                : const Text('Đã rời phòng'),
            trailing: Text(
              '${room.scores[player.id] ?? 0}',
              key: ValueKey('score-${player.id}'),
            ),
          ),
        Text('Thứ tự: ${room.playerOrder.map(_name).join(' → ')}'),
        Text('Số ván: ${room.games.length}'),
        if (game != null) ...[
          Text('Ván ${game.gameNumber} · ${gameStatusLabel(game.status)}'),
          Text('Người đánh: ${_name(game.currentPlayerId)}'),
          Text('Người trả: ${_name(game.payerId)}'),
          Text(
            'Bi còn lại: ${(game.remainingBalls.toList()..sort()).join(', ')}',
          ),
        ],
        if (rules != null) ...[
          const SizedBox(height: 16),
          Text('Luật phiên bản ${rules.version}'),
          Text(
            rules.ballPoints.entries
                .map(
                  (entry) =>
                      'Bi ${entry.key}: ${entry.value.enabled ? '${entry.value.points}đ' : 'tắt'}',
                )
                .join(' · '),
          ),
        ],
        if (room.endConditions.durationSeconds case final int seconds)
          Text('Thời lượng: $seconds giây'),
        if (room.endConditions.scoreThreshold case final int threshold)
          Text('Ngưỡng điểm: $threshold'),
        const SizedBox(height: 16),
        const Text(
          'Phòng tự lưu local; đóng/mở app vẫn giữ nguyên trạng thái.',
        ),
      ],
    );
  }
}
