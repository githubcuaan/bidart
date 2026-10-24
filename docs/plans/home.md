# Plan — Trang Home (tab 0)

Ngày lập: 2026-10-23. Trạng thái: chờ duyệt, chưa implement.

## 1. Mục tiêu

Thay `lib/screens/home.dart` (đang là `Text('he')`) bằng dashboard local:

- Trả lời ngay "đang có trận nào không" → tiếp tục trận.
- Vào nhanh tạo phòng / danh sách phòng.
- Tổng quan số liệu local (phòng, ván, đã xong).
- Phòng gần đây để xem lại.
- Empty state hướng dẫn user mới.

Không phải danh sách phòng thứ hai. Không ghi điểm ở Home. Không thêm backend,
dependency, schema hay migration.

## 2. Quyết định thiết kế

| #   | Quyết định                                                       | Lý do                                                                           |
| --- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| D1  | Dùng `roomListProvider(null)`, tính active/recent/stats ở client | Cùng family instance với tab Room mặc định → không query thêm; tránh API mới    |
| D2  | Active card dùng `RoomHeaderSection` + watch `roomByIdProvider`  | Tái dùng `RoomHeaderSection` chuẩn (LIVE badge, countdown, mục tiêu); 1 query thêm chỉ khi có phòng active |
| D3  | Bấm active card → `ChoseRoom(roomId)`, không vào thẳng `InRoom`  | Giữ 1 bước xác nhận, tránh mở nhầm màn ghi điểm; tái dùng luồng có sẵn          |
| D4  | Chuyển tab bằng callback từ `Mainscreen` (`onOpenRooms`)         | Tab index là state private của `Mainscreen`; không thêm global nav provider     |
| D5  | Tách `home.dart` thành `lib/screens/home/home.dart` + `widgets/` | Theo pattern `lib/screens/rooms/`; file dưới 250 dòng dễ test                   |
| D6  | Không hiển thị ngày/giờ tương đối, không thêm `intl`             | `intl` chỉ là transitive, không nên import trực tiếp                            |

## 3. Dữ liệu

Nguồn: `roomListProvider(null)` → `List<RoomSummary>` (repository đã sort
`createdAt DESC`, tie-break `id ASC`; giữ nguyên thứ tự này).

Đây là **view model / read projection của UI**, không phải DTO: không serialize,
không persist, không đi qua boundary repository/network, không có logic nghiệp
vụ. Nó chỉ gom việc chọn active/recent/stats ra khỏi widget để unit test được.
`RoomSummary` (repository trả về) mới là read model gần DTO.

Projection thuần Dart, test riêng được:

`lib/screens/home/home_snapshot.dart`

```dart
class HomeSnapshot {
  const HomeSnapshot({
    required this.active,
    required this.recent,
    required this.roomCount,
    required this.gameCount,
    required this.finishedCount,
  });

  factory HomeSnapshot.from(List<RoomSummary> rooms);

  final RoomSummary? active;      // firstWhereOrNull status == active
  final List<RoomSummary> recent; // non-active, take 3
  final int roomCount;            // rooms.length
  final int gameCount;            // sum gameCount
  final int finishedCount;        // status == finished
}
```

Quy tắc:

- Nhiều hơn 1 phòng `active` (vi phạm invariant): lấy phòng đầu tiên, không throw.
  UI vẫn mở được; ghi chú trong code.
- `recent` loại phòng active để không trùng card "tiếp tục trận".
- Danh sách rỗng → `active == null`, `recent` rỗng, stats toàn 0.

## 4. Bố cục

Home là **body của tab**, nằm trong `IndexedStack` + `Scaffold`/`AppBar` của
`Mainscreen`. Không thêm `Scaffold`, `AppBar`, `AppScreen`.

```
RefreshIndicator(onRefresh: invalidate)
└─ ListView(AlwaysScrollableScrollPhysics, padding 16)
   ├─ Text "Sẵn sàng vào bàn?"            (headlineSmall, bold)
   ├─ Text "Trận đấu tự lưu trên máy..."   (bodyMedium, onSurfaceVariant)
   ├─ SizedBox 16
   ├─ ActiveRoomCard | NewRoomCard        key: home-active-room / home-start-card
   ├─ SizedBox 12
   ├─ HomeQuickActions                    key: home-create-room, home-open-rooms
   ├─ SizedBox 20
   └─ AsyncContent<List<RoomSummary>>     (data block)
      ├─ loading  → padding + CircularProgressIndicator
      ├─ error    → RoomLoadError(onRetry: invalidate)   key: home-load-error
      └─ data:
         ├─ HomeStatsRow                   key: home-stats
         ├─ SizedBox 20
         ├─ RecentRoomsSection             key: home-recent-list
         └─ (rooms.isEmpty) HomeEmptyState key: home-empty-state
```

Thứ tự ưu tiên thị giác: active card > CTA tạo phòng > stats > recent.
Empty state thay cho stats + recent khi chưa có phòng nào (không hiện số 0 vô nghĩa).

### 4.1. ActiveRoomCard

- Tái dùng trực tiếp `RoomHeaderSection` (`lib/screens/rooms/in_room/widgets/sections/room_header_section.dart`).
- `ActiveRoomCard` là `ConsumerWidget` nhận `roomId` (hoặc `RoomSummary active`), gọi `ref.watch(roomByIdProvider(roomId))` và `ref.read(clockProvider)` cho `now`.
- Hiển thị thông qua `RoomHeaderSection(room: room, now: () => ref.read(clockProvider)())`:
  - Dot trạng thái semantic + chữ `LIVE MATCH` nổi bật.
  - Tên phòng (`room.name`, `headlineSmall`, w600).
  - Tự động hiển thị countdown thời lượng còn lại (`RoomDurationCountdown`) và điểm mục tiêu nếu phòng có thiết lập `endConditions`.
  - Đảm bảo nhất quán 100% về UI/UX và logic đếm giờ với `InRoom` và `ChoseRoom`.
- Tương tác điều hướng:
  - Bọc `RoomHeaderSection` trong `InkWell` (hoặc action tap với `key: const ValueKey('home-active-room')`) → tap vào card mở `ChoseRoom(roomId)`.
- Trạng thái loading / error từ `roomByIdProvider`:
  - `loading`: hiển thị card placeholder (shimmer hoặc khung kích thước tương đương) để tránh layout shift.
  - `error`: hiển thị thông báo lỗi rút gọn kèm nút thử lại (`ref.invalidate(roomByIdProvider(roomId))`).

### 4.2. Không có phòng active

`NewRoomCard`: card viền đứt (`outlineVariant`), icon `play_circle_outline`,
text `Chưa có trận nào đang chơi`, `FilledButton.icon('Tạo phòng mới')`
→ push `AddRoom`. Key `home-start-card`.

### 4.3. HomeQuickActions

Hàng `Wrap` (spacing 12):

- `FilledButton.icon(Icons.add, 'Tạo phòng mới')` → push `AddRoom`,
  key `home-create-room`.
- `OutlinedButton.icon(Icons.list_alt, 'Tất cả phòng')` → gọi
  `widget.onOpenRooms?.call()`, key `home-open-rooms`.
- Disable cả hai khi `value.isLoading`? Không. Chỉ disable nút tạo khi đang có
  phòng active? Không — `AddRoom` đã xử lý `ActiveRoomExistsFailure` và có
  `CreateRoomErrorPanel`. Giữ nguyên hành vi.

### 4.4. HomeStatsRow

3 ô đều nhau, tái dùng style `_MetricTile` của `RoomHeaderSection` (copy token,
không import private class):

| Nhãn    | Giá trị         | Nguồn                |
| ------- | --------------- | -------------------- |
| Phòng   | `roomCount`     | `rooms.length`       |
| Ván     | `gameCount`     | tổng `gameCount`     |
| Đã xong | `finishedCount` | `status == finished` |

Số `titleMedium` bold, nhãn `labelSmall` `onSurfaceVariant`. Không ELO, không
win rate, không điểm.

### 4.5. RecentRoomsSection

- Header hàng: `Phòng gần đây` (`titleMedium` bold) + `TextButton('Xem tất cả')`
  → `onOpenRooms`.
- Tái dùng `RoomListItem` (đã có key `room-<id>`, subtitle trạng thái/số
  người/số ván, tap → `ChoseRoom`).
- Tối đa 3 dòng. Không có dòng nào → ẩn cả section.
- Lưu ý: `IndexedStack` giữ tab Room trong cây widget; test trên `Mainscreen`
  có thể thấy 2 widget cùng key `room-<id>`. Test Home nên pump `Home` riêng.

### 4.6. HomeEmptyState

- Icon `sports_bar`/`golf_course` lớn, màu `primary` alpha 0.4.
- Tiêu đề `Chưa có phòng nào`.
- 3 bước:
  1. Tạo phòng, chọn 2–5 người, người đề-pa và người đền.
  2. Cấu hình điểm từng bi hoặc dùng bộ luật yêu thích.
  3. Ghi từng lượt trong phòng; undo được; app tự lưu khi đóng.
- CTA `FilledButton('Tạo phòng đầu tiên')` → `AddRoom`.

### 4.7. Refresh

- `RefreshIndicator.onRefresh`:
  `ref.invalidate(roomListProvider(null));` rồi
  `await ref.read(roomListProvider(null).future);` (bọc try/catch để lỗi hiện
  qua `AsyncContent`, không làm crash indicator).
- Không cần invalidate khi đổi tab: create/next-game/room actions đã
  `ref.invalidate(roomListProvider)` (kiểm tra tại
  `create_room_controller.dart:96`, `next_game_controller.dart:67`,
  `room_action_controller.dart:165`).

## 5. File thay đổi

Thêm:

```
lib/screens/home/home.dart
lib/screens/home/home_snapshot.dart
lib/screens/home/widgets/active_room_card.dart
lib/screens/home/widgets/new_room_card.dart
lib/screens/home/widgets/home_quick_actions.dart
lib/screens/home/widgets/home_stats_row.dart
lib/screens/home/widgets/recent_rooms_section.dart
lib/screens/home/widgets/home_empty_state.dart
test/screens/home/home_test.dart
```

Sửa:

```
lib/screens/home.dart              -> xóa, thay bằng lib/screens/home/home.dart
lib/screens/main_screen.dart       -> import mới; Home(onOpenRooms: ...)
test/screens/main_screen_test.dart -> import mới; bỏ kỳ vọng placeholder 'he'
docs/ui/ui_description.md          -> thêm mục "2. Tab Home" mô tả bố cục
```

Không đổi: domain, repository, provider, schema, `pubspec.yaml`.

## 6. Các bước implement

### Bước 1 — Snapshot + unit test

- [ ] Viết `HomeSnapshot.from`.
- [ ] Test: rỗng; 1 active + 3 finished; 4 finished (recent cắt còn 3);
      active không nằm trong recent; stats cộng đúng; 2 active → lấy first.
- Verify: `flutter test test/screens/home/home_test.dart`.

### Bước 2 — Khung Home + wiring tab

- [ ] Tạo `Home` là `ConsumerWidget` nhận `VoidCallback? onOpenRooms`.
- [ ] `Mainscreen`: truyền `onOpenRooms: () => setState(() => _indexSelected = 1)`.
- [ ] `Home` watch `roomListProvider(null)`.
- [ ] AppBar title giữ `Bidart`.
- [ ] Xóa `lib/screens/home.dart` cũ, sửa import.
- Verify: `flutter analyze`; app chạy, tab Home không còn "he".

### Bước 3 — Active card + empty/start card

- [ ] `ActiveRoomCard` (watch `roomByIdProvider(roomId)`, nhúng `RoomHeaderSection(room: room, now: ...)`, bọc tap → `ChoseRoom(roomId)`), `NewRoomCard`.
- [ ] Tap active card → `Navigator.push(ChoseRoom(roomId))`.
- [ ] Tap tạo → `Navigator.push(AddRoom())`.
- Verify widget test 2, 3.

### Bước 4 — Quick actions + stats

- [ ] `HomeQuickActions`, `HomeStatsRow`.
- [ ] `onOpenRooms` gọi đúng 1 lần.
- Verify widget test 4, 5.

### Bước 5 — Recent + empty state

- [ ] `RecentRoomsSection` (reuse `RoomListItem`).
- [ ] `HomeEmptyState`.
- Verify widget test 6, 7.

### Bước 6 — Loading / error / refresh

- [ ] `AsyncContent` với `loadingBuilder` có padding (tránh `Center` trong
      `ListView` gây lỗi unbounded height).
- [ ] `RoomLoadError` + retry invalidate.
- [ ] `RefreshIndicator`.
- Verify widget test 8, 9.

### Bước 7 — Dọn dẹp + docs

- [ ] Cập nhật `docs/ui/ui_description.md` mục Home.
- [ ] `flutter analyze` sạch.
- [ ] `flutter test` toàn bộ pass (hiện 188; thêm test mới).
- [ ] Smoke: tạo phòng → về Home thấy active card; kết thúc phòng → card biến
      mất, phòng vào recent; restart app → vẫn đúng.

## 7. Test plan (`test/screens/home/home_test.dart`)

Setup giống `room_flow_test.dart`: `InMemoryGameRepository`,
`clockProvider` cố định, `idFactoryProvider` tăng dần; helper `seed()` tạo
phòng rồi `updateRoom` để set status/game status.

| #   | Case                          | Kỳ vọng                                                                         |
| --- | ----------------------------- | ------------------------------------------------------------------------------- |
| 1   | Repo rỗng                     | `home-empty-state`, `home-start-card`, không có `home-stats`/`home-recent-list` |
| 2   | 1 active                      | `home-active-room` render `RoomHeaderSection` (LIVE MATCH, tên phòng, timer/mục tiêu nếu có); tap → `ChoseRoom` |
| 3   | Không active                  | `home-start-card`; tap CTA → `AddRoom`                                          |
| 4   | 1 active + 4 finished         | recent đúng 3, mới nhất trước, không chứa active                                |
| 5   | Stats                         | `Phòng 5`, `Ván 5`, `Đã xong 4`                                                 |
| 6   | `onOpenRooms`                 | Bấm `home-open-rooms` và `Xem tất cả` → callback gọi 1 lần/nút                  |
| 7   | Empty state                   | 3 bước hiển thị; CTA → `AddRoom`                                                |
| 8   | `listRooms` throw             | `home-load-error`; bấm thử lại → gọi lại repo                                   |
| 9   | Loading gate                  | `CircularProgressIndicator`; không có stats/recent                              |
| 10  | 2 active (dữ liệu bất thường) | Không crash, card dùng phòng đầu                                                |
| 11  | Pull-to-refresh               | `fling` xuống → invalidate + query lại (đếm call)                               |

Cập nhật `test/screens/main_screen_test.dart`:

- Đổi import `screens/home.dart` → `screens/home/home.dart`.
- Test `Placeholder tabs...`: bỏ `Home()` khỏi danh sách placeholder (Home giờ
  có nội dung thật); vẫn kiểm tra `Scaffold` đơn và không `AppScreen`.
- Thêm assert: tab Home hiển thị tiêu đề `Sẵn sàng vào bàn?` thay vì text rỗng.

## 8. Edge cases

- **Dữ liệu hỏng**: `roomListProvider` ném lỗi → error panel, không tự tạo
  phòng, không nuốt lỗi.
- **Nhiều active**: lấy first, UI không crash; invariant vẫn do tầng command bảo
  vệ.
- **Tên phòng dài**: ellipsis 2 dòng; card dùng `Expanded`, không overflow.
- **Text scale 1.5–2.0**: test surface 1000x1600; card dùng `Wrap`/`Flexible`,
  không `Row` cứng.
- **Màn nhỏ**: ListView cuộn; CTA vẫn chạm được (>= 48dp).
- **Tab Room đang filter**: Home dùng `roomListProvider(null)` riêng, không
  ảnh hưởng filter của tab Room.
- **Refresh khi đang lỗi**: vẫn kéo được (AlwaysScrollableScrollPhysics).

## 9. Acceptance criteria

- [ ] Tab Home không còn placeholder; `flutter analyze` sạch.
- [ ] Có phòng active → thấy card live, tap vào đúng `ChoseRoom`.
- [ ] Không có phòng → empty state + CTA tạo phòng hoạt động.
- [ ] Stats khớp dữ liệu local; recent tối đa 3, mới nhất trước.
- [ ] Tạo/kết thúc phòng ở tab Room → quay lại Home số liệu tự cập nhật
      (không cần restart).
- [ ] Lỗi đọc DB hiện panel + thử lại được; không crash.
- [ ] `flutter test` pass toàn bộ; test mới phủ 11 case trên.
- [ ] Không đổi domain/schema/dependency.

## 10. Ngoài phạm vi (P1+)

- Card teaser `Tìm kèo quanh đây` / `Quán gần bạn` → cần callback
  `onOpenPeople`/`onOpenMap`; làm sau khi có dữ liệu thật, tránh card giả.
- Điểm/người dẫn đầu chi tiết theo từng cơ thủ trong phòng active: hiện tại `RoomHeaderSection` hiển thị metadata trận (LIVE MATCH, tên phòng, countdown, điểm mục tiêu); bảng xếp hạng/điểm chi tiết từng người giữ ở `InRoom`/`ChoseRoom`.
- Lịch sử chi tiết, biểu đồ, streak, ELO → chưa có backend.
- Notification nhắc tiếp tục trận.
- Deep link `/room/:id`.

## 11. Rủi ro

| Rủi ro                                   | Giảm thiểu                                                                           |
| ---------------------------------------- | ------------------------------------------------------------------------------------ |
| Home thành bản sao tab Room              | Recent tối đa 3, có CTA trỏ sang tab Room; không filter/không full list              |
| Query trùng                              | Dùng đúng `roomListProvider(null)` — cùng instance với tab Room mặc định             |
| Query `roomByIdProvider` cho active room | Chỉ query thêm 1 lần khi có phòng active (tối đa 1 phòng); tận dụng cache Riverpod family |
| Stale sau thao tác                       | Dựa vào invalidate sẵn có; thêm pull-to-refresh                                      |
| Test vỡ do `IndexedStack` giữ cả 2 tab   | Test Home pump riêng, không qua `Mainscreen`                                         |
| Over-engineering                         | P0 chỉ 6 widget nhỏ, không state management mới                                      |
