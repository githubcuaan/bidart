# Plan: đổi UI phần setting điểm + bật/tắt bi

Phạm vi: `RulesDialog` (Sửa luật) trong phòng — bảng điểm và trạng thái bật/tắt
từng bi. Không đổi luật nghiệp vụ, không đổi contract trả về của dialog.

## 1. Hiện trạng

- `lib/screens/rooms/room_edit_dialogs.dart:59-157` — `RulesDialog`:
  9 hàng `Row`, mỗi hàng gồm `Checkbox` + `TextField` (`labelText: 'Điểm bi N'`).
- State: `Map<int, bool> enabled` + `Map<int, TextEditingController> fields`,
  khởi tạo từ `room.ruleVersions.singleWhere(currentRuleVersion)`.
- Validate: tính inline trong `build`, hiển thị 1 dòng báo lỗi tổng; lúc save
  gọi lại `RuleConfigValidator.validateBallPoints`.
- Consumer: `lib/screens/rooms/in_room.dart:160-165` (`RoomActionKind.rules`) —
  dialog trả `Map<int, BallPointConfig>`, controller nhận `RoomAction`.
- Validator: `lib/domain/validation/rule_config_validator.dart` — key đúng 1..9,
  bi bật phải có điểm dương, bi tắt phải bằng 0, phải có ít nhất 1 bi bật.
- Test bám key: `test/screens/rooms/in_room_actions_test.dart:287-292`
  dùng `rule-points-1`, `save-rules`.

## 2. UI mục tiêu

Lưới các ô điều khiển, mỗi hàng/cột tương ứng một bi (1..9).

Thành phần trong mỗi ô:

1. Nút bật/tắt: hình tròn ở phía trên ô, đóng vai trò trạng thái chọn của
   bi. Icon bi được **vẽ bằng widget** (`PoolBallIcon`), không dùng asset ảnh.
   Bi đang kích hoạt hiện màu đầy đủ; bi đang tắt bị grayscale + mờ.
2. Ô điểm: khung chữ nhật nhỏ bên dưới chứa nhãn `Point`, dùng để nhập/hiển
   thị điểm của bi. Bi đang tắt hiển thị dấu gạch ngang (chưa gán điểm).

Toàn bộ lưới được bao quanh bởi khung vuông lớn bên ngoài, gom thành một khối
chức năng thống nhất.

## 3. File dự kiến

- Thực tế: `lib/widgets/room/ball_rules_editor/`
  - `ball_rules_editor.dart` — `BallRulesEditor` (khung ngoài + `GridView`).
  - `BallRuleCell` — một ô: `BallToggleDot` + `BallPointField` + lỗi.
  - `ball_toggle_dot.dart` — nút tròn bật/tắt (ripple + Semantics + Tooltip).
  - `pool_ball_icon.dart` — icon bi vẽ thuần widget, không asset.
  - `ball_point_field.dart` — ô nhập điểm.
- Sửa: `lib/screens/rooms/room_edit_dialogs.dart` — `RulesDialog` dùng grid,
  bỏ vòng lặp 9 dòng `Row` + `Checkbox`.
- Mới test: `test/screens/rooms/room_edit_dialogs_test.dart`.
- Không đụng: `in_room.dart`, `rule_config_validator.dart`, model domain.

## 4. Chi tiết triển khai

### 4.1 Khung lưới (`BallRulesGrid`)

```dart
BallRulesGrid({
  required Map<int, bool> enabled,
  required Map<int, TextEditingController> fields,
  required Map<int, String> errors,
  required ValueChanged<int> onToggle,
  required VoidCallback onEdit,
})
```

- `GridView.builder` `shrinkWrap: true`, `NeverScrollableScrollPhysics`,
  tối đa 3 cột (hẹp thì 2 → 1), `mainAxisExtent: 116`,
  `mainAxisSpacing: 10`, `crossAxisSpacing: 10`.
- Thứ tự ô: 1..9 theo hàng.
- Bọc ngoài: `Container` viền `Border.all`, `borderRadius: 12`, padding 12,
  kèm tiêu đề "Bảng điểm bi" và dòng mô tả ngắn.
- Không dùng `Table` (không wrap tốt trong dialog hẹp).
- Bỏ ô trống nếu sau này mở rộng > 9 bi — hiện chưa cần.

### 4.2 Icon bi và nút bật/tắt (`PoolBallIcon`, `BallToggleDot`)

Vẽ bi bằng widget, không còn `Image.asset` và không còn khai báo `assets:`
trong `pubspec.yaml`.

- `PoolBallIcon(ball, size, enabled)`:
  - Bi 1–8: đĩa tròn màu đặc + số ở giữa. Bảng màu: 1 `#FACC15`, 2 `#2563EB`,
    3 `#EF4444`, 4 `#9333EA`, 5 `#F97316`, 6 `#16A34A`, 7 `#854D0E`,
    8 `#18181B` (thêm viền `outlineVariant`).
  - Bi 9: nền trắng + sọc vàng ngang `44%` chiều cao + đĩa tối ở giữa chứa
    số 9 màu vàng.
  - Màu số tự chọn theo `computeLuminance()`: nền sáng → số tối, nền tối →
    số trắng.
  - `RadialGradient` nhẹ + `BoxShadow` để trông nổi khối; `ClipOval` cắt tròn.
  - Tắt: `ColorFiltered` grayscale (không đổi màu gốc).
- `BallToggleDot`: `InkWell` + `customBorder: CircleBorder()`,
  `AnimatedOpacity` 150ms (`1` bật / `0.4` tắt), `Semantics(button, toggled)`
  + `Tooltip`, giữ key `'$keyPrefix-enabled-$b'`.
- Kích thước icon 36px trong vùng chạm 44×44 ở cell.

### 4.3 Ô điểm (`BallPointField`)

- `TextField`: `textAlign: TextAlign.center`, `isDense: true`.
- `InputDecoration`: `labelText: 'Point'`, `filled: true`, `border:
  OutlineInputBorder(borderRadius: 8)`, `contentPadding` nhỏ,
  `fillColor` khác nhau khi bật/tắt.
- Bi tắt: `enabled: false`, style có `TextDecoration.lineThrough`,
  `hintText: '—'` (khớp dấu gạch ngang trong thiết kế).
- `keyboardType: TextInputType.number`,
  `inputFormatters: [FilteringTextInputFormatter.digitsOnly]`,
  `textInputAction: TextInputAction.done`.
- Key giữ nguyên `ValueKey('rule-points-$b')`.

### 4.4 State trong `_RulesDialogState`

- Giữ nguyên `enabled` + `fields` (init/dispose không đổi) để không đổi hành vi.
- `onToggle(b)`: `setState` đổi bool. Tắt bi không xoá text trong controller;
  khi lưu, bi tắt vẫn gửi `points: 0` như hiện tại.
- `onEdit`: `setState(() {})` để recompute trạng thái validate.
- Tách `bool get valid` ra khỏi `build` (hiện đang tính inline).
- Giữ nguyên `config.ballPoints[b]!` — không đổi hành vi, tránh lan sang
  refactor khác.

### 4.5 Validate

- Bỏ dòng báo lỗi tổng 1 dòng.
- Thay bằng lỗi dưới từng ô: `Text(error, key: ValueKey('rule-error-$b'))`
  với style lỗi của theme.
- Nút `save-rules` vẫn `onPressed: valid ? ... : null` (giữ kỳ vọng test dòng 289).
- Vẫn gọi `RuleConfigValidator.validateBallPoints` trước khi pop như hiện tại.

### 4.6 Kích thước dialog

- Giữ `SizedBox(width: 340)` (đủ ~100px/ô cho 3 cột).
- Thêm `ConstrainedBox(maxHeight: 420)` và giữ `SingleChildScrollView` cho
  màn hình thấp.

### 4.7 Test

`test/screens/rooms/room_edit_dialogs_test.dart`:

- Render đủ 9 ô, đúng thứ tự 1..9.
- Tap `rule-enabled-1` → ô điểm bi 1 bị disable, save vẫn bật.
- Tap `rule-enabled-1` hai lần → trạng thái bật/tắt đảo đúng (không assert ảnh).
- Tắt hết 9 bi → `save-rules.onPressed == null`.
- Nhập `rule-points-1` = `'0'` → save null và có `rule-error-1`.
- Nhập giá trị hợp lệ → tap save → dialog trả map đúng.

`test/screens/rooms/in_room_actions_test.dart` giữ nguyên, chỉ chạy lại để xác
nhận không đổi hành vi.

### 4.8 Thứ tự làm

1. Tạo `widgets/ball_rules_grid.dart` (dot + field, chưa nối).
2. Refactor `RulesDialog` dùng grid, giữ nguyên keys và flow save.
3. Validate per-cell + getter `valid`.
4. `flutter analyze`.
5. `flutter test`.
6. Viết test mới; chỉnh test cũ nếu lỗi key.

## 5. Câu hỏi cần chốt

1. Lưới 3×3 hay xếp kiểu rack tam giác (1-2-3-4-5-6-7-8-9)? Mô tả PNG nói
   "hàng và cột" → đang nghiêng 3×3.
2. ~~Vòng tròn có hiện số bi ở giữa không?~~ Đã chốt: vẽ số trực tiếp trong
   `PoolBallIcon`; bỏ hoàn toàn asset ảnh bi.
3. Có cần nút "Bật tất cả / Tắt tất cả" phụ không? Không thêm trừ khi yêu cầu.
