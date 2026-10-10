# Mô tả giao diện ứng dụng (từ `scratch/*.html` + đề xuất cho tab chưa có mẫu)

Nguồn scratch: `scratch/createRoom.html`, `scratch/inGame.html`, `scratch/tinder.html`, `scratch/map.html`.
Tab chưa có mẫu (`Home`, `Profile`): mô tả đề xuất giữ cùng style. Logic nghiệp vụ xem `docs/rule.md`, `docs/screens.md`.

## 0. Khung chung (áp dụng cả 4 mẫu)

- Nền dark: `surface #0f131d`, chữ `on-surface #dfe2f1`, chữ phụ `on-surface-variant #bbcabf`.
- Màu nhấn: `primary #4edea3` (xanh lá bàn bida), `primary-container #10b981` (nút CTA),
  `secondary #ffb95f` (vàng/cam điểm số, rating), `error #ffb4ab` / `error-container #93000a` (phạt, bỏ qua).
- Font `Plus Jakarta Sans` (400/600/700/800). Icon `Material Symbols Outlined`.
- Header (AppBar): trái là title theo tab, phải là avatar tròn (`CircleAvatar`).
  Bấm avatar -> mở drawer phải (`endDrawer`) chứa Profile. Không dùng nút back; vuốt/bấm ngoài để đóng.
- Bottom nav (`lib/widgets/naviBar.dart:18`): 4 tab Material `NavigationBar`
  `Home (home)` | `Room (create)` | `Map (map)` | `People (people)`.
  Map với `Map` = tab `CLB Quán` (mẫu `map.html`), `People` = tab `Tìm kèo` (mẫu `tinder.html`),
  `Room` = tab `Phòng` (mẫu `createRoom.html` + `inGame.html`).
  Icon outlined khi chưa chọn, filled khi active. Không còn tab `Profile`.
- Layout mobile-first, `main` chừa `pt-16 pb-28` để khỏi bị header/nav che, bo góc chủ đạo `rounded-xl/2xl`.

---

## 1. Tab Phòng — trang chính + 2 trang con

Tab `Phòng` là đầu mối luồng game, gồm 1 trang chính và 2 trang con.
Điều hướng: `Phòng (chính) -> Tạo phòng (con) -> Trong phòng (con)`.
Nút back trên 2 trang con quay về cấp cha, bottom nav giữ nguyên tab `Phòng` active.

### 1.0. Trang chính Phòng (chọn phòng + tạo phòng) — chưa có mẫu scratch

Mục đích: điểm vào duy nhất; user chọn phòng có sẵn để vào, hoặc rẽ sang tạo phòng mới.

Bố cục đề xuất (giữ style khung chung):

1. Header tab `Phòng`.
2. Hàng CTA chính: nút `Tạo phòng mới` (primary, icon `add_circle`) -> sang trang con 1.1.
3. Danh sách phòng (chọn để vào):
   - Mỗi hàng: tên/mã phòng (`Phòng #09`), luật (`9 Bi Bắn Đền`), số người (`4/5`),
     trạng thái (`Đang đánh Vòng 4` / `Chờ` / `Xong`), vai trò (`Chủ phòng`/`Khách`).
   - Bấm hàng -> sang trang con 1.2 (trong phòng). Phòng đang đánh hiển thị live dot + timer.
4. Trạng thái rỗng: illustration + `Chưa có phòng nào` + nút `Tạo phòng ngay`.
5. Không tự tạo phòng tại trang chính; form cấu hình nằm hết ở trang con 1.1.

### 1.1. Trang con Tạo phòng (`scratch/createRoom.html`) — UI giữ nguyên như mẫu

Mục đích: cài đặt trận bắn đền trước giờ đề-pa (số người, thứ tự, điểm từng bi, phạt).

Bố cục từ trên xuống:

1. Dòng trạng thái: chấm xanh nhấp nháy + `Phòng thi đấu cá cược` (primary, uppercase),
   phải là badge `Chuẩn 9 Bi Quốc Tế` (icon `military_tech`, nền secondary mờ).
2. Tiêu đề `Cài đặt & Tạo phòng Bắn Đền` (`headline-sm`)
   + mô tả phụ: thiết lập thứ tự ra cơ, biểu điểm, luật đền từng bi.
3. Banner ảnh bàn bida (cao 128px, bo `xl`, overlay gradient):
   nhãn `Luật Đấu Solo & Hội Nhóm`, dòng đậm `Quy luật luân phiên: Người trước đền người sau`,
   dòng mờ `Tự động trừ phạt khi mắc lỗi gãi cơ`.
4. Section `Số người chơi` (card `surface-container-low`):
   - Header hàng: icon `group` + tên + mô tả `Chọn quy mô bàn thi đấu` + chip `Vòng tròn khép kín`.
   - Chips chọn số người: grid 4 cột `2 / 3 / 4 / 5 Người`. Mặc định active `4 Người`
     (nền `primary-container`, chữ `on-primary-container`, bóng xanh). Bấm chip đổi active (JS).
   - Roster `Thứ tự ra cơ xoay tua` (icon `cached`, nút `Thêm cơ thủ` icon `person_add`):
     4 hàng, mỗi hàng gồm số thứ tự vòng tròn + avatar (ảnh hoặc chữ tắt TH/LQ/MB)
     + tên + hạng + ghi chú lượt (`Đề-pa lượt 1` / `Lượt 2 (Đền sau Bạn)` / `Lượt 3` / `Lượt 4 (Đền cho Bạn)`)
     + 2 nút mũi tên lên/xuống (`swap-up/down-btn`) để đổi thứ tự (JS đảo DOM).
5. Section `Cấu hình điểm số từng bi` (icon `tune`):
   - Header + nhãn `Tự do bật/tắt`.
   - 8 hàng Bi 1–8, mỗi hàng: viên bi tròn màu chuẩn quốc tế
     (1 vàng `#facc15`, 2 xanh dương `#2563eb`, 3 đỏ `#ef4444`, 4 tím `#9333ea`,
     5 cam `#f97316`, 6 xanh lá `#16a34a`, 7 nâu `#854d0e`, 8 đen `#18181b`)
     + tên bi + dòng điểm (`Người trước: -10đ...` màu error, hoặc `Không tính điểm` màu mờ)
     + ô input số (điểm) + toggle switch.
     Mẫu mặc định: bật 1 (10đ), 3 (10đ), 5 (15đ), 7 (20đ), 8 (20đ); tắt 2, 4, 6 (mờ `opacity-60`, input disabled = 0).
   - Khối riêng `Bi 9 Đặc Biệt (Quyết định)` (viền secondary, icon `stars`):
     bi 9 trắng sọc vàng + mô tả `Ăn bi 9 kết thúc ván lập tức` + input lớn `50 điểm`
     + hàng checkbox `Nhân đôi (x2) điểm bi 9 nếu dọn bàn từ bi 1` (checked, hiển thị `+100đ`).
   - Khối `Phạt Lỗi Gãi / Nhảy Bi` (viền error, icon `warning`):
     mô tả `Lỗi phạm quy, nhảy bi ra ngoài bàn` + input `-20 điểm` màu error.
6. Section `Tóm tắt điều lệ phòng bắn đền` (nền `surface-container-high`, icon `assignment`):
   3 bullet: quy tắc đền điểm (ăn được cộng, người trước bị trừ, bi tắt không tính);
   xử lý phạm quy TH1/TH2 (mất lượt, trừ điểm, bi trong tay);
   khai cuộc đề-pa (số 1 phá, ăn hợp lệ giữ cơ, không thì chuyển số 2).
7. Khối CTA cuối: nút chính `Bắt đầu ván đấu ngay` (icon `play_circle`,
   nền `primary-container`, cao ~56px, bóng xanh, hiệu ứng scale khi bấm)
   + nút phụ `Lưu mẫu cài đặt này (Bộ luật yêu thích)` (icon `bookmark_add`).
   Bấm `Bắt đầu` = tạo phòng xong -> push sang trang con 1.2 (trong phòng).

---

### 1.2. Trang con Trong phòng (`scratch/inGame.html`) — UI giữ nguyên như mẫu

Mục đích: ghi nhận từng lượt bắn trong phòng vừa tạo/vừa vào, tự đối soát cộng/trừ theo luật đền.

Bố cục từ trên xuống:

1. Strip trận (card blur): trái là chấm live + `Live Match • Vòng 4` (primary uppercase)
   + `Phòng #09 • 9 Bi Bắn Đền` (`title-md`); phải là chip timer icon `timer` + `28:14` màu secondary.
2. Nhóm `Lượt đánh & Điểm số hiện tại` + chú thích `Thứ tự bắn đền xoay vòng`:
   4 thẻ người chơi bấm được (`selectPlayer` đổi highlight):
   - P1 active (Tuấn Anh/Bạn): viền trái primary + bóng xanh, avatar 44px + badge `sports_esports`,
     chip `Đang có cơ`, dòng `Đang nhắm bắn Bi 9`, điểm `+45đ` primary + `Dẫn đầu`.
   - P2 (Huy Bida): chip `Bắn trước đó` nền error, cảnh báo `Nguy cơ chịu đền nếu Tuấn Anh ăn`,
     điểm `-15đ` error + `Hạng 3`.
   - P3 (Minh Rasson): `Lượt tiếp: Sau Tuấn Anh`, `+10đ` secondary + `Hạng 2`, mờ 80%.
   - P4 (Hoàng Long): `Chờ vòng mới`, `-40đ` error + `Hạng 4`, mờ 80%.
3. Section `Chạm Chọn Bi Vừa Vào Lỗ` (card blur, nhãn `Thao Tác Ghi Nhận Lượt`, chip `Chuẩn 9-Ball`):
   lưới 3 cột × 3 hàng, mỗi ô là nút bi (`ball-card`, cao 96px):
   viên bi gradient màu chuẩn + số trắng ở giữa + điểm bên dưới
   (1:5, 2:5, 3:10, 4:10, 5:15, 6:15, 7:20, 8:25, 9:+50đ Kèo).
   Bi đang chọn (mặc định Bi 9) nổi bật: nền `surface-container-highest`,
   phát sáng cam `rgba(245,158,11,0.45)`, badge `Đang chọn` trên đỉnh. Bấm bi khác đổi glow + badge (JS `selectBall`).
4. Hộp `Hạch Toán Luật Bắn Đền` (icon `balance`, chip `Tự động đối soát`):
   banner công thức active: `Tuấn Anh ăn Bi 9: +50 điểm` (primary, icon `add_circle`)
   + `Huy Bida chịu đền: -50 điểm` (error, icon `remove_circle`)
   + note (icon `info`): người hụt lượt trước đền toàn bộ điểm bi vừa rớt lỗ.
   Dòng trạng thái: `Lượt bắn kế tiếp: Tuấn Anh (Được Giữ Cơ Tiếp Tục)` (icon `bolt`).
5. Nhóm `Xử Lý Tình Huống Phạm Lỗi`: grid 2 cột:
   - TH1 (icon `warning`, chip đỏ): `Ăn bi rồi phạm quy` — bi rớt nhưng nhảy bi/chạm tay, `Giữ nguyên cơ` (icon `check_circle`).
   - TH2 (icon `swap_horiz`, chip vàng): `Đánh hụt / Mắc lỗi ngay` — không chạm băng/không ăn bi, `Chuyển cơ vòng sau` (icon `sync`).
   Mẫu dùng `alert` demo khi bấm.
6. Thanh thao tác cuối: grid 2 nút `Hoàn Tác (Undo)` (icon `undo`, secondary)
   + `Xem Nhật Ký` (icon `format_list_numbered`, tertiary)
   + nút chính `Xác Nhận & Chuyển Cơ` (cao 64px, nền `primary-container`, icon `check_circle`, bóng xanh).

---

## 3. Tìm kèo (`scratch/tinder.html`) — tab `Tìm kèo`

Mục đích: lướt thẻ cơ thủ kiểu Tinder để ghép kèo.

Bố cục từ trên xuống:

1. Header tab `Tìm Kèo` (cấu trúc header chung).
2. Khối `Radar Ghép Kèo`: hàng tiêu đề gồm chấm radar ping + tên + chip `Trực Tiếp`
   + nút `Bộ lọc` (icon `tune`). Bên dưới là chips cuộn ngang:
   `Q. Cầu Giấy (3km)` (icon `near_me`) | `Hạng C → A` (icon `military_tech`) | `9 Bi / Bắn Đền` (icon `sports_cricket`).
3. Chồng thẻ (tỉ lệ `3/4.4`, cao tối đa 560px): 2 thẻ ma phía sau (scale 0.95/0.98, mờ dần)
   + 1 thẻ active phía trước (`active-player-card`, bo `xl`, bóng lớn):
   - Ảnh full-bleed + 2 lớp gradient (đen dưới chân thẻ, đen mờ trên đỉnh).
   - Góc trên trái: chip `Độ hợp cạ: 94%` (icon lửa `local_fire_department`, blur).
     Góc trên phải: chip `Đã xác minh` (icon `verified`).
   - Tem swipe ẩn (opacity 0, hiện khi bấm/quẹt qua JS): `KÈO CHIẾN` (nền primary, xoay -12°)
     / `BỎ QUA` (nền error, xoay +12°) / `SIÊU KÈO ⚡` (bay lên).
   - Thân thông tin (padding `md`): ribbons `HẠNG B+ (ELO 1680)` (icon `stars`, nền secondary-container)
     + `Thắng 68% (142 ván)` (icon `trending_up`); tên `Đức 'Cơ Điên' • 27 tuổi` (`headline-md`);
     hàng vị trí `Cách 1.8 km • Rảnh tại King Billiards` (icon `near_me`, vế sau màu primary);
     hộp kèo (icon `monetization_on`): `Chuyên 9 Bi Bắn đền 20k-50k/điểm • Đánh giao lưu học hỏi • Có cơ riêng Peri`;
     tags phụ: `Không hút thuốc` / `Đánh tối nay 19:30` / `Chia đôi tiền bàn`.
4. Thanh hành động 3 nút tròn: `Bỏ qua` X đỏ 56px (`close`) | `Siêu thích` bolt xanh 48px (`bolt`, fill)
   | `Thách đấu` primary 64px + bóng xanh (`sports_score`, fill).
   JS: phải = bay phải + tem KÈO CHIẾN, trái = bay trái + BỎ QUA, siêu = bay lên + SIÊU KÈO, rồi reset thẻ.
5. Khay `Cơ thủ online quanh đây` (`5 người sẵn sàng`, icon `groups`):
   hàng ngang 5 avatar tròn 48px + chấm xanh online + tên + hạng/ELO
   (Hoàng L. A 1750, Trang Bi B+ 1620, Tuấn Anh C+ 1480, Minh Pro B 1590, Khang B. C 1420).

---

## 4. CLB Quán (`scratch/map.html`) — tab `CLB Quán`

Mục đích: tìm quán bida gần vị trí, xem bàn trống, chỉ đường / đặt bàn.

Bố cục từ trên xuống:

1. Header tab `Clb Quán` (cấu trúc header chung).
2. Thanh tìm kiếm (card blur): icon `search` + input `Tìm quán bida, CLB, đường...`
   + nút định vị `my_location` (bấm hiện alert demo).
   Chips lọc cuộn ngang: `Gần nhất` (active primary, icon `near_me`)
   | `Bàn Rasson` | `Bàn Aileex King` | `Còn bàn trống` (chấm pulse) | `Mở 24/7` (icon `schedule`).
   Bấm chip đổi active (JS).
3. Canvas bản đồ (cao 400px, bo `xl`): ảnh nền + lớp lưới SVG tối + 3 đường mô phỏng
   + 1 đường traffic đứt nét primary; cụm nút phải `layers` / `add` / `remove`;
   điểm user (chấm primary + 2 vòng ping/pulse + nhãn `Vị trí của bạn`);
   3 pin quán bấm được (`selectClub` đổi bottom sheet):
   - `Legend • Rasson` (selected): nhãn nổi + pin bi 9 phát sáng xanh + chóp tam giác.
   - `Arena Pool Club`: pin bi 8 tối, mờ 85%.
   - `King Billiards`: pin bi 1 vàng, mờ 85%.
4. Bottom sheet chi tiết quán (`club-detail-sheet`, card blur, bóng lớn):
   - Hàng định danh: thumbnail vuông 80px + chip tag (`Đang chọn • CLB Tiêu Chuẩn`)
     + nút bookmark + tên `Legend Billiards Club` + địa chỉ `18 Hoàng Đạo Thúy...`
     + hàng rating (sao fill + `4.9 (240)`) • khoảng cách (icon `directions_car` + `850m (4 phút)`).
   - Banner bàn live: icon `table_restaurant` + `Trạng thái bàn trực tiếp`
     + `Còn 5 bàn trống (3 bàn Rasson Chronos, 2 bàn Min)` + badge `Live` ping.
   - Hàng giá: `Giá dịch vụ: 80.000đ - 120.000đ / giờ` (secondary đậm).
   - Chips tiện ích: `Điều hòa 100%` (`ac_unit`) / `Chỗ để ô tô` (`local_parking`)
     / `Cơ chuẩn quốc tế` (`verified`) / `Đồ ăn nhẹ` (`fastfood`).
   - 2 nút: `Chỉ đường` (4/12, icon `turn_right`, alert mở bản đồ)
     + `Đặt bàn / Hẹn kèo` (8/12, primary, icon `bolt`, bóng xanh, alert giữ bàn).
   - Dữ liệu mẫu 3 quán nằm trong `CLUBS_DATA` (legend/arena/king: tên, địa chỉ, rating,
     khoảng cách, trạng thái bàn, giá, tag, tiện ích).
5. Card cộng đồng `Kèo đang mở gần quán này` (`Xem tất cả (8)`):
   hàng gồm avatar + badge `B+` + tên `Vinh "Tay Trái"` + `Rank B+`
   + `9-Ball Solo • Chấp 1 ván • Đang có mặt` + nút `Vào bắt kèo` (hover thành primary).

---

## 5. Profile (`lib/screens/profile.dart`) — drawer phải từ avatar AppBar, chưa có mẫu scratch

Profile không nằm ở bottom nav. Entry duy nhất: avatar tròn ở góc phải AppBar.
Bấm avatar -> `endDrawer` trượt ra từ cạnh phải màn hình (rộng ~80%, full-height,
nền `surface-container-low`, bo trái `xl`). Nội dung drawer chính là `Profile()`.
Bấm vùng tối ngoài drawer hoặc vuốt phải để đóng; tab nav bên dưới giữ nguyên.
Chi tiết field xem `docs/screens.md` §4 (hồ sơ) + §5 (lịch sử đấu).

### 5.1. Xem thông tin cá nhân (mặc định)

Bố cục từ trên xuống:

1. Nút `edit`/dòng `Chỉnh sửa hồ sơ` trong drawer (cấu trúc header chung).
2. Card định danh: avatar tròn lớn (bấm để đổi ảnh) + tên + chip hạng (`Hạng B+`, đồng bộ chip header)
   + dòng phụ tuổi/giới tính/khu vực (vd `27 tuổi • Nam • Cầu Giấy`).
   Nút icon `edit` góc phải -> sang chế độ 5.2.
3. Hàng thống kê nhanh (3 ô): `Tổng trận` / `Thắng %` / `ELO` (vd `142` / `68%` / `1680`).
   Kiểu số `headline-sm`, nhãn `label-sm` màu phụ — tái dùng ribbon kiểu thẻ Tìm kèo.
4. Nhóm `Thông tin liên hệ`: các hàng icon + giá trị
   (`phone` số điện thoại, `email` email, `location_on` địa chỉ, `military_tech` trình độ/hạng).
   Mỗi hàng 1 dòng, icon màu primary, chữ tràn thì ellipsis.
5. Nhóm lối tắt (menu list, mỗi hàng icon + tên + `chevron_right`):
   - `Lịch sử đấu` (`history`) -> `docs/screens.md` §5 (list theo thời gian, lọc thắng/thua, bấm vào xem chi tiết lượt/bi/lỗi).
   - `Bộ luật yêu thích` (`bookmark`) -> mẫu đã lưu ở trang con Tạo phòng 1.1.
   - `Quán đã lưu` (`location_on`) -> quán bookmark ở tab CLB Quán.
   - `Cài đặt tài khoản` (`settings`): đổi mật khẩu, OTP, đăng xuất, xóa tài khoản.

### 5.2. Chỉnh sửa thông tin cá nhân

Vào từ nút `edit` / `Chỉnh sửa hồ sơ` ở card định danh. Có thể là trang con push hoặc bottom sheet
full-height; nút back hủy thay đổi chưa lưu.

1. Đổi avatar: bấm avatar -> picker ảnh (chụp/tải lên), preview tròn + nút `Xóa ảnh`.
2. Form text field (giữ dark input như ô tìm kiếm tab CLB Quán):
   tên hiển thị (bắt buộc), tuổi, giới tính (dropdown Nam/Nữ/Khác), số điện thoại, địa chỉ.
   Validate inline: tên trống, SĐT/email sai định dạng -> text error đỏ dưới field, disable nút Lưu.
3. Chọn trình độ/hạng: chips hoặc dropdown đơn chọn theo `SkillLevel`
   (`lib/core/enum/skill_level.dart`), hiển thị `code` + `displayName` + tooltip `description`.
   Đây là `selfDeclaredLevel` (tự khai báo), khác ELO tính từ thắng/thua.
4. Thanh CTA cuối: nút chính `Lưu thay đổi` (primary, disable khi form invalid/dirty-check)
   + nút phụ `Hủy`. Lưu thành công -> toast/snackbar + quay về 5.1 với dữ liệu mới.
5. Trạng thái: đang lưu hiển thị loading trên nút; lỗi mạng giữ form + báo lỗi, không mất dữ liệu đã nhập.
