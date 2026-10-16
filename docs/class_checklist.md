# Class design checklist

_a checklist which show progress we implement class_

all the class is following the [class_design](./class_design.md)

## Module 1: User & Auth

- [ ] User
- [x] SkillLevel (enhanced enum)

## Module 2: Scoring

- [x] Room (aggregate nhiều ván)
- [x] RoomStatus (enum)
- [x] RoomEvent (edit/undo barrier theo revision; commands RAM đã kiểm thử)
- [x] RuleTemplate (model; lưu mẫu ở Phase 4)
- [x] BallPointConfig
- [x] GameSession
- [x] GameStatus (enum)
- [x] RuleConfig
- [ ] RulePreset (enum)
- [ ] PenaltyRule
- [ ] PocketRule
- [ ] PocketPosition (enum)
- [ ] FoulType (enum)
- [x] PlayerInGame
- [x] Turn (model/snapshot/revision, engine và undo đã kiểm thử)
- [x] PottedBall
- [ ] DenType (enum)
- [x] ScoreTransaction
- [x] TransactionType (enum)
- [x] ScoreLog
- [x] FoulClassification (enum theo contract Step 1, thay FoulType/DenType cũ)
- [x] RoomMode, EndConditions, PendingEndReason, ChainState, TurnStateSnapshot
- [x] RoomSummary

Models/serialization và Phase 3 RAM đã kiểm thử tự động; người dùng xác nhận manual smoke trên emulator toàn bộ PASS. Các mục RulePreset/PenaltyRule/PocketRule/PocketPosition là thiết kế P1 cũ, chưa triển khai; FoulType/DenType cũ không dùng trong contract hiện tại. Không xác nhận persistence hoàn tất.

### Services và tích hợp Phase 3

- [x] ScoreEngine, TurnInput, ScoreEngineResult (thuần Dart)
- [x] RoomService / NextGameSetup (create/read/next game; thay thế thủ công)
- [x] RoomCommands (record/undo/finish/cancel/evaluate/edit)
- [x] evaluateRoomEnd (lịch sử hiệu lực và clock)
- [x] InMemoryGameRepository (atomic aggregate + receipt; không durable)
- [x] RoomActionController / NextGameController / RoomCommandQueue
- [x] InRoom và edit/replacement dialogs
- [x] Regression nhiều ván: tái dựng ledger/bi từ history, JSON round-trip

API và test map: [plans/step3-handoff.md](./plans/step3-handoff.md).

## Module 3: History & Statistics

- [ ] PlayerStatistics
- [ ] ExportRecord
- [ ] ExportFormat (enum)

## Module 4: Matchmaking

- [ ] PlayerProfile
- [ ] GameType (enum)
- [ ] SwipeAction
- [ ] SwipeType (enum)
- [ ] Match
- [ ] MatchStatus (enum)
- [ ] Conversation
- [ ] Message
- [ ] Report
- [ ] ReportStatus (enum)
- [ ] BlockList

## Module 5: Venue Map

- [ ] Venue
- [ ] VenueReview
- [ ] VenueTable
