# Bước 1 — Đặc tả core phòng đã chốt

**Trạng thái: hoàn thành phần thiết kế/đặc tả, chưa triển khai code.**

Tổng hợp câu trả lời và các lần xác nhận của người phụ trách. Luật nghiệp vụ chuẩn của dự án nằm tại [../rule.md](../rule.md); khi UI/scratch hoặc class design cũ mâu thuẫn, ưu tiên luật và contract trong tài liệu này. Các tên model/command dưới đây là contract thiết kế, không khẳng định code đã tồn tại.

## 1. Phạm vi và công nghệ

- Local trước: một thiết bị ghi điểm cho cả bàn; 2–5 guest, tên trim không rỗng/không trùng, định danh bằng ID chứ không bằng tên.
- Một phòng nhiều ván; điểm cộng dồn. Tạo là bắt đầu ván đầu, không có phòng chờ; chỉ một phòng chưa đóng tại một thời điểm.
- Chủ phòng chỉ ghi cho người đang có cơ. Người dùng xác định tính hợp lệ/lỗi; app không tự phân xử mọi luật 9 bi.
- MVP gồm luật yêu thích, chỉnh sửa giữa ván, kết thúc theo thời gian/ngưỡng điểm, undo và tự lưu/phục hồi.
- **Riverpod** quản lý state/dependency; controller điều phối engine -> repository -> publish state sau lưu thành công.
- **Drift/SQLite** là nguồn chính cho local; lưu command, lịch sử và state liên quan cùng transaction, có schema version/migration.
- Engine thuần Dart không phụ thuộc Flutter/Riverpod/database; repository interface tách nguồn local và online.
- Online sau dùng **Firebase Authentication, Cloud Firestore, Security Rules, Cloud Functions**. Không triển khai online trong MVP local.
- Hệ số lỗ, preset vùng miền, x2 bi 9 và các chế độ đền nâng cao chưa thuộc MVP. Đền cả làng trong chuỗi đề-pa vẫn bắt buộc, không phải tính năng nâng cao bị hoãn.

## 2. Domain contract: phòng -> ván -> cú đánh

| Model | Trách nhiệm / dữ liệu bắt buộc |
| --- | --- |
| `Room` | ID, tên hiển thị, owner ID, mode local/online, trạng thái, createdAt/endTime, participant IDs, roster hoạt động, thứ tự, rule version hiện tại, current game ID, tổng điểm cộng dồn, cấu hình thời gian/ngưỡng và dấu chờ kết thúc |
| `GameSession` | Một ván thuộc room; số ván, trạng thái, thời gian bắt đầu/kết thúc, winner ID, current player ID, payer ID, trạng thái chuỗi đề-pa/chuỗi giữ cơ, thứ tự và lịch sử hiệu lực |
| `PlayerInGame` / participant | ID guest/user, tên, thời điểm tham gia/rời; giữ liên kết lịch sử khi rời. Điểm của người rời vẫn nằm trong ledger toàn phòng |
| `RuleConfig` | Immutable version; cấu hình bi 1–9 enabled/points, giới hạn điểm optional; bi bật có điểm nguyên dương, tối thiểu một bi bật |
| `Turn` | Một cú đã xác nhận: command/turn ID, room/game ID, actor ID, rule version, bi ăn và trạng thái đặt lại, lỗi, payer(s), giao dịch, thời gian, before/after state, isUndone |
| `ScoreTransaction` | from/to participant IDs khác nhau, amount nguyên dương, game/turn ID, loại và group ID khi trả nhiều người |
| `ScoreLog` | Điểm trước/sau của mỗi người bị ảnh hưởng, phục vụ nhật ký/undo |
| `RoomEvent` | Thay đổi roster/rules/order, ID/version, dữ liệu trước/sau và mốc chặn undo |
| `RuleTemplate` | Tên mẫu và bản cấu hình độc lập; áp dụng cho phòng tạo mới không sửa lịch sử phòng cũ |

`RoomStatus`: `ACTIVE -> FINISHED/CANCELLED`. Chờ kết thúc là flag/reason trong `ACTIVE`, vẫn cho đánh nốt ván.

`GameStatus`: `IN_PROGRESS -> FINISHED/INCOMPLETE/CANCELLED`. Ván thắng bi 9 là `FINISHED`; đóng phòng thủ công giữa ván là `INCOMPLETE`; huỷ phòng giữ ván/lịch sử với trạng thái huỷ. Giữa hai ván: phòng vẫn `ACTIVE`, current game đã `FINISHED`, chưa có ván mới đang chơi.

Không dùng `PENDING/startGame` trong luồng tạo phòng. `createRoom` tạo phòng và ván đầu atomically; `startNextGame` là thao tác riêng sau một ván hoàn tất. Không xoá/reset điểm cũ khi xếp lại bộ bi 1–9.

### Dữ liệu đầu vào của cú đánh

- Actor phải là current player. Chọn người/bi trên UI chỉ là draft, xác nhận mới tạo `Turn`.
- Bi phải đang trên bàn, trong 1–9 và không trùng trong một input.
- Ghi nhận cả bi không điểm. Input chứa phân loại lỗi và kết quả bi giữ ngoài bàn/đặt lại theo luật; không nhập số điểm tuỳ ý.
- Trạng thái chuỗi trước cú phải cho engine phân biệt TH1/TH2 và ăn+lỗi cùng cú; không dựa vào nhãn UI mơ hồ để bỏ qua nhánh ăn+lỗi.
- Cú ăn sớm hợp lệ vẫn tính điểm/giữ cơ nhưng đặt lại bi. Cùng cú ăn bi đến lượt và bi tiếp theo thì giữ cả hai ngoài bàn; bi 9 trong cú lỗi luôn đặt lại.

## 3. Luật điểm và lượt

- Ngoài đề-pa: người vừa mất cơ trả toàn bộ điểm cho người ăn suốt chuỗi giữ cơ. Actor cú ngay trước không tự trở thành payer nếu đang giữ cơ.
- Chuỗi đề-pa: mỗi người còn lại trả tổng điểm bi của cú, người đề-pa nhận tổng các khoản. Ăn+lỗi cùng cú đảo chiều: người phạm lỗi trả tổng điểm cho từng người còn lại.
- Không ăn/không lỗi: chuyển người kế tiếp. TH1 (đã ăn hợp lệ ở cú trước rồi lỗi ở cú khác): giữ điểm cũ, không swap, chuyển người kế tiếp.
- TH2: swap actor với payer, payer đánh tiếp. Ăn+lỗi cùng cú: không nhận điểm ăn; trả tổng điểm bi có điểm cho payer (hoặc cả làng trong đề-pa), swap như TH2.
- Ván đầu setup cả người đề-pa, thứ tự và payer (payer thuộc roster, khác người đề-pa). Các ván sau dùng payer từ ván trước.
- Ăn bi 9 hợp lệ khi đủ điều kiện kết thúc thì thắng, kể cả bi 9 tắt điểm. Ăn toàn bộ bi còn lại gồm bi 9 trong một cú hợp lệ cũng thắng.
- Ván sau: người thắng đầu, người trả bi 9 đứng sau, những người còn lại theo vòng cũ bắt đầu sau người thắng. Ví dụ A/B/C/D/E, C thắng, B trả: C/B/D/E/A. Đi chấm phá giữ nguyên thứ tự; đền cả làng chỉ trong chuỗi đề-pa.

## 4. Command contracts

Command thay đổi dữ liệu có ID duy nhất; cùng ID retry trả kết quả đã commit, không áp dụng hai lần. Controller tuần tự hoá command theo phòng. Tất cả trả state/result hoặc lỗi rõ ràng; validation/persistence thất bại không publish state mới. Expected version dùng chống ghi dựa trên state cũ, đặc biệt khi online.

| Command | Input | Preconditions / output |
| --- | --- | --- |
| `createRoom` | Command ID, roster, order, starter, payer, rule config, end conditions | 2–5 guest hợp lệ; chưa có phòng active; tạo room `ACTIVE` + ván 1 `IN_PROGRESS`, điểm 0, createdAt và current player, lưu atomically |
| `getRoom/listRooms` | ID / filter | Đọc phòng active/đã đóng, bao gồm lịch sử và người đã rời; thiếu ID trả not-found |
| `recordTurn` | ID/version, game ID, actor, bi/kết quả bi, lỗi | Room active + ván đang chơi; actor đúng lượt; tính giao dịch/bi/thứ tự, ghi log/snapshot; có thể finish ván và đóng phòng nếu đang chờ kết thúc |
| `undoLastTurn` | ID/version, game ID, xác nhận nếu mở lại ván | Chỉ cú hiệu lực cuối của ván hiện tại, không qua mốc edit; room chưa đóng, chưa start ván sau; phục hồi before-state, giữ bản ghi undone, tính lại điều kiện kết thúc theo lịch sử còn hiệu lực và thời gian thực |
| `startNextGame` | ID/version | Ván trước finished, room active và không có điều kiện kết thúc; roster 2–5; tạo ván mới với bộ bi đầy đủ, order/payer theo luật, giữ điểm phòng |
| `addPlayer` | ID/version, tên/participant | Room active, không vượt 5, tên không trùng; điểm 0, cuối order, ghi event/mốc undo |
| `removePlayer` | ID/version, participant ID | Chỉ giữa hai ván trong room active; roster ván kế phải hợp lệ; giữ ledger/lịch sử, không xoá participant referenced; roster/order setup ván mới không được tham chiếu người đã rời |
| `updateRules` | ID/version, cấu hình mới | Room active; validate, tạo version mới hiệu lực cú sau; không recompute lịch sử, ghi mốc undo |
| `reorderPlayers` | ID/version, permutation roster | Room active; giữ current/payer, order mới dùng cho người tiếp theo; ghi mốc undo |
| `finishRoom` | ID/version, xác nhận | Chốt đầy đủ điểm; ván đang chơi thành incomplete; room finished/read-only, không mở lại bằng undo |
| `cancelRoom` | ID/version, xác nhận | Room cancelled/read-only, giữ ledger và lịch sử, không xoá dữ liệu |
| `saveRuleTemplate` | Tên và cấu hình hợp lệ | Lưu bản sao độc lập để tái dùng; không mutate room/history |
| `evaluateEndConditions` | Room, clock hiện tại | Thời gian tính từ tạo phòng; khi đạt thời gian/điểm đánh dấu chờ kết thúc; nếu ván đã hết thì không start ván mới. Chạy khi load/resume, trước command và khi timer đến hạn |

Sửa luật/người/thứ tự chỉ có hiệu lực sau command edit đã commit. Undo không vượt mốc edit, kể cả khi lượt cũ nằm trước một edit giữa hai cú.

### Kết thúc tự động

- Đạt điều kiện thì đánh nốt ván, ghi đầy đủ điểm rồi đóng phòng; không ép điểm về ngưỡng.
- Ngưỡng +100: B +90 -> +110 -> +80; vẫn đóng cuối ván với +80.
- Undo cú gây chạm ngưỡng: tính lại dấu chờ từ lịch sử hiệu lực, bao gồm các lần chạm trước mốc chặn undo. Nếu không còn lần chạm ngưỡng, không người khác đạt và chưa hết thời gian thì bỏ dấu.
- Undo không làm lùi đồng hồ; room đã đóng là read-only. Nếu thời gian đã hết khi resume, tiếp tục nốt ván, không tự xoá hoặc kết thúc ván chưa chơi xong.

## 5. Invariants

- Tổng điểm toàn phòng, gồm người đã rời, bằng 0; điểm khớp giao dịch hiệu lực qua mọi ván.
- Roster hoạt động 2–5 khi chơi; ID duy nhất, order là permutation roster; current/payer hợp lệ và khác nhau khi cần trả/swap.
- Rules/version và giao dịch cũ immutable. Bi được đặt lại có thể ăn lần sau; không chặn theo “đã từng ăn” mà kiểm tra trạng thái bàn hiệu lực.
- Bi còn lại lấy từ các kết quả giữ ngoài bàn/đặt lại trong ván, không từ tổng số lần ghi điểm.
- Một command commit tối đa một lần, command + lịch sử + state trong cùng transaction.
- Undo khôi phục points/order/current/payer/chain/balls/status và tính lại end conditions, không undo clock hoặc vượt edit barrier.
- Trận/phòng đã đóng chỉ xem; guest rời không làm mất giao dịch hoặc điểm đã có.

## 6. Bảng input/output dùng cho unit tests

Các điểm trong bảng là delta, trừ case nêu điểm hiện tại. Engine nhận cấu hình đã chốt của phòng, không dùng điểm mẫu UI làm mặc định.

| Case | Input | Output bắt buộc |
| --- | --- | --- |
| Tạo | A/B, order A/B, starter A, payer B, bi 3=10 | Room active, ván 1 đang chơi, A có cơ, điểm 0; 1 hoặc 6 người / tên trùng / payer A bị từ chối |
| Ăn thường | B có cơ, A payer, bi 3=10 hợp lệ | B +10/A -10, B giữ cơ, A vẫn payer |
| Chuỗi | Case trên rồi B ăn bi 5=15 | Tổng B +25/A -25; không chuyển payer thành B |
| Nhiều bi | B ăn hợp lệ 2 và 3 cùng cú, tổng 25 | Một Turn, B +25/A -25, cả 2/3 ngoài bàn |
| Ăn sớm | Đang tới bi 2, B ăn riêng bi 3=10 hợp lệ | B +10/A -10, bi 3 đặt lại, B giữ cơ; ăn lại hợp lệ có thể tính tiếp |
| Bi tắt | B ăn hợp lệ bi 2 tắt điểm | Không transaction, bi ngoài bàn nếu tới lượt, B giữ cơ |
| Đề-pa | A đề-pa, B/C/D, bi 10 | A +30, B/C/D mỗi người -10; chuỗi vẫn đề-pa |
| Không ăn | A/B/C/D, B có cơ, không lỗi | C có cơ, B payer; kết thúc chuỗi B |
| TH1 | B đã ăn hợp lệ cú trước, cú này lỗi không ăn | Giữ điểm cũ, order không đổi, C đánh tiếp |
| TH2 | A/B/C/D, B có cơ, A payer, lỗi trước khi ăn hợp lệ | Order B/A/C/D, A có cơ; A không ăn thì C có cơ |
| Ăn+lỗi | B ăn bi 10 và 15 cùng cú lỗi, A payer | B -25/A +25; không cộng ăn, swap như TH2 |
| Đề-pa+lỗi | A đề-pa ăn bi 10 cùng cú lỗi, B/C/D | A -30, B/C/D mỗi người +10; swap với payer setup/from previous game |
| Bi 9 sớm | B ăn riêng 9=50 hợp lệ, còn bi 2 | B +50/A -50; đặt lại 9, B giữ cơ, ván chưa xong |
| Bi 9 lỗi | Chỉ còn 9, ăn 9 rồi lỗi cùng cú | Không thắng, đặt lại 9, trả điểm/swap theo luật |
| Thắng | Chỉ còn 8/9, B ăn cả hai hợp lệ | Ván finished, B winner; ngoài đề-pa chỉ A trả, trong đề-pa cả làng trả |
| Bi 9 tắt | Chỉ còn 9 tắt, B ăn hợp lệ | Không giao dịch, B thắng |
| Ván mới | A/B/C/D/E, C thắng, B trả 9 | C/B/D/E/A, đủ bi 1–9, điểm phòng không reset |
| Chấm phá | A đi hết bi trong chuỗi đề-pa | Cả làng trả; ván sau giữ nguyên order |
| Edit | Thay rules/order hoặc thêm người sau một cú | History cũ không đổi, version/event lưu; undo không vượt event; reorder giữ current/payer |
| Remove | Xoá giữa hai ván, còn >=2 | Rời active roster, điểm/lịch sử giữ; xoá trong ván bị từ chối |
| Undo | Undo TH2 / cú thắng 9 trước ván mới | Phục hồi order/current/payer/balls/scores; ván có thể mở lại, turn undone; không mở room đã đóng |
| Ngưỡng | Ngưỡng 100, B 90 ->110 ->80 | Chờ cuối ván, chốt B 80; không start ván mới |
| Undo ngưỡng | B 90 ->110, undo về 90, chưa hết giờ | Bỏ pending-end nếu không còn điều kiện khác; hết giờ thì vẫn pending |
| Clock | Đóng app khi ván chưa xong, resume đã hết giờ | Restore đúng state, pending-end, đánh hết ván rồi đóng |
| Persistence | Save lỗi / retry command ID cũ | Lỗi không publish state; retry không thêm turn/transaction trùng |
| Invalid | Actor sai, bi ngoài bàn/ngoài 1–9/trùng input, stale version | Lỗi rõ ràng, không mutate state |

## 7. Kiến trúc online đã chốt (triển khai sau)

- Online dùng tài khoản đăng ký; Firestore là nguồn chính, không coi Drift/Firestore là hai nguồn có thẩm quyền ngang nhau.
- Chỉ owner ghi điểm/undo. Client gửi command ID và expected state version; Cloud Functions xác thực quyền, tính/kiểm tra luật, ghi command và state trong transaction.
- Security Rules chặn sửa trực tiếp điểm/lịch sử/state có thẩm quyền; Functions dùng Admin SDK phải tự kiểm tra quyền vì bỏ qua Rules.
- Online ban đầu cần mạng để ghi/undo; mất mạng chỉ xem dữ liệu đã tải và báo rõ. Cache không có nghĩa server đã chấp nhận command; không queue command offline hoặc tự chuyển local thành online.
- Engine local Dart; runtime backend chưa chốt, nếu dùng TypeScript/JavaScript phải dùng cùng đặc tả/test input-output.
- Schema Firestore, Auth provider, region, quota/chi phí và sync chi tiết là công việc online sau, không blocker cho MVP local.

## 8. Bàn giao bước 1

- [x] Luật và phạm vi thống nhất.
- [x] Domain room/game/turn và lifecycle được mô tả.
- [x] Command contracts, validation, undo/edit và end conditions được mô tả.
- [x] Bảng input/output cho engine/tests.
- [x] Công nghệ và ranh giới local/online thống nhất.

Chuyển sang Phase 2: triển khai models/validator và repository interface. Checklist code/tests vẫn chưa hoàn thành. [class_design.md](../class_design.md) là thiết kế ban đầu; phần scoring phải được triển khai theo bổ sung room/version/commands tại đây, không theo các chữ ký cũ nếu mâu thuẫn.
