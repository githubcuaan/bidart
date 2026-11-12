# Bidart

<p align="center">
  <img src="docs/branding/bidart-logo-wordmark.svg" alt="Bidart logo" width="590">
</p>

Bidart is a Flutter app for recording and scoring nine-ball penalty matches. One device manages a room of 2–5 players, tracks shots and fouls, calculates zero-sum scores, and keeps a history that can be reopened later.

The app currently provides a home dashboard, room management, match scoring, onboarding, profile screens, and Firebase Authentication. People discovery, chat, maps, and online room synchronization are not part of the active match flow.

## Features

- Create a room with a player roster, shooting order, opening player, and payer.
- Configure points for balls 1–9, save rule templates, and set optional time or score limits.
- Record pots, misses, and fouls; calculate scores and advance the shooting order according to the project's nine-ball penalty rules.
- Review the shot log, undo eligible turns, continue into the next game, and reopen finished rooms as read-only history.
- Save rooms locally with Drift/SQLite on mobile and Drift's WASM database on web. Match data stays on the device/browser rather than syncing between users.
- Sign in or register with email and password through Firebase Authentication.

The scoring rules are **house rules**, not standard WPA nine-ball rules. See [the rule reference](docs/core/rule.md) and [the domain contract](docs/plans/step1.md) for the exact behavior.

## Getting started

### Requirements

- Flutter with Dart **3.13.1 or later** (see [`pubspec.yaml`](pubspec.yaml) for the SDK constraint)
- An Android emulator/device, iOS simulator/device, or supported web browser
- A Firebase project with **Email/Password** sign-in enabled
- Firebase CLI and FlutterFire CLI if generating your own Firebase configuration

### Configure Firebase

The app initializes Firebase at startup. `lib/firebase_options.dart` and `android/app/google-services.json` are ignored by Git, so a fresh clone needs configuration before a normal run.

1. Create or select a Firebase project and enable **Authentication → Sign-in method → Email/Password** in the Firebase console.
2. Install the FlutterFire CLI if needed (`dart pub global activate flutterfire_cli`), then run `flutterfire configure` from the repository root. Select the platforms you intend to run; this generates `lib/firebase_options.dart` and platform configuration such as `android/app/google-services.json`.
3. If using an existing project, obtain its matching configuration files from the project owner instead. [`lib/firebase_options.example.dart`](lib/firebase_options.example.dart) shows the expected Dart options but contains placeholders, not a working connection.

Do not commit local Firebase configuration files. Firebase Auth is used for sign-in; room data is still stored locally and is **not** backed up to the Firebase account.

### Run

```sh
flutter pub get
flutter run
```

For the browser, use `flutter run -d chrome`. The web build includes `web/sqlite3.wasm` and `web/drift_worker.js` for local storage; persistent browser storage must be available. Clearing site data or uninstalling the app can remove locally stored matches.

## Development

```sh
flutter analyze
flutter test
```

When changing Freezed, JSON-serializable, or Drift models, regenerate the checked-in Dart code with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Project layout

| Path | Purpose |
| --- | --- |
| `lib/screens/` | Flutter screens and room workflows |
| `lib/features/` | Riverpod providers and UI controllers |
| `lib/domain/` | Scoring models, validation, and match commands |
| `lib/data/` | Local database and repository implementations |
| `lib/core/` | Shared theme, labels, and supporting types |
| `test/` | Unit, repository, and widget tests |
| `docs/` | Rules, architecture notes, plans, and design assets |

For implementation details and known platform limitations, see the [project overview](docs/bidart-project.md) and [testing handoff](docs/plans/step5-handoff.md). Android and web match-persistence flows have been manually exercised; iOS has not been verified in the documented handoff.
