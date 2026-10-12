# Step 2 — Models and create/select rooms

**Status: implementation plan; not implemented.**

Scope: Phase 2 in [../bidart-project.md](../bidart-project.md). Follow [step1.md](./step1.md) when older class designs or UI samples conflict.

Deliver immutable domain models, validation, repository contract and in-memory implementation, create/list/get/start-next-game services, Riverpod state, and room screens. Scoring/undo belong to Phase 3; Drift persistence and restart recovery belong to Phase 4. In-memory storage is an integration milestone, not completed offline persistence.

## 1. Establish baseline and dependencies

- [ ] Run `flutter analyze` and `flutter test`; record pre-existing failures separately.
- [ ] Add compatible `flutter_riverpod`; reuse existing Freezed, JSON and UUID dependencies.
- [ ] Wrap the app with `ProviderScope` in `lib/main.dart`.
- [ ] Leave unrelated tabs unchanged.

**Acceptance:** app starts; baseline failures identified; dependencies injectable in tests.

## 2. Define domain ownership and supporting types

Create models under `lib/domain/models/scoring/`.

- [ ] `Room` owns participants, active roster, order, cumulative scores, rule versions, games, current game ID, status, timestamps, revision and end conditions.
- [ ] `GameSession` owns game number, current/payer IDs, game order, remaining balls, chain state, winner, timestamps and turns.
- [ ] Add supporting types: `RoomMode`, `EndConditions`, `PendingEndReason`, `ChainState`, `TurnStateSnapshot`.
- [ ] Distinguish local owner identity from participant IDs; do not implement Auth.
- [ ] Keep scores authoritative at room level; avoid independently editable player totals.
- [ ] Define before/after snapshots covering scores, roster/order, current/payer, chain, balls and relevant statuses/timestamps. Do not recursively embed entire Room/Turn histories.
- [ ] Specify how room-level order and game-level order stay consistent when commands commit.

**Acceptance:** each field has one authoritative owner; snapshots support the Step 1 undo contract.

## 3. Implement immutable models and serialization

- [ ] Implement `Room`, `RoomStatus`, `RoomEvent`, `RuleTemplate`.
- [ ] Implement `GameSession`, `GameStatus`, `PlayerInGame`.
- [ ] Implement `RuleConfig`, `BallPointConfig`.
- [ ] Implement `Turn`, `PottedBall`, `ScoreTransaction`, `ScoreLog`.
- [ ] Use Freezed immutable collections, equality and `copyWith`.
- [ ] Use IDs for references, not names or nested mutable player objects.
- [ ] Include command ID, actor, rule reference, payers, ball outcomes, foul classification, transactions, logs, snapshots and `isUndone` in `Turn`.
- [ ] Distinguish removed balls from respotted balls.
- [ ] Require distinct transaction participants and positive integer amounts.
- [ ] Give room events revision, before/after edit data and undo barrier.
- [ ] Keep rule versions immutable and templates independent from room configuration.
- [ ] Exclude P1 pocket multipliers, regional presets and x2 rules.

Generate code:

```sh
dart run build_runner build --delete-conflicting-outputs
```

**Tests:** JSON round-trip, nested snapshots, integer ball-map keys, immutable collections and preserved historical rule versions.

## 4. Implement reusable validators

Suggested files:

```text
lib/domain/validation/room_validator.dart
lib/domain/validation/rule_config_validator.dart
lib/domain/validation/validation_issue.dart
```

- [ ] Validate roster size 2–5 and unique participant IDs.
- [ ] Trim guest names; reject empty and duplicate names.
- [ ] Validate order as an exact permutation of active roster.
- [ ] Require starter and payer in roster and different from each other.
- [ ] Require configurations for balls 1–9, with no extra ball numbers.
- [ ] Require positive integer points for enabled balls; disabled balls contribute zero.
- [ ] Require at least one enabled ball; enforce optional point limit.
- [ ] Validate positive optional duration and score threshold.
- [ ] Return structured issues with field paths and codes; map codes to UI messages outside domain.

**Decision needed:** duplicate names use trim-only or trim plus case-insensitive comparison. Step 1 does not specify case handling; confirm before implementation.

**Tests:** valid 2/5 players; invalid 1/6; whitespace/duplicate names; duplicate IDs/order; missing order entries; invalid starter/payer; malformed rules and end conditions.

## 5. Define atomic repository contract and fake

Files:

```text
lib/domain/repositories/game_repository_interface.dart
lib/data/repositories/in_memory_game_repository.dart
```

- [ ] Define `listRooms` and `getRoom`.
- [ ] Define atomic room creation and aggregate update with expected revision.
- [ ] Store command receipts for idempotent retries.
- [ ] Define typed failures: validation, not-found, active-room-exists, stale-version and persistence.
- [ ] Check committed command receipts before rejecting stale versions.
- [ ] Atomically enforce one active room, including concurrent create attempts.
- [ ] Commit aggregate and command receipt together.
- [ ] Leave all stored data unchanged after failed writes.
- [ ] Support injected save failures and deterministic tests.

**Acceptance:** retries return the original committed result; concurrent creates cannot produce two active rooms; partial writes never become visible.

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

- [ ] Give form participants stable draft IDs so reordering does not change identity.
- [ ] Do not publish or navigate with an uncommitted room.

**Tests:** valid initialization; zero-sum scores; existing active room rejection; persistence failure; retry returns the same room without duplicates.

## 7. Implement reads and `startNextGame`

- [ ] `listRooms`: status filter, documented deterministic sorting and summaries.
- [ ] `getRoom`: full aggregate or explicit not-found.
- [ ] Extract a pure next-game setup helper; do not implement scoring here.

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

## 8. Add Riverpod providers and controllers

Under `lib/features/scoring/provider/`:

- [ ] Repository, room service, clock and ID providers.
- [ ] Room list and room-by-ID async providers.
- [ ] Create-room draft/controller.
- [ ] Next-game command controller.

Rules:

- Widgets collect input; services enforce domain rules.
- Serialize commands per room.
- Disable duplicate submit while saving.
- Keep command ID for unchanged-input retries; changed input starts a new command.
- Publish committed state only after repository success.
- Preserve draft after errors; refresh list after success.

**Tests:** loading → success/error; double submit; retained draft; failed save does not publish candidate room.

## 9. Build `add_room.dart`

File: `lib/screens/rooms/add_room.dart`.

- [ ] Room name input.
- [ ] Add/remove/reorder 2–5 guests.
- [ ] Starter and initial payer selectors.
- [ ] Ball 1–9 enabled/points controls.
- [ ] Optional end conditions.
- [ ] Order/rule preview and inline validation.
- [ ] Preserve player IDs through rename/reorder.
- [ ] Clear invalid selections when a player is removed.
- [ ] Disable submit when invalid or saving.
- [ ] Show active-room conflict with an action to open the existing room.
- [ ] Navigate by room ID only after successful commit.

**Widget tests:** invalid form, roster reorder, starter/payer conflict, loading lock, save failure retaining input and successful navigation.

## 10. Build list/select flow with distinct screen roles

- [ ] `lib/screens/rooms/rooms.dart`: sole room list, create action, status filters, empty/loading/error/retry states.
- [ ] `lib/screens/rooms/chose_room.dart`: selected-room gateway accepting `roomId`; details, resume/view action and not-found handling. No second room list.
- [ ] `lib/screens/rooms/in_room.dart`: minimal room-ID destination showing committed roster/scores/current game. Full turn UI belongs to Phase 3.
- [ ] Closed/cancelled room destinations are read-only.
- [ ] Returning to the list does not close the room or discard its aggregate.

**Widget tests:** empty list; active/closed rooms; missing ID; failed load/retry; create → gateway → room; back navigation preserves room.

## 11. Acceptance and handoff

```sh
flutter analyze
flutter test
```

- [ ] Valid room creates exactly one first game.
- [ ] Invalid input/save failure creates nothing.
- [ ] Same command never creates duplicates.
- [ ] Only one room remains active.
- [ ] List/open/back preserves committed state.
- [ ] Next game keeps cumulative scores.
- [ ] Historical rules remain unchanged.
- [ ] Update Phase 2 and entity checklists only for implemented, tested items.
- [ ] Record remaining decisions, baseline failures and temporary in-memory limitation.

**Delivery limit:** in-memory state survives navigation, not app restart. Persistent templates, Drift storage and restart recovery remain Phase 4; scoring and undo remain Phase 3.

## Implementation order

`Models → validators → repository fake → services/tests → Riverpod → create form → list/gateway → acceptance`

Complete tests for each layer before integrating the next. This file records a plan, not completion of Phase 2.
