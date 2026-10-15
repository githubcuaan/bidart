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
- [ ] Input/result immutable; validate actor, game, rules, payer, balls.
- [ ] Transactions amount > 0, tổng điểm luôn 0; bi tắt vẫn được ghi nhận.
- [ ] Giữ/chuyển cơ, TH1/TH2, đề-pa/cả làng, ăn sớm/đặt lại, thắng bi 9.
- [ ] Unit tests theo step1 §6; lỗi không mutate input.

### CP2 — Commands, undo và lifecycle
- [ ] recordTurn, undoLastTurn, finishRoom, cancelRoom, evaluateEndConditions.
- [ ] Idempotency, expected revision, atomic commit và failure/retry tests.
- [ ] Undo khôi phục snapshots, giữ lịch sử undone, chặn qua edit/ván mới/phòng đóng.
- [ ] Pending-end theo lịch sử hiệu lực và clock; không cắt điểm.
- [ ] Edit roster/rules/order, barriers; setup thay thế thủ công khi cần.

### CP3 — Controllers và UI
- [ ] Shared per-room queue; publish sau commit; refresh room/list reads.
- [ ] Scoreboard/current player/balls, draft, preview, lỗi, xác nhận.
- [ ] Undo có xác nhận khi mở lại ván; nhật ký; next game; finish/cancel.
- [ ] Khoá submit đang xử lý; lỗi lưu giữ draft; closed room read-only.
- [ ] Widget/controller tests và layout màn hình hẹp.

### CP4 — Regression và bàn giao
- [ ] `flutter analyze`, `flutter test` đều sạch.
- [ ] Cập nhật project/entity checklist chỉ cho tính năng đã test.
- [ ] Handoff API, lệnh kiểm tra và giới hạn RAM-only.
- [ ] Kiểm tra thủ công trên thiết bị/emulator nếu môi trường cho phép; nếu chưa làm phải ghi rõ.

Mỗi checkpoint triển khai có commit riêng kèm tests; không push hoặc tạo PR khi chưa được yêu cầu.
