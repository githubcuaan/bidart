# Phase 5 — Kiểm thử và bàn giao

Ngày kiểm chứng tự động: 2026-10-15. Automated PASS; người dùng xác nhận
manual Web toàn bộ chuỗi kiểm thử bên dưới PASS. Android/iOS chưa kiểm chứng.

## Xác nhận Web sau sửa kết nối database

- Người dùng xác nhận mở Web thủ công PASS; reload vẫn giữ dữ liệu.
- `flutter analyze` sạch; `flutter build web` thành công sau tách kết nối native/Web.
- Người dùng xác nhận toàn bộ 5 nhóm manual Web PASS: điểm/chuyển cơ;
  TH2 swap; undo; reload sau undo; kết thúc/xem lại/read-only.
- Kịch bản: A/B/C, starter A, payer B, mỗi bi 10 điểm, không giới hạn;
  A ăn bi 1 → A +20/B −10/C −10 → miss → B lỗi TH2 → swap B/A/C
  → undo về A/B/C, current B → reload giữ state/history → kết thúc,
  mở lại/reload giữ điểm và lịch sử, không cho ghi/undo/edit/ván tiếp.
- Chưa có thông tin trình duyệt/OS. Không suy rộng kết quả Web thành
  force-stop/relaunch Android/iOS hoặc kiểm thử mẫu luật.

## Kết quả

- `flutter analyze`: No issues found.
- `flutter test`: **188 pass** (186 trước đó + 2 regression mới).
- Không đổi schema, dependencies hoặc luật nghiệp vụ.

## Test map

| Phạm vi | Test trong `test/` |
| --- | --- |
| Validator, roster, cấu hình | `domain/validation/validators_test.dart` |
| Create, reads, next game | `domain/services/room_service_test.dart`, `next_game_test.dart` |
| Luật, TH1/TH2, bi, zero-sum | `domain/services/score_engine_test.dart` |
| Undo, edits, kết thúc | `domain/services/room_commands_test.dart` |
| Tái dựng ledger/bi, nhiều ván | `domain/services/scoring_regression_test.dart` |
| Save/load, guards, retry, templates | `data/repositories/drift_game_repository_test.dart` |
| Restore state, receipt, barrier | `domain/services/drift_persistence_regression_test.dart` |
| Form, roster, navigation, loading/error, read-only | `screens/rooms/room_flow_test.dart` |
| Draft, confirm, undo, edits, lifecycle | `screens/rooms/in_room_actions_test.dart` |
| Queue, double submit, publish sau commit | `features/scoring/provider/` |

### Regression mới

1. SQLite file thật: tạo → ăn bi → miss → TH2 → đóng DB/mở connection mới → undo
   → đóng/mở lại → retry undo với revision cũ → finish → đóng/mở lại → read-only.
   So sánh toàn bộ JSON; kiểm tra điểm, order, current player, dấu undone và receipt.
2. SQL trigger từ chối insert receipt **sau khi room đã được ghi**: transaction phải
   rollback cả create lẫn update; bỏ trigger rồi retry thành công, retry tiếp không
   tăng revision hoặc thêm receipt trùng. Khác hook fail-before-write cũ.

Đóng/mở connection trên file không tương đương force-stop process hoặc kiểm thử UI
trên Android/iOS. Tests RAM trước đây chỉ mô phỏng tạo service/repository mới.

## API và luật bàn giao

- Contract commands/invariants: [project](../bidart-project.md#contract-logic-đã-chốt).
- Luật chuẩn và bảng input/output: [step1.md](step1.md) §2–6; nguồn: [rule.md](../rule.md).
- API engine/controllers và giới hạn RAM trước đây: [step3-handoff.md](step3-handoff.md).
- Storage, providers, templates: [step4.md](step4.md).
- UI không sửa tổng điểm trực tiếp; commands lưu aggregate + receipt atomically.
- Thêm/sửa luật không tính lại lịch sử; edit chặn undo; phòng đóng/huỷ chỉ xem.

## Manual acceptance — checklist thiết bị còn chờ

`flutter devices` hiện chỉ thấy Linux; không có Android/iOS kết nối.
Chạy trên thiết bị/emulator mục tiêu, tắt mạng, dùng dữ liệu thử (không clear app data):

| Bước | Kỳ vọng | Kết quả |
| --- | --- | --- |
| Tạo 3 người A/B/C, starter A, payer B; mọi bi 10 điểm | Phòng active, điểm 0 | Chưa chạy |
| A ăn bi 1 rồi miss | A +20, B/C -10; current B | Chưa chạy |
| B lỗi TH2 | Order swap thật với payer A | Chưa chạy |
| Undo | Order A/B/C, current B, điểm/bi như trước TH2; history đánh dấu undone | Chưa chạy |
| Ghi lại điểm/bi/order/history; force-stop rồi mở lại/chọn phòng | Khôi phục chính xác, không tạo phòng/lượt trùng | Chưa chạy |
| Kết thúc phòng, mở lại và xem | Giữ điểm/history, không ghi lượt/undo/edit | Chưa chạy |
| Lưu mẫu luật, force-stop rồi tạo phòng từ mẫu | Mẫu còn; phòng cũ không thay đổi | Chưa chạy |

Ghi model thiết bị, OS, build, ngày, PASS/FAIL từng bước và lỗi tái hiện trước khi
đóng checklist Phase 5. Manual Phase 3 đã PASS không thay thế acceptance persistence.

## Giới hạn

- Chỉ local; chưa Firebase/online, export hoặc telemetry.
- Schema v1 có onCreate; khi đổi schema cần migration + migration tests.
- Dữ liệu hỏng hiện lỗi rõ; chưa UI sửa/xoá dữ liệu hỏng.
- Web manual flow và reload đã được người dùng xác nhận PASS; chưa xác nhận
  force-stop/relaunch trên Android/iOS; chưa chứng minh mọi tình huống
  mất điện hoặc OS kill giữa commit bằng test file reopen.
