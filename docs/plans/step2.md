# Step 2 — Models and create/select rooms

**Status: implemented and tested through §11. In-memory integration complete; scoring/undo and durable persistence remain Phases 3–4.**

Scope: Phase 2 in [../bidart-project.md](../bidart-project.md). Follow [step1.md](./step1.md) when older class designs or UI samples conflict.

Deliver immutable domain models, validation, repository contract and in-memory implementation, create/list/get/start-next-game services, Riverpod state, and room screens. Scoring/undo belong to Phase 3; Drift persistence and restart recovery belong to Phase 4. In-memory storage is an integration milestone, not completed offline persistence.

## 1. Establish baseline and dependencies

- [x] Run `flutter analyze` and `flutter test`; baseline clean, confirmed by user.
- [x] Add compatible `flutter_riverpod`; reuse existing Freezed, JSON and UUID dependencies.
- [x] Wrap the app with `ProviderScope` in `lib/main.dart`.
- [x] Leave unrelated tabs unchanged.

Verified after integration: `flutter analyze` reports no issues; `flutter test` passes both widget tests, including entry-point `ProviderScope` coverage.

**Acceptance:** app starts; baseline failures identified; dependencies injectable in tests.

## 2. Define domain ownership and supporting types

Create models under `lib/domain/models/scoring/`.

- [x] Define `Room` ownership: participants, active roster, order, cumulative scores, rule versions, games, current game ID, status, timestamps, revision and end conditions.
- [x] Define `GameSession` ownership: game number, current/payer IDs, game order, remaining balls, chain state, winner, timestamps and turns.
- [x] Add supporting types: `RoomMode`, `EndConditions`, `PendingEndReason`, `ChainState`, `TurnStateSnapshot`.
- [x] Distinguish local owner identity from participant IDs; do not implement Auth.
- [x] Keep scores authoritative at room level; avoid independently editable player totals.
- [x] Define before/after snapshots covering scores, roster/order, current/payer, chain, balls and relevant statuses/timestamps. Do not recursively embed entire Room/Turn histories.
- [x] Specify how room-level order and game-level order stay consistent when commands commit.

Ownership and undo boundaries: [step2-domain-contract.md](./step2-domain-contract.md). Supporting types implemented under `lib/domain/models/scoring/`; aggregate classes remain §3 work. Generator dependencies upgraded for Dart 3.13 compatibility. Tests cover serialization, copying, immutable collection views and non-restorable metadata exclusion.

**Acceptance:** each field has one authoritative owner; snapshots support the Step 1 undo contract.

## 3. Implement immutable models and serialization

- [x] Implement `Room`, `RoomStatus`, `RoomEvent`, `RuleTemplate`.
- [x] Implement `GameSession`, `GameStatus`, `PlayerInGame`.
- [x] Implement `RuleConfig`, `BallPointConfig`.
- [x] Implement `Turn`, `PottedBall`, `ScoreTransaction`, `ScoreLog`.
- [x] Use Freezed immutable collections, equality and `copyWith`.
- [x] Use IDs for references, not names or nested mutable player objects.
- [x] Include command ID, actor, rule reference, payers, ball outcomes, foul classification, transactions, logs, snapshots and `isUndone` in `Turn`.
- [x] Distinguish removed balls from respotted balls.
- [x] Require distinct transaction participants and positive integer amounts.
- [x] Give room events revision, before/after edit data and undo barrier.
- [x] Keep rule versions immutable and templates independent from room configuration.
- [x] Exclude P1 pocket multipliers, regional presets and x2 rules.

Generate code:

```sh
dart run build_runner build
```

**Tests:** JSON round-trip, nested snapshots, integer ball-map keys, immutable collections and preserved historical rule versions.

Aggregates implemented under `lib/domain/models/scoring/` (`room`, `game_session`, `player_in_game`, `rule_config`, `ball_point_config`, `rule_template`, `turn`, `potted_ball`, `score_transaction`, `transaction_type`, `score_log`, `foul_classification`, `room_event`, `room_event_type`); enums `RoomStatus`/`GameStatus` reused from §2. Foul model uses step-1 `FoulClassification` (none/th1/th2/potAndFoul), not WPA-style `FoulType`; no `PenaltyRule`/`PocketRule`/preset/x2 per P1 exclusion. Coverage in `test/domain/models/scoring/aggregate_models_test.dart` (8 tests).

## 4. Implement reusable validators

Suggested files:

```text
lib/domain/validation/room_validator.dart
lib/domain/validation/rule_config_validator.dart
lib/domain/validation/validation_issue.dart
```

- [x] Validate roster size 2–5 and unique participant IDs.
- [x] Trim guest names; reject empty and duplicate names.
- [x] Validate order as an exact permutation of active roster.
- [x] Require starter and payer in roster and different from each other.
- [x] Require configurations for balls 1–9, with no extra ball numbers.
- [x] Require positive integer points for enabled balls; disabled balls contribute zero.
- [x] Require at least one enabled ball; validate optional score limit through `EndConditions.scoreThreshold` (no separate per-ball or total-ball cap).
- [x] Validate positive optional duration and score threshold.
- [x] Return structured issues with field paths and codes; map codes to UI messages outside domain.

**Decision confirmed by user:** duplicate names use trim plus case-insensitive comparison (`An` = `an`). IDs remain stable identity.

**Tests:** valid 2/5 players; invalid 1/6; whitespace/duplicate names; duplicate IDs/order; missing order entries; invalid starter/payer; malformed rules and end conditions.

Implemented as pure static validators under `lib/domain/validation/` (`validation_issue.dart`, `room_validator.dart`, `rule_config_validator.dart`); no codegen, no Flutter dependency. Active IDs must be unique and reference participants; roster size counts unique known active IDs, not historical participants. `normalizeParticipants` returns immutable trimmed copies preserving IDs/timestamps/casing; §6 services must normalize, validate, then persist those copies. Validation alone does not mutate input. `BallPointConfig` asserts guard debug misuse; `validateBallEntry` covers raw values for production where asserts stripped. Score limits belong only to `EndConditions.scoreThreshold`, consistent with the domain contract. Coverage in `test/domain/validation/validators_test.dart` (17 tests).

## 5. Define atomic repository contract and fake

Files:

```text
lib/domain/repositories/game_repository_interface.dart
lib/data/repositories/in_memory_game_repository.dart
```

- [x] Define `listRooms` and `getRoom`.
- [x] Define atomic room creation and aggregate update with expected revision.
- [x] Store command receipts for idempotent retries.
- [x] Define typed failures: validation, not-found, active-room-exists, stale-version and persistence.
- [x] Check committed command receipts before rejecting stale versions.
- [x] Atomically enforce one active room, including concurrent create attempts.
- [x] Commit aggregate and command receipt together.
- [x] Leave all stored data unchanged after failed writes.
- [x] Support injected save failures and deterministic tests.

**Acceptance:** retries return the original committed result; concurrent creates cannot produce two active rooms; partial writes never become visible.

Implemented `GameRepository`, immutable command receipts and typed failures in the domain interface, with `InMemoryGameRepository` in data. Reads sort by created timestamp descending then ID ascending; optional status filtering. Updates require candidate revision = expected revision + 1. Receipts retain the original aggregate result, even after later updates. Command IDs are repository-wide; reusing one for another room or operation is rejected. Services must use a new command ID when input changes and validate business rules before writes. The fake detaches nested collections through model serialization and commits without asynchronous gaps in a single isolate. `failNextWrite` injects a failure into the next otherwise-valid non-retry write. Coverage: 9 repository tests, including concurrent creation, rollback, retries, stale revisions and collection isolation. RAM only; not restart persistence.

## 6. Implement `createRoom`

File: `lib/domain/services/room_service.dart`.

Sequence:

1. Resolve an already committed command ID.
2. Validate input.
3. Generate room/game/rule IDs with an injected ID factory.
4. Capture one timestamp with an injected clock.
5. Create rule version 1.
6. Initialize every participant score to zero.
7. Create room `ACTIVE`.
8. Create game 1 `IN_PROGRESS`, balls 1–9, selected starter/payer and initial break chain.
9. Persist aggregate and command receipt atomically, including the active-room check.
10. Return committed room ID.

- [x] Give form participants stable draft IDs so reordering does not change identity.
- [x] Do not publish or navigate with an uncommitted room.

**Tests:** valid initialization; zero-sum scores; existing active room rejection; persistence failure; retry returns the same room without duplicates.

Implemented `RoomService.createRoom` with injected ID factory/clock, normalized participants, local-mode room at revision 0, rule version 1 and exactly one initialized game. Caller-supplied participant IDs remain unchanged; mutable input collections are captured before asynchronous work. Committed receipts precede validation; concurrent same-command calls share an in-flight result, including receipt recovery across service instances. Only the committed room ID is returned; typed validation/storage failures propagate without publishing candidate state. Coverage in `test/domain/services/room_service_test.dart`; stable draft IDs and navigation now covered by §9 widget tests. In-memory storage still does not survive restart.

## 7. Implement reads and `startNextGame`

- [x] `listRooms`: status filter, documented deterministic sorting and summaries.
- [x] `getRoom`: full aggregate or explicit not-found.
- [x] Extract a pure next-game setup helper; do not implement scoring here.

`startNextGame` sequence:

1. Resolve a committed retry receipt.
2. Check expected revision and room `ACTIVE` status.
3. Require previous game `FINISHED`.
4. Check pending-end and elapsed-time/threshold conditions using the Step 1 contract.
5. Validate active roster.
6. Derive next starter/payer/order from previous outcome.
7. Restore balls 1–9 and initialize chain.
8. Preserve room scores and history.
9. Commit the new game atomically.

Model/store winner, final payer and break-clear outcome now; Phase 3 produces those outcomes. Use finished-game fixtures for Step 2 tests. Do not guess replacement payer/order when roster edits remove required players; settle the valid setup policy before supporting that branch.

**Tests:** `A/B/C/D/E`, C wins, B pays → `C/B/D/E/A`; break-clear preserves order; scores unchanged; active game, closed room, expired timer, pending-end and stale revision rejected. Check previously reached score thresholds, not only current scores.

Implemented reads and `startNextGame` in `RoomService`, immutable `RoomSummary`, and pure `NextGameSetup`. Read sorting is createdAt descending then ID ascending. Next-game receipts have a distinct command type; retry returns the original aggregate before revision checks. Writes preserve scores, rule versions and game history, increment revision and reset balls/chain. Historical threshold checks inspect before/after score snapshots of non-undone turns. Roster/order changes between games and missing/removed winner or final payer are explicitly rejected until their setup policy is settled; no replacement is guessed. Coverage: 16 tests in `test/domain/services/next_game_test.dart`; full suite 70 tests passes, `flutter analyze` clean. RAM-only storage remains unchanged.

## 8. Add Riverpod providers and controllers

Under `lib/features/scoring/provider/`:

- [x] Repository, room service, clock and ID providers.
- [x] Room list and room-by-ID async providers.
- [x] Create-room draft/controller.
- [x] Next-game command controller.

Rules:

- Widgets collect input; services enforce domain rules.
- Serialize commands per room.
- Disable duplicate submit while saving.
- Keep command ID for unchanged-input retries; changed input starts a new command.
- Publish committed state only after repository success.
- Preserve draft after errors; refresh list after success.

**Tests:** loading → success/error; double submit; retained draft; failed save does not publish candidate room.

Implemented in `lib/features/scoring/provider/`: injectable RAM repository/service/clock/UUID providers, filtered async room reads, immutable create draft and command controllers. Saving locks draft input; equivalent-input retries retain command IDs, changed input/revision allocates a new ID. Shared per-room queue serializes next-game commands and recovers after failures. Successful commits invalidate room/list reads; failures retain draft and expose errors without publishing candidates. Six tests cover loading, duplicate submits, failed-save retry, changed input, next-game success/idempotency and queue isolation. UI integration is delivered in §9–10; storage remains RAM-only.

## 9. Build `add_room.dart`

File: `lib/screens/rooms/add_room.dart`.

- [x] Room name input.
- [x] Add/remove/reorder 2–5 guests.
- [x] Starter and initial payer selectors.
- [x] Ball 1–9 enabled/points controls.
- [x] Optional end conditions.
- [x] Order/rule preview and inline validation.
- [x] Preserve player IDs through rename/reorder.
- [x] Clear invalid selections when a player is removed.
- [x] Disable submit when invalid or saving.
- [x] Show active-room conflict with an action to open the existing room.
- [x] Navigate by room ID only after successful commit.

**Widget tests:** invalid form, roster reorder, starter/payer conflict, loading lock, save failure retaining input and successful navigation.

`AddRoom` generates guest IDs once through the injected factory, reorders with accessible up/down buttons, and clears removed starter/payer selections. Raw numeric input stays in text controllers; invalid numbers block submit without constructing invalid asserted models. Optional duration is entered in seconds; disabled balls persist as zero points but remain on the table. Draft/inputs survive save failure; successful creation replaces the form route with `ChoseRoom(roomId)`. An active-room failure offers navigation to the existing room. No candidate room is passed between screens.

## 10. Build list/select flow with distinct screen roles

- [x] `lib/screens/rooms/rooms.dart`: sole room list, create action, status filters, empty/loading/error/retry states.
- [x] `lib/screens/rooms/chose_room.dart`: selected-room gateway accepting `roomId`; details, resume/view action and not-found handling. No second room list.
- [x] `lib/screens/rooms/in_room.dart`: minimal room-ID destination showing committed roster/scores/current game. Full turn UI belongs to Phase 3.
- [x] Closed/cancelled room destinations are read-only.
- [x] Returning to the list does not close the room or discard its aggregate.

**Widget tests:** empty list; active/closed rooms; missing ID; failed load/retry; create → gateway → room; back navigation preserves room.

`Rooms` integrates into the existing tab without changing other tabs. Shared presentation in `room_presentation.dart` maps domain issues/statuses to Vietnamese messages and displays committed cumulative scores, roster/order, current game, rules and limits. `InRoom` exposes start-next-game only for an active room with a finished game; the service remains authoritative for end-condition checks. Closed/cancelled rooms expose no write controls. All screens disclose RAM-only storage.

## 11. Acceptance and handoff

```sh
flutter analyze
flutter test
```

- [x] Valid room creates exactly one first game.
- [x] Invalid input/save failure creates nothing.
- [x] Same command never creates duplicates.
- [x] Only one room remains active.
- [x] List/open/back preserves committed state.
- [x] Next game keeps cumulative scores.
- [x] Historical rules remain unchanged.
- [x] Update Phase 2 and entity checklists only for implemented, tested items.
- [x] Record remaining decisions, baseline failures and temporary in-memory limitation.

Acceptance coverage: domain/repository tests plus `test/features/scoring/provider/room_controllers_test.dart` and `test/screens/rooms/room_flow_test.dart`. Verified 2026-10-15: all 94 tests pass (18 room-screen widget tests), `flutter analyze` clean. Handoff/API map and remaining decisions: [step2-handoff.md](./step2-handoff.md). No baseline failures remain. No device/emulator restart-persistence validation is claimed.

**Delivery limit:** in-memory state survives navigation, not app restart. Persistent templates, Drift storage and restart recovery remain Phase 4; scoring and undo remain Phase 3.

## Implementation order

`Models → validators → repository fake → services/tests → Riverpod → create form → list/gateway → acceptance`

Each layer has automated coverage. Checked items record implemented/tested behavior within the Step 2 RAM-only boundary; they do not claim Phase 3 scoring or Phase 4 persistence is complete.
