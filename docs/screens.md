# Mô tả các màn hình

Tài liệu mô tả các màn hình chính của ứng dụng dựa trên các tính năng và
`docs/rule.md`. Một số thao tác phụ như xác nhận, chọn ngày đấu hoặc báo lỗi
có thể được triển khai dưới dạng dialog/bottom sheet thay vì màn hình riêng.

## Auth

### 1. Màn hình đăng nhập

Màn hình khởi đầu dành cho người dùng đã có tài khoản.

- Nhập số điện thoại hoặc email và mật khẩu.
- Hiển thị lỗi khi thông tin không hợp lệ hoặc tài khoản không tồn tại.
- Điều hướng sang màn hình đăng ký.
- Điều hướng sang màn hình quên mật khẩu.
- Sau khi đăng nhập thành công, chuyển tới màn hình chính của ứng dụng.

### 2. Màn hình đăng ký

Màn hình tạo tài khoản mới.

- Nhập số điện thoại/email, mật khẩu và xác nhận mật khẩu.
- Kiểm tra tài khoản đã tồn tại và độ an toàn của mật khẩu.
- Xác thực số điện thoại/email nếu hệ thống yêu cầu.
- Sau khi đăng ký thành công, chuyển sang cập nhật hồ sơ cá nhân hoặc màn hình chính.

### 3. Màn hình quên mật khẩu

Màn hình khôi phục quyền truy cập tài khoản.

- Nhập số điện thoại/email đã đăng ký.
- Gửi và xác nhận mã OTP hoặc đường dẫn khôi phục.
- Nhập mật khẩu mới và xác nhận mật khẩu mới.
- Thông báo kết quả và quay lại màn hình đăng nhập.

## Profile

### 4. Màn hình hồ sơ cá nhân

Màn hình hiển thị và chỉnh sửa thông tin người chơi.

- Hiển thị tên, tuổi, giới tính, số điện thoại và địa chỉ.
- Hiển thị trình độ/hạng của người chơi.
- Cho phép cập nhật ảnh đại diện và thông tin cá nhân.
- Cho phép người dùng chọn hoặc cập nhật trình độ chơi.
- Có lối tắt tới lịch sử đấu và các thiết lập tài khoản.

### 5. Màn hình lịch sử đấu

Màn hình hiển thị các trận đã tạo hoặc đã tham gia.

- Danh sách trận theo thời gian, đối thủ, kết quả và điểm số.
- Phân biệt trận đang diễn ra, đã hoàn thành và đã huỷ.
- Lọc theo khoảng thời gian hoặc kết quả thắng/thua.
- Chọn một trận để xem chi tiết các lượt bắn, lần cộng/trừ điểm và lỗi đã ghi nhận.

## Game

### 6. Màn hình tạo phòng bắn đền

Màn hình thiết lập trận trước khi bắt đầu.

- Chọn số lượng người chơi và thêm người chơi theo tên hoặc hồ sơ.
- Chọn người bắn trước và thứ tự lượt ban đầu.
- Chọn loại trận theo luật 9 bi cơ bản.
- Cấu hình các bi có điểm và số điểm tương ứng cho từng bi.
- Hiển thị tóm tắt luật trước khi tạo phòng.
- Không cho bắt đầu nếu thiếu người chơi hoặc cấu hình điểm không hợp lệ.
- Khi xác nhận, tạo phòng và chuyển sang màn hình trong trận.

Luật cấu hình tại đây được dùng làm dữ liệu cố định cho toàn bộ trận. Người
dùng không nên thay đổi luật giữa trận nếu chưa kết thúc hoặc huỷ trận.

### 7. Màn hình trong trận

Màn hình chính để theo dõi và ghi nhận từng lượt bắn.

- Hiển thị danh sách người chơi, điểm hiện tại và người đang có lượt.
- Quy trình cộng điểm chính gồm ba bước:
  1. Chọn người chơi vừa ăn bi.
  2. Chọn hình bi mà người đó đã ăn. Mỗi hình bi hiển thị rõ số bi và số điểm
     tương ứng theo luật của phòng.
  3. Hệ thống chạy logic game, tính điểm cộng/trừ và cập nhật bảng điểm ngay.
- Sau khi cập nhật, hiển thị tóm tắt kết quả:
  - Người ăn bi được cộng điểm của bi đã chọn.
  - Người bắn trước đó bị trừ điểm tương ứng theo luật bắn đền.
  - Điểm mới của tất cả người chơi và người nhận lượt tiếp theo.
- Không cho chọn bi không tồn tại hoặc bi không có điểm theo cấu hình phòng.
- Việc chọn hình bi chỉ là dữ liệu đầu vào; người dùng không nhập trực tiếp số
  điểm để tránh sai lệch với logic game.
- Cho phép đánh dấu người chơi mắc lỗi và chọn trường hợp lỗi:
  - **TH1: ăn bi rồi mới mắc lỗi**: giữ nguyên lượt bắn hiện tại.
  - **TH2: chưa ăn bi đã mắc lỗi**: đổi cơ với người bắn trước đó; lượt tiếp theo
    thuộc về người trước đó và hai người đổi lượt bắn cho nhau.
- Cho phép hoàn tác lượt vừa nhập trong thời gian ngắn nếu chọn nhầm người hoặc
  nhầm bi; hoàn tác phải khôi phục cả điểm, lượt bắn và lịch sử.
- Lưu lịch sử từng lượt, bao gồm người bắn, bi ăn, lỗi, điểm cộng/trừ và người
  được chuyển lượt.
- Hiển thị trạng thái kết thúc trận và cho phép xem lại bảng điểm.

#### Thành phần giao diện nhập điểm

- **Danh sách người chơi**: các thẻ hoặc nút lớn, hiển thị tên, avatar, điểm
  hiện tại và trạng thái lượt. Người dùng chạm vào một người để bắt đầu nhập.
- **Bộ chọn bi**: lưới các nút hình bi. Mỗi nút gồm hình bi, số bi và điểm được
  cấu hình. Bi đang chọn phải có trạng thái nổi bật.
- **Tóm tắt kết quả**: hiển thị người được cộng, người bị trừ, số điểm thay
  đổi và lượt tiếp theo sau khi logic game chạy.
- **Nút hoàn tác**: khôi phục trạng thái trước lượt vừa nhập, bao gồm điểm,
  lượt bắn và lịch sử trận.

Luồng thao tác chuẩn:

`Chọn người chơi -> Chọn hình bi -> Logic game chạy -> Cập nhật điểm`

Mọi thay đổi điểm phải được tạo từ một lượt bắn đã xác nhận, không cho sửa
trực tiếp tổng điểm mà không lưu lý do hoặc lịch sử thay đổi.

### 8. Màn hình chi tiết trận đấu

Màn hình xem lại một trận đã lưu.

- Hiển thị người chơi, luật đã dùng và kết quả cuối cùng.
- Hiển thị bảng điểm theo từng lượt.
- Hiển thị các lần ăn bi có điểm, người bị trừ điểm và các lỗi đã ghi nhận.
- Đối với lỗi TH1, thể hiện lượt vẫn được giữ nguyên.
- Đối với lỗi TH2, thể hiện việc đổi cơ và người nhận lượt tiếp theo.
- Cho phép xuất/chia sẻ kết quả nếu tính năng này được bật.

## Match

### 9. Màn hình tìm đối thủ

Màn hình tìm người chơi phù hợp theo kiểu lướt chọn.

- Hiển thị thẻ người chơi gồm tên, ảnh, trình độ/hạng, khu vực và thông tin
  chơi phù hợp.
- Vuốt trái để bỏ qua, vuốt phải để thể hiện muốn đấu.
- Cho phép lọc theo khoảng cách, trình độ, loại bida và thời gian rảnh.
- Không hiển thị người đã bị chặn hoặc đã bị bỏ qua theo chính sách ứng dụng.
- Khi hai người cùng chọn nhau, tạo một kết nối/match.

### 10. Màn hình chat và hẹn đấu

Màn hình trao đổi sau khi đã match.

- Hiển thị danh sách các cuộc trò chuyện và trạng thái kết nối.
- Cho phép gửi tin nhắn để thống nhất thời gian, địa điểm và loại trận.
- Cho phép gửi lời mời đấu, chấp nhận, từ chối hoặc huỷ lời mời.
- Có thể chuyển nhanh sang tạo phòng bắn đền với người đang chat.
- Cho phép báo cáo hoặc chặn người dùng.

## Map

### 11. Màn hình bản đồ quán bida

Màn hình tìm quán bida gần vị trí người dùng.

- Hiển thị vị trí hiện tại và các quán bida lân cận trên bản đồ.
- Hiển thị tên quán, khoảng cách, địa chỉ, giờ mở cửa và đánh giá nếu có dữ liệu.
- Cho phép tìm kiếm theo tên hoặc khu vực.
- Cho phép lọc theo khoảng cách, loại bàn hoặc tiện ích của quán.
- Chọn một điểm trên bản đồ để xem thông tin chi tiết và chỉ đường.
- Nếu người dùng không cấp quyền vị trí, cho phép chọn khu vực thủ công.
