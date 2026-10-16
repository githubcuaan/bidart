# Step 2 §2 — Domain ownership contract

Supporting types live in `lib/domain/models/scoring/`. Aggregate implementation follows in §3. Business rules remain governed by [step1.md](./step1.md).

## Authoritative ownership

| Owner | Fields / responsibility |
| --- | --- |
| `Room` | ID, display name, local owner ID, mode, status, created/ended timestamps, monotonically increasing revision, participants including those who left, active player IDs, room order, cumulative scores, immutable rule versions/current rule reference, games/current game ID, end conditions and pending-end reasons |
| `GameSession` | ID/room ID, game number, status, start/end timestamps, current/previous player IDs, payer ID, game order, remaining balls, chain state, winner ID, final payer ID, break-clear outcome and turns |
| `PlayerInGame` | Stable participant ID, display name, joined/left timestamps; no independently writable score |
| `Turn` | Confirmed command/turn identity, actor and payer IDs, rule reference, ball outcomes, foul data, score transactions/logs, before/after snapshots, timestamp and undone marker |

- `Room.scores` includes every participant, including departed players. It must match all effective transactions across games and sum to zero.
- Owner identity belongs to the local installation/operator, not to a guest selected as starter. Keep owner and participant namespaces separate; no Auth implementation in this step.
- Rules, participants and histories are linked by stable IDs, never names. Rule versions belong to the room; turns reference the version used at confirmation.
- `currentGameId` identifies the latest game even between games, when that game is finished. No separate pending game is created.
- Remaining balls represent current table state, including respots; prior scoring alone cannot determine them.

## Room order versus game order

- Room order is authoritative for the active roster and subsequent setup.
- Current game order is the committed gameplay copy. While a game is in progress, it must equal room order.
- Create, turn/swap, reorder and add-player commands update both orders atomically while playing.
- Between games, roster/order edits update only room setup; completed game order stays historical.
- `startNextGame` derives the new order from the prior outcome and valid active setup, then commits room order and new game order together.
- Each relevant order must be a permutation of its roster. Never rewrite completed games to match later roster changes.
- Removing a winner/final payer between games requires an explicit valid next-game setup policy; do not silently invent replacements.

## Supporting types

- `RoomMode`: local/online. Online is a future mode, not permission to implement Firebase now.
- `RoomStatus`: active/finished/cancelled. Pending-end is not another status.
- `GameStatus`: inProgress/finished/incomplete/cancelled.
- `EndConditions`: optional positive duration in seconds and positive score threshold. Null disables a condition. Validation follows in §4.
- `PendingEndReason`: timeLimit/scoreThreshold, stored as a set because both may apply.
- `ChainState`: whether the current holding chain is the break chain and whether it has had a legal pot. A disabled-point legal ball still counts. Payer remains a separate game field.
- `TurnStateSnapshot`: cumulative scores, active roster, shared in-progress order, current/previous/payer IDs, chain, balls, room/game statuses, relevant timestamps, winner/final payer/break-clear outcome and pending-end reasons.

## Snapshot and undo boundary

- Before/after snapshots identify room/game and contain only restorable state, not nested histories or aggregates.
- A single snapshot order restores both room and current-game order because they must match during play.
- Participant records, rules and their versions are not reverted by turn undo: roster/rule edits create barriers that undo cannot cross.
- Command receipts, revisions, event history, room identity and the real clock never rewind. Undo itself is a new revision/command.
- Recompute pending-end reasons after restore using effective history, including threshold touches before barriers, and current time. Never blindly restore the old pending-end flag.
- A snapshot does not authorize reopening a closed room; lifecycle checks precede undo.

## Verification

Tests cover immutable snapshot collections, value equality/copying, JSON round-trip, optional end limits, concurrent pending-end reasons and snapshot payloads without recursive history or revision metadata. Engine transitions and aggregate invariant validation follow in later steps.
