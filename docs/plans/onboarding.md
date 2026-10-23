# Plan — Welcome / Onboarding khi mở ứng dụng

Ngày lập: 2026-10-24. Trạng thái: đã implement (2026-10-24).

> Ghi chú triển khai: code đã có trong working tree; `flutter test` và
> `flutter analyze` đều pass. Các kiểm tra thủ công trên thiết bị thật
> (TalkBack/VoiceOver, profile 60fps) chưa thực hiện trong phiên này.

Ước lượng: **3–3,5 ngày** cho 1 dev Flutter (chưa gồm thời gian duyệt nội dung
và chỉnh animation theo cảm nhận thực tế trên thiết bị).

## 1. Mục tiêu

Thay màn hình đầu tiên hiện tại (`Mainscreen` vào thẳng tab Home) bằng một chuỗi
onboarding 5 trang, xuất hiện **một lần** khi người dùng mở app lần đầu:

- Giới thiệu BiDART là gì và giải quyết nỗi đau nào (chia điểm bắn đền, cãi nhau,
  quên lượt).
- Dạy 3 thao tác cốt lõi: chọn người → chọn bi → điểm tự cập nhật; undo và tự lưu.
- Giới thiệu tầm nhìn tìm kèo / tìm quán (có nhãn “Sắp có” vì chưa có backend).
- Kết thúc bằng CTA tạo phòng đầu tiên, đưa người dùng vào đúng việc họ cần làm.
- Thiết kế dark, đồng bộ brand (logo 9 bi, mint `#4EDEA3`, amber `#FFB95F`) và
  chuyển động mượt, không dùng ảnh raster.
- Có đường xem lại giới thiệu từ Cài đặt tài khoản, không reset trạng thái.

### Không nằm trong phạm vi

- Đăng nhập / đăng ký / OTP (auth chưa triển khai).
- Xin quyền vị trí, thông báo, đăng ký tài khoản.
- Cá nhân hoá nội dung theo dữ liệu người dùng.
- Âm thanh, video, Lottie/Rive, ảnh chụp thật.
- Light-mode artwork riêng (onboarding dark-locked có chủ đích).
- Lưu tiến độ từng trang khi app bị kill giữa chừng.
- Analytics/A-B testing.

## 2. Quyết định thiết kế

| #   | Quyết định                                                                  | Lý do                                                                                                      |
| --- | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| D1  | 5 trang: Welcome + 3 giá trị + Ready                                        | Đủ kể chuyện trong ~35–45 giây, có skip; 3 trang thì thiếu, 6–7 trang thì mệt                             |
| D2  | Chỉ hiện khi `onboarding_seen_version < current`                            | Người cũ không bị làm phiền; khi thêm trang mới chỉ cần tăng version                                       |
| D3  | Onboarding luôn dark, bọc `Theme(data: AppTheme.dark)`                      | Nối liền native splash dark hiện có, tránh nháy trắng; tạo không gian “cinematic” cho brand                 |
| D4  | Chỉ thêm `shared_preferences`; không thêm package animation/indicator       | 1 boolean/version không đáng mở schema Drift; dot + hiệu ứng tự viết bằng Flutter built-in                 |
| D5  | Chỉ ghi `seen` khi bấm Skip hoặc hoàn tất, không ghi khi vừa xem trang 1    | Thoát giữa chừng thì lần sau vẫn thấy lại giới thiệu                                                       |
| D6  | Gate ở `BidartApp.home`, preload prefs trong `main()` trước `runApp`        | Không có màn loading riêng, không nháy onboarding → Home → onboarding; vào app đúng 1 frame                |
| D7  | CTA cuối “Tạo phòng đầu tiên” mở thẳng `AddRoom`; nút phụ về Home           | Đưa người dùng vào hành động chính ngay; tránh thêm 1 bước chạm                                            |
| D8  | Xem lại từ `AccountSettingsScreen`, dùng `replay: true`                     | Không đổi version, không ảnh hưởng lần mở app sau; CTA cuối đổi thành “Đã hiểu”                             |
| D9  | Trang Tìm kèo/CLB gắn chip “SẮP CÓ”                                         | Tính năng mới có UI mock, chưa có backend; không hứa điều chưa làm được                                     |
| D10 | Chỉ trang đang active mới chạy animation loop; tôn trọng `disableAnimations` | Không tốn pin/CPU cho trang offscreen; test `pumpAndSettle` không bị treo                                   |
| D11 | Nội dung nằm trong `onboarding_content.dart` dạng data const                 | Đổi copy không phải sửa widget; dễ test thứ tự/CTA; tránh hard-code rải rác                               |
| D12 | Visual vẽ bằng widget + `CustomPainter`; tái dùng `BidartLogoMark`/`PoolBallIcon` | Không tăng bundle, scale mọi kích thước, khớp theme token; không phụ thuộc asset từ designer               |

### Phương án đã cân nhắc nhưng không chọn

- **Drift table `app_settings`:** sạch về kiến trúc nhưng phải bump schema v2,
  migration, DAO, test riêng cho đúng 1 số nguyên → over-engineering.
- **Lưu file JSON qua `path_provider`:** không chạy trên web, trong khi app có
  build web; `shared_preferences` hỗ trợ cả mobile/web/desktop.
- **`smooth_page_indicator` / `flutter_animate`:** thêm dependency chỉ để làm
  vài hiệu ứng đã có sẵn bằng `AnimationController` + `AnimatedBuilder`.
- **Dark/light hai bộ artwork:** tăng gấp đôi công chỉnh visual; onboarding là
  khoảnh khắc brand nên dark-locked là lựa chọn có chủ đích.

## 3. Luồng trải nghiệm

### 3.1. Sơ đồ

```
Native splash (dark, logo BiDART)
        │
        ▼
Đọc onboarding_seen_version (preload trong main)
        │
        ├── đã xem (>= 1) ──────────────► Mainscreen (Home)
        │
        └── chưa xem (0)
                │
                ▼
        Trang 1 → 2 → 3 → 4 → 5
                │       │
                │       └── Bỏ qua (trang 1–4) ──► Mainscreen (Home)
                │
                └── Trang 5:
                    ├── "Tạo phòng đầu tiên" ──► Mainscreen + mở AddRoom
                    └── "Khám phá ứng dụng"  ──► Mainscreen (Home)
```

### 3.2. Hành vi

| Tình huống                     | Hành vi                                                                 |
| ------------------------------ | ----------------------------------------------------------------------- |
| Mở app lần đầu                 | Hiện trang 1, không có hiệu ứng loading                                 |
| Vuốt ngang                     | Chuyển trang; cập nhật dot + CTA; haptic nhẹ khi trang dừng             |
| Bấm “Tiếp tục”                 | `PageController.nextPage` 380 ms; trang cuối đổi thành CTA hoàn tất     |
| Bấm dot                        | Nhảy tới trang tương ứng                                                |
| Bấm “Bỏ qua” (trang 1–4)       | Ghi `seen = current`, fade 180 ms, vào Home                             |
| Back Android ở trang 2–5       | Về trang trước, không thoát app                                         |
| Back Android ở trang 1         | Thoát app như bình thường                                               |
| Bấm “Tạo phòng đầu tiên”       | Ghi `seen`, vào Mainscreen, post-frame push `AddRoom`                   |
| Bấm “Khám phá ứng dụng”        | Ghi `seen`, vào Mainscreen Home                                         |
| Kill app giữa onboarding       | Lần sau hiện lại từ trang 1 (chấp nhận; P1 mới lưu trang)               |
| Mở lại từ Cài đặt              | `replay: true`: có nút “Đóng”, không có Skip, CTA cuối “Đã hiểu” → pop   |
| Xoay ngang / tablet            | Nội dung co giãn theo `LayoutBuilder`, không overflow                    |
| OS bật “Remove animations”     | Tắt loop, rút animation còn fade ngắn; không confetti                   |

### 3.3. Điều kiện hiển thị

- Key: `onboarding.seen_version` (int, mặc định 0).
- Hằng số: `onboardingVersion = 1` trong `lib/features/onboarding/onboarding_store.dart`.
- Hiển thị khi `seenVersion < onboardingVersion`.
- Muốn cho người cũ xem lại toàn bộ: tăng `onboardingVersion` lên 2.
- Không lưu “đang ở trang mấy”; không lưu “đã skip từng trang”.

## 4. Nội dung 5 trang

Khung chung mỗi trang:

```
┌────────────────────────────────────┐
│ (◉) BiDART                  Bỏ qua │  ← top bar 56dp
│                                    │
│          ILLUSTRATION              │  ← 38–42% chiều cao khả dụng
│          (animation)               │
│                                    │
│ 01 • CHIA ĐIỂM TỰ ĐỘNG             │  ← eyebrow
│ Không còn cãi nhau                 │  ← title, 2 dòng
│ sau mỗi cú bi.                     │
│                                    │
│ Chọn hình bi vừa vào lỗ...         │  ← body, tối đa 3 dòng
│                                    │
│ ●  ○  ○  ○  ○                       │  ← dots (bấm được)
│ ┌────────────────────────────────┐ │
│ │          Tiếp tục →            │ │  ← CTA 56dp
│ └────────────────────────────────┘ │
└────────────────────────────────────┘
```

Nội dung chính xác (copy tiếng Việt, có thể chỉnh khi duyệt):

| #   | Eyebrow                     | Title (xuống dòng theo `\n`)       | CTA                    |
| --- | --------------------------- | ---------------------------------- | ---------------------- |
| 1   | `BIDART • TRỢ LÝ BÀN BIDA`  | `Ghi điểm chuẩn.\nChơi hết mình.`  | `Bắt đầu`              |
| 2   | `01 • CHIA ĐIỂM TỰ ĐỘNG`    | `Không còn cãi nhau\nsau mỗi cú bi.` | `Tiếp tục`           |
| 3   | `02 • GHI CÚ TRONG 3 CHẠM`  | `Chọn người. Chọn bi.\nXong.`      | `Tiếp tục`             |
| 4   | `03 • RA NGOÀI BÀN` + chip  | `Tìm kèo. Tìm quán.\nNgay quanh bạn.` | `Tiếp tục`          |
| 5   | `04 • SẴN SÀNG`             | `Vào bàn thôi.`                    | `Tạo phòng đầu tiên`   |

### 4.1. Trang 1 — Welcome

**Copy**

- Eyebrow: `BIDART • TRỢ LÝ BÀN BIDA`
- Title: `Ghi điểm chuẩn.` / `Chơi hết mình.`
- Body: `Trợ lý ghi điểm bắn đền cho bàn 2–5 người. Tự động chia điểm theo luật,
  lưu từng cú ngay trên máy — không cần mạng.`
- CTA: `Bắt đầu` (icon `arrow_forward_rounded`).

**Visual**

- Nền canvas `#0F131D` (đúng màu native splash) + quầng mint tỏa từ trên phải.
- Vòng tròn mint 168dp, stroke 2dp, hở 70° ở vị trí “pocket”.
- `BidartLogoMark(size: 120)` đặt giữa, float nhẹ.
- 3 viên bi nhỏ (`PoolBallIcon`) bay quanh quỹ đạo 220dp: bi 9 (28dp), bi 3
  (20dp), bi 1 (18dp), tốc độ khác nhau.
- Dotted orbit 36 chấm, alpha 12%, xoay chậm 24 giây/vòng.

**Motion**

- Logo scale `0.94 → 1` + fade 560 ms.
- Ring vẽ dần (`Tween<double>` sweep) 700 ms, delay 120 ms.
- Balls trượt vào quỹ đạo 800 ms, delay 240 ms, `easeOutCubic`.

### 4.2. Trang 2 — Chia điểm tự động

**Copy**

- Eyebrow: `01 • CHIA ĐIỂM TỰ ĐỘNG`
- Title: `Không còn cãi nhau` / `sau mỗi cú bi.`
- Body: `Chọn hình bi vừa vào lỗ. BiDART tự tính người được cộng, người chịu đền
  và điểm của cả bàn theo đúng luật đề-pa.`
- CTA: `Tiếp tục`.

**Visual**

- Card bảng điểm nghiêng nhẹ `-0.03 rad`, rộng ~300dp, bo 16dp:
  - Header: `VÒNG 4 • 9 BI BẮN ĐỀN` + chấm live.
  - 4 hàng: `Tuấn Anh +30` (mint), `Huy Bida −10` + chip `Chịu đền` (đỏ),
    `Minh Rasson −10`, `Hoàng Long −10`.
  - Footer: `Tổng bàn: 0` (chip) + bi 9 nhỏ.
- Một chip `+50đ` nổi lên cạnh hàng người ăn rồi tắt.
- Dữ liệu minh hoạ hard-code trong widget (không import scoring engine).

**Motion**

- Số điểm đếm `0 → giá trị` 700 ms, stagger 120 ms mỗi hàng.
- Hàng người ăn scale nhẹ `1.0 → 1.03 → 1.0`.
- Hàng chịu đền fade viền đỏ từ 0 → 60% rồi giữ.
- Chip `Tổng bàn: 0` pop cuối (scale 0.8 → 1.05 → 1).

### 4.3. Trang 3 — Ghi cú trong 3 chạm

**Copy**

- Eyebrow: `02 • GHI CÚ TRONG 3 CHẠM`
- Title: `Chọn người. Chọn bi.` / `Xong.`
- Body: `Chạm cơ thủ đang có cơ, chọn bi vừa ăn — điểm cập nhật ngay. Nhập nhầm?
  Hoàn tác từng cú, không giới hạn.`
- CTA: `Tiếp tục`.

**Visual**

- Card “Lượt của Tuấn Anh” + 3 step-chip: `1 Chọn người` → `2 Chọn bi` →
  `3 Xong`.
- Lưới 3×3 `PoolBallIcon` (bi 1–9), size 46dp.
- Bi 9 có viền amber, glow, badge `Đang chọn`.
- Dưới lưới: pill `↺ Đã hoàn tác cú trước` trượt lên.

**Motion**

- Ripple tròn từ bi 9 mỗi 2,4 giây (chỉ trang active).
- Step-chip active chạy lần lượt 0 → 1 → 2, mỗi bước 420 ms.
- Undo pill `translateY 12 → 0` + fade, delay 1,2 giây.

### 4.4. Trang 4 — Tìm kèo & CLB (Sắp có)

**Copy**

- Eyebrow: `03 • RA NGOÀI BÀN` + chip `SẮP CÓ` (secondary, chữ nhỏ).
- Title: `Tìm kèo. Tìm quán.` / `Ngay quanh bạn.`
- Body: `Lướt tìm đối thủ cùng trình, xem quán còn bàn trống và chốt kèo trong
  vài chạm. Tính năng đang được hoàn thiện.`
- CTA: `Tiếp tục`.

**Visual**

- 2 lớp thẻ swipe: thẻ sau xoay `+4°`, thẻ trước xoay `-2°`.
- Thẻ trước: avatar gradient + chữ tắt, tên `Đức “Cơ Điên”`, chip
  `Hạng B+`, chip `94% hợp cạ`.
- Nửa dưới: map card nhỏ với 3 pin, route nét đứt mint, 1 pin phát ping.
- Badge `SẮP CÓ` đặt góc trên phải illustration, nền secondary 16%, viền 40%.

**Motion**

- Thẻ trước float ±4dp, 3,2 giây.
- Pin radar ping 1,8 giây/lần, 2 vòng.
- Route nét đứt chạy `strokeDashOffset` chậm (nếu painter hỗ trợ; không thì fade
  từng đoạn).

### 4.5. Trang 5 — Ready

**Copy**

- Eyebrow: `04 • SẴN SÀNG`
- Title: `Vào bàn thôi.`
- Body: `Tạo phòng đầu tiên, chọn người đề-pa và người chịu đền. Mọi thứ còn lại
  để BiDART lo.`
- Recap chips: `2–5 người` • `9 bi chuẩn` • `Tự lưu offline`
- CTA chính: `Tạo phòng đầu tiên` (icon `play_circle_fill_rounded`).
- CTA phụ: `Khám phá ứng dụng` (TextButton).
- Không có Skip ở trang này.

**Visual**

- Mini room card: `Phòng #01`, `4 người`, `9 Bi Bắn Đền`, chấm live.
- Vòng check mint lớn phía sau card, vẽ dần.
- Confetti 12 hạt (mint/amber/trắng) bung 1 lần khi trang active, 900 ms,
  không lặp.

**Motion**

- Check ring sweep 800 ms, `easeInOutCubic`.
- Card `translateY 16 → 0` + fade 520 ms.
- Confetti chỉ chạy nếu `!disableAnimations`.

## 5. Hệ thống thiết kế

### 5.1. Token màu (dark-locked)

| Token              | Giá trị                          | Dùng cho                            |
| ------------------ | -------------------------------- | ----------------------------------- |
| `canvas`           | `#0F131D` (khớp splash)          | Nền gốc                             |
| `canvasDeep`       | `#0B0F17`                        | Đáy gradient                        |
| `surface`          | `#161B24`                        | Card, top bar                       |
| `surfaceHigh`      | `#242A34`                        | Card nổi, scoreboard                |
| `primary`          | `#4EDEA3`                        | Eyebrow, dot active, ring, CTA text |
| `primaryContainer` | `#10B981`                        | CTA gradient, glow                  |
| `secondary`        | `#FFB95F`                        | Bi 9, chip “Sắp có”, điểm nhấn       |
| `onSurface`        | `#DFE2F1`                        | Title                               |
| `onSurfaceVariant` | `#BBCABF`                        | Body                                |
| `error`            | `#FFB4AB`                        | Hàng chịu đền                       |
| `outline`          | `#414942` @ 60%                  | Viền card                           |

- Quầng nền: radial mint alpha 16% ở `topRight`, radial amber alpha 8% ở
  `bottomLeft`; không dùng `BackdropFilter`.
- Lưới nền: `CustomPainter`, ô 48dp, line 1dp alpha 5%, mask radial để mờ dần
  ra viền.
- Gradient CTA: `#4EDEA3 → #10B981` (trái → phải), shadow
  `0 12 32 rgba(16,185,129,0.32)`.

### 5.2. Typography

App hiện chưa bundle font `Plus Jakarta Sans` (chỉ logo painter tham chiếu). P0
dùng font hệ thống để không đổi typography toàn app và không tăng asset:

| Vai trò   | Style                         | Ghi chú                            |
| --------- | ----------------------------- | ---------------------------------- |
| Eyebrow   | `labelSmall` 11, w700         | Uppercase, letterSpacing 1.4       |
| Title     | 30/36, w800                   | letterSpacing -0.4, tối đa 2 dòng  |
| Body      | 15/22, w400                   | `onSurfaceVariant`, tối đa 3 dòng  |
| Recap     | `labelMedium` 13, w600        | Chip nền `surfaceHigh`             |
| CTA       | 16, w700                      | Icon 20dp, gap 8                   |
| Skip      | `labelLarge` 14, w600         | `onSurfaceVariant`, hit area 48dp  |

> P1 (tuỳ chọn): bundle Plus Jakarta Sans 600/800 vào `assets/fonts` và chỉ áp
> dụng cho onboarding qua `Theme` cục bộ. Không đổi font toàn app trong task này.

### 5.3. Khoảng cách & layout

- Content max width: 480dp (tablet 520dp), căn giữa.
- Padding ngang: 24dp. Top bar cao 56dp. Bottom safe area + 16dp.
- Illustration frame: cao 38–42% chiều cao khả dụng, min 220dp, max 360dp,
  aspect ratio ~1:1.1; nhỏ hơn trên màn thấp.
- Khoảng cách: eyebrow → title 10dp; title → body 12dp; body → dots 28dp;
  dots → CTA 14dp.
- Dot: 8×8, active 24×8, radius 999, gap 8.
- Card radius 16; illustration frame radius 28; pill radius 999.
- Toàn bộ dùng `SafeArea`; nền gradient phủ edge-to-edge.

### 5.4. Nguyên tắc visual

- Không ảnh raster, không network image; mọi thứ scale theo `size`.
- Mỗi trang có **một** điểm nhấn màu: mint (1, 3, 5), amber (2), mint+amber (4).
- Nền tối, card sáng hơn 1 bậc; không dùng pure black `#000`.
- Không blur nặng; cảm giác “kính” tạo bằng gradient + viền sáng 6%.
- Visual phải đọc được ở 200×200dp (widget test) và 360dp.

## 6. Chuyển động

### 6.1. Token

| Token           | Giá trị                          | Dùng cho                          |
| --------------- | -------------------------------- | --------------------------------- |
| `fast`          | 160 ms                           | Press, đổi label CTA              |
| `base`          | 240 ms                           | Dot, fade nhỏ                     |
| `page`          | 380 ms                           | `PageView.nextPage`               |
| `entrance`      | 560 ms                           | Visual + text vào trang           |
| `loopFloat`     | 2.800 ms                         | Float lên/xuống                   |
| `loopGlow`      | 2.200 ms                         | Quầng sáng thở                    |
| `loopRadar`     | 1.800 ms                         | Ping map                          |
| `curveIn`       | `Curves.easeOutCubic`            | Entrance, fade                    |
| `curvePage`     | `Curves.easeInOutCubic`          | Chuyển trang                      |
| `curvePress`    | `Curves.easeOut`                 | Scale nút                        |

Không dùng bounce/elastic cho title/CTA; chỉ confetti và dot có thể hơi nảy.

### 6.2. Timeline vào trang (mỗi lần trang thành active)

```
0 ms     visual: opacity 0→1, scale 0.94→1        (560 ms, easeOutCubic)
60 ms    eyebrow: opacity 0→1, translateY 10→0     (420 ms)
120 ms   title: opacity 0→1, translateY 18→0       (480 ms)
200 ms   body: opacity 0→1, translateY 12→0        (420 ms)
350 ms   visual-specific sequence (score/ripple/confetti)
```

- Mỗi `OnboardingPage` giữ 1 `AnimationController`; khi `isActive` chuyển
  `false → true` thì `reset()` + `forward()`.
- Bottom bar (dots + CTA) đứng ngoài `PageView`, không chạy lại entrance.
- Khi rời trang, controller dừng; quay lại thì chạy lại (tạo cảm giác “sống”).

### 6.3. Chuyển trang & parallax

- `PageView.builder`, `physics: BouncingScrollPhysics` (iOS) /
  `ClampingScrollPhysics` mặc định Android; cho phép vuốt.
- `AnimatedBuilder` trên `PageController` (chỉ khi `hasClients`):
  - Visual: `translateX = -0.08 × delta × width`.
  - Text block: `translateX = -0.03 × delta × width`.
  - Nền: màu quầng lerp `primary → secondary` theo `page / (n - 1) × 0.35`.
  - Opacity content: `1 - 0.15 × |delta|` (tối thiểu 0.7).
- CTA label đổi bằng `AnimatedSwitcher` 180 ms, không đổi kích thước nút.
- Dot active dùng `AnimatedContainer` 220 ms.

### 6.4. Idle loop (chỉ trang active)

- Float: `sin(t × 2π / 2.8s) × 5dp`.
- Glow: opacity `0.55 ↔ 0.9`, 2.2 giây, reverse.
- Ring: xoay 360° / 24 giây.
- Radar: 2 vòng ping, reset sau 1.8 giây.
- Tất cả nằm trong `TickerMode(enabled: isActive)` và chỉ `Transform`/`Opacity`.

### 6.5. Micro-interaction

- CTA: `AnimatedScale` 1 → 0.97 khi `onTapDown`, về 1 khi `onTapUp/Cancel`
  (120 ms); shadow tăng nhẹ khi press.
- Haptic: `HapticFeedback.selectionClick()` khi `onPageChanged`; `lightImpact()`
  khi hoàn tất. Bọc `try/catch`/platform check để không lỗi trên web/desktop.
- Skip: `AnimatedOpacity` 180 ms trên toàn màn trước khi gọi callback.
- Dot: tap để nhảy trang, có `Semantics(button: true, label: 'Trang N')`.

### 6.6. Reduced motion

Đọc `MediaQuery.disableAnimationsOf(context)`:

- Không chạy loop (float/glow/ring/radar/confetti).
- Entrance rút còn fade 120 ms, không translate/scale.
- `nextPage` dùng 200 ms hoặc `jumpToPage` nếu `accessibleNavigation`.
- Vẫn giữ thay đổi màu dot/CTA (không gây chóng mặt).

### 6.7. Quy tắc hiệu năng

- Chỉ animate `Transform` và `Opacity`; không animate layout mỗi frame.
- `RepaintBoundary` quanh illustration frame.
- Không `BackdropFilter`, `ImageFiltered`, `Opacity` lồng nhiều lớp.
- `CustomPainter` tĩnh: `shouldRepaint => false`; painter động nhận `Listenable`.
- `const` cho text/icon tĩnh.
- Visual trang offscreen không tick; `PageView` chỉ build trang gần viewport.
- Kiểm tra bằng `flutter run --profile` + DevTools frame chart; mục tiêu < 16 ms
  trên thiết bị tầm trung, không jank khi vuốt nhanh.

## 7. Kiến trúc & file thay đổi

### 7.1. Cây file

Thêm:

```
lib/features/onboarding/onboarding_store.dart
lib/features/onboarding/provider/onboarding_provider.dart

lib/screens/onboarding/onboarding_screen.dart
lib/screens/onboarding/onboarding_content.dart
lib/screens/onboarding/widgets/onboarding_page.dart
lib/screens/onboarding/widgets/onboarding_top_bar.dart
lib/screens/onboarding/widgets/onboarding_bottom_bar.dart
lib/screens/onboarding/widgets/onboarding_dots.dart
lib/screens/onboarding/widgets/onboarding_backdrop.dart
lib/screens/onboarding/widgets/onboarding_illustration_frame.dart
lib/screens/onboarding/widgets/visuals/welcome_visual.dart
lib/screens/onboarding/widgets/visuals/scoring_visual.dart
lib/screens/onboarding/widgets/visuals/recording_visual.dart
lib/screens/onboarding/widgets/visuals/discovery_visual.dart
lib/screens/onboarding/widgets/visuals/ready_visual.dart

test/features/onboarding/onboarding_store_test.dart
test/screens/onboarding/onboarding_screen_test.dart
test/screens/onboarding/onboarding_gate_test.dart
```

Sửa:

```
pubspec.yaml                       -> thêm shared_preferences
lib/main.dart                      -> preload prefs + override store + gate
lib/screens/main_screen.dart       -> thêm openCreateRoomOnStart (post-frame)
lib/screens/profile/settings/account_settings_screen.dart
                                   -> thêm mục "Xem lại giới thiệu"
test/widget_test.dart              -> override store, cập nhật test khởi động
docs/ui/ui_description.md          -> thêm mục 6. Onboarding
docs/ui/screens.md                 -> thêm mục 0. Onboarding
```

Không đổi: domain, scoring engine, Drift schema, repository, các tab hiện có.

### 7.2. Store & provider

`lib/features/onboarding/onboarding_store.dart`:

```dart
const onboardingVersion = 1;
const onboardingSeenKey = 'onboarding.seen_version';

abstract interface class OnboardingStore {
  int get seenVersion;
  Future<void> markSeen(int version);
}

class PrefsOnboardingStore implements OnboardingStore {
  PrefsOnboardingStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  int get seenVersion => _prefs.getInt(onboardingSeenKey) ?? 0;

  @override
  Future<void> markSeen(int version) =>
      _prefs.setInt(onboardingSeenKey, version);
}

/// Fallback khi SharedPreferences không khởi tạo được: coi như đã xem để
/// không chặn app và không hiện onboarding lặp lại mỗi lần mở.
class SeenOnboardingStore implements OnboardingStore {
  const SeenOnboardingStore();

  @override
  int get seenVersion => onboardingVersion;

  @override
  Future<void> markSeen(int version) async {}
}
```

`lib/features/onboarding/provider/onboarding_provider.dart`:

```dart
final onboardingStoreProvider = Provider<OnboardingStore>(
  (ref) => throw UnimplementedError('Override in main()'),
);

final showOnboardingProvider =
    NotifierProvider<ShowOnboardingController, bool>(
  ShowOnboardingController.new,
);

class ShowOnboardingController extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(onboardingStoreProvider).seenVersion < onboardingVersion;

  /// Ghi nhận đã xem rồi mới chuyển UI. Lỗi ghi không chặn người dùng.
  Future<void> complete() async {
    try {
      await ref.read(onboardingStoreProvider).markSeen(onboardingVersion);
    } catch (error) {
      debugPrint('Không lưu được onboarding: $error');
    } finally {
      state = false;
    }
  }
}
```

Ghi chú:

- `seenVersion` đọc đồng bộ vì prefs đã preload trong `main()`.
- Nếu prefs lỗi khi khởi tạo, `main()` dùng store fallback coi như đã xem
  (`seenVersion = onboardingVersion`) để app vẫn mở được, không hiện onboarding
  lặp lại mỗi lần mở.
- Không expose `markSeen` ra widget; chỉ gọi qua controller.

### 7.3. Gate trong `main.dart` / `BidartApp`

```dart
Future<OnboardingStore> _openOnboardingStore() async {
  try {
    return PrefsOnboardingStore(await SharedPreferences.getInstance());
  } catch (error) {
    debugPrint('Không đọc được onboarding flag: $error');
    return const SeenOnboardingStore();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboardingStore = await _openOnboardingStore();
  final database = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        onboardingStoreProvider.overrideWithValue(onboardingStore),
        appDatabaseProvider.overrideWithValue(database),
        gameRepositoryProvider.overrideWithValue(
          DriftGameRepository(database: database),
        ),
      ],
      child: const BidartApp(),
    ),
  );
}
```

`BidartApp` chuyển thành `ConsumerStatefulWidget` để giữ cờ
`_openCreateRoom` trong session:

```dart
class _BidartAppState extends ConsumerState<BidartApp> {
  bool _openCreateRoom = false;

  Future<void> _finish(OnboardingExit exit) async {
    setState(() => _openCreateRoom = exit == OnboardingExit.createRoom);
    await ref.read(showOnboardingProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final showOnboarding = ref.watch(showOnboardingProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bidart',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      home: showOnboarding
          ? OnboardingScreen(onFinish: _finish)
          : Mainscreen(openCreateRoomOnStart: _openCreateRoom),
    );
  }
}
```

- `OnboardingExit` là enum `{ explore, createRoom }`, khai báo trong
  `screens/onboarding/onboarding_screen.dart`.
- `Mainscreen` thêm `final bool openCreateRoomOnStart;` và trong `initState`:
  `if (widget.openCreateRoomOnStart) WidgetsBinding.instance.addPostFrameCallback(... push(AddRoom()))`.
  Chỉ push 1 lần; nếu đang có phòng active, `AddRoom` tự hiện lỗi như hiện tại.
- Không thêm global navigator key, không đổi routing toàn app.

### 7.4. `OnboardingScreen` API

```dart
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.replay = false,
    this.onFinish,
  });

  /// true: mở từ Cài đặt, có nút Đóng, CTA cuối "Đã hiểu" và pop.
  final bool replay;

  /// Chỉ dùng khi replay = false.
  final Future<void> Function(OnboardingExit exit)? onFinish;
}
```

- Root build bọc `Theme(data: AppTheme.dark, child: ...)` và
  `AnnotatedRegion<SystemUiOverlayStyle>(value: SystemUiOverlayStyle.light)`
  để status bar sáng trên nền tối; `Scaffold(backgroundColor: Colors.transparent)`
  đặt trên `OnboardingBackdrop` để gradient phủ edge-to-edge.
- Trang 1 dùng nền `#0F131D` đúng màu splash; top bar fade-in sau 120 ms để
  giảm cảm giác logo “nhảy” từ giữa màn hình splash lên góc trái.
- `replay: true` ⇒ đẩy bằng `MaterialPageRoute`, CTA cuối:
  - Primary `Đã hiểu` → `Navigator.pop`.
  - Không có CTA phụ.
- `replay: false` ⇒ CTA cuối:
  - Primary `Tạo phòng đầu tiên` → `onFinish(OnboardingExit.createRoom)`.
  - Secondary `Khám phá ứng dụng` → `onFinish(OnboardingExit.explore)`.
- Top bar:
  - Gate mode: logo + `Bỏ qua` (trang 1–4).
  - Replay mode: logo + icon `close` (`Đóng`).
- `PopScope`: gate mode `canPop: _index == 0`; nếu `!_didPop && _index > 0`
  thì `previousPage`. Replay mode `canPop: true`.

### 7.5. Content model

`onboarding_content.dart`:

```dart
enum OnboardingVisual { welcome, scoring, recording, discovery, ready }

class OnboardingPageContent {
  const OnboardingPageContent({
    required this.visual,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.ctaLabel,
    this.comingSoon = false,
  });

  final OnboardingVisual visual;
  final String eyebrow;
  final String title;
  final String body;
  final String ctaLabel;
  final bool comingSoon;
}

const onboardingPages = <OnboardingPageContent>[ ... ];
```

- `OnboardingPage` nhận `content`, `index`, `isActive`, `pageDelta` (hoặc
  `PageController`), `enableMotion`.
- Switch visual theo enum; visual widget nhận `isActive` để tự quản loop.
- Không đặt logic điều hướng trong visual.

### 7.6. Widget key cho test

| Key                        | Widget                                   |
| -------------------------- | ---------------------------------------- |
| `onboarding-screen`        | root `Scaffold`/`DecoratedBox`           |
| `onboarding-page-view`     | `PageView`                               |
| `onboarding-page-{i}`      | wrapper mỗi trang                        |
| `onboarding-skip`          | TextButton “Bỏ qua”                      |
| `onboarding-close`         | nút Đóng (replay)                        |
| `onboarding-primary-cta`   | CTA chính                                |
| `onboarding-secondary-cta` | CTA phụ (trang 5)                        |
| `onboarding-dot-{i}`       | dot                                      |
| `onboarding-replay-tile`   | ListTile trong Cài đặt                   |

## 8. Accessibility

- Mỗi trang có `Semantics(label: 'Trang ${i + 1} trên ${n}: ${title}')`; đổi
  trang thì `SemanticsService.announce` (chỉ khi screen reader bật).
- Visual decorative: `ExcludeSemantics` + một label mô tả ngắn
  (`BiDART, bảng điểm minh hoạ`, `lưới bi 1 đến 9`, ...).
- Nút/dot tối thiểu 48×48dp hit area (dot dùng `SizedBox` bao ngoài).
- Contrast: title/body trên `#0F131D` đạt AA; không dùng mint làm chữ body.
- Text scale 2.0: title/body co giãn, illustration thu nhỏ, toàn bộ page cuộn
  được trong `SingleChildScrollView` + `ConstrainedBox(minHeight)`.
- Skip/Close luôn trong vùng an toàn, không bị tai thỏ che.
- Không dùng chuyển động để truyền tải thông tin duy nhất.
- Ngôn ngữ: tiếng Việt, câu ngắn, không viết tắt khó hiểu.

## 9. Edge cases

- **Màn thấp 320×568:** visual co còn ~220dp; page cuộn dọc; CTA luôn trong
  `SafeArea`, không bị che.
- **Text scale 2.0:** cho phép cuộn; không đặt `maxLines` cứng cho body.
- **Tablet/landscape:** content max width 520; visual và text vẫn dọc (không
  chuyển 2 cột trong P0 để tránh rẽ nhánh layout).
- **Vuốt nhanh nhiều trang:** `PageController` dùng chung; chỉ trang active tick.
- **Bấm CTA liên tục:** chặn double-tap bằng `_finishing` flag trong 300 ms.
- **Ghi prefs lỗi:** vẫn vào app; log; lần sau có thể hiện lại onboarding (chấp
  nhận, không crash).
- **prefs chưa preload:** không xảy ra vì gate đọc store đã có sẵn; test phải
  override store, không để provider throw.
- **Mở replay khi đang ở trang 5 của gate:** không thể xảy ra (drawer chỉ có sau
  khi vào app).
- **`pumpAndSettle` treo do loop:** test phải dùng `pump(Duration)` hoặc bật
  `disableAnimations`; code phải dừng loop khi reduced motion.
- **`AddRoom` bị chặn do có phòng active:** giữ nguyên `CreateRoomErrorPanel`
  hiện có; onboarding không cần xử lý riêng.
- **Hot restart khi đang onboarding:** hiện lại trang 1 (D5).

## 10. Test plan

### 10.1. Unit — `onboarding_store_test.dart`

Setup: `TestWidgetsFlutterBinding.ensureInitialized()`;
`SharedPreferences.setMockInitialValues({...})`.

| #   | Case                                  | Kỳ vọng                                      |
| --- | ------------------------------------- | -------------------------------------------- |
| 1   | Không có key                          | `seenVersion == 0`                            |
| 2   | Key = 1                               | `seenVersion == 1`                            |
| 3   | `markSeen(1)`                         | prefs ghi đúng key/value                      |
| 4   | `markSeen` hai lần                    | vẫn là 1, không throw                         |
| 5   | Version tương lai (2)                 | `>= onboardingVersion` → không hiện           |
| 6   | prefs trả giá trị âm (dữ liệu bẩn)    | vẫn nhỏ hơn version → hiện onboarding         |

### 10.2. Widget — `onboarding_screen_test.dart`

Pump trực tiếp `OnboardingScreen` trong `MaterialApp`, dùng
`MediaQuery(data: MediaQueryData(disableAnimations: true))` hoặc
`tester.binding.platformDispatcher.accessibilityFeaturesTestValue`.
**Không dùng `pumpAndSettle` khi animation loop đang bật.**

| #   | Case                                | Kỳ vọng                                                        |
| --- | ----------------------------------- | -------------------------------------------------------------- |
| 1   | Mở lần đầu                          | Trang 1 hiển thị title, eyebrow, CTA `Bắt đầu`                  |
| 2   | Bấm CTA                             | Sang trang 2, dot 2 active, CTA `Tiếp tục`                      |
| 3   | Vuốt trái                           | Sang trang 2; vuốt phải về trang 1                              |
| 4   | Bấm dot 3                           | Nhảy đúng trang 3, nội dung đúng                                |
| 5   | Trang 5                             | CTA chính `Tạo phòng đầu tiên`, CTA phụ `Khám phá ứng dụng`; không có Skip |
| 6   | Bấm tạo phòng                       | `onFinish(OnboardingExit.createRoom)` gọi đúng 1 lần             |
| 7   | Bấm khám phá                        | `onFinish(OnboardingExit.explore)` gọi đúng 1 lần                |
| 8   | Bấm Skip ở trang 3                  | `onFinish(OnboardingExit.explore)`                               |
| 9   | Back Android ở trang 3              | Về trang 2, app không bị pop                                    |
| 10  | Replay mode                         | Có nút `Đóng`, không có Skip; CTA cuối `Đã hiểu`; bấm → pop      |
| 11  | Text scale 2.0, surface 320×568     | Không overflow; cuộn tới CTA được                               |
| 12  | `disableAnimations: true`           | `pumpAndSettle` kết thúc; không ticker loop                     |
| 13  | Semantics                           | Có label trang, Skip, CTA; visual bị exclude khỏi semantics     |
| 14  | Double tap CTA                       | Chỉ 1 callback (không double finish)                            |

### 10.3. Gate — `onboarding_gate_test.dart` / cập nhật `widget_test.dart`

| #   | Case                                | Kỳ vọng                                                        |
| --- | ----------------------------------- | -------------------------------------------------------------- |
| 1   | Store `seenVersion = 0`             | `BidartApp` render `OnboardingScreen`, không render `Mainscreen` |
| 2   | Store `seenVersion = 1`             | Render `Mainscreen`, không render `OnboardingScreen`            |
| 3   | Hoàn tất onboarding                 | Store ghi 1; sau đó render `Mainscreen`                         |
| 4   | Hoàn tất với `createRoom`           | `Mainscreen` render và `AddRoom` được push sau frame            |
| 5   | Hoàn tất với `explore`              | `Mainscreen` render, không push `AddRoom`                       |
| 6   | Replay từ Cài đặt                   | Push `OnboardingScreen(replay: true)`, pop về Cài đặt, flag không đổi |

Cập nhật test cũ:

- `test/widget_test.dart`: inject `onboardingStoreProvider` bằng store đã xem
  (hoặc mock prefs) cho các test kiểm tra `Mainscreen`; thêm test first-launch.
- Test gọi `app.main()` phải `await` và mock prefs trước.
- `test/screens/main_screen_test.dart`: thêm test constructor
  `openCreateRoomOnStart: true` push `AddRoom` đúng 1 lần.

### 10.4. Manual smoke

- Cài sạch → mở app → thấy onboarding, không nháy màn hình trắng.
- Xem hết 5 trang (cả swipe và CTA) → tạo phòng → `AddRoom` mở.
- Kill app, mở lại → vào thẳng Home.
- Vào Cài đặt → Xem lại giới thiệu → xem → Đóng → vẫn ở Cài đặt.
- Bật “Remove animations” của OS → không còn loop, vẫn dùng được.
- Xoay ngang, tablet, text scale 2.0 → không overflow.
- Đo frame bằng DevTools khi vuốt nhanh 10 lần → không jank, memory ổn định.
- Kiểm tra trên Android + iOS + web (nếu build web được).

## 11. Các bước implement

### Bước 1 — Store + provider + test (0,5 ngày)

- [ ] Thêm `shared_preferences: ^2.5.0` vào `pubspec.yaml`, `flutter pub get`.
- [ ] Viết `onboarding_store.dart` (gồm `SeenOnboardingStore` fallback),
      `onboarding_provider.dart`.
- [ ] Viết `onboarding_store_test.dart` (6 case).
- Verify: `flutter test test/features/onboarding/onboarding_store_test.dart`.

### Bước 2 — Gate + preload (0,5 ngày)

- [ ] `main()` preload prefs, override `onboardingStoreProvider`; fallback khi lỗi.
- [ ] `BidartApp` watch `showOnboardingProvider`, xử lý `_finish`.
- [ ] `Mainscreen.openCreateRoomOnStart` + post-frame push `AddRoom`.
- [ ] Tạo `OnboardingScreen` skeleton (Scaffold + text tạm) để test gate.
- [ ] Cập nhật `test/widget_test.dart`, thêm `onboarding_gate_test.dart`.
- Verify: `flutter test test/widget_test.dart test/screens/onboarding/`.

### Bước 3 — Khung onboarding (0,5 ngày)

- [ ] `onboarding_content.dart` với 5 trang + enum visual.
- [ ] `OnboardingScreen` + `PageController` + `PopScope` + `_finishing`.
- [ ] Top bar (Skip/Close), bottom bar (CTA + secondary), dots bấm được.
- [ ] Layout responsive: `LayoutBuilder` + `SingleChildScrollView` +
  `ConstrainedBox(minHeight)`; `SafeArea`.
- [ ] Key theo bảng §7.6.
- Verify: widget test 1–10.

### Bước 4 — Visual + animation (1–1,5 ngày)

- [ ] `OnboardingBackdrop` (gradient + grid + glow theo page).
- [ ] `OnboardingIllustrationFrame` + 5 visual.
- [ ] `OnboardingPage` entrance stagger + parallax.
- [ ] Idle loop cho trang active; `TickerMode`; reduced-motion.
- [ ] CTA press scale + haptic + AnimatedSwitcher label.
- Verify: chạy app thật, quay màn hình 60fps; widget test 11–14.

### Bước 5 — Hoàn tất luồng (0,5 ngày)

- [ ] `OnboardingExit`, CTA cuối, nút phụ; replay mode.
- [ ] `AccountSettingsScreen` thêm tile `Xem lại giới thiệu`.
- [ ] Kiểm tra push `AddRoom` sau gate; xử lý trường hợp có phòng active.
- Verify: smoke flow + test gate 4–6.

### Bước 6 — Dọn dẹp, docs, kiểm tra (0,5 ngày)

- [ ] Cập nhật `docs/ui/ui_description.md` mục 6 và `docs/ui/screens.md` mục 0.
- [ ] `dart format lib test`.
- [ ] `flutter analyze` sạch.
- [ ] `flutter test` toàn bộ pass.
- [ ] Kiểm tra accessibility (TalkBack/VoiceOver) và text scale.
- [ ] Đo hiệu năng bằng `--profile`; ghi chú kết quả vào PR.

## 12. Acceptance criteria

- [ ] Cài mới mở app → onboarding 5 trang, không nháy trắng, không màn loading.
- [ ] Điều hướng được bằng CTA, vuốt, dot, back Android; không kẹt trang.
- [ ] Skip hoạt động ở trang 1–4; trang 5 có CTA tạo phòng + khám phá.
- [ ] Hoàn tất/skip ghi `onboarding.seen_version = 1`; mở lại app vào thẳng Home.
- [ ] CTA tạo phòng mở đúng `AddRoom`; CTA khám phá về Home.
- [ ] Xem lại từ Cài đặt hoạt động, không reset trạng thái đã xem.
- [ ] Animation mượt trên thiết bị thật; tôn trọng reduced motion; không loop
      khi trang offscreen.
- [ ] Không overflow ở 320×568 và text scale 2.0.
- [ ] Screen reader đọc được tên trang, nút Skip, CTA, dot.
- [ ] `flutter analyze` sạch; toàn bộ test pass; test mới phủ các case §10.
- [ ] Không đổi domain/scoring/schema; chỉ thêm dependency `shared_preferences`.
- [ ] Không dùng ảnh raster/network image; bundle size không tăng đáng kể.

## 13. Rủi ro & giảm thiểu

| Rủi ro                                             | Giảm thiểu                                                                                   |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Onboarding làm phiền người dùng cũ                 | Chỉ hiện theo version; có Skip; không hiện lại trừ khi tăng version                            |
| Loop animation làm `pumpAndSettle` treo            | Tôn trọng `disableAnimations`; test dùng `pump(Duration)`; chỉ active page tick                |
| Nháy giữa native splash và onboarding              | Dùng đúng `#0F131D`, preload prefs trước `runApp`, không thêm splash Flutter                  |
| Dark-locked xung đột với theme sáng                | Có chủ đích; kiểm tra contrast; P1 mới làm bản light                                          |
| Trang “Tìm kèo/CLB” hứa tính năng chưa có          | Chip `SẮP CÓ` + copy “đang được hoàn thiện”; có thể ẩn trang bằng content flag                |
| Layout vỡ trên màn nhỏ / text scale lớn            | Scroll + minHeight + visual co giãn; test 320×568 & scale 2.0                                 |
| Jank khi vuốt nhiều visual                         | Chỉ Transform/Opacity, RepaintBoundary, không blur, không build lại cả trang mỗi frame        |
| Thêm dependency mới                                 | Chỉ `shared_preferences`; nếu bị chặn, fallback bảng Drift `app_settings` (P1)                |
| Push `AddRoom` sai thời điểm                        | `addPostFrameCallback` trong `initState` của Mainscreen, có test đếm số lần push               |
| Người dùng thoát giữa chừng rồi thấy lại từ đầu    | Chấp nhận trong P0; P1 lưu `onboarding.last_page`                                             |
| Nội dung/CTA thay đổi sau khi code                  | Tách `onboarding_content.dart`; đổi copy không đụng widget                                    |

## 14. P1+ (ngoài phạm vi lần này)

- Lưu trang đang xem để resume sau khi kill app.
- Bản light-mode riêng cho onboarding.
- Bundle font Plus Jakarta Sans cho display text.
- Animation nâng cao: Lottie/Rive nếu designer cung cấp; particle system phong phú.
- Cá nhân hoá theo hành vi: người mới chưa có phòng → nhấn mạnh tạo phòng; người
  đã có trận → nhấn mạnh xem lại/luật.
- Đo funnel (trang nào bị skip nhiều) khi có analytics.
- Deep link `bidart://onboarding?page=3`.
- Xin quyền thông báo/vị trí ở cuối onboarding (khi các tính năng đó sẵn sàng).

## 15. Câu hỏi cần duyệt

| #   | Câu hỏi                                                        | Mặc định đề xuất                    |
| --- | -------------------------------------------------------------- | ----------------------------------- |
| 1   | 5 trang hay rút còn 4 (bỏ trang Tìm kèo/CLB)?                  | Giữ 5 trang, trang 4 có chip SẮP CÓ  |
| 2   | Onboarding luôn dark hay theo theme hệ thống?                   | Luôn dark (D3)                      |
| 3   | CTA cuối mở thẳng `AddRoom` hay chỉ về Home?                    | Mở thẳng `AddRoom` (D7)             |
| 4   | Có cần “Xem lại giới thiệu” trong Cài đặt ngay P0?              | Có, chi phí thấp                    |
| 5   | Có bundle Plus Jakarta Sans cho tiêu đề không?                  | Không, dùng font hệ thống ở P0      |
| 6   | Copy tiếng Việt ở §4 đã đúng giọng thương hiệu chưa?            | Duyệt trước khi code visual          |
