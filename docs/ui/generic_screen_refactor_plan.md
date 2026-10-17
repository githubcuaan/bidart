# Kế hoạch refactor screens bằng generic và composition

## Mục tiêu

- Dùng generic cho dữ liệu: `AsyncContent<T>`.
- Dùng composition cho layout: `AppScreen`.
- Giữ nguyên giao diện, navigation, state và nghiệp vụ hiện tại.
- Không ép mọi screen kế thừa một `BaseScreen<T, Controller, State>` lớn.
- Không đổi kiến trúc provider, repository hoặc mô hình dữ liệu trong đợt này.

## Kiến trúc đích

```text
Mainscreen                         ← shell tab, drawer, navigation
├── Home                           ← nội dung
├── Rooms                          ← nội dung + AsyncContent<List<...>>
├── Maps                           ← nội dung
└── People                         ← nội dung + state riêng

AppScreen                          ← shell cho trang push riêng
├── ChoseRoom + AsyncContent<...>
├── InRoom + AsyncContent<...>
├── AddRoom
└── ProfileEditScreen

Profile                            ← nội dung drawer + AsyncContent<...>
```

| Component         | Trách nhiệm                                      |
| ----------------- | ------------------------------------------------ |
| `AppScreen`       | `Scaffold`, app bar, actions, FAB                |
| `AsyncContent<T>` | Hiển thị loading/error/data theo `AsyncValue<T>` |

`AppScreen` không cần type parameter: layout không phụ thuộc kiểu dữ liệu.

## Bước 1 — Chốt baseline và hành vi cần giữ

- [x] Chạy `flutter analyze`.
- [x] Chạy `flutter test`.
- [x] Ghi nhận lỗi có sẵn; không trộn sửa lỗi ngoài phạm vi.
- [x] Kiểm tra các nơi sử dụng screen trước khi thay shell.

### Kết quả rà soát call sites (2026-10-17)

Rà soát constructor, imports và navigation trong `lib/` và `test/`. Chưa thay shell hoặc chạy kiểm thử trong bước này.

| Screen                   | Nơi sử dụng hiện tại                                                                                    | Quyết định shell                                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `Mainscreen`             | `lib/main.dart`, `MaterialApp.home`                                                                     | Giữ shell gốc, drawer, bottom navigation và `IndexedStack`    |
| `Home`, `Maps`, `People` | `lib/screens/main_screen.dart`, children của `IndexedStack`                                             | Chỉ nội dung, không thêm `AppScreen`                          |
| `Rooms`                  | `Mainscreen`; tests trong `test/screens/rooms/room_flow_test.dart`                                      | Chỉ nội dung; giữ shell do cha/test cung cấp                  |
| `Profile`                | `Mainscreen.endDrawer`, bên trong `Drawer`                                                              | Không thêm `Scaffold`                                         |
| `ProfileEdit`            | `lib/screens/profile.dart`, `Navigator.push` từ Profile                                                 | Trang độc lập, có thể dùng `AppScreen`                        |
| `AddRoom`                | `Rooms`, `Navigator.push`; room flow tests                                                              | Trang độc lập, giữ app bar và thanh submit đáy                |
| `ChoseRoom`              | `Rooms` qua `push`; `AddRoom` qua `pushReplacement` sau tạo phòng hoặc mở phòng từ lỗi; room flow tests | Trang độc lập, có thể dùng `AppScreen`; giữ route replacement |
| `InRoom`                 | `ChoseRoom`, `Navigator.push`; room flow và in-room action tests                                        | Trang độc lập, có thể dùng `AppScreen`; giữ lifecycle         |

Các điều chỉnh cần áp dụng khi triển khai:

- Workspace hiện tại dùng `lib/screens/people.dart` và `lib/screens/profile.dart`, không có các thư mục screen People/Profile mô tả ở những bước sau. `People` hiện là placeholder; chưa có challenge/pass/reload cần migrate.
- Màn hình chỉnh sửa hiện tên `ProfileEdit`, nằm cùng file `lib/screens/profile.dart`, không phải `ProfileEditScreen` trong file riêng.
- `Profile` hiện render `ListView` đồng bộ, chưa có provider hoặc `.when(...)`; chưa cần `AsyncContent` cho screen này.
- `AddRoom` có `bottomNavigationBar: SafeArea(...)` chứa hành động submit. Bổ sung `Widget? bottomNavigationBar` vào API `AppScreen` trước khi migrate; không chuyển hành động này vào body hoặc FAB.
- Helper `pump` trong `test/screens/rooms/room_flow_test.dart` bọc mọi screen bằng `MaterialApp(home: Scaffold(body: screen))`. Giữ wrapper cho `Rooms`; khi sửa test cho trang độc lập, phân biệt content screen và standalone screen để tránh Scaffold lồng ngoài ý muốn.
- `test/screens/rooms/in_room_actions_test.dart` và một số room flow tests đã mount trang độc lập trực tiếp trong `MaterialApp.home`; duy trì khả năng sử dụng này.
- Phần kế hoạch bên dưới là hướng đích; đường dẫn, tên lớp và giả định dữ liệu phải theo kết quả rà soát này khi thực hiện.

Checklist hành vi:

- Đổi tab giữ state qua `IndexedStack`.
- Drawer hồ sơ mở đúng.
- Lọc phòng, tạo phòng, mở chi tiết hoạt động.
- Retry gọi đúng provider.
- Vào phòng và cập nhật điểm giữ nguyên.
- Form giữ validation, trạng thái lưu và dispose controller.
- People giữ challenge/pass/reload.

**Điều kiện hoàn thành:** có baseline để phân biệt regression với lỗi cũ.

## Bước 2 — Tạo AppScreen

File mới: `lib/widgets/screen/app_screen.dart`.

API đề xuất, chưa phải implementation hoàn chỉnh:

```dart
class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;

  // build trả về Scaffold.
}
```

- [x] Nhận `appBar` thay vì bắt buộc `title`, hỗ trợ tiêu đề động/actions/back riêng.
- [x] Không tự thêm padding, `SafeArea` hoặc scroll.
- [x] Không thêm drawer hoặc logic điều hướng tab; hỗ trợ `bottomNavigationBar` tùy chọn để giữ thanh submit của `AddRoom`.
- [x] Không chứa provider hoặc nghiệp vụ.
- [x] Kiểm tra các thuộc tính Scaffold hiện có trước khi migrate; thêm `bottomNavigationBar` theo nhu cầu thực tế.

**Điều kiện hoàn thành:** test xác nhận body, app bar và FAB hiển thị đúng.

## Bước 3 — Tạo AsyncContent<T>

File mới: `lib/widgets/async/async_content.dart`.

API đề xuất, chưa phải implementation hoàn chỉnh:

```dart
class AsyncContent<T> extends StatelessWidget {
  const AsyncContent({
    super.key,
    required this.value,
    required this.dataBuilder,
    required this.errorBuilder,
    this.loadingBuilder,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace stackTrace,
  ) errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final bool skipLoadingOnRefresh;
  final bool skipLoadingOnReload;
}
```

- [x] Chỉ render trạng thái; screen tiếp tục gọi `ref.watch`.
- [x] Loading mặc định là `Center(child: CircularProgressIndicator())`.
- [x] Retry nằm trong `errorBuilder`; screen truyền đúng `ref.invalidate` khi migrate.
- [x] Hỗ trợ cấu hình refresh/reload để giữ chính sách hiện tại khi migrate từng screen.
- [x] Không dùng `dynamic` hoặc ép kiểu.
- [x] Không tự coi `null` hoặc danh sách rỗng là lỗi.
- [x] Chưa tạo `AsyncListScreen<T>`: `AsyncContent<List<T>>` đủ cho Rooms.

**Điều kiện hoàn thành:** hoạt động với dữ liệu đơn, danh sách và kiểu nullable.

## Bước 4 — Viết test component trước khi migrate

Files mới:

```text
test/widgets/screen/app_screen_test.dart
test/widgets/async/async_content_test.dart
```

- [x] AppScreen hiển thị đúng body, app bar và FAB.
- [x] Loading hiển thị indicator mặc định.
- [x] Custom loading được dùng khi truyền vào.
- [x] Data truyền đúng giá trị vào builder.
- [x] Error truyền đúng lỗi và stack trace.
- [x] Nút retry gọi callback.
- [x] Refresh/reload giữ đúng chính sách hiển thị.
- [x] Danh sách rỗng vẫn đi qua `dataBuilder`.
- [x] Dữ liệu nullable do screen xử lý, không bị wrapper diễn giải lại.
- [x] Cùng component rebuild đúng qua loading → error → retry → data; giao diện trạng thái cũ được gỡ bỏ.

Kết quả: 15 widget tests pass (4 AppScreen, 11 AsyncContent); analyze các component và test tương ứng không có lỗi. Chưa migrate screen.

**Điều kiện hoàn thành:** test component pass độc lập.

## Bước 5 — Migrate Rooms làm pilot

File: `lib/screens/rooms/rooms.dart`.

- [x] Thay phần `ref.watch(...).when(...)` bằng `AsyncContent`.
- [x] Giữ `_status`, dropdown và nút tạo phòng.
- [x] Giữ `Expanded` bao vùng danh sách.
- [x] Giữ empty message, `ListView.builder`, widget keys và navigation.
- [x] Giữ `RoomLoadError` và retry đúng provider đang lọc.
- [x] Giữ `skipLoadingOnRefresh: false`.
- [x] Không bọc `AppScreen`: Rooms nằm trong shell `Mainscreen`.

Kết quả: 34 tests pass khi chạy room flow và widget component tests; analyze `rooms.dart` và `room_flow_test.dart` không có lỗi. Bổ sung regression test retry sau lỗi khi lọc phòng: hiển thị loading, giữ trạng thái lọc, trả đúng phòng và mở đúng chi tiết.

**Điều kiện hoàn thành:** loading/error/empty/data, filter và retry đều pass.

## Bước 6 — Migrate chi tiết phòng

Thứ tự:

1. `lib/screens/rooms/chose_room.dart`.
2. `lib/screens/rooms/in_room.dart`.

- [x] Thay `Scaffold` bằng `AppScreen` nếu API đáp ứng nguyên trạng.
- [x] Thay `.when(...)` phần tải dữ liệu bằng `AsyncContent<Room>` với kiểu tường minh.
- [x] Giữ navigation, widget keys và nội dung riêng của từng screen.

Riêng InRoom:

- [x] Giữ `ConsumerStatefulWidget`.
- [x] Giữ `WidgetsBindingObserver`, lifecycle và cleanup.
- [x] Không đưa scoring actions, listener hoặc side effects vào generic widget.
- [x] Giữ trạng thái loading của từng action.

Kết quả: 54 tests pass khi chạy `flutter test --no-pub test/screens/rooms test/widgets`; analyze hai screen và room flow tests không có lỗi. Thêm hai test mount trang độc lập, xác nhận một Scaffold, loading ban đầu và loading khi refresh. Các test hiện có kiểm tra navigation/back, retry, scoring actions, lifecycle và cleanup tiếp tục pass.

**Điều kiện hoàn thành:** mở phòng, cập nhật dữ liệu, quay lại và lifecycle không đổi.

## Bước 7 — Migrate hồ sơ

### Profile

File hiện tại: `lib/screens/profile.dart`.

- [x] Xác nhận Profile hiện render dữ liệu đồng bộ, không có `userAsync.when(...)`; chưa cần `AsyncContent` hoặc provider mới.
- [x] Giữ các card và nội dung hiện có.
- [x] Không thêm `AppScreen`: đây là nội dung drawer.

### ProfileEdit

File hiện tại: `lib/screens/profile.dart`, lớp `ProfileEdit`.

- [x] Chỉ thay shell bằng `AppScreen`.
- [x] Giữ form key, controllers, validation, save và dispose.

Kết quả: 19 tests pass khi chạy profile và widget component tests. Bổ sung 4 tests cho drawer → editor, validation, save/loading/confirmation, hủy và mở lại form, dispose trong khi save. Save vẫn là hành vi giả lập hiện có, không bổ sung persistence.

**Điều kiện hoàn thành:** drawer tải đúng; sửa/lưu hồ sơ không regression.

## Bước 8 — Migrate AddRoom

File: `lib/screens/rooms/add_room.dart`.

- [x] Thay shell bằng `AppScreen`, giữ `bottomNavigationBar` chứa nút submit.
- [x] Giữ state và controller hiện tại.
- [x] Dùng `AsyncContent<List<RuleTemplate>>` cho danh sách mẫu luật, giữ hành vi ẩn (shrink) khi loading, lỗi hoặc rỗng.
- [x] Không tạo `BaseFormScreen` lúc này: form tạo phòng và sửa hồ sơ chưa có abstraction chung đủ rõ.

Kết quả: 59 tests pass khi chạy `flutter test --no-pub test/screens test/widgets`; analyze `add_room.dart` và `room_flow_test.dart` không có lỗi. Test mới xác nhận AddRoom có đúng một Scaffold qua AppScreen, thanh submit bị khóa khi form chưa hợp lệ, loading mẫu luật không chặn form, và áp dụng mẫu vẫn hoạt động.

**Điều kiện hoàn thành:** chọn template, validation, submit và bàn phím hoạt động như trước.

## Bước 9 — Chuẩn hóa các tab còn lại

### People

File hiện tại: `lib/screens/people.dart`.

Rà soát lại cho thấy `People` hiện chỉ là placeholder `StatelessWidget` trả về `Center(child: Text('he'))`, không còn hai nhánh `Scaffold` như mô tả ban đầu. Không có challenge/pass/reload/mock data để migrate.

- [x] Kiểm tra mọi nơi sử dụng: chỉ dùng trong `IndexedStack` của `Mainscreen`.
- [x] Xác nhận không có `Scaffold` con cần bỏ.
- [x] Không thêm `AppScreen` hay `PeopleTopBar` cho placeholder.
- [x] Không thay đổi nội dung hoặc thêm state ngoài phạm vi refactor.
- [x] Ghi nhận challenge/pass/reload chưa tồn tại trong workspace hiện tại.

### Home và Maps

- [x] Giữ widget nội dung đơn giản.
- [x] Không thêm generic hoặc wrapper không cần thiết.

### Mainscreen

- [x] Giữ `Scaffold`, drawer, bottom navigation và `IndexedStack`.
- [x] Không migrate shell đặc thù sang `AppScreen`.

Kết quả: không có thay đổi code ở bước này vì các tab đã đúng kiến trúc đích. Bổ sung `test/screens/main_screen_test.dart` với 4 tests: một AppBar/Scaffold duy nhất, đổi tab không mất state lọc phòng, drawer mở đúng và đóng lại, và các tab placeholder không có shell lồng nhau.

**Điều kiện hoàn thành:** không có app bar kép, mất SnackBar hoặc reset state tab.

## Bước 10 — Kiểm thử tổng và dọn code

- [ ] Format các file được thay đổi bằng `dart format`.
- [ ] Chạy `flutter analyze`, đối chiếu baseline.
- [ ] Chạy `flutter test`, đối chiếu baseline.
- [ ] Chỉ dọn imports/helper khi không còn sử dụng.

Manual smoke test:

- [ ] Chuyển tab rồi quay lại, state được giữ.
- [ ] Mở/đóng drawer và sửa hồ sơ.
- [ ] Danh sách phòng: loading/error/empty/data.
- [ ] Filter rồi retry đúng danh sách đang chọn.
- [ ] Tạo phòng → mở chi tiết → vào phòng.
- [ ] People: pass/challenge đến empty rồi reload.
- [ ] Form khi bàn phím mở và trên màn hình nhỏ.

## Thứ tự triển khai

| Đợt | Phạm vi |
|---|---|
| 1 | Baseline, AppScreen, AsyncContent<T> và tests |
| 2 | Rooms pilot và ChoseRoom |
| 3 | InRoom và regression tests |
| 4 | Profile, ProfileEditScreen và AddRoom |
| 5 | People và kiểm thử tổng |

## Tiêu chí nghiệm thu

- Shell và async rendering được dùng chung đúng nơi.
- Từng screen vẫn sở hữu state, provider, navigation và nghiệp vụ riêng.
- Không thêm Scaffold lồng nhau ngoài nhu cầu có chủ đích.
- Không đổi hành vi refresh/reload, validation hoặc lifecycle.
- Không phát sinh lỗi analyze/test mới so với baseline.
- Không có generic class khổng lồ hoặc abstraction chưa có nhu cầu thực tế.
