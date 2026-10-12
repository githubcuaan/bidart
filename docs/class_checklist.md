# Class design checklist

_a checklist which show progress we implement class_

all the class is following the [class_design](./class_design.md)

## Module 1: User & Auth

- [ ] User
- [x] SkillLevel (enhanced enum)

## Module 2: Scoring

- [ ] Room (aggregate nhiều ván)
- [ ] RoomStatus (enum)
- [ ] RoomEvent (edit/undo barrier)
- [ ] RuleTemplate
- [ ] BallPointConfig
- [ ] GameSession
- [ ] GameStatus (enum)
- [ ] RuleConfig
- [ ] RulePreset (enum)
- [ ] PenaltyRule
- [ ] PocketRule
- [ ] PocketPosition (enum)
- [ ] FoulType (enum)
- [ ] PlayerInGame
- [ ] Turn
- [ ] PottedBall
- [ ] DenType (enum)
- [ ] ScoreTransaction
- [ ] TransactionType (enum)
- [ ] ScoreLog

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
