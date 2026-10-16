# Folder Structure

Docs: [class_design.md](./class_design.md) | [class_checklist.md](./class_checklist.md)

## Convention state management

- Dùng **Riverpod** cho state management và dependency injection, gồm luồng tạo/chọn phòng và trong phòng.
- Đặt providers/controllers theo feature tại `features/<feature>/provider/`; widget chỉ thu input và render state.
- Controller gọi engine thuần Dart và repository; chỉ publish state thành công sau khi persistence thành công.
- Không đặt luật tính điểm trong widget/provider: engine ở `domain/services/`, repository interface ở `domain/repositories/`.
- Dùng **Drift/SQLite** cho local storage; lưu cú đánh và state liên quan trong cùng transaction, tự lưu sau mỗi cú và phục hồi khi mở lại app. Riverpod không thay thế database hoặc cơ chế đồng bộ online.
- Dùng **Firebase** cho backend online: Authentication, Cloud Firestore, Security Rules và Cloud Functions. Local repository dùng Drift; online repository dùng Firebase làm nguồn dữ liệu chính. Chi tiết quyền, command idempotency và offline policy xem [plans/step1.md](./plans/step1.md).
- Quyết định chi tiết: [plans/step1.md](./plans/step1.md), §1–7. Cây thư mục là thiết kế mục tiêu, không phải toàn bộ code hiện có.

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── config/
│   │   └── env.dart                    # flutter_dotenv / --dart-define
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── errors/
│   │   ├── app_exception.dart          # base exception
│   │   ├── failure.dart                # sealed Failure classes
│   │   └── error_handler.dart
│   ├── models/
│   │   └── geo_point.dart              # {lat, lng} value object (shared)
│   ├── enum/
│   │   └── skill_level.dart            # enhanced enum (rank, code, displayName)
│   ├── theme/
│   │   └── app_theme.dart
│   ├── router/
│   │   └── app_router.dart
│   └── utils/
│       └── date_utils.dart
│
├── data/
│   ├── local/                        # drift/SQLite
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   │   ├── game_session_table.dart
│   │   │   ├── turn_table.dart
│   │   │   ├── rule_config_table.dart
│   │   │   └── ...
│   │   ├── daos/
│   │   │   ├── game_dao.dart
│   │   │   └── ...
│   │   └── mappers/                  # drift row → freezed model
│   │       ├── game_session_mapper.dart
│   │       ├── turn_mapper.dart
│   │       └── ...
│   ├── remote/                       # Firebase (giai đoạn online)
│   │   ├── firebase_client.dart       # Auth / Firestore / callable Functions
│   │   ├── api/
│   │   │   ├── auth_api.dart
│   │   │   ├── matchmaking_api.dart
│   │   │   └── venue_api.dart
│   │   └── mappers/                  # Firestore documents → freezed model
│   │       └── ...
│   └── repositories/
│       ├── auth_repository.dart
│       ├── game_repository.dart
│       ├── matchmaking_repository.dart
│       └── venue_repository.dart
│
├── domain/
│   ├── models/                       # freezed classes
│   │   ├── user/
│   │   │   └── user.dart
│   │   ├── scoring/
│   │   │   ├── room.dart               # aggregate: nhiều ván, điểm cộng dồn
│   │   │   ├── room_status.dart
│   │   │   ├── room_event.dart         # edits và undo barriers
│   │   │   ├── rule_template.dart
│   │   │   ├── ball_point_config.dart
│   │   │   ├── game_session.dart
│   │   │   ├── game_status.dart
│   │   │   ├── rule_config.dart
│   │   │   ├── penalty_rule.dart
│   │   │   ├── pocket_rule.dart
│   │   │   ├── pocket_position.dart
│   │   │   ├── foul_type.dart
│   │   │   ├── player_in_game.dart
│   │   │   ├── turn.dart
│   │   │   ├── potted_ball.dart
│   │   │   ├── den_type.dart
│   │   │   ├── score_transaction.dart
│   │   │   ├── transaction_type.dart
│   │   │   └── score_log.dart
│   │   ├── history/
│   │   │   ├── player_statistics.dart
│   │   │   ├── export_record.dart
│   │   │   └── export_format.dart
│   │   ├── matchmaking/
│   │   │   ├── player_profile.dart
│   │   │   ├── game_type.dart
│   │   │   ├── swipe_action.dart
│   │   │   ├── swipe_type.dart
│   │   │   ├── match.dart
│   │   │   ├── match_status.dart
│   │   │   ├── conversation.dart
│   │   │   ├── message.dart
│   │   │   ├── report.dart
│   │   │   ├── report_status.dart
│   │   │   └── block_list.dart
│   │   └── venue/
│   │       ├── venue.dart
│   │       ├── venue_review.dart
│   │       └── venue_table.dart
│   ├── services/
│   │   └── score_engine.dart         # pure logic, no Flutter dependency
│   └── repositories/                 # abstract interfaces (optional)
│       └── game_repository_interface.dart
│
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── login_screen.dart
│   │   │   └── widgets/
│   │   └── provider/
│   │       └── auth_provider.dart
│   ├── scoring/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── game_screen.dart
│   │   │   │   └── new_game_screen.dart
│   │   │   └── widgets/
│   │   │       ├── scoreboard.dart
│   │   │       ├── turn_input.dart
│   │   │       └── pocket_selector.dart
│   │   └── provider/
│   │       └── game_provider.dart
│   ├── history/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── history_screen.dart
│   │   │   │   └── game_detail_screen.dart
│   │   │   └── widgets/
│   │   └── provider/
│   │       └── history_provider.dart
│   ├── matchmaking/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── swipe_screen.dart
│   │   │   │   ├── match_list_screen.dart
│   │   │   │   └── chat_screen.dart
│   │   │   └── widgets/
│   │   │       ├── player_card.dart
│   │   │       └── swipe_actions.dart
│   │   └── provider/
│   │       └── matchmaking_provider.dart
│   └── venue/
│       ├── presentation/
│       │   ├── screens/
│       │   │   ├── venue_map_screen.dart
│       │   │   └── venue_detail_screen.dart
│       │   └── widgets/
│       │       └── venue_card.dart
│       └── provider/
│           └── venue_provider.dart
│
├── l10n/                             # optional: localization
│   └── app_vi.arb
│
└── test/
    ├── unit/
    │   └── scoring/
    │       └── score_engine_test.dart   # MUST HAVE (đền cả làng rules)
    └── widget/
```
