---
categories:
  - "[[Projects]]"
subjects:
  - "[[Flutter]]"
type: project
status: active # backlog | active | paused | completed
priority: p2 # p1 (cao nhất) | p2 | p3 (thấp nhất)
deadline:
repo: "https://github.com/githubcuaan/bidart.git"
created: 2026-08-26
---

# Bidart — Core logic tạo phòng & trong phòng

**Goal:** Hoàn thành luồng `Danh sách phòng -> Tạo phòng -> Trong phòng -> Xem lại kết quả` cho trận bắn đền 9 bi, chơi guest và hoạt động offline. Người dùng cấu hình người chơi/điểm từng bi, ghi nhận lượt và lỗi; hệ thống tính điểm zero-sum, cập nhật thứ tự bắn, hoàn tác chính xác và khôi phục trận sau khi mở lại app.

**Phạm vi công việc hiện tại:** domain models, validation, tạo/chọn phòng, scoring/turn engine, state trong phòng, lưu local và kiểm thử. Không triển khai Auth, tìm đối, chat, bản đồ, đồng bộ online, mã mời/join phòng từ thiết bị khác, xuất PDF hoặc thống kê nâng cao.

**Định nghĩa phòng trong MVP:** một `Room` local chứa nhiều `GameSession` (ván), mỗi ván chứa nhiều `Turn` (cú đánh). Điểm cộng dồn toàn phòng, gồm người đã rời; local trước, Firebase online sau. Đặc tả đã chốt: [plans/step1.md](./plans/step1.md).

### Hiện trạng đã kiểm tra

- Step 2 hoàn tất: domain models/validators, repository contract + RAM implementation, room services và Riverpod providers/controllers đã có tests.
- `rooms.dart` là danh sách duy nhất; `add_room.dart` là form; `chose_room.dart` là gateway một phòng; `in_room.dart` hiển thị state đã commit và thao tác ván tiếp khi hợp lệ.
- Tạo/chọn/vào/quay lại giữ state trong cùng provider scope; phòng đóng/huỷ chỉ đọc. Chưa có scoring/undo hoặc finish/cancel commands.
- `pubspec.yaml` có Riverpod, Freezed/JSON/UUID; chưa có Drift/SQLite. Dữ liệu RAM mất sau restart, chưa hoàn tất offline persistence.
- Cấu trúc trong `folder_structure.md` là thiết kế mục tiêu, không phải toàn bộ code đã tồn tại. Giữ screens hiện tại khi tích hợp; không refactor các tab ngoài phạm vi.

### Tiêu chí hoàn thành

- Tạo được phòng hợp lệ với 2–5 guest theo UI hiện có; chọn người đề-pa và thứ tự bắn.
- Cấu hình điểm bi 1–9 có version; cho sửa khi chơi, chỉ áp dụng từ cú tiếp theo, không tính lại lịch sử. Có lưu luật yêu thích.
- Ăn bi có điểm tạo giao dịch từ người chịu đền sang người ăn; tổng điểm mọi người luôn bằng 0.
- Ghi nhận được lượt không ăn bi và lỗi TH1/TH2; xác định đúng người hiện tại, người trước và người tiếp theo theo luật đã chốt.
- Undo khôi phục điểm, bi còn lại, thứ tự bắn, trạng thái trận và lịch sử hiệu lực.
- Tạo phòng/lưu lượt thất bại không để dữ liệu cập nhật một phần; thao tác xác nhận lặp không tạo lượt trùng.
- Đóng/mở app vẫn vào lại đúng phòng và trạng thái đã lưu; trận kết thúc/huỷ chỉ được xem lại.
- Unit/widget tests liên quan đạt; chạy `flutter analyze` và `flutter test`, ghi nhận lỗi ngoài phạm vi nếu có.

---

## Project Files

```base
filters:
  and:
    - file.hasLink(this.file)
properties:
  file.name:
    displayName: Title
  note.categories:
    displayName: Category
  note.status:
    displayName: Status
views:
  - type: table
    name: All
    order:
      - file.name
      - categories
      - status
```

---

## Milestones & Tasks

- [x] **Phase 1: Chốt contract và luật (hoàn thành đặc tả, chưa triển khai)**
  - [x] Phòng local, 2–5 guest không trùng tên; một phòng nhiều ván, điểm cộng dồn, chỉ một phòng active.
  - [x] Luật trong `rule.md` và bảng input/output trong `plans/step1.md` đã thống nhất.
  - [x] Một `Turn` là một cú đã xác nhận, có thể không ăn hoặc ăn nhiều bi; chọn trên UI chỉ là draft.
  - [x] Chốt Room ACTIVE -> FINISHED/CANCELLED, ván IN_PROGRESS -> FINISHED/INCOMPLETE/CANCELLED; tạo là bắt đầu, contract undo/edit/kết thúc trong `plans/step1.md`.
  - [x] Chốt Riverpod cho state management và dependency injection; engine thuần Dart, controller và repository tách riêng. Quyết định tại [plans/step1.md](./plans/step1.md).
  - [x] Chốt Drift/SQLite cho local storage, kết hợp Riverpod; lưu lượt và state liên quan trong cùng transaction, tự lưu và phục hồi khi mở lại app.
  - [x] Chốt Firebase cho backend giai đoạn online (Auth, Firestore, Security Rules, Cloud Functions). MVP vẫn làm local trước; quyền chủ phòng, command idempotency và offline policy ghi tại [plans/step1.md](./plans/step1.md).

- [x] **Phase 2: Models và tạo/chọn phòng (P0, RAM-only)**
  - [x] Tạo immutable models/enums cho `Room`, `RoomStatus`, `RoomEvent`, `RuleTemplate`, `GameSession`, `PlayerInGame`, `RuleConfig`, `GameStatus`, `Turn`, `PottedBall`, `ScoreTransaction`, `ScoreLog` theo contract bước 1.
  - [x] Triển khai cấu hình điểm theo từng bi (`ballNumber -> enabled/points`) và rule versions theo contract bước 1.
  - [x] Bổ sung IDs actor/người chịu đền, thứ tự player IDs, current player và dữ liệu trước/sau lượt để xử lý chuyển cơ/undo; không dùng tên làm khoá.
  - [x] Tạo validator: 2–5 người, ID duy nhất, tên trim không rỗng, thứ tự là hoán vị roster, người đề-pa thuộc roster, bi trong 1–9, điểm nguyên dương cho bi bật, bi tắt tính 0.
  - [x] Validate tên guest không trùng, ít nhất một bi bật; giới hạn điểm optional theo cấu hình; payer/starter thuộc roster và khác nhau.
  - [x] Viết `createRoom`: validate -> tạo IDs/timestamp -> rule version -> điểm 0 -> lưu Room active + ván đầu đang chơi atomically -> trả room ID. Không tạo phòng nếu lưu thất bại.
  - [x] Viết `listRooms/getRoom/startNextGame`; ván tiếp chỉ sau ván hoàn tất và khi chưa có điều kiện đóng phòng, không reset điểm phòng.
  - [x] Nối `add_room.dart` với form, thêm/xoá/sắp xếp guest, chọn người đầu và preview luật; disable submit khi invalid/đang lưu.
  - [x] Nối `rooms.dart` và `chose_room.dart` với danh sách/chọn phòng; xử lý empty/loading/error và phòng không tồn tại. Chốt trách nhiệm hai file để tránh hai danh sách trùng chức năng.
  - [x] Sau tạo thành công mới điều hướng bằng room ID; quay về danh sách không đóng hoặc làm mất phòng.

- [x] **Phase 3: Engine và thao tác trong phòng (P0, RAM-only; automated tests và manual smoke PASS)**
  - [x] Tạo `lib/domain/services/score_engine.dart` thuần Dart: nhận session + turn input, trả kết quả mới; không phụ thuộc Flutter/storage.
  - [x] Validate actor, trạng thái trận, bi còn trên bàn, bi trùng trong input, cấu hình lỗi và người chịu đền; lỗi không mutate state.
  - [x] Tính điểm bằng giao dịch có `amount > 0`: mỗi khoản cộng luôn có khoản trừ tương ứng; không cho UI nhập/sửa trực tiếp tổng điểm.
  - [x] Xử lý giữ cơ khi ăn hợp lệ, chuyển cơ khi không ăn và TH1/TH2 theo bảng luật đã duyệt; TH2 đổi vị trí thật trong order.
  - [x] Ghi nhận riêng bi tắt điểm để `remainingBalls` đúng; UI vẫn chọn được bi tắt nhưng không tạo giao dịch điểm.
  - [x] Lưu lịch sử actor, bi, lỗi, giao dịch, score logs, snapshot trước/sau; regression tái dựng điểm và bi từ lượt hiệu lực.
  - [x] Commands `recordTurn`, `undoLastTurn`, `startNextGame`, `finishRoom`, `cancelRoom`, edit và `evaluateEndConditions`; validation/lỗi rõ ràng.
  - [x] Chuỗi đề-pa trả cả làng, payer cố định trong chuỗi, ăn sớm/đặt lại và thứ tự ván mới theo luật đã chốt.
  - [x] Thời gian từ tạo phòng/ngưỡng điểm: đánh nốt ván, ghi đủ điểm; undo tính lại pending-end, không lùi clock.
  - [x] Undo lượt hiệu lực cuối khôi phục state, giữ dấu `isUndone`; không vượt edit barrier/ván mới/phòng đóng, không undo lặp cùng lượt.
  - [x] `lib/screens/rooms/in_room.dart`: scoreboard, lượt hiện tại, bi, preview, lỗi, xác nhận, undo, nhật ký, edits, kết thúc/huỷ.
  - [x] Chọn bi/lỗi chỉ đổi draft; xác nhận tạo một lượt, khoá khi lưu và giữ draft nếu lỗi. Winner/payer rời roster được thay bằng lựa chọn thủ công cho ván mới.

  Bàn giao: [plans/step3-handoff.md](./plans/step3-handoff.md). Người dùng đã kiểm thử thủ công trên emulator và xác nhận toàn bộ PASS; không coi RAM-only là persistence hoặc hoàn tất Phase 5.

- [x] **Phase 4: Persistence và phục hồi (P0 cho bản bàn giao)**
  - [x] Định nghĩa `lib/domain/repositories/game_repository_interface.dart`: create/list/get/save room aggregate và commands atomic; local implementation ở `lib/data/repositories/game_repository.dart` (Drift).
  - [x] Dùng in-memory repository cho tests và tích hợp sớm, sau đó local repository; in-memory không được tính là hoàn thành offline persistence.
  - [x] Thêm Drift/Riverpod; schema Room -> GameSession -> Turn, rule versions/templates, roster/events, transactions và undo barrier; có schema version/migration (v1 onCreate; migration v2 thuộc Phase 5 khi đổi schema).
  - [x] Lưu lượt + state trong cùng transaction. Dùng command/turn ID chống lưu trùng khi retry; UI chỉ công bố state mới sau lưu thành công.
  - [x] Reload theo session ID, phục hồi lượt/điểm/bi/trạng thái; hiển thị lỗi dữ liệu hỏng thay vì tạo trận mới âm thầm.
  - [x] Cho thêm người/sửa luật/thứ tự khi chơi; xoá người chỉ giữa hai ván, giữ ledger/lịch sử. Edit là mốc chặn undo; phòng đóng/huỷ read-only.
  - [x] Lưu luật yêu thích độc lập, không mutate cấu hình/lịch sử phòng cũ.

  Chi tiết: [plans/step4.md](./plans/step4.md). Code + tests tự động xong; manual
  force-stop/relaunch trên thiết bị thuộc Phase 5.

- [x] **Phase 5: Kiểm thử và bàn giao (P0; Web + Android)**
  - [x] Unit tests cho validator, create/startNextGame và các nhánh engine; test map tại `plans/step5-handoff.md`.
  - [x] Repository tests cho save/load, atomicity SQL rollback, retry không trùng và restore sau undo trên SQLite file.
  - [x] Widget tests: form invalid, sắp xếp roster, tạo/chọn phòng, xác nhận lượt, loading/lỗi, undo và xem trận kết thúc.
  - [x] Chạy thử offline trên Android: tạo -> ghi lượt -> TH2 -> undo -> force-stop/mở lại -> kết thúc -> xem lại; mẫu luật sau force-stop PASS theo người dùng.
    Web: người dùng xác nhận toàn bộ manual điểm/chuyển cơ, TH2, undo,
    reload sau undo và kết thúc/xem lại/read-only PASS. Android toàn bộ manual
    PASS ngày 2026-10-16; iOS chưa kiểm chứng. Chi tiết tại `plans/step5-handoff.md`.
  - [x] Chạy `flutter analyze` sạch, `flutter test` 188 pass; cập nhật `class_checklist.md`.
  - [x] Bàn giao API, bảng luật, test map và giới hạn tại [plans/step5-handoff.md](./plans/step5-handoff.md). Acceptance Web + Android PASS.

### Thứ tự triển khai đề xuất

`Đặc tả đã chốt -> Models/validator -> Repository interface + fake -> Create/list/startNextGame -> Engine + unit tests -> Controller + UI -> Local persistence -> Regression + bàn giao`

Mỗi bước cần chạy được trước khi sang bước sau. Đền cả làng trong chuỗi đề-pa, luật yêu thích và kết thúc thời gian/điểm là **P0** đã chốt. Hệ số lỗ, các chế độ đền nâng cao/preset vùng miền và x2 bi 9 là **P1**; không tự thêm luật từ scratch.

## Contract logic đã chốt

| Command                                             | Input chính                                                      | Kết quả / ràng buộc                                                                   |
| --------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `createRoom`                                        | Roster, order, starter, payer, rules, end conditions, command ID | Room ACTIVE + ván đầu IN_PROGRESS, điểm 0; lưu atomically, không có PENDING           |
| `startNextGame`                                     | Room ID, command ID/version                                      | Ván trước hoàn tất, room chưa chờ đóng; reset bi, không reset điểm                    |
| `recordTurn`                                        | Room/game ID, command ID/version, actor, bi, lỗi                 | Actor đúng current player; giao dịch, state, history được lưu cùng nhau               |
| `undoLastTurn`                                      | Room/game ID, command ID/version, xác nhận                       | Chỉ ván hiện tại, không qua edit barrier, không mở room đã đóng; tính lại pending-end |
| `finishRoom/cancelRoom`                             | Room ID, command ID/version, xác nhận                            | Đóng read-only, giữ lịch sử; finish giữa ván đánh dấu incomplete                      |
| `addPlayer/removePlayer/updateRules/reorderPlayers` | Room ID, ID/version, dữ liệu edit                                | Edit có lịch sử; remove chỉ giữa ván; không tính lại điểm cũ; mốc chặn undo           |
| `saveRuleTemplate/evaluateEndConditions`            | Cấu hình / room + clock                                          | Lưu mẫu độc lập / đánh dấu chờ hết ván theo thời gian hoặc ngưỡng                     |
| `getRoom/listRooms`                                 | ID / filter trạng thái                                           | Dữ liệu đã lưu để vào lại hoặc xem kết quả                                            |

Controller Riverpod điều phối `command -> engine -> repository -> publish state`; widget chỉ thu input/hiển thị. Riverpod quản lý state và dependency injection, không chứa luật tính điểm hoặc thay thế persistence. Có thể đặt controller/providers tại `lib/features/scoring/provider/` theo thiết kế mục tiêu và giữ màn hình tại `lib/screens/rooms/` ở giai đoạn này. Engine thuần Dart và repository interface độc lập với Riverpod để hỗ trợ local trước, online sau.

### Invariants bắt buộc

- Tổng điểm luôn bằng 0, kể cả sau lỗi, undo và reload; scores phải khớp tổng giao dịch hiệu lực.
- Player IDs duy nhất; current/payer hợp lệ; order chứa đúng roster hoạt động; điểm người rời vẫn thuộc ledger phòng.
  Bi hợp lệ 1–9, chỉ ghi nếu đang trên bàn; bi đặt lại có thể ăn lần sau. Remaining balls theo kết quả bi của ván, không theo số lần đã ghi điểm.
- Rule versions và lịch sử immutable; sửa chỉ áp dụng cú sau, không recompute điểm cũ.
- Một command được commit tối đa một lần; không có lượt/giao dịch tồn tại mà state trận chưa cập nhật tương ứng.
- Undo phục hồi cả roster order, current/previous player, scores, balls, timestamps/status liên quan; không chỉ trừ ngược điểm.

## Luật đã xác nhận

Nguồn nghiệp vụ: [rule.md](./rule.md). Domain, lifecycle, commands, invariants và bảng test cụ thể: [plans/step1.md](./plans/step1.md). Bước 1 hoàn thành đặc tả, không phải code. `screens.md`, class design và scratch là tài liệu thiết kế ban đầu; khi mâu thuẫn phải theo đặc tả mới, không tự bổ sung luật.

- Payer là người vừa mất cơ, giữ suốt chuỗi người sau đánh; đề-pa cả làng trả mỗi người toàn bộ điểm.
- TH1 chuyển người kế tiếp, giữ thứ tự/điểm cũ; TH2 swap với payer. Ăn+lỗi cùng cú trả ngược tổng điểm và swap như TH2.
- Bi ăn sớm tính điểm/giữ cơ nhưng đặt lại; cùng cú ăn bi đến lượt và bi tiếp theo giữ ngoài bàn. Bi 9 lỗi luôn đặt lại; thắng bi 9 theo điều kiện mới.
- Người thắng đề-pa, payer bi 9 đứng sau; đi chấm phá giữ order. Điểm cộng dồn, không reset qua ván.
- Đạt thời gian/ngưỡng chờ hết ván, cộng/trừ đủ điểm; undo tính lại pending-end. Edit chặn undo, phòng đóng chỉ xem.

### Bảng test tối thiểu

| Nhóm        | Case cần kiểm tra                                                                                                  |
| ----------- | ------------------------------------------------------------------------------------------------------------------ |
| Tạo phòng   | 1/6 người bị từ chối; 2/5 người hợp lệ; tên trắng; ID/order trùng; starter ngoài roster; điểm/bi không hợp lệ      |
| Tính điểm   | A ăn bi 10đ, B chịu đền -> A +10/B -10; nhiều bi trong một cú; bi tắt không tạo giao dịch; điểm tổng 0             |
| Lượt bắn    | Giữ cơ, payer cố định, chuỗi đề-pa, wrap-around, payer setup ván đầu, TH1/TH2/ăn+lỗi, order ván mới                |
| Validation  | Actor sai, bi không còn trên bàn/ngoài 1–9/trùng input, room thiếu/đã đóng, stale version; bi đặt lại được ghi lại |
| Undo        | Không có lượt; undo ăn bi; undo TH2 phục hồi thứ tự; undo nhiều lần theo chính sách; ghi lượt mới sau undo         |
| Kết thúc    | Bi 9 hợp lệ/lỗi/ăn sớm/tắt điểm, ngưỡng điểm giảm/undo, timer khi resume, finish/cancel, chặn room đóng            |
| Lưu dữ liệu | Lưu lỗi không đổi state; retry không nhân đôi; reload rule/score/order/balls/history khớp trước khi đóng app       |

---

## Quick Links & Resources

- **Repository:** workspace Bidart hiện tại; URL remote chưa xác nhận, không tự điền.
- **Luật nghiệp vụ:** [rule.md](./rule.md).
- **Luồng tạo phòng/trong phòng:** [screens.md](./screens.md), mục Game §6–8.
- **Thiết kế domain:** [class_design.md](./class_design.md), Module 2; [class_checklist.md](./class_checklist.md).
- **Kiến trúc mục tiêu:** [folder_structure.md](./folder_structure.md).
- **UI tham khảo:** [ui_description.md](./ui_description.md), [createRoom.html](../scratch/createRoom.html), [inGame.html](../scratch/inGame.html). Nội dung mẫu không tự động trở thành luật.
- **Development/checks:** [README.md](../README.md).
- **Reference:** [Flutter testing](https://docs.flutter.dev/testing), [Dart enums](https://dart.dev/language/enums), [Drift](https://drift.simonbinder.eu/).

---

## Log & Notes

- 2026-08-26: Khởi tạo dự án.
- 2026-10-12: Bổ sung kế hoạch chi tiết cho phần tạo/chọn phòng và core trong phòng dựa trên docs/code hiện tại. Chưa triển khai logic; checklist implementation giữ chưa hoàn thành.
- Đã triển khai Riverpod cho state management/dependency injection; Drift/SQLite cho local storage vẫn chưa thêm dependency hoặc triển khai code.
- Đã chốt Firebase cho backend online; tách local/online repository và nguồn dữ liệu chính. Online ban đầu cần mạng để ghi điểm/undo, backend kiểm tra quyền chủ phòng và xử lý command; chưa triển khai Firebase.
- Cập nhật 2026-10-15: Phase 4 persistence hoàn tất code/tests; Phase 5 automated PASS (188 tests), còn manual offline force-stop/relaunch. Chi tiết `plans/step5-handoff.md`.
- 2026-10-15: Hoàn tất Step 2 UI và acceptance tự động; bàn giao API/giới hạn tại [plans/step2-handoff.md](./plans/step2-handoff.md). Chưa kiểm thử thủ công trên thiết bị/emulator, chưa có persistence.
- Deadline và URL repository chưa xác nhận; không đặt mốc thời gian giả định. Chi tiết backend online để giai đoạn sau.
