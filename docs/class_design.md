# Thiết kế Class & Entity — App Bida (Flutter)

Tài liệu này mô tả domain model chi tiết cho từng module, kèm UML class diagram (Mermaid).
Đơn vị đo: `GeoPoint` = {lat, lng}. Các trường có `?` là nullable/optional.

---

## 1. Module: User & Auth

**Vai trò:** User là entity gốc, liên kết tới `PlayerInGame` (chơi bida), `PlayerProfile` (tìm đối), `PlayerStatistics` (thống kê), `Venue` (người thêm quán).

```mermaid
classDiagram
    class User {
        +String id
        +String phone
        +String name
        +String? avatarUrl
        +SkillLevel selfDeclaredLevel
        +DateTime createdAt
        +register()
        +login()
        +updateProfile()
    }

    class SkillLevel {
        <<enhanced enumeration>>
        K_I(rank:1, code:"K/I", name:"Nhập môn")
        H(rank:2, code:"H", name:"Sơ cấp yếu")
        G(rank:3, code:"G", name:"Phong trào phổ thông")
        F(rank:4, code:"F", name:"Phong trào khá")
        E(rank:5, code:"E", name:"Bán chuyên sơ cấp")
        D(rank:6, code:"D", name:"Tay cơ cứng")
        C(rank:7, code:"C", name:"Trình độ xuất sắc")
        B(rank:8, code:"B", name:"Bán chuyên cao cấp")
        A(rank:9, code:"A", name:"Chuyên nghiệp")
        +int rankOrder
        +String code
        +String displayName
        +String description
        +isHigherThan(other) bool
        +rankDistance(other) int
    }

    User --> SkillLevel : selfDeclaredLevel
```

**Ghi chú thiết kế:**

- Đây là **enhanced enum** (Dart hỗ trợ enum có field + method), không phải enum phẳng — vì mỗi hạng cần cả `code` ("K/I", "H"...), `displayName` và `description` dài để hiển thị UI (vd: tooltip giải thích hạng khi user chọn).
- `rankOrder` (1→9) là **số nguyên dùng để so sánh/lọc** — đây là lý do quan trọng nhất phải nâng cấp: Module 4 (matchmaking) cần lọc đối thủ trong khoảng rank gần nhau (vd: ±1-2 hạng) chứ không thể so sánh trực tiếp bằng enum phẳng.
- Đặt tên field trong `User` là `selfDeclaredLevel` (không phải `level`) để nhấn mạnh đây là **hạng tự khai báo** — không phải hạng được hệ thống tính toán. Nếu sau này muốn có "hạng tính toán từ thắng/thua" (elo-like), nên thêm field riêng `computedRating: int` trong `PlayerStatistics` (Module 3), tránh nhầm lẫn 2 khái niệm.
- Text mô tả dài (`description`) nên lưu ở dạng **static lookup table trong code** (không lưu DB) vì đây là dữ liệu tĩnh, không đổi theo user.

---

## 2. Module: Scoring — Tính điểm bắn đền (Core / MVP)

Đây là module quan trọng nhất, cần rule engine linh hoạt vì luật "bắn đền" khác nhau theo vùng miền.

```mermaid
classDiagram
    class GameSession {
        +String id
        +RuleConfig ruleConfig
        +List~PlayerInGame~ players
        +List~Turn~ turns
        +GameStatus status
        +DateTime startTime
        +DateTime? endTime
        +String? winnerId
        +startGame()
        +addTurn(turn)
        +undoLastTurn()
        +finishGame()
        +getCurrentScores() Map
        +getRemainingBalls() List~int~
        +getCurrentDenBallNumber() int?
    }

    class GameStatus {
        <<enumeration>>
        PENDING
        IN_PROGRESS
        FINISHED
        CANCELLED
    }

    class RuleConfig {
        +String id
        +String name
        +RulePreset presetType
        +int totalBalls
        +int pointsPerBall
        +List~PenaltyRule~ penaltyRules
        +List~PocketRule~ pocketRules
        +validate() bool
        +getPenaltyFor(foulType) int
        +getMultiplierFor(pocket) double
    }

    class RulePreset {
        <<enumeration>>
        MIEN_BAC
        MIEN_NAM
        CUSTOM
    }

    class PenaltyRule {
        +String id
        +FoulType foulType
        +int penaltyPoints
        +String description
    }

    class PocketRule {
        +String id
        +PocketPosition pocket
        +double multiplier
    }

    class PocketPosition {
        <<enumeration>>
        TOP_LEFT
        TOP_RIGHT
        MID_LEFT
        MID_RIGHT
        BOTTOM_LEFT
        BOTTOM_RIGHT
    }

    class FoulType {
        <<enumeration>>
        TOUCH_BALL
        NO_BALL_POTTED
        OWN_BALL_POCKETED
        OPPONENT_CUE_POCKETED
        CUSHION_FAIL
        OTHER
    }

    class PlayerInGame {
        +String id
        +User? user
        +String displayName
        +int currentScore
        +int ballsPotted
        +int foulCount
        +addScore(points)
        +applyPenalty(points)
        +reset()
    }

    class Turn {
        +String id
        +int turnNumber
        +List~PottedBall~ pottedBalls
        +bool isFoul
        +FoulType? foulType
        +DenType denType
        +bool isUndone
        +DateTime timestamp
        +String? note
        +calculateOutcome() List~ScoreTransaction~
    }

    class PottedBall {
        +String id
        +int ballNumber
        +PocketPosition pocket
        +bool isDenBall
        +int pointValue
    }

    class DenType {
        <<enumeration>>
        NONE
        DEN_CHI_DINH
        DEN_CA_LANG
    }

    class ScoreTransaction {
        +String id
        +PlayerInGame fromPlayer
        +PlayerInGame toPlayer
        +int amount
        +TransactionType type
        +String? transactionGroupId
    }

    class TransactionType {
        <<enumeration>>
        NORMAL_POT
        DEN_CHI_DINH
        DEN_CA_LANG
    }

    class ScoreLog {
        +String id
        +int previousScore
        +int newScore
        +DateTime timestamp
    }

    GameSession "1" --> "1" RuleConfig
    GameSession "1" --> "2..*" PlayerInGame : has
    GameSession "1" --> "*" Turn : contains
    GameSession --> GameStatus
    RuleConfig "1" --> "*" PenaltyRule
    RuleConfig "1" --> "*" PocketRule
    RuleConfig --> RulePreset
    PenaltyRule --> FoulType
    PocketRule --> PocketPosition
    Turn "*" --> "1" PlayerInGame : người bắn (actor)
    Turn --> FoulType
    Turn --> DenType
    Turn "1" --> "1..*" PottedBall : ghi nhận bi ăn
    PottedBall --> PocketPosition
    Turn "1" --> "*" ScoreTransaction : sinh ra
    Turn "1" --> "*" ScoreLog : log mỗi người bị ảnh hưởng
    ScoreTransaction "*" --> "1" PlayerInGame : fromPlayer (trả)
    ScoreTransaction "*" --> "1" PlayerInGame : toPlayer (nhận)
    ScoreTransaction --> TransactionType
    ScoreLog "*" --> "1" PlayerInGame
    PlayerInGame "0..1" --> "0..1" User
```

**1. Bổ sung `PottedBall` + `PocketPosition` (thay cho `ballsPottedThisTurn: int`)**

- Mỗi lượt (`Turn`) giờ ghi nhận **danh sách bi ăn cụ thể** (`pottedBalls`), mỗi bi biết rõ: ăn bi số mấy (`ballNumber`), vào lỗ nào trong 6 lỗ chuẩn (`PocketPosition`), có phải bi đền/bi chỉ định không (`isDenBall`), và giá trị điểm của riêng bi đó (`pointValue`) — vì `PocketRule` cho phép lỗ giữa nhân hệ số khác lỗ góc.
- `GameSession.getRemainingBalls()` và `getCurrentDenBallNumber()` được **tính toán (derived)** từ toàn bộ `PottedBall` đã ghi nhận trừ đi `RuleConfig.totalBalls`, chứ không lưu state riêng — tránh 2 nguồn dữ liệu bị lệch nhau (số bi còn lại phải luôn nhất quán với lịch sử lượt bắn).

**2. Bổ sung `ScoreTransaction` (thay cho `Turn.scoreChange: int`)**

- Điểm/tiền giờ được mô hình như **giao dịch có 2 phía**: `fromPlayer` (người trả) → `toPlayer` (người nhận), với `amount` luôn dương. Đây là cách duy nhất biểu diễn đúng bản chất zero-sum của luật đền.
- **Đền cả làng** (`DenType.DEN_CA_LANG`, ví dụ bàn 4 người): 1 `Turn` sinh ra **N-1 `ScoreTransaction`** (người phạm lỗi trả cho từng người còn lại), tất cả share chung `transactionGroupId` để UI có thể hiển thị gộp ("A đền cả làng lượt 12") dù về data là nhiều dòng riêng lẻ.
- **Đền chỉ định** (`DenType.DEN_CHI_DINH`, ví dụ ăn bi đền của B): chỉ sinh **1 `ScoreTransaction`** từ A → B.
- `Turn.calculateOutcome()` là nơi rule engine thực thi toàn bộ logic: đọc `pottedBalls` + `denType` + tra `RuleConfig` (cả `PenaltyRule` lẫn `PocketRule`) → trả về danh sách `ScoreTransaction` → áp dụng vào `PlayerInGame.currentScore` của từng người liên quan.
- `ScoreLog` được giữ lại nhưng đổi vai trò: không còn gắn 1-1 với `Turn` như cũ, mà là **snapshot điểm số sau khi nettinng tất cả transaction trong lượt đó, cho từng người chơi bị ảnh hưởng** (1 `Turn` với đền cả làng sẽ tạo ra N dòng `ScoreLog`, mỗi người 1 dòng). Nhờ vậy `undoLastTurn()` chỉ cần lặp qua các `ScoreLog` của `Turn` đó để revert `previousScore` cho từng người và đánh dấu `Turn.isUndone = true`, bất kể lượt đó có bao nhiêu giao dịch.

---

## 3. Module: History & Statistics

```mermaid
classDiagram
    class GameSession {
        <<from Module 2>>
    }

    class PlayerStatistics {
        +String id
        +User user
        +int totalGames
        +int wins
        +int losses
        +int draws
        +double winRate
        +double avgScorePerGame
        +int totalBallsPotted
        +DateTime lastUpdated
        +computeFromSessions(sessions)
    }

    class ExportRecord {
        +String id
        +GameSession gameSession
        +ExportFormat format
        +String fileUrl
        +DateTime createdAt
    }

    class ExportFormat {
        <<enumeration>>
        IMAGE
        PDF
    }

    User "1" --> "0..1" PlayerStatistics
    GameSession "1" --> "0..*" ExportRecord
    ExportRecord --> ExportFormat
```

**Ghi chú thiết kế:**

- Không tạo entity `GameHistory` riêng — lịch sử chính là tập `GameSession` có `status = FINISHED`, tránh trùng dữ liệu. Màn hình "Lịch sử" chỉ là 1 query/view.
- `PlayerStatistics` là bảng **denormalized** (tính sẵn), cập nhật mỗi khi 1 `GameSession` kết thúc — tránh phải tính lại từ đầu mỗi lần mở app.

---

## 4. Module: Matchmaking (Tìm đối kiểu Tinder)

```mermaid
classDiagram
    class PlayerProfile {
        +String id
        +User user
        +SkillLevel skillLevel
        +int maxRankDistance
        +List~GameType~ preferredGameTypes
        +String bio
        +List~TimeSlot~ availableTimes
        +GeoPoint location
        +List~String~ photos
        +bool isActive
        +isCompatibleWith(other) bool
    }

    class GameType {
        <<enumeration>>
        BAN_DEN
        LO
        BA_BANG
        CAROM
    }

    class SwipeAction {
        +String id
        +PlayerProfile fromProfile
        +PlayerProfile toProfile
        +SwipeType action
        +DateTime timestamp
    }
    note for SwipeAction "UNIQUE(fromProfile, toProfile)\nfeed query loại profile đã có SwipeAction bất kỳ loại nào"

    class SwipeType {
        <<enumeration>>
        LIKE
        PASS
        SUPER_LIKE
    }

    class Match {
        +String id
        +PlayerProfile profileA
        +PlayerProfile profileB
        +DateTime matchedAt
        +MatchStatus status
        +PlayerProfile? unmatchedBy
        +DateTime? expiresAt
        +unmatch(by)
        +isConversationLocked() bool
    }

    class MatchStatus {
        <<enumeration>>
        ACTIVE
        UNMATCHED
        EXPIRED
    }

    class Conversation {
        +String id
        +Match match
        +List~Message~ messages
    }

    class Message {
        +String id
        +PlayerProfile sender
        +String content
        +DateTime sentAt
        +bool isRead
    }

    class Report {
        +String id
        +PlayerProfile reporterProfile
        +PlayerProfile reportedProfile
        +String reason
        +ReportStatus status
        +DateTime createdAt
    }

    class ReportStatus {
        <<enumeration>>
        PENDING
        REVIEWED
        DISMISSED
    }

    class BlockList {
        +String id
        +PlayerProfile blockerProfile
        +PlayerProfile blockedProfile
        +DateTime createdAt
    }

    PlayerProfile --> GameType
    PlayerProfile "1" --> "*" SwipeAction : sends
    SwipeAction --> SwipeType
    SwipeAction "2" ..> "0..1" Match : mutual like creates
    Match "1" --> "1" Conversation
    Match --> MatchStatus
    Conversation "1" --> "*" Message
    Message "*" --> "1" PlayerProfile : sender
    PlayerProfile "1" --> "*" Report : reports
    Report --> ReportStatus
    PlayerProfile "1" --> "*" BlockList : blocks
```

**Ghi chú thiết kế:**

- `PlayerProfile.isCompatibleWith(other)` dùng `SkillLevel.rankDistance()` (Module 1) + `maxRankDistance` do user tự set (vd: chỉ muốn gặp người trong ±2 hạng) — lọc ngay ở tầng query feed, tránh hiện người hạng K ghép với người hạng A gây trải nghiệm tệ cho cả hai bên.
- **Vá lỗ hổng — Pass vĩnh viễn:** ràng buộc `UNIQUE(fromProfile, toProfile)` trên `SwipeAction` đảm bảo mỗi cặp chỉ có tối đa 1 record. Query lấy feed luôn `WHERE toProfile NOT IN (SELECT toProfile FROM SwipeAction WHERE fromProfile = :me)` — nghĩa là bất kể Like hay Pass, người đó **không bao giờ hiện lại** trong feed của mình nữa. Nếu sau này muốn tính năng "xem lại người đã Pass" (kiểu Tinder Rewind trả phí) thì mới cần query riêng trên bảng này, không cần đổi schema.
- **Vá lỗ hổng — vòng đời `Match`:** trước đây chỉ có `ACTIVE/ARCHIVED` không đủ. Giờ có `UNMATCHED` (1 trong 2 bên chủ động huỷ, lưu `unmatchedBy` để biết ai huỷ) và `EXPIRED` (match tạo ra nhưng không ai nhắn tin trong X ngày, dùng `expiresAt` để job nền tự chuyển trạng thái — khuyến khích người dùng chủ động nhắn sớm). `Conversation.isConversationLocked()` suy ra từ `match.status != ACTIVE` (không lưu field riêng để tránh 2 nguồn state lệch nhau) — khi khoá thì UI chỉ cho xem lại lịch sử chat, không cho gửi tin mới.
- `Match` chỉ được tạo khi tồn tại **2 `SwipeAction` LIKE** (hoặc ít nhất 1 `SUPER_LIKE`) giữa 2 profile theo cả 2 chiều — nên xử lý ở backend (Supabase function/trigger), không nên tính ở client để tránh gian lận.
- `Report` và `BlockList` tách riêng vì mục đích khác nhau: Report cần workflow duyệt (moderation), Block chỉ là hành động 1 chiều ẩn user khỏi feed — cần có từ đầu vì tính năng này tiếp xúc người lạ ngoài đời thật.

---

## 5. Module: Venue Map (Tìm quán bida)

```mermaid
classDiagram
    class Venue {
        +String id
        +String name
        +String address
        +GeoPoint location
        +String openHours
        +String? priceRange
        +String? phone
        +List~String~ photos
        +User? addedByUser
        +bool verified
        +double avgRating
        +getDistanceFrom(point) double
        +updateAvgRating()
    }

    class VenueReview {
        +String id
        +Venue venue
        +User user
        +int rating
        +String comment
        +DateTime createdAt
    }

    class VenueTable {
        +String id
        +Venue venue
        +int tableNumber
        +bool isAvailable
        +DateTime lastUpdated
    }

    User "0..1" --> "*" Venue : addedBy
    Venue "1" --> "*" VenueReview
    Venue "1" --> "*" VenueTable
```

**Ghi chú thiết kế:**

- `addedByUser` cho phép **crowdsource** dữ liệu quán (vì data ban đầu sẽ thưa) — nhưng có cờ `verified` để admin duyệt trước khi hiển thị công khai, tránh spam địa điểm ảo.
- `VenueTable` (số bàn trống real-time) đánh dấu là tính năng **tương lai** — chỉ khả thi nếu chủ quán chủ động cập nhật, nên để version sau, không nằm trong Phase 3 ban đầu.

---

## 6. Diagram tổng hợp — Quan hệ giữa các module

```mermaid
classDiagram
    class User
    class PlayerInGame
    class GameSession
    class PlayerStatistics
    class PlayerProfile
    class Venue
    class Match

    User "1" --> "*" PlayerInGame : chơi (optional, hỗ trợ guest)
    User "1" --> "0..1" PlayerStatistics : có
    User "1" --> "0..1" PlayerProfile : có (Phase 3)
    User "0..1" --> "*" Venue : thêm quán (Phase 3)
    PlayerInGame "*" --> "1" GameSession : thuộc về
    PlayerProfile "*" --> "*" Match : tham gia qua swipe
```

**Đọc diagram này để thấy:** `User` là entity trung tâm nhưng **không bắt buộc** cho Phase 1 (chơi guest được) — chỉ trở thành bắt buộc khi cần Phase 3 (matchmaking, venue crowdsource) vì cần định danh để chat/report an toàn.

---

## 7. Mapping sang tầng dữ liệu Flutter

| Module                                     | Local (Drift/SQLite)     | Remote (Supabase/Firebase)                |
| ------------------------------------------ | ------------------------ | ----------------------------------------- |
| Scoring (GameSession, Turn, RuleConfig...) | Bắt buộc — offline-first | Optional (sync sau nếu cần backup)        |
| History & Statistics                       | Tính từ local trước      | Optional sync                             |
| Matchmaking                                |                          | Bắt buộc — cần realtime + auth            |
| Venue Map                                  | Cache local (đọc nhanh)  | Nguồn chính (crowdsource + Google Places) |

**Khuyến nghị code:** dùng `freezed` cho immutable model classes (map trực tiếp từ các class ở trên), `drift` generate table từ model cho Scoring, và 1 lớp `Mapper`/`Repository` riêng để chuyển đổi giữa model local ↔ model remote (tránh model bị "dính" logic của cả 2 nguồn dữ liệu).
