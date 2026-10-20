# Luật bắn đền

## Luật cơ bản

- Dựa trên luật 9 bi cơ bản, nhưng áp dụng các biến thể bắn đền dưới đây. Không coi các biến thể này là luật WPA chuẩn. Người ghi điểm xác định tính hợp lệ/lỗi; app không tự quan sát bàn.
- cơ chế cộng điểm tùy theo người chơi:
  - chọn bi có điểm
  - bi đó có bao nhiêu điểm

- Người ăn bi có điểm sẽ được cộng điểm
- Người vừa mất cơ chịu đền suốt chuỗi người sau giữ cơ, không phải người đánh cú ngay trước. Mỗi bi có điểm tạo khoản trả từ người chịu đền sang người ăn.
- Tổng điểm của toàn bộ phải bằng 0

## Phòng, ván và ghi nhận

- MVP local, một thiết bị ghi cho cả bàn; 2–5 người guest. Một phòng chứa nhiều ván, điểm cộng dồn.
- Tạo phòng là bắt đầu; chỉ một phòng đang chơi. Chủ phòng chỉ ghi nhận cho người đang có lượt.
- Một cú ăn nhiều bi được ghi chung, tính tổng điểm. Bi tắt điểm vẫn ghi nhận trạng thái bi và giữ cơ nếu ăn hợp lệ; không tạo giao dịch điểm.
- Ăn hợp lệ giữ cơ; không ăn và không lỗi chuyển người kế tiếp theo vòng.
- Mọi bi 1–9 bật/tắt được; bi bật có điểm nguyên dương; không cho tắt toàn bộ. Giới hạn điểm có thể cấu hình hoặc không đặt giới hạn.
- Cho thêm người và sửa luật trong lúc chơi; chỉ xoá người giữa hai ván. Người mới bắt đầu 0 điểm và đứng cuối thứ tự; giữ điểm/lịch sử người rời để tổng điểm toàn phòng bằng 0. Guest không được trùng tên; cần 2–5 người hoạt động trước ván mới.
- Luật sửa chỉ áp dụng từ cú tiếp theo, không tính lại lịch sử; mỗi cú tham chiếu version luật. Sửa thứ tự thủ công giữ nguyên người đang có cơ và người chịu đền; thứ tự mới quyết định người tiếp theo. Undo không vượt qua thay đổi người, luật hoặc thứ tự thủ công.
- Trước khi bắt đầu ván đầu, thiết lập thứ tự bắn và người chịu đền để có người swap khi lỗi đề-pa. Không suy ra payer từ một ván trước chưa tồn tại.
- Thứ tự ván đầu cố định: người đề-pa đứng đầu, người đền đầu đứng thứ hai; chỉ được đổi thứ tự từ người thứ ba trở đi.

## Chuỗi đề-pa

- Trong cả chuỗi giữ cơ đề-pa, tất cả người còn lại đều chịu đền, mỗi người trả toàn bộ điểm bi.
- Ví dụ bàn A/B/C/D, A ăn bi 10 điểm: A +30, B/C/D mỗi người -10.
- Ăn bi có điểm và lỗi trong cùng cú thuộc chuỗi đề-pa: người đề-pa trả tổng điểm bi cho từng người còn lại; không nhận điểm ăn bi.

## Bi ăn sớm và kết thúc ván

- Bi ăn khi chưa đến thứ tự phải móc lên đặt lại. Ví dụ đang đánh bi 2 nhưng ăn bi 3: đặt lại bi 3.
- Bi 9 ăn sớm vẫn tính điểm và giữ cơ nếu hợp lệ, nhưng đặt lại và không kết thúc ván.
- Ăn bi 9 hợp lệ khi chỉ còn bi 9 thì thắng ván. Ăn hợp lệ cả hai bi cuối cùng trong một cú cũng thắng ngay.
- Người thắng đề-pa ván mới; người đã chịu đền bi 9 đứng sau. Ví dụ A → B → C → D → E, C thắng và B trả bi 9: C → B → D → E → A.
- Nếu người đề-pa đi hết bi (đi chấm phá), cả làng chịu đền và thứ tự ván sau giữ nguyên.
- Bi ăn sớm ngoài bi 9 cũng tính điểm và giữ cơ nếu hợp lệ nhưng đặt lại; nếu cùng cú ăn cả bi đến lượt và bi tiếp theo (ví dụ 2 và 3), cả hai giữ ngoài bàn.
- Bi 9 tắt điểm vẫn thắng nếu được ăn hợp lệ và đủ điều kiện kết thúc ván.

## Lỗi

- **TH1:** đã ăn hợp lệ ở cú trước trong chuỗi giữ cơ, sau đó mắc lỗi ở cú khác. Giữ điểm đã ghi, không đổi thứ tự; người kế tiếp đánh. “Giữ nguyên” là giữ thứ tự, không phải người phạm lỗi đánh tiếp.
- **TH2:** chưa ăn hợp lệ trong chuỗi mà mắc lỗi. Đổi vị trí với người chịu đền và chuyển cơ cho người đó. Ví dụ A → B → C → D, B lỗi, A chịu đền: thứ tự B → A → C → D, A đánh tiếp; A không ăn thì C đánh.
- **Ăn bi và lỗi cùng cú:** không cộng điểm ăn; người phạm lỗi trả tổng điểm các bi có điểm cho người chịu đền và đổi cơ/thứ tự như TH2. Trong chuỗi đề-pa trả cho từng người còn lại.
- Không có phạt điểm cố định riêng; chỉ trả điểm khi ăn bi có điểm và lỗi cùng cú.
- TH2 trong chuỗi đề-pa swap với người chịu đền từ ván trước; ván đầu dùng người chịu đền đã setup trước ván.
- Bi ăn sớm trong cú lỗi vẫn phải đặt lại theo luật ăn sớm.
- Một cú hợp lệ ăn toàn bộ bi còn lại gồm bi 9 thì thắng ván. Đền cả làng chỉ trong chuỗi đề-pa; ngoài chuỗi đề-pa chỉ người chịu đền trả tổng điểm, không có hệ số đặc biệt cho cú này.
- Bi 9 ăn trong cú lỗi phải đặt lại, không thắng ván. Bi không điểm được bỏ ra, trừ bi ăn sớm phải đặt lại; bi 9 trong cú lỗi luôn đặt lại.

## Undo, lưu và đóng phòng

- Undo nhiều cú liên tiếp trong ván hiện tại, không giới hạn thời gian; chỉ sửa nhập nhầm và giữ dấu vết lịch sử. Phải phục hồi điểm, bi, người có cơ/người chịu đền và thứ tự.
- Được undo cú bi 9 để mở lại ván nếu chưa bắt đầu ván mới hoặc đóng phòng; cần xác nhận.
- Tự lưu sau mỗi cú, phục hồi khi mở lại app; có lưu luật yêu thích.
- Back/chuyển tab/đóng app không đóng phòng local. Phòng kết thúc/huỷ chỉ xem lại; huỷ giữ lịch sử.
- Kết thúc phòng thủ công giữa ván giữ điểm, đánh dấu ván chưa hoàn thành và khoá phòng.
- Có cấu hình kết thúc phòng theo thời gian hoặc ngưỡng điểm trong MVP. Thời gian tính từ lúc tạo phòng, kể cả khi đóng app. Khi đạt điều kiện, đánh dấu chờ kết thúc, chơi hết ván hiện tại và ghi đầy đủ điểm tới cú cuối rồi chốt phòng, không bắt đầu ván mới.
- Đã chạm ngưỡng điểm thì vẫn chốt cuối ván dù điểm giảm sau đó. Không ép điểm cuối về ngưỡng. Ví dụ ngưỡng +100: B từ +90 lên +110 rồi xuống +80; hết ván đóng phòng với B +80.
- Undo cú làm chạm ngưỡng phải tính lại dấu chờ kết thúc theo lịch sử hiệu lực. Nếu không còn lần chạm ngưỡng hợp lệ, không người khác đạt ngưỡng và chưa hết thời gian thì bỏ dấu, được tiếp tục ván sau. Undo không làm lùi thời gian thực hoặc mở lại phòng đã đóng.

## Trạng thái đặc tả

Tài liệu đã tổng hợp các luật được xác nhận qua phần trả lời và các lần bổ sung trong [plans/step1.md](./plans/step1.md), bao gồm ngưỡng điểm và undo. Các ghi chú câu hỏi mở cũ đã được trả lời trong những lần xác nhận sau, không còn là blocker luật tương ứng.

Phần chốt luật đã hoàn thành; toàn bộ bước 1 vẫn cần đồng bộ project plan, domain model phòng/nhiều ván, command contracts và bảng test input/output. Đây là đặc tả nghiệp vụ, không phải xác nhận tính năng đã được triển khai. Nếu phát sinh tình huống chưa được mô tả, phải xác nhận thêm thay vì tự suy luận luật mới.
