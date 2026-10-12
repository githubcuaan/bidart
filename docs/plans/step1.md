## A. Phạm vi phòng

## Trạng thái bước 1

### Xác nhận cuối: ngưỡng điểm và undo

- Đã chạm ngưỡng thì chờ hết ván rồi đóng phòng, tính đầy đủ điểm phát sinh; điểm cuối có thể thấp hơn ngưỡng. Ví dụ +90 → +110 → +80 với ngưỡng +100: đóng phòng cuối ván, điểm cuối +80.
- Undo cú làm chạm ngưỡng tính lại dấu chờ kết thúc từ lịch sử hiệu lực. Bỏ dấu nếu không còn lần chạm ngưỡng hợp lệ, không người khác đạt ngưỡng và chưa hết thời gian. Ví dụ undo +90 → +110 về +90: được chơi ván sau nếu không có điều kiện kết thúc khác.
- Nhóm câu hỏi bổ sung đã được trả lời. Các ghi chú “còn cần chốt” bên dưới về ngưỡng điểm được thay thế bởi xác nhận này. Cần biên tập lại bản đặc tả và đồng bộ project plan/contracts/tests trước khi đánh dấu toàn bộ Phase 1 hoàn thành; không coi việc trả lời câu hỏi là đã triển khai tính năng.

### Xác nhận bổ sung lần 4 (ưu tiên hơn ghi chú cũ)

- Đền cả làng chỉ trong chuỗi đề-pa; ngoài chuỗi đề-pa người chịu đền trả tổng điểm, kể cả cú ăn hết bi còn lại gồm bi 9. Cú hợp lệ ăn hết bi còn lại gồm bi 9 thắng ván.
- Sửa thứ tự giữ nguyên current player/payer; thứ tự mới quyết định người tiếp theo. Undo không vượt qua sửa thứ tự thủ công.
- Đạt điều kiện kết thúc thì chơi hết ván, ghi đầy đủ điểm tới cú cuối rồi chốt phòng. Chưa xác định nếu điểm giảm dưới ngưỡng hoặc undo cú chạm ngưỡng có bỏ trạng thái chờ kết thúc không.
- Cho xoá người giữa hai ván, giữ điểm/lịch sử người rời; roster hoạt động cần 2–5 người trước ván mới.

**Còn cần chốt:** khi đã chạm ngưỡng điểm, điểm giảm sau đó có vẫn đóng phòng cuối ván không; undo cú chạm ngưỡng có tính lại trạng thái chờ kết thúc không. Sau khi chốt cần đồng bộ project plan/contracts trước khi đánh dấu bước 1 hoàn thành.

Chưa hoàn thành: đã chốt công nghệ và phần lớn luật; cần chốt các edge cases chỉnh sửa giữa ván, kết thúc tự động và thứ tự ván mới trước khi hoàn thiện contract/tests. Phần xác nhận bổ sung dưới đây được ưu tiên khi mâu thuẫn với câu trả lời ban đầu.

### Xác nhận bổ sung

1. Người vừa mất cơ chịu đền suốt chuỗi người sau giữ cơ, không phải actor của cú ngay trước.
2. Trong cả chuỗi giữ cơ đề-pa, mỗi người còn lại trả toàn bộ điểm bi. Ví dụ 4 người, bi 10đ: ba người mỗi người -10, người đề-pa +30.
3. Chủ phòng ghi theo lượt: chỉ ghi cho người đang có cơ.
4. TH1: đã ăn hợp lệ ở cú trước, cú sau lỗi; giữ điểm đã ăn, không swap thứ tự, chuyển người kế tiếp.
5. Ăn bi có điểm và lỗi cùng một cú: người phạm lỗi trả tổng điểm các bi cho người chịu đền, không nhận điểm ăn; swap như TH2. Trong chuỗi đề-pa, trả tổng điểm cho từng người còn lại.
6. Bi ăn chưa đến thứ tự phải đặt lại: ví dụ đang đánh bi 2 nhưng ăn bi 3 thì móc bi 3 lên đánh tiếp.
7. Bi 9 ăn sớm vẫn tính điểm và giữ cơ nhưng đặt lại, chưa kết thúc ván. Ăn hợp lệ hai bi cuối cùng trong cùng cú thì thắng ngay.
8. Back/chuyển tab/đóng app không kết thúc phòng local; lưu để vào lại. Điều kiện kết thúc theo thời gian/điểm thuộc MVP.
9. Huỷ giữ lịch sử. Cho thêm/xoá người và sửa luật trong lúc chơi; semantics áp dụng/undo cần chốt thêm.
10. Người đứng sau người thắng ở ván mới là người đã chịu đền điểm bi 9 cho người thắng ở ván trước. Trường hợp có nhiều người trả bi 9 trong chuỗi đề-pa chưa chốt cách chọn.

### Các quyết định còn thiếu

### Xác nhận bổ sung lần 2

### Xác nhận bổ sung lần 3

- Không cho xoá người cho tới hết trận; thay thế quyết định cho xoá giữa ván trước đây.
- Ván đầu phải setup thứ tự bắn và người chịu đền trước khi bắt đầu.
- Đạt điều kiện thời gian/điểm thì chơi hết ván hiện tại rồi chốt phòng.
- Cho sửa thứ tự thủ công trong lúc chơi.
- Bi ăn sớm trong cú lỗi vẫn đặt lại. Một cú ăn hết bi còn lại gồm bi 9: người dùng xác nhận “đền cả làng”; chiều trả, số điểm và phạm vi ngoài đề-pa cần xác nhận.

**Câu hỏi mở hiện tại (ưu tiên hơn danh sách rà soát cũ):** công thức đền cả làng khi ăn hết bi trong một cú; current player/payer và undo sau sửa thứ tự; ngưỡng điểm đã đạt nhưng sau đó giảm/undo; thời điểm được xoá người (hết ván hay đóng phòng). Chưa đánh dấu bước 1 hoàn thành.

- Thêm người: điểm ban đầu 0, đứng cuối thứ tự. Xoá người vẫn giữ điểm/lịch sử của họ để tổng điểm toàn phòng, gồm người đã rời, bằng 0. Người thay thế khi xoá current player/payer chưa xác định.
- Sửa luật chỉ hiệu lực từ cú tiếp theo, không tính lại lịch sử. Undo không được vượt qua thay đổi roster/rules; lưu version luật và mốc chặn undo.
- Thời gian phòng tính từ lúc tạo, kể cả khi đóng app; thời điểm dừng khi đạt thời gian/điểm chưa chốt.
- Đi chấm phá: người đề-pa đi hết bi, cả làng chịu đền và giữ nguyên thứ tự cho ván sau.
- Bi ăn sớm ngoài bi 9 cũng tính điểm và giữ cơ nếu hợp lệ, nhưng đặt lại. Nếu cùng cú ăn cả bi đến lượt và bi tiếp theo (ví dụ 2 và 3), giữ cả hai ngoài bàn.
- TH2 trong chuỗi đề-pa swap với người chịu đền được mang từ ván trước; ván đầu chưa có payer ván trước cần chốt riêng.
- Guest không được trùng tên. Bi 9 tắt điểm vẫn thắng nếu ăn hợp lệ đủ điều kiện. Kết thúc phòng thủ công giữa ván giữ điểm, đánh dấu ván chưa hoàn thành và khoá phòng.

Các mục còn thiếu bên dưới là danh sách rà soát ban đầu; mục đã được xác nhận ở lần 2 không còn là câu hỏi mở. Còn cần chốt: người thay khi xoá current/payer; TH2 đề-pa ván đầu; dừng tự động ngay hay hết ván; sửa thứ tự thủ công; ưu tiên đặt lại bi sau lỗi và trường hợp nhiều bi cuối/bi 9 cùng cú.

- Thêm người giữa ván: điểm ban đầu và vị trí trong thứ tự; xoá người đang có cơ/người chịu đền; xử lý số người ngoài 2–5 và điểm người đã rời phòng để bảo toàn zero-sum.
- Sửa luật: thời điểm hiệu lực, version luật từng command; có cho sửa thứ tự thủ công không; undo có vượt qua thay đổi roster/rules không.
- Kết thúc tự động: tính giờ từ tạo phòng hay chỉ thời gian hoạt động; chạm ngưỡng giữa ván dừng ngay hay hết ván; trường hợp bi 9/ăn sớm và undo làm thay đổi điều kiện kết thúc.
- Ván mới: cách chọn người đứng thứ hai nếu cả làng trả bi 9; thuật toán thứ tự còn lại.
- Bi ăn sớm ngoài bi 9 có tính điểm/giữ cơ không; một cú nhiều bi xác định bi đến lượt theo trạng thái trước/sau cú; đặt lại bi sau lỗi có ưu tiên luật ăn sớm không; TH2 khi chưa có người chịu đền ở đề-pa swap với ai.
- Cho trùng tên guest không; bi 9 tắt điểm có kết thúc/thắng không; hành vi kết thúc thủ công khi ván chưa xong.

1. Phòng local hay online? Một thiết bị ghi điểm cho cả bàn, hay nhiều thiết bị cùng vào phòng?

- trước hết hãy làm phòng local, chỉ cần tên và lưu đỉêm cho trận đó.
- sau đó kết hợp làm phòng onl
- một thiết bị ghi cho cả bàn.

2. Số người: giới hạn 2–5 như mẫu UI, hay khoảng khác?

- 2-5

3. Người chơi: nhập tên guest đủ chưa? Có cần chọn tài khoản đã đăng ký? Cho phép trùng tên không?

- đối với phòng local thì tên guest là đủ
- nhưng đối với phòng onl thì phải là tài khoản đã đăng kí để lưu lại log trận đấu.

4. Vòng đời: một phòng chỉ chơi một ván, hay nhiều ván liên tiếp? Nếu nhiều ván, điểm cộng dồn hay reset?

- 1 Phòng chỉ chơi nhiều ván nhiều ván điểm cộng dồn
- một phòng kết thúc chỉ khi được bấm kết thúc hoặc người dùng thoát ra hết
- có thể khoán trước điều kiện kết thúc (đủ thời gian, một người chạm đến 1 điểm thắng nhật định)

5. Tạo và bắt đầu: tạo xong đánh ngay, hay có trạng thái chờ để sửa người/luật trước khi bắt đầu? Có cho nhiều phòng đang chơi cùng lúc không?

- tạo là bắt đầu
- Đang chơi phòng A thì không được bắt đầu phòng B, trừ khi kết thúc/huỷ A.
  Logic đơn giản, tránh ghi nhầm phòng.

## B. Thứ tự và người chịu đền

6. “Người bắn trước đó” là:

- Người thực sự đánh cú trước.

7.  Lượt đề-pa: người đầu ăn bi có điểm thì ai chịu đền? Người cuối trong vòng, không tính điểm, hay cách khác?

- tất cả những người còn lại đều bị trừ điểm ở lượt đề pa, và trong lượt bắn đề pa đó.

8.  Ăn hợp lệ: người ăn luôn giữ cơ? Nếu ăn nhiều bi liên tiếp, cùng một người chịu đền toàn bộ?
    A tiếp tục chịu đền suốt chuỗi B giữ cơ:
    B ăn bi 3: B +10, A -10
    B ăn bi 5: B +15, A -15
    Tổng: B +25, A -25, C 0
9.  Không ăn, không lỗi: chuyển sang người kế tiếp theo vòng, đúng không?
    đúng
10. Chọn người ghi điểm: chỉ cho chọn người đang có cơ, hay được chọn bất kỳ người nào? Nếu chọn người khác, hệ thống sửa lượt thế nào?
    chỉ người chủ phòng mới được ghi điểm.

## C. Bi và tính điểm

11. Cấu hình điểm: bi 1–9 đều bật/tắt được? Bi bật phải có điểm nguyên dương? Có giới hạn điểm tối đa và cho phép tắt toàn bộ không?

- Mọi bi bật/tắt được; bi bật có điểm nguyên dương, tối đa phụ thuộc vào cáu hình ban đầu (có thể có / không có giới hạn); không cho tắt toàn bộ.

12. Một cú ăn nhiều bi: ghi nhận chung một cú rồi cộng tổng điểm, đúng không?

- ghi nhận chung rồi cộng tổng.

13. Bi không điểm: vẫn ghi nhận đã rời bàn và giữ cơ nếu ăn hợp lệ, đúng không?

- Đúng, vẫn ghi nhận bi đã ăn và giữ cơ, không tạo giao dịch điểm.

14. Hệ số: MVP có tính theo lỗ, đền chỉ định, đền cả làng hoặc x2 bi 9 khi dọn bàn không? Nếu có, mô tả điều kiện và người trả/nhận.

- tạm thời chưa làm các điều kiện nâng cao này, để sau này.

15. Bi 9: ăn hợp lệ có kết thúc ngay kể cả bàn còn bi khác? Bi 9 tắt điểm vẫn kết thúc? Có cho kết thúc thủ công trước bi 9 không?

- nếu chưa ăn từ 1 -> 8 mà ăn chín thì chín sẽ đuợc móc lên đánh tiếp
- nếu đã đủ điều kiện (chỉ còn 9). kết thúc ván.

## D. Lỗi TH1 / TH2

16. TH1 — ăn bi rồi lỗi:

- Bi vừa ăn có được tính điểm không?
  -> không, nếu ăn bi có điểm mà bị lỗi thì sẽ bị đền cho người trước ddos
- Bi giữ ngoài bàn hay đặt lại?
  -> nếu ăn trực tiếp thì đặt ngoài
  -> ăn nối, chưa đến lượt bị đó thì lôi lên đánh.
- “Giữ nguyên lượt” nghĩa là chính người phạm lỗi đánh tiếp, đúng không?
  ->tức là người sau người đó đánh.

- TH1 chỉ đạt điều kiện khi: ăn bi xong bắn tiếp tục lỗi, nếu ăn bi rồi lỗi ngay trong một cơ, điểm sẽ đền cho người trước (nếu có) rồi sẽ đổi cơ như th2.

17. TH2 — chưa ăn bi đã lỗi: xác nhận ví dụ này:
    Thứ tự: A → B → C → D
    B đang đánh, A là người trước.
    B mắc TH2.
    Thứ tự mới: B → A → C → D
    A đánh tiếp; nếu A không ăn thì C đánh.
    Đúng không? Nếu không, thứ tự và lượt tiếp phải thế nào?
    - đúng như bạn nói.
18. Phạt điểm: lỗi chỉ ảnh hưởng lượt, hay còn mất điểm? Nếu mất: bao nhiêu, ai nhận, có phụ thuộc loại lỗi không?

- lỗi chỉ ảnh hưởng mất lượt
- chỉ mất điểm trong trường hợp ăn bi có điểm và lỗi cùng lucs.

19. Bi sau lỗi: bi cái vào lỗ, bi mục tiêu vào lỗ sai luật hoặc nhảy khỏi bàn được xử lý thế nào? Đặc biệt bi 9: đặt lại hay kết thúc?

- với các bi không có điểm: bỏ ra luôn
- với các bi có điểm: phải đền cho người trước như ví dụ ở TH1
- với bi 9: đặt lại rồi theo luật để giữ cho người sau đặt / đổi cơ

20. Phạm vi tự kiểm tra: app chỉ ghi lỗi do người dùng chọn, hay phải tự kiểm tra luật 9 bi như chạm bi thấp nhất trước? Cần phân biệt loại lỗi nào trên UI?
    Người dùng tự xác định lỗi
    Người ghi điểm quan sát bàn rồi chọn:

- Không lỗi.
- TH1: ăn bi rồi mắc lỗi.
- TH2: chưa ăn bi đã mắc lỗi.
  App chỉ xử lý điểm, bi và lượt theo lựa chọn đó. Không tự biết cú đánh thực tế đúng luật không.
  Ví dụ B chạm sai bi trước: người dùng tự chọn TH2; app thực hiện đổi cơ/thứ tự.

## E. Undo, kết quả và dữ liệu

21. Undo: chỉ lượt cuối hay nhiều lượt liên tiếp? Có giới hạn thời gian? Cho undo lượt ăn bi 9 để mở lại ván đã kết thúc không?

- Cho undo nhiều lượt liên tiếp trong ván hiện tại, không giới hạn thời gian, chỉ để sửa dữ liệu nhập nhầm.
  Mỗi lần hoàn tác lượt hiệu lực cuối và giữ dấu vết lịch sử. Cho undo lượt bi 9 để mở lại ván nếu chưa bắt đầu ván mới hoặc đóng phòng; cần xác nhận.

22. Kết quả: người điểm cao nhất thắng, hay người ăn bi 9 thắng? Đồng điểm xử lý hòa hay tiêu chí phụ?

- kết quả của ván sẽ là người ăn bi 9.
- người thắng sẽ được depa, cơ sau đó sẽ là người đền còn các lượt còn lại sẽ là theo ván trước:
  - ví dụ: a -> b -> c -> d->e. c thắng -> c đề pa -> b -> d ->e-> a

23. Kết thúc/huỷ: trận đã đóng có được sửa/mở lại không? Huỷ giữ lịch sử hay xoá? Có được đổi người, thứ tự hoặc luật giữa ván không?

- trận đã đóng tạm thời để là chỉ xem, sau này có kế hoạch khác tính sau

24. Lưu dữ liệu: phải tự lưu sau mỗi cú và phục hồi khi mở lại app, đúng không? Có cần lưu bộ luật yêu thích ngay trong MVP?

- tự động lưu dữ liệu sau mỗi cơ
- được, thêm chức năng lưu luật yêu thích

25. Kỹ thuật: nhóm đã chọn storage/state management chưa? Nếu chưa, có đồng ý Drift/SQLite + ChangeNotifier cho MVP local không?

- Đã thống nhất sử dụng **Riverpod** cho state management và dependency injection; không dùng `ChangeNotifier` làm convention cho luồng phòng.
- Controller điều phối thao tác, gọi engine và repository; chỉ cập nhật state thành công sau khi lưu thành công. Widget chỉ thu input và hiển thị state.
- Engine luật chơi thuần Dart, không phụ thuộc Flutter, Riverpod hoặc database. Repository có interface riêng để hỗ trợ local trước, online sau.
- Đã thống nhất **Drift/SQLite** cho local storage, kết hợp **Riverpod** cho state management và dependency injection. Lưu cú đánh và state liên quan trong cùng transaction; tự lưu sau mỗi cú và phục hồi khi mở lại app.
- Chốt **Firebase** cho backend giai đoạn online: Firebase Authentication định danh người chơi, Cloud Firestore lưu dữ liệu/realtime, Security Rules kiểm soát truy cập và Cloud Functions xử lý command có thẩm quyền.

### Quyết định kiến trúc local/online

- MVP triển khai phòng local trước; một thiết bị ghi điểm cho cả bàn. Firebase không thay thế Drift hoặc Riverpod.
- Phòng local dùng Drift làm nguồn dữ liệu chính. Phòng online dùng Firebase làm nguồn dữ liệu chính; không coi hai bản ghi độc lập ở Drift và Firestore là hai nguồn có thẩm quyền ngang nhau.
- Tách repository interface, local implementation và Firebase implementation; controller không truy cập database trực tiếp.
- Phòng online: chỉ chủ phòng được ghi điểm/undo; backend xác thực danh tính, vai trò thành viên và quyền thao tác. Ẩn nút trên client không thay thế kiểm tra quyền.
- Client gửi command có ID duy nhất và expected state version. Cloud Functions xác thực, tính/kiểm tra kết quả và ghi command + state trong Firestore transaction; retry không tạo lượt trùng, command dựa trên state cũ bị từ chối.
- Security Rules chặn client sửa trực tiếp điểm/lịch sử/state có thẩm quyền. Cloud Functions dùng Admin SDK phải tự kiểm tra quyền vì Admin SDK bỏ qua Security Rules.
- Engine local vẫn thuần Dart. Runtime/implementation engine backend chưa chốt; nếu dùng TypeScript/JavaScript, dùng chung đặc tả luật và bộ test input/output để tránh lệch với Dart.
- Phòng local chơi offline đầy đủ. Phòng online ban đầu cần mạng để ghi điểm/undo; mất mạng chỉ xem dữ liệu đã tải và báo trạng thái. Firestore cache không có nghĩa command đã được server chấp nhận; chưa triển khai queue command offline hoặc tự chuyển phòng local thành online.
- Schema Firestore, cấu hình Auth, region, chi phí/quota và cơ chế đồng bộ chi tiết cần thiết kế ở giai đoạn online; quyết định này chưa thêm dependency hay triển khai backend.
