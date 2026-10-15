# Phase 3 — Engine và thao tác trong phòng

Trạng thái: đang triển khai. Branch: `sol/phase3`, stacked trên `step2`.

Nguồn luật: [step1.md](step1.md) và [../rule.md](../rule.md).
Storage vẫn RAM-only; Drift/khôi phục sau restart thuộc Phase 4.

## Quyết định bổ sung

- Nếu winner hoặc final payer đã rời roster giữa hai ván, người dùng chọn người thay thế trước khi bắt đầu ván mới; không tự suy đoán.
- Người thay thế thuộc roster hoạt động; starter và payer khác nhau. Thiếu lựa chọn hợp lệ thì từ chối bắt đầu ván.
- Lựa chọn chỉ áp dụng setup ván mới, không sửa winner/payer, ledger hay lịch sử ván cũ.
- Commands edit và undo barrier triển khai trên RAM trong Phase 3; lưu bền thuộc Phase 4.

## Checkpoints

### CP0 — Contract và baseline
- [x] Xác nhận baseline ngày 2026-10-15: `flutter analyze` không lỗi; `flutter test` pass 94 tests.
- [x] Branch riêng phụ thuộc Phase 2; không rewrite branch Phase 2.
- [x] Ghi chính sách thay thế winner/payer và ranh giới persistence.

### CP1 — Pure score engine
- [x] Input/result immutable; validate actor, game, rules, payer, balls.
- [x] Transactions amount > 0, tổng điểm luôn 0; bi tắt vẫn được ghi nhận.
- [x] Giữ/chuyển cơ, TH1/TH2, đề-pa/cả làng, ăn sớm/đặt lại, thắng bi 9.
- [x] Unit tests cho các nhánh engine trong step1 §6; lỗi không mutate input.

CP1 API: `ScoreEngine.evaluate(game, rules, scores, input, occurredAt)` dùng named arguments;
`TurnInput` chứa turn ID, actor, ball numbers, foul classification. Result chứa candidate
game/scores, ball outcomes, payer IDs, transactions và score logs. Engine từ chối foul
classification không khớp chain/input; tự tính respot từ prefix bi còn lại được ăn.
Không append Turn hoặc ghi storage: room status/revision, snapshots, history, undo và
end conditions thuộc command layer CP2. Caller phải kiểm tra room ACTIVE trước khi gọi.

Kiểm tra CP1 ngày 2026-10-15: `flutter analyze` sạch; toàn bộ 117 tests pass.
23 engine tests gồm 8.192 tổ hợp pot subset/foul/break-chain/roster 2–5 người.
Chạy riêng: `flutter test test/domain/services/score_engine_test.dart`.

### CP2 — Commands, undo và lifecycle
- [x] recordTurn, undoLastTurn, finishRoom, cancelRoom, evaluateEndConditions.
- [x] Idempotency, expected revision, atomic commit và failure/retry tests.
- [x] Undo khôi phục snapshots, giữ lịch sử undone, chặn qua edit/ván mới/phòng đóng.
- [x] Pending-end theo lịch sử hiệu lực và clock; không cắt điểm.
- [x] Edit roster/rules/order, barriers; setup thay thế thủ công khi cần.

CP2 API: import `lib/domain/services/room_commands.dart` để dùng extension
`RoomCommands` trên `RoomService`. Mọi command nhận `commandId`, `roomId`,
`expectedRevision`, trả committed `Room` hoặc lỗi; cùng command ID retry trả
receipt gốc trước kiểm tra revision. Input thay đổi phải dùng command ID mới.

- `recordTurn`: thêm `gameId`, `TurnInput`; snapshot/history/score cùng một write.
- `undoLastTurn`: thêm `gameId`, `confirmReopen` khi undo cú thắng; chỉ lượt hiệu lực cuối.
- `finishRoom` / `cancelRoom`: thêm `confirmed`; phòng đóng read-only, không xoá ledger.
- `evaluateEndConditions`: command riêng cho load/resume/timer; mỗi lần đánh giá mới
  dùng ID mới. Closed room bị từ chối; UI phải kiểm tra trạng thái trước khi gọi.
- `addPlayer`: `participantId`, `name`; `removePlayer`: `participantId`.
- `updateRules`: `ballPoints`; `reorderPlayers`: `playerOrder`.
- `RoomService.startNextGame`: thêm optional `replacementStarterId`,
  `replacementPayerId`; bắt buộc khi vai trò tương ứng đã rời roster, không được
  override vai trò còn hiện diện. Chỉ áp dụng setup mới; không sửa outcome cũ.

`Room.events` và `Turn.revision` lưu edit barriers theo revision, không dựa vào
timestamp (nhiều command có thể cùng thời điểm). Rule events giữ rules trước/sau;
JSON cũ thiếu events/revision đọc được với mặc định rỗng/0. Rules/roster/order edit
trong ván cập nhật gameplay, edit giữa ván chỉ cập nhật room setup, giữ nguyên ván cũ.
Vòng ván mới dùng room order hiện tại: thường winner/starter đầu, payer sau,
còn lại theo vòng; chấm phá giữ vòng tương đối và bắt đầu từ starter đã chọn.

Kiểm tra CP2 ngày 2026-10-15: `flutter analyze` sạch; toàn bộ 146 tests pass.
29 tests mới kiểm tra commands/lifecycle, concurrency, atomic failure/retry,
undo barriers, ngưỡng/clock, edits và lựa chọn thay thế thủ công.
Chạy riêng: `flutter test test/domain/services/room_commands_test.dart test/domain/services/next_game_test.dart`.
Tại CP2 controllers/UI chưa nối commands mới; phần này được bổ sung trong CP3 bên dưới. Vẫn RAM-only.

### CP3 — Controllers và UI
- [x] Shared per-room queue; publish sau commit; refresh room/list reads.
- [x] Scoreboard/current player/balls, draft, preview, lỗi, xác nhận.
- [x] Undo có xác nhận khi mở lại ván; nhật ký; next game; finish/cancel.
- [x] Khoá submit đang xử lý; lỗi lưu giữ draft; closed room read-only.
- [x] Widget/controller tests và layout màn hình hẹp.

CP3 API: `roomActionControllerProvider(roomId).notifier.submit(RoomAction(...),
expectedRevision: revision)` trả committed room hoặc null, lỗi nằm trong AsyncValue.
`RoomActionKind` gồm record/undo/finish/cancel/evaluate/add/remove/rules/order.
Controller capture collections, dùng signature + revision để giữ command ID khi retry
input không đổi; `.retry()` giữ cả payload và participant ID của edit đã thất bại.
Double submit chia sẻ Future; tất cả đi qua `roomCommandQueueProvider`.
`nextGameControllerProvider` nhận thêm replacementStarterId/replacementPayerId và `.retry()`.

`InRoom` có scoreboard, draft chọn bi (gồm bi tắt điểm), toggle lỗi tự phân loại theo chain,
preview từ engine, xác nhận, xoá draft, undo, lịch sử bi/transactions/undone/events,
edit dialogs, xoá người giữa hai ván, replacement dialog, finish/cancel có xác nhận.
Chọn bi không ghi dữ liệu; lỗi lưu giữ draft; chỉ clear sau commit thành công.
Controls khoá khi action hoặc next-game đang lưu. Lỗi có retry payload cũ hoặc reload;
draft không còn hợp lệ sau reload có thể xoá để nhập lại. Closed room không có controls ghi.

Load/resume/timer so sánh `evaluateRoomEnd` với committed state; chỉ gửi command nếu
có thay đổi. Timer huỷ khi rời màn hình/đổi phòng, đợi thao tác đang lưu trước khi đánh giá.
Command tự kiểm tra end conditions nên không phụ thuộc UI timer để chặn ván mới.

Kiểm tra CP3 ngày 2026-10-15: `flutter analyze` sạch; toàn bộ 172 tests pass.
8 controller tests và 18 widget tests mới: draft/preview/atomic saves/retry, queue,
TH2/undo, disabled balls, edits, replacements retry, read-only, timer/resume,
rời màn khi đang lưu và layout 320px. Chưa khẳng định đã thử thiết bị/emulator thủ công.
Chạy riêng:
`flutter test test/features/scoring/provider/room_action_controller_test.dart test/screens/rooms/in_room_actions_test.dart`.

### CP4 — Regression và bàn giao
- [ ] `flutter analyze`, `flutter test` đều sạch.
- [ ] Cập nhật project/entity checklist chỉ cho tính năng đã test.
- [ ] Handoff API, lệnh kiểm tra và giới hạn RAM-only.
- [ ] Kiểm tra thủ công trên thiết bị/emulator nếu môi trường cho phép; nếu chưa làm phải ghi rõ.

Mỗi checkpoint triển khai có commit riêng kèm tests; không push hoặc tạo PR khi chưa được yêu cầu.
