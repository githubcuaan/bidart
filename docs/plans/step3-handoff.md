# Phase 3 handoff — scoring RAM-only

## Phạm vi bàn giao

Phase 3 hoàn tất trong phạm vi RAM-only: engine, commands, undo/edit barriers và UI
đã triển khai, kiểm thử tự động và được người dùng xác nhận manual smoke PASS trên emulator.
Không có Drift/SQLite, migrations, lưu mẫu luật hoặc khôi phục sau restart.
Đổi màn hình/tạo lại service với cùng repository giữ dữ liệu; tắt process mất dữ liệu.
Không gọi JSON round-trip hoặc đọc lại repository RAM là kiểm thử persistence.

Luật chuẩn: [step1.md](step1.md) §2–6 và [../rule.md](../rule.md).
Chi tiết từng checkpoint/API: [step3.md](step3.md).

## API / ownership

| Layer | Entry points | Trách nhiệm |
| --- | --- | --- |
| Pure engine | `ScoreEngine.evaluate`, `TurnInput`, `ScoreEngineResult` | Candidate game/scores, ball outcomes, transactions/logs; không lưu |
| Room service | `createRoom`, `getRoom`, `listRooms`, `startNextGame` | Committed aggregates; setup nhiều ván, điểm cộng dồn |
| Commands | Import `room_commands.dart`, extension `RoomCommands` | record/undo/finish/cancel/evaluate/add/remove/rules/order |
| End policy | `evaluateRoomEnd(room, now)` | Pure; tính pending từ clock và history hiệu lực, đóng khi hết ván |
| Repository | `GameRepository`, `InMemoryGameRepository` | Aggregate + command receipt atomic, revision guard, retry không trùng |
| Riverpod | `roomActionControllerProvider`, `nextGameControllerProvider` | Queue theo phòng, khoá submit, giữ command ID khi retry input cũ, invalidate reads sau commit |
| UI | `InRoom(roomId)`, edit/replacement dialogs | Draft/preview, confirm, undo/history, edits, read-only; evaluate khi load/resume/timer |

Commands nhận command ID và expected revision. `recordTurn` còn nhận game ID và TurnInput;
undo nhận game ID, `confirmReopen` nếu mở lại ván. Finish/cancel cần confirmed.
Retry cùng ID trả receipt gốc, không phải room revision mới nhất. Thay input/revision dùng ID mới;
reload qua room provider để đọc state hiện tại. Không ghi trực tiếp scores từ UI.

Winner/final payer rời roster: trước ván mới phải chọn replacement thuộc roster, hai vai trò
khác nhau; không tự đoán, không sửa outcome/ledger cũ. Edit chỉ tác động lượt/setup tiếp theo,
ghi RoomEvent và chặn undo bằng revision (không dùng timestamp).

## Test map và regression

| Phạm vi | Test file trong `test/` |
| --- | --- |
| Models, serialization, immutable snapshots | `domain/models/scoring/` |
| Roster/rules/limits validation | `domain/validation/validators_test.dart` |
| Atomicity, receipts, retries, detached data | `data/repositories/in_memory_game_repository_test.dart` |
| Create/read/next game | `domain/services/room_service_test.dart`, `next_game_test.dart` |
| TH1/TH2, pot+foul, break chain, respot, disabled 9/win | `domain/services/score_engine_test.dart` |
| Undo/edit barriers, pending threshold/clock, replacements | `domain/services/room_commands_test.dart` |
| Draft locking, command IDs, shared queue, retry | `features/scoring/provider/room_controllers_test.dart`, `room_action_controller_test.dart` |
| Form/navigation/loading/errors/read-only | `screens/rooms/room_flow_test.dart` |
| Confirm/undo/edit/replacements, timer/resume, narrow layout | `screens/rooms/in_room_actions_test.dart` |
| Nhiều ván và history reconstruction độc lập | `domain/services/scoring_regression_test.dart` |

Regression mới gồm 6 tests: luồng ba ván (TH1 → TH2 → undo → normal next game →
chấm phá → đóng/xem lại); tái tạo service trên cùng RAM repository và retry receipt cũ sau undo;
4 chuỗi seed cố định, mỗi chuỗi 100 bước cho roster 2–5 người. Sau mỗi bước, tái dựng
ledger từ transactions hiệu lực và bàn bi từ outcomes; đối chiếu logs, zero-sum và JSON round-trip.
Đây không phải tests restart app. 8.192 tổ hợp engine từ CP1 vẫn được giữ nguyên.

Lệnh tại project root:

Kết quả CP4: `flutter analyze` không lỗi, `flutter test` pass **178 tests**;
6 regression tests mới pass. Không đổi production code/dependencies trong CP4.

```sh
flutter analyze
flutter test
flutter test test/domain/services/scoring_regression_test.dart
```

## Kiểm tra thủ công — PASS theo xác nhận người dùng

Người thực hiện: người dùng. Môi trường: emulator. Kết quả báo cáo: mọi thứ PASS,
không báo lỗi trong manual smoke Phase 3. Agent ghi nhận kết quả này, không tự thao tác
emulator hoặc tuyên bố đã kiểm thử thay người dùng. Model emulator, OS/API, build và
ảnh/video kiểm thử chưa được cung cấp; không tự điền các thông tin này.

Phạm vi smoke checklist đã bàn giao để kiểm tra:

1. Tạo 3–5 guest, reorder, setup starter/payer; vào phòng, kiểm tra điểm 0 và bi 1–9.
2. Chọn bi: chỉ preview, chưa đổi scoreboard; xác nhận đúng một lượt; không chọn bi và
   xác nhận: chuyển cơ, không đổi điểm. Bi tắt điểm vẫn ghi outcome và giữ cơ nếu hợp lệ.
3. TH2 swap order thật và payer đánh tiếp; undo khôi phục order/current/payer/điểm/bi.
4. Ăn sớm 9 phải đặt lại; ăn toàn bộ bi còn lại hợp lệ thắng; undo cú thắng hỏi xác nhận.
5. Edit luật/order/thêm người: chỉ tác động lượt mới, undo không vượt edit barrier.
6. Giữa ván xoá winner/payer, chọn replacements thủ công, bắt đầu ván mới, giữ điểm/lịch sử.
7. Hết thời gian khi background/resume hoặc chạm ngưỡng: đánh nốt ván, ghi đầy đủ điểm rồi đóng.
8. Finish/cancel hỏi xác nhận; xem lại lịch sử, không còn controls ghi. Back/tab không đóng phòng.

**Sau Phase 4:** mới kiểm tra force-stop/relaunch, restore room/undo barriers/receipts,
migration, dữ liệu hỏng và templates. Hiện thao tác restart sẽ mất phòng — giới hạn đã biết,
không phải acceptance pass. Manual smoke Phase 3 đã được xác nhận PASS; durable recovery
và các tiêu chí persistence vẫn là release gates mở cho Phase 4/5.

## Trạng thái review

CP4 cập nhật tests/checklists/handoff; người dùng đã xác nhận manual smoke PASS và yêu cầu commit phần còn lại Phase 3.
Không push hoặc tạo PR. Phase 4/5 không được đánh dấu hoàn thành bởi bàn giao này.
