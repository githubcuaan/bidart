---
categories:
  - "[[Projects]]"
subjects:
  - "[[Flutter]]"
type: project
status: active                     # backlog | active | paused | completed
priority: p2                       # p1 (cao nhất) | p2 | p3 (thấp nhất)
deadline: 
repo: ""                           # Chưa xác nhận URL repository
created: 2026-08-26
---

# Bidart — Core logic tạo phòng & trong phòng

**Goal:** Hoàn thành luồng `Danh sách phòng -> Tạo phòng -> Trong phòng -> Xem lại kết quả` cho trận bắn đền 9 bi, chơi guest và hoạt động offline. Người dùng cấu hình người chơi/điểm từng bi, ghi nhận lượt và lỗi; hệ thống tính điểm zero-sum, cập nhật thứ tự bắn, hoàn tác chính xác và khôi phục trận sau khi mở lại app.

**Phạm vi công việc hiện tại:** domain models, validation, tạo/chọn phòng, scoring/turn engine, state trong phòng, lưu local và kiểm thử. Không triển khai Auth, tìm đối, chat, bản đồ, đồng bộ online, mã mời/join phòng từ thiết bị khác, xuất PDF hoặc thống kê nâng cao.

**Định nghĩa phòng trong MVP:** một `Room` local chứa nhiều `GameSession` (ván), mỗi ván chứa nhiều `Turn` (cú đánh). Điểm cộng dồn toàn phòng, gồm người đã rời; local trước, Firebase online sau. Đặc tả đã chốt: [plans/step1.md](./plans/step1.md).

### Hiện trạng đã kiểm tra

- `lib/screens/rooms/rooms.dart`: chỉ có widget placeholder, chưa có logic phòng.
- `lib/screens/rooms/add_room.dart`, `lib/screens/rooms/chose_room.dart`: file trống.
- Chưa có domain models, score engine hoặc repository cho scoring trong `lib/`.
- `pubspec.yaml` đã khai báo `freezed_annotation`, `json_annotation`, `uuid` và generator; chưa khai báo Drift/SQLite hoặc thư viện quản lý state.
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
  - [x] Chốt Riverpod cho state management và dependency injection; engine thuần Dart, controller và repository tách riêng. Quyết định được ghi tại [plans/step1.md](./plans/step1.md), câu 25.
  - [x] Chốt Drift/SQLite cho local storage, kết hợp Riverpod; lưu lượt và state liên quan trong cùng transaction, tự lưu và phục hồi khi mở lại app.
  - [x] Chốt Firebase cho backend giai đoạn online (Auth, Firestore, Security Rules, Cloud Functions). MVP vẫn làm local trước; quyền chủ phòng, command idempotency và offline policy ghi tại [plans/step1.md](./plans/step1.md).

- [ ] **Phase 2: Models và tạo/chọn phòng (P0)**
  - [ ] Tạo immutable models/enums cho `Room`, `RoomStatus`, `RoomEvent`, `RuleTemplate`, `GameSession`, `PlayerInGame`, `RuleConfig`, `GameStatus`, `Turn`, `PottedBall`, `ScoreTransaction`, `ScoreLog` theo contract bước 1.
  - [ ] Bổ sung cấu hình điểm theo từng bi (`ballNumber -> enabled/points`): `pointsPerBall` đơn lẻ trong class design chưa đủ cho yêu cầu màn hình tạo phòng.
  - [ ] Bổ sung IDs actor/người chịu đền, thứ tự player IDs, current player và dữ liệu trước/sau lượt để xử lý chuyển cơ/undo; không dùng tên làm khoá.
  - [ ] Tạo validator: 2–5 người, ID duy nhất, tên trim không rỗng, thứ tự là hoán vị roster, người đề-pa thuộc roster, bi trong 1–9, điểm nguyên dương cho bi bật, bi tắt tính 0.
  - [ ] Validate tên guest không trùng, ít nhất một bi bật; giới hạn điểm optional theo cấu hình; payer/starter thuộc roster và khác nhau.
  - [ ] Viết `createRoom`: validate -> tạo IDs/timestamp -> rule version -> điểm 0 -> lưu Room active + ván đầu đang chơi atomically -> trả room ID. Không tạo phòng nếu lưu thất bại.
  - [ ] Viết `listRooms/getRoom/startNextGame`; ván tiếp chỉ sau ván hoàn tất và khi chưa có điều kiện đóng phòng, không reset điểm phòng.
  - [ ] Nối `add_room.dart` với form, thêm/xoá/sắp xếp guest, chọn người đầu và preview luật; disable submit khi invalid/đang lưu.
  - [ ] Nối `rooms.dart` và `chose_room.dart` với danh sách/chọn phòng; xử lý empty/loading/error và phòng không tồn tại. Chốt trách nhiệm hai file để tránh hai danh sách trùng chức năng.
  - [ ] Sau tạo thành công mới điều hướng bằng room ID; quay về danh sách không đóng hoặc làm mất phòng.

- [ ] **Phase 3: Engine và thao tác trong phòng (P0)**
  - [ ] Tạo `lib/domain/services/score_engine.dart` thuần Dart: nhận session + turn input, trả kết quả mới; không phụ thuộc Flutter/storage.
  - [ ] Validate actor, trạng thái trận, bi còn trên bàn, bi trùng trong input, cấu hình lỗi và người chịu đền; lỗi không mutate state.
  - [ ] Tính điểm bằng giao dịch có `amount > 0`: mỗi khoản cộng luôn có khoản trừ tương ứng; không cho UI nhập/sửa trực tiếp tổng điểm.
  - [ ] Xử lý giữ cơ khi ăn hợp lệ, chuyển cơ khi không ăn và TH1/TH2 theo bảng luật đã duyệt; TH2 phải đổi vị trí hai người, không chỉ đổi highlight.
  - [ ] Tách bi không tính điểm khỏi bi đã rời bàn: vẫn cần cách ghi nhận bi tắt để `remainingBalls` đúng, dù không xuất hiện trong bộ chọn cộng điểm.
  - [ ] Lưu lịch sử có actor, bi, lỗi, giao dịch, score logs, thứ tự trước/sau và người nhận lượt; bi còn lại được suy ra từ lượt hiệu lực.
  - [ ] Tạo `recordTurn`, `undoLastTurn`, `startNextGame`, `finishRoom`, `cancelRoom`, commands edit và `evaluateEndConditions` theo bước 1; validation/lỗi rõ ràng.
  - [ ] Triển khai chuỗi đề-pa trả mỗi người, payer cố định suốt chuỗi, bi ăn sớm/đặt lại và thứ tự ván mới; không dùng luật WPA/mẫu UI thay biến thể đã chốt.
  - [ ] Triển khai thời gian từ tạo phòng/ngưỡng điểm: đạt điều kiện chờ hết ván, ghi đủ điểm; undo tính lại pending-end nhưng không lùi clock.
  - [ ] Undo lượt hiệu lực cuối: khôi phục toàn bộ state trước lượt, đánh dấu `isUndone`, không tính lại lượt đó vào điểm/bi còn lại. Không cho undo lặp cùng lượt.
  - [ ] Tích hợp màn hình trong phòng mới (đề xuất `lib/screens/rooms/in_room.dart`): scoreboard, lượt hiện tại, chọn bi, preview cộng/trừ, ghi nhận lỗi, xác nhận, undo, nhật ký, kết thúc/huỷ.
  - [ ] Chọn người/bi chỉ thay đổi draft; một lần xác nhận tạo đúng một lượt, khoá nút khi xử lý và giữ draft nếu lưu lỗi.

- [ ] **Phase 4: Persistence và phục hồi (P0 cho bản bàn giao)**
  - [ ] Định nghĩa `lib/domain/repositories/game_repository_interface.dart`: create/list/get/save room aggregate và commands atomic; local implementation ở `lib/data/repositories/game_repository.dart`.
  - [ ] Dùng in-memory repository cho tests và tích hợp sớm, sau đó local repository; in-memory không được tính là hoàn thành offline persistence.
  - [ ] Thêm Drift/Riverpod; schema Room -> GameSession -> Turn, rule versions/templates, roster/events, transactions và undo barrier; có schema version/migration.
  - [ ] Lưu lượt + state trong cùng transaction. Dùng command/turn ID chống lưu trùng khi retry; UI chỉ công bố state mới sau lưu thành công.
  - [ ] Reload theo session ID, phục hồi lượt/điểm/bi/trạng thái; hiển thị lỗi dữ liệu hỏng thay vì tạo trận mới âm thầm.
  - [ ] Cho thêm người/sửa luật/thứ tự khi chơi; xoá người chỉ giữa hai ván, giữ ledger/lịch sử. Edit là mốc chặn undo; phòng đóng/huỷ read-only.
  - [ ] Lưu luật yêu thích độc lập, không mutate cấu hình/lịch sử phòng cũ.

- [ ] **Phase 5: Kiểm thử và bàn giao (P0)**
  - [ ] Unit tests cho validator, create/startNextGame và mọi nhánh engine theo bảng input/output tại `plans/step1.md` §6.
  - [ ] Repository tests cho save/load, atomicity, retry không trùng và restore sau undo.
  - [ ] Widget tests: form invalid, sắp xếp roster, tạo/chọn phòng, xác nhận lượt, loading/lỗi, undo và xem trận kết thúc.
  - [ ] Chạy thử offline trên thiết bị/emulator: tạo -> ghi lượt -> TH2 -> undo -> đóng/mở app -> kết thúc -> xem lại.
  - [ ] Chạy `flutter analyze`, `flutter test`; cập nhật tiến độ entity trong `class_checklist.md` khi code thực sự hoàn thành.
  - [ ] Bàn giao API, bảng luật đã chốt, test cases và giới hạn còn lại; không đánh dấu xong tính năng chỉ có UI mẫu.

### Thứ tự triển khai đề xuất

`Đặc tả đã chốt -> Models/validator -> Repository interface + fake -> Create/list/startNextGame -> Engine + unit tests -> Controller + UI -> Local persistence -> Regression + bàn giao`

Mỗi bước cần chạy được trước khi sang bước sau. Đền cả làng trong chuỗi đề-pa, luật yêu thích và kết thúc thời gian/điểm là **P0** đã chốt. Hệ số lỗ, các chế độ đền nâng cao/preset vùng miền và x2 bi 9 là **P1**; không tự thêm luật từ scratch.

## Contract logic đề xuất

| Command | Input chính | Kết quả / ràng buộc |
| --- | --- | --- |
| `createRoom` | Roster, thứ tự, người đầu, rule config | Phòng `PENDING`, điểm 0, rule snapshot; không có lịch sử |
| `startGame` | Session ID | `IN_PROGRESS`, thời gian bắt đầu, current player; chỉ từ `PENDING` |
| `recordTurn` | Session ID, command ID, actor ID, bi ăn, lỗi | State mới + giao dịch + nhật ký + lượt tiếp; chỉ khi đang chơi |
| `undoLastTurn` | Session ID | Phục hồi snapshot trước lượt hiệu lực cuối; báo lỗi nếu không có lượt để undo |
| `finishGame` | Session ID, xác nhận | `FINISHED`, thời gian kết thúc, kết quả; điều kiện kết thúc cần chốt |
| `cancelGame` | Session ID, xác nhận | `CANCELLED`, giữ lịch sử; không xoá phòng |
| `getRoom/listRooms` | ID / filter trạng thái | Dữ liệu đã lưu để vào lại hoặc xem kết quả |

Controller Riverpod điều phối `command -> engine -> repository -> publish state`; widget chỉ thu input/hiển thị. Riverpod quản lý state và dependency injection, không chứa luật tính điểm hoặc thay thế persistence. Có thể đặt controller/providers tại `lib/features/scoring/provider/` theo thiết kế mục tiêu và giữ màn hình tại `lib/screens/rooms/` ở giai đoạn này. Engine thuần Dart và repository interface độc lập với Riverpod để hỗ trợ local trước, online sau.

### Invariants bắt buộc

- Tổng điểm luôn bằng 0, kể cả sau lỗi, undo và reload; scores phải khớp tổng giao dịch hiệu lực.
- Player IDs duy nhất; current/previous player hợp lệ; thứ tự chứa đúng roster, không trùng hoặc thiếu người.
- Bi hợp lệ trong 1–9; một bi không được ăn hai lần trong lịch sử hiệu lực nếu chưa có luật đặt lại bi được chốt.
- Rules của trận là snapshot độc lập với form/preset; sửa draft phòng mới không ảnh hưởng trận cũ.
- Một command được commit tối đa một lần; không có lượt/giao dịch tồn tại mà state trận chưa cập nhật tương ứng.
- Undo phục hồi cả roster order, current/previous player, scores, balls, timestamps/status liên quan; không chỉ trừ ngược điểm.

## Luật cần xác nhận trước triển khai

`rule.md` và phần Game trong `screens.md` là baseline nghiệp vụ hiện tại. `ui_description.md`/scratch chỉ tham khảo UI khi có mâu thuẫn; các quyết định dưới đây chưa phải luật đã được duyệt.

| Vấn đề | Điểm chưa thống nhất | Quyết định cần nhóm chốt |
| --- | --- | --- |
| Người “bắn trước đó” | Người trước trong vòng thứ tự hay actor của cú đánh trước? Người đề-pa chưa có cú trước | Cách xác định payer, đặc biệt lượt đầu và lúc cùng người giữ cơ nhiều lần; không cho giao dịch tự trả |
| TH1 | Rule nói giữ lượt; chưa rõ bi đã ăn có tính điểm/ở lại ngoài bàn không | Điểm, bi và previous player sau TH1 |
| TH2 | Rule yêu cầu đổi cơ với người trước và đổi thứ tự; UI mẫu có mô tả chuyển vòng sau | Ưu tiên hành vi TH2 trong rule: định nghĩa swap và người bắn tiếp, gồm wrap-around 2/3/5 người |
| Phạt lỗi | UI có -20đ nhưng rule chưa quy định khoản phạt hay người nhận | MVP có phạt điểm không? Nếu có, ai nhận để tổng vẫn bằng 0? Không tự trừ điểm một phía |
| Bi không điểm | Screens chặn chọn để cộng điểm nhưng engine cần biết bi còn lại | Thao tác ghi nhận bi không điểm riêng, không sinh giao dịch |
| Kết thúc/bi 9 | UI nói ăn bi 9 kết thúc, x2 khi dọn bàn; rule chưa mô tả các ngoại lệ | Ăn bi 9 hợp lệ, ăn kèm lỗi, đặt lại bi, kết thúc thủ công và định nghĩa dọn bàn |
| Undo | Screens nói “trong thời gian ngắn”, chưa có thời hạn | Thời hạn, undo nhiều lượt và có mở lại trận vừa kết thúc bằng undo không |
| Kết quả | `winnerId` đơn lẻ chưa biểu diễn đồng điểm | Cách xác định thắng/hòa, có cho kết thúc sớm không |
| Luật 9 bi | Rule dẫn chiếu “toàn bộ luật 9 bi cơ bản” nhưng chưa có input nhận biết tất cả lỗi | Những gì app tự kiểm tra được và những gì người ghi điểm phải xác nhận; không tuyên bố engine tự phân xử đầy đủ |

### Bảng test tối thiểu

| Nhóm | Case cần kiểm tra |
| --- | --- |
| Tạo phòng | 1/6 người bị từ chối; 2/5 người hợp lệ; tên trắng; ID/order trùng; starter ngoài roster; điểm/bi không hợp lệ |
| Tính điểm | A ăn bi 10đ, B chịu đền -> A +10/B -10; nhiều bi trong một cú; bi tắt không tạo giao dịch; điểm tổng 0 |
| Lượt bắn | Giữ cơ, không ăn chuyển lượt, vòng cuối về đầu, người đầu chưa có lượt trước, TH1, TH2 ở 2/3/5 người |
| Validation | Actor sai, bi đã ăn/ngoài 1–9, bi trùng trong input, room không tồn tại, command khi chưa start/đã kết thúc |
| Undo | Không có lượt; undo ăn bi; undo TH2 phục hồi thứ tự; undo nhiều lần theo chính sách; ghi lượt mới sau undo |
| Kết thúc | Bi 9 theo luật đã chốt, đồng điểm, finish/cancel lặp, chặn ghi lượt mới ở trận đóng |
| Lưu dữ liệu | Lưu lỗi không đổi state; retry không nhân đôi; reload rule/score/order/balls/history khớp trước khi đóng app |

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
- Đã chốt Drift/SQLite cho local storage và Riverpod cho state management/dependency injection; chưa thêm dependency hoặc triển khai code.
- Đã chốt Firebase cho backend online; tách local/online repository và nguồn dữ liệu chính. Online ban đầu cần mạng để ghi điểm/undo, backend kiểm tra quyền chủ phòng và xử lý command; chưa triển khai Firebase.
- Deadline, URL repository và các luật còn mâu thuẫn cần nhóm xác nhận; chưa đặt mốc thời gian giả định.
