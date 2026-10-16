# Step 2 handoff — create/select rooms

## Delivered

Models, validators, atomic repository contract/RAM implementation, room services, Riverpod providers/controllers and the create/list/gateway/in-room UI are implemented. Other tabs remain unchanged.

Navigation: Rooms tab → `AddRoom` → `ChoseRoom(roomId)` → `InRoom(roomId)`. Successful creation replaces the form route; back returns to the list without closing the room. Both destinations reload committed data by ID. Closed/cancelled rooms are read-only.

## API map

| Boundary | Entry points |
| --- | --- |
| Validation | `RoomValidator`, `RuleConfigValidator`; structured `ValidationIssue` codes |
| Repository | `GameRepository.listRooms/getRoom/getCommandReceipt/createRoom/updateRoom` |
| Service | `RoomService.createRoom/listRooms/getRoom/startNextGame`; pure `NextGameSetup` |
| Dependencies | `gameRepositoryProvider`, `roomServiceProvider`, `clockProvider`, `idFactoryProvider` |
| Reads | `roomListProvider(status)` (`null` means all), `roomByIdProvider(roomId)` |
| Create command | `createRoomControllerProvider.notifier.setDraft(draft)` / `.submit()` |
| Next-game command | `nextGameControllerProvider(roomId).notifier.submit(expectedRevision: revision)` |
| Serialization | `roomCommandQueueProvider.run(roomId, command)`; currently used by next-game controller |

Controller submits return the committed ID/room, or `null` with an `AsyncError` in state. Duplicate in-flight submits share a Future. Unchanged input retries retain command IDs; changed create input or next-game revision starts a new command. Successful writes invalidate room/list reads; failed writes publish no candidate aggregate. Repository receipts preserve the original committed result, not a later room revision.

The form generates stable guest IDs, supports 2–5 guests and up/down ordering, and clears removed starter/payer selections. Raw numeric strings are validated before submit. Duration input uses seconds. Disabled balls persist with zero points and still belong to the initial set of balls 1–9.

## Verification

Run `flutter analyze` and `flutter test` from the project root. Coverage includes models/serialization, validators, atomicity, idempotency, create/next-game services, controller retry/state and widget navigation/errors/read-only behavior. Widget tests also exercise five guests, stable IDs/order and a narrow phone layout.

Verified on 2026-10-15: `flutter analyze` reports no issues; `flutter test` passes all 94 tests, including 18 room-screen widget tests and six controller tests. No baseline failures remain. Automated widget tests are not a claim of manual device/emulator validation.

## Remaining boundaries and decisions

- RAM only: shared provider scope preserves rooms across navigation, not app restart. No Drift database, migration or recovery yet (Phase 4).
- No scoring, record-turn, undo, finish/cancel commands or roster/rule editing during play (Phase 3 onward). Finished/closed rooms in tests are fixtures; production UI does not fabricate those outcomes.
- Start-next-game UI is available for an active room with a finished current game; service additionally rejects pending-end, expired timer, reached score thresholds and stale revisions.
- Roster edits between games and missing/removed winner/final payer remain rejected. Replacement/order policy must be settled before supporting them.
- Rule templates have a tested model only; no persistent favorite-template workflow yet.
- Reads are explicitly invalidated after controller commits, not repository streams. Future command controllers must use the shared per-room queue and refresh affected reads.
- No Auth, online synchronization, second-device joining or P1 pocket/preset/x2 rules.
