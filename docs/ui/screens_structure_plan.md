# Plan: tổ chức lại cấu trúc thư mục + tách nhỏ widget

> Trạng thái: **đã thực hiện** (Phase 1–7). `flutter analyze` sạch,
> `flutter test` 215/215 pass. Số dòng thực tế ghi ở mục 6.

Mục tiêu: mỗi file một widget công khai, không file nào quá ~200 dòng, không phụ
thuộc chéo giữa screen với file dialog. Không đổi hành vi UI, giữ nguyên mọi
`ValueKey` và text tiếng Việt để test không đổi.

## 1. Hiện trạng (vấn đề)

| File | Dòng | Vấn đề |
| --- | --- | --- |
| `lib/screens/rooms/in_room.dart` | 545 | 1 `ListView` ~300 dòng children, 11 khối UI lẫn nhau |
| `lib/screens/rooms/add_room.dart` | 523 | Form dài ~310 dòng, 8 khối UI lẫn nhau |
| `lib/screens/rooms/room_edit_dialogs.dart` | 300 | 4 dialog + helper dùng chung trong 1 file |
| `lib/screens/profile.dart` | 324 | Drawer + screen edit form + `_StatBox` |
| `lib/screens/rooms/room_presentation.dart` | 151 | Helper + widget dùng chung nằm trong thư mục screen |

Phụ thuộc ngược cần sửa: `in_room.dart` import `playerName()` từ
`room_edit_dialogs.dart` (screen import từ file dialog).

Trùng lặp UI: `add_room.dart:344-379` và `RulesDialog` đều là editor 9 bi
(`Switch` + `TextField`) — nên gộp về một widget dùng chung.

## 2. Cấu trúc thư mục đích

Nguyên tắc: **không có widget trong `features/`**. `features/` chỉ chứa state/
provider; UI nằm ở `lib/screens/` hoặc `lib/widgets/`; chuỗi hiển thị thuần
Dart nằm ở `lib/core/labels/`.

```
lib/
  app/                        (để dành: app.dart, router.dart, theme.dart)
  core/
    enum/
    labels/
      room_labels.dart              playerName, roomStatusLabel,
                                    gameStatusLabel, validationMessage,
                                    roomFailureMessage (không import Flutter)
  domain/                       (models, repositories, services, validation)
  data/                         (local, repositories)
  features/
    scoring/
      provider/                 (chỉ state layer, không widget)
        room_providers.dart
        room_action_controller.dart
        create_room_controller.dart
        next_game_controller.dart
        rule_template_controller.dart
  widgets/                      dùng chung toàn app
    screen/app_screen.dart
    async/async_content.dart
    dialog/confirm_dialog.dart
    stat_box.dart
    navi_bar.dart
    room/
      room_details.dart           RoomDetails
      room_load_error.dart        RoomLoadError
      ball_rules_editor/
        ball_rules_editor.dart    BallRulesEditor
        ball_toggle_dot.dart      BallToggleDot
        ball_point_field.dart     BallPointField
  screens/                      tab roots + screen con
    main_screen.dart
    home.dart
    maps.dart
    people.dart
    rooms/
      rooms.dart                      Rooms (tab root)
      chose_room.dart                 ChoseRoom
      widgets/room_list_item.dart
      dialogs/
        add_player_dialog.dart
        rules_dialog.dart
        order_dialog.dart
        replacement_dialog.dart
      in_room/
        in_room.dart                 InRoom (shell + state)
        in_room_commands.dart        part of in_room.dart
        room_end_timer.dart          RoomEndTimer
        widgets/
          turn_draft_panel.dart
          turn_actions.dart
          turn_preview_panel.dart
          ball_selection_chips.dart
          foul_toggle.dart
          room_error_panel.dart
          room_management_actions.dart
          room_lifecycle_actions.dart
          room_history_panel.dart
      add_room/
        add_room.dart
        widgets/
          player_roster_editor.dart
          role_selectors.dart
          end_conditions_fields.dart
          room_draft_preview.dart
          rule_template_section.dart
          create_room_error_panel.dart
    profile.dart                 (không đụng: dev khác đang làm)
```

Quy tắc bám theo:

1. Một file = một widget công khai. Widget private (`_X`) ở ngay file cha.
2. Widget chỉ dùng trong 1 screen → `<screen>/widgets/`.
3. Widget dùng ≥ 2 screen → `lib/widgets/room/` (hoặc `lib/widgets/<domain>/`).
4. Widget không phụ thuộc feature nào → `lib/widgets/`.
5. `features/` **không chứa UI**: chỉ provider/controller/state.
6. Chuỗi hiển thị dùng chung → `lib/core/labels/`, không import Flutter.
7. File > 200 dòng hoặc > 3 widget → tách.
8. `part` file sinh tự động của freezed/drift không di chuyển.
9. Test mirror cấu trúc: `test/screens/...`, `test/widgets/...`.

## 3. Tác vụ tách, theo thứ tự

### Phase 1 — Nền tảng, không đổi hành vi

1. Tạo `lib/core/labels/room_labels.dart`, chuyển
   `playerName`, `roomStatusLabel`, `gameStatusLabel`, `validationMessage`,
   `roomFailureMessage` ra khỏi `room_presentation.dart` và
   `room_edit_dialogs.dart`.
   - Sửa import ở `in_room.dart`, `rooms.dart`, `add_room.dart`,
     `room_edit_dialogs.dart`.
   - `in_room.dart` hết phụ thuộc vào file dialog.
2. Tạo `lib/widgets/room/room_details.dart` và
   `lib/widgets/room/room_load_error.dart` từ `room_presentation.dart`.
   - Xoá `room_presentation.dart` sau khi mọi import đã trỏ sang file mới.
3. Tạo `widgets/dialog/confirm_dialog.dart` cho AlertDialog `confirm-action`
   đang nằm trong `in_room.dart:103-122`.

Không test nào import trực tiếp các file trên → chỉ sửa import, test giữ nguyên.

### Phase 2 — Tách dialogs

4. `dialogs/add_player_dialog.dart`, `order_dialog.dart`,
   `replacement_dialog.dart`, `rules_dialog.dart`.
5. Xoá `room_edit_dialogs.dart`.
   - Key giữ nguyên: `new-player-name`, `save-player`, `order-up/down-$id`,
     `save-order`, `replacement-starter`, `replacement-payer`,
     `confirm-replacements`, `rule-enabled-$b`, `rule-points-$b`, `save-rules`.

### Phase 3 — Bảng điểm bi dùng chung

6. Tạo `lib/widgets/room/ball_rules_editor/` theo
   `docs/ui/ball_rules_grid_plan.md`: `BallRulesEditor` + `BallToggleDot` +
   `BallPointField`.
7. `RulesDialog` dùng `BallRulesEditor` (chế độ sửa luật trong phòng).
8. `add_room.dart:344-379` thay khối Switch/TextField 9 bi bằng
   `BallRulesEditor` (chế độ tạo phòng).
   - Key hiện tại `ball-enabled-$b`, `ball-points-$b` phải giữ nguyên → widget
     nhận tham số `keyPrefix` để sinh key theo ngữ cảnh.
   - Kiểm tra lại test `room_flow_test.dart` có assert key `ball-*` không.

### Phase 4 — Tách `in_room.dart`

9. Tạo `in_room/widgets/`:
   - `ball_selection_chips.dart` — Wrap `pot-ball-$b` + dòng "bi tắt điểm vẫn
     ghi nhận" + text "Chuỗi đề-pa".
   - `foul_toggle.dart` — `SwitchListTile` `turn-foul` + phân loại lỗi.
   - `turn_preview_panel.dart` — `score-preview` + danh sách log + đặt lại bi.
   - `turn_actions.dart` — `clear-turn-draft` + `record-turn`.
   - `room_management_actions.dart` — `undo-turn`, `add-player`, `edit-rules`,
     `edit-order`, `remove-player-$id`.
   - `room_lifecycle_actions.dart` — `finish-room`, `cancel-room`.
   - `room_history_panel.dart` — `ExpansionTile` `room-history`.
   - Khối lỗi/retry (`retry-action`, `reload-room`) → `room_error_panel.dart`.
10. `in_room.dart` còn lại: shell `AppScreen` + `AsyncContent` + state
    (`_balls`, `_foul`, `_busy`, `_draftOwner`) + điều phối controller.
    Mục tiêu < 200 dòng.

### Phase 5 — Tách `add_room.dart`

11. `add_room/widgets/`:
    - `player_roster_editor.dart` — `player-row-`, `player-name-$id`,
      `move-up/down-$id`, `remove-player-$id`, `add-player`.
    - `role_selector_field.dart` — `starter-selector`, `payer-selector`.
    - `rule_template_section.dart` — `template-name`, `save-template`,
      `apply-template-*`.
    - Khối lỗi tạo phòng → `create_room_error_panel.dart`.
    - Field điều kiện kết thúc + preview thứ tự giữ nguyên trong form hoặc tách
      `end_conditions_fields.dart` nếu file vẫn > 200 dòng.
12. `add_room.dart` còn lại < 200 dòng.

### Phase 6 — Profile (hoãn)

13. ~~Tách profile~~ **Hoãn**: phần profile do dev khác phụ trách, không sửa
    trong phiên này.
14. ~~Tách `stat_box.dart`~~ Hoãn cùng profile (`_StatBox` vẫn private).
15. `main_screen.dart`: giữ nguyên, chỉ cập nhật import.

### Phase 7 — Dọn và test

16. Xoá thư mục/file rỗng (`screens/rooms/widgets/` rỗng sau khi dựng xong).
17. Di chuyển test theo cấu trúc mới:
    - `test/screens/rooms/room_flow_test.dart` giữ ở `test/screens/rooms/`
      (flow bắt đầu từ tab Rooms).
    - `test/screens/rooms/in_room_actions_test.dart` →
      `test/features/scoring/presentation/rooms/in_room_actions_test.dart`.
    - `test/screens/profile_test.dart`: giữ nguyên (profile ngoài phạm vi).
18. `flutter analyze` → `flutter test`.

## 4. Ràng buộc phải giữ

- **Mọi `ValueKey` giữ nguyên tên.** Test dùng
  `find.byKey(ValueKey(name))` với chuỗi hardcode.
- **Mọi text tiếng Việt giữ nguyên.** Test dùng `find.text('...')`.
- Không đổi kiểu widget mà test `find.byType` đang truy: `InRoom`, `ChoseRoom`,
  `Rooms`, `AddRoom`, `Home`, `Profile`, `ProfileEdit`, `AppScreen`,
  `AsyncContent`, `AppBar`, `ListTile`, `FilledButton`, `OutlinedButton`.
- Tách file → chỉ sửa import. Tách widget con bên trong → an toàn nếu key và
  cây widget giữ nguyên.
- Mỗi phase chạy `flutter test` trước khi qua phase sau.

## 5. Câu hỏi cần chốt

1. ~~Vị trí tab Rooms~~ Đã chốt: **4 tab cùng cấp trong `lib/screens/`**.
   `lib/screens/rooms/rooms.dart` là tab root; chỉ phần nội bộ của scoring
   (`in_room/`, `add_room/`, `chose_room.dart`, `dialogs/`, `widgets/`,
   `labels/`) nằm ở `features/scoring/presentation/`.
2. Có cần dựng `lib/app/` + router thật (`go_router`) không, hay giữ điều
   hướng bằng `Navigator` hiện tại?
3. Có giữ test ở `test/screens/` để khỏi đổi đường dẫn, hay mirror cấu trúc
   mới?

## 6. Kết quả thực tế

```
lib/core/labels/room_labels.dart
lib/widgets/room/{room_details,room_load_error}.dart
lib/widgets/room/ball_rules_editor/{ball_rules_editor,ball_toggle_dot,ball_point_field}.dart
lib/widgets/{stat_box.dart,dialog/confirm_dialog.dart}
lib/screens/rooms/
  rooms.dart + widgets/room_list_item.dart
  chose_room.dart
  dialogs/{add_player,order,replacement,rules}_dialog.dart
  in_room/
    in_room.dart (253) + in_room_commands.dart (133) + room_end_timer.dart (67)
    widgets/{ball_selection_chips,foul_toggle,turn_actions,turn_draft_panel,
             turn_preview_panel,room_error_panel,room_management_actions,
             room_lifecycle_actions,room_history_panel}.dart
  add_room/
    add_room.dart (364)
    widgets/{player_roster_editor,role_selectors,rule_template_section,
             create_room_error_panel,end_conditions_fields,
             room_draft_preview}.dart
lib/screens/profile.dart         (giữ nguyên, dev khác đang làm)
lib/features/scoring/provider/   (chỉ 5 file state, không widget)
```

`features/` sau refactor chỉ còn 5 file provider/controller, không có UI.

Số dòng sau refactor:

| File | Trước | Sau |
| --- | --- | --- |
| `in_room.dart` | 545 | 253 (+133 commands +67 timer) |
| `add_room.dart` | 523 | 364 |
| `room_edit_dialogs.dart` | 300 | tách 4 file, mỗi file 49–103 |
| `profile.dart` | 324 | không đổi (ngoài phạm vi phiên này) |
| file lớn nhất ngoài form state | 545 | 160 (BallRulesEditor) |

Ghi chú:

- `in_room_commands.dart` dùng `part of` để `in_room.dart` chỉ còn state +
  build; `room_end_timer.dart` là class thuần, không phụ thuộc widget.
- `add_room.dart` vẫn 364 dòng vì giữ toàn bộ state form (controller, draft,
  validate). Có thể hạ tiếp bằng cách tách `CreateRoomDraft` thành view-model.
- `BallRulesEditor` dùng chung cho `AddRoom` (`keyPrefix: 'ball'`) và
  `RulesDialog` (`keyPrefix: 'rule'`), responsive 3 → 1 cột khi dialog hẹp.
- Test: `room_flow_test.dart` ở `test/screens/rooms/`;
  `in_room_actions_test.dart` ở `test/features/scoring/presentation/rooms/`.
- `dart format` chỉ áp dụng cho file đã sửa.
