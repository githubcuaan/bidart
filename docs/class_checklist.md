# Class design checklist

_a checklist which show progress we implement class_

all the class is following the [class_design](./class_design.md)

## Module 1: User & Auth

- [ ] User
- [x] SkillLevel (enhanced enum)

## Module 2: Scoring

- [x] Room (aggregate nhiều ván)
- [x] RoomStatus (enum)
- [x] RoomEvent (edit/undo barrier model; commands ở Phase 3–4)
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
- [x] Turn (model/snapshot; engine ở Phase 3)
- [x] PottedBall
- [ ] DenType (enum)
- [x] ScoreTransaction
- [x] TransactionType (enum)
- [x] ScoreLog
- [x] FoulClassification (enum theo contract Step 1, thay FoulType/DenType cũ)
- [x] RoomMode, EndConditions, PendingEndReason, ChainState, TurnStateSnapshot
- [x] RoomSummary

Step 2 models/serialization đã kiểm thử. Các mục RulePreset/PenaltyRule/PocketRule/PocketPosition là thiết kế P1 cũ, chưa triển khai; FoulType/DenType cũ không dùng trong contract hiện tại. Checklist này xác nhận models, không xác nhận engine, edit commands hoặc persistence hoàn tất.

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
