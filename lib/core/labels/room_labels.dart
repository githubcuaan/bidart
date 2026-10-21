import 'package:bidart/domain/models/scoring/game_status.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/services/score_engine.dart';
import 'package:bidart/domain/validation/validation_issue.dart';

/// Display labels shared by every room screen; no Flutter imports here.
String playerName(Room room, String id) =>
    room.participants
        .where((p) => p.id == id)
        .map((p) => p.displayName)
        .firstOrNull ??
    id;

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

String historyGameStatusLabel(GameStatus status) => switch (status) {
  GameStatus.inProgress => 'Đang chơi',
  GameStatus.finished => 'Đã xong',
  GameStatus.incomplete => 'Chưa xong',
  GameStatus.cancelled => 'Đã huỷ',
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
  ValidationCode.invalidOpeningOrder =>
    'Người đề-pa phải đứng đầu, người đền đầu đứng thứ hai.',
  _ => 'Cấu hình phòng không hợp lệ (${code.name}).',
};

String roomFailureMessage(Object error) => switch (error) {
  RoomNotFoundFailure() => 'Không tìm thấy phòng.',
  ActiveRoomExistsFailure() => 'Đã có một phòng đang chơi.',
  StaleRevisionFailure() => 'Phòng đã thay đổi. Tải lại trước khi thử tiếp.',
  PersistenceFailure(:final message) when message.contains('hỏng') => 'Dữ liệu đã lưu bị hỏng. Không tạo trận mới thay thế; thử lại hoặc xóa dữ liệu hỏng.',
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
