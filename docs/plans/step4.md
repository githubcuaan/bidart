# Phase 4 — Persistence và phục hồi

Trạng thái: code + kiểm thử tự động xong. Chưa kiểm thử thủ công force-stop/relaunch
trên thiết bị (thuộc Phase 5).

Nguồn luật: [step1.md](step1.md) §2–6. Bàn giao RAM-only trước đó: [step3-handoff.md](step3-handoff.md).

## Triển khai

- `lib/data/local/app_database.dart`: Drift schema v1 — `rooms`, `command_receipts`,
  `rule_templates`. Aggregate Room lưu JSON đầy đủ (nhiều ván, lượt, rule versions,
  roster/events, transactions, undo barriers). Cột rời hỗ trợ sort/filter/revision guard.
- `lib/data/repositories/game_repository.dart`: `DriftGameRepository` (GameRepository +
  RuleTemplateRepository). Room + receipt commit cùng transaction; retry cùng command ID
  trả receipt gốc trước mọi kiểm tra revision; hỏng JSON -> `PersistenceFailure`
  tiếng Việt, UI hiện lỗi thay vì tạo trận mới âm thầm.
- `lib/domain/repositories/rule_template_repository.dart`: contract + validation dùng
  chung cho RAM và Drift. Mẫu lưu độc lập, apply là copy, không mutate phòng cũ.
- `lib/data/repositories/in_memory_game_repository.dart`: thêm templates để parity test.
- `lib/features/scoring/provider/room_providers.dart`: `appDatabaseProvider`,
  `ruleTemplateRepositoryProvider`, `ruleTemplateListProvider/ById`.
- `lib/features/scoring/provider/rule_template_controller.dart`: lưu mẫu từ UI.
- `lib/main.dart`: khởi tạo `AppDatabase` file-backed, override `gameRepositoryProvider`
  bằng Drift. Tests override bằng InMemory hoặc `AppDatabase.memory()`.
- UI: `rooms.dart`, `room_presentation.dart`, `add_room.dart` đổi chữ RAM-only sang
  tự lưu local; `roomFailureMessage` thêm nhánh dữ liệu hỏng; `AddRoom` có lưu mẫu
  luật + chip áp dụng mẫu cho phòng mới.
- `pubspec.yaml`: thêm `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`,
  `drift_dev`; hooks `sqlite3.source: system` để test offline dùng lib hệ thống.

## Kiểm thử tự động

- `flutter analyze`: sạch.
- `flutter test`: 186 pass (178 cũ + 8 mới).
- Mới: `test/data/repositories/drift_game_repository_test.dart` (7 tests: sort/filter,
  restart cùng DB giữ rooms/receipts, fail-then-retry, hỏng -> lỗi rõ, guards,
  templates độc lập + parity InMemory).
- Mới: `test/domain/services/drift_persistence_regression_test.dart` (1 test: tạo phòng
  -> ăn break cả làng -> miss -> TH2 swap -> reorder barrier -> restart -> JSON khớp,
  zero-sum, receipt cũ idempotent, undo không vượt barrier).

```sh
flutter analyze
flutter test
flutter test test/data/repositories/drift_game_repository_test.dart test/domain/services/drift_persistence_regression_test.dart
```

## Giới hạn / việc còn lại (Phase 5)

- Chưa chạy manual trên thiết bị/emulator: tạo -> ghi lượt -> TH2 -> undo ->
  force-stop/relaunch -> restore -> kết thúc -> xem lại.
- Chưa migration v1->v2 (mới chỉ v1 `onCreate`); khi đổi schema phải thêm migration test.
- Không log/telemetry cho lỗi hỏng; chưa UI xóa dữ liệu hỏng.
