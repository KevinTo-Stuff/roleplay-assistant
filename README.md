# roleplay-assistant

A Flutter/Dart application that provides helpful tools and utilities for running
and managing roleplaying sessions. This repository contains the app source, assets,
and platform folders for Android, Windows and web builds.

## Quick Overview

- **Purpose**: Provide a toolbox for game masters and players to simplify roleplay
 session management (NPC management, encounter helpers, notes, etc.).
- **Tech**: Built with Flutter and Dart. Targets Android, Windows, and web.

### Features (examples)

- **Session Tools**: encounter trackers, initiative rollers, NPC notes.
- **Assets & Fonts**: bundled in `assets/` and `fonts/`.
- **Multi-platform**: Android, Windows, Web (desktop and browser builds).

## Prerequisites

- **Flutter SDK**: Install from <https://flutter.dev> and ensure `flutter` is on PATH.
- **Platform toolchains**: Android SDK for Android builds, Visual Studio for
 Windows desktop, and a supported browser for web.
- **IDE (optional)**: VS Code, Android Studio, or IntelliJ IDEA for development.

## Getting Started

1. Clone the repository:

  `git clone https://github.com/KevinTo-Stuff/roleplay-assistant.git`
2. Change into the project directory:

  `cd roleplay-assistant`
3. Install dependencies:

  `flutter pub get`
4. Run on a connected device or emulator:

  `flutter run -d <device-id>`

  Replace `<device-id>` with `chrome`, `windows`, or an Android device id from
  `flutter devices`.

## Builds

- Build Android APK:

 `flutter build apk --release`

- Build Android app bundle:

 `flutter build appbundle --release`

- Build web release:

 `flutter build web --release`

- Build Windows (desktop):

 `flutter build windows --release`

## Running Tests & Formatting

- Run unit/widget tests:

 `flutter test`

- Format Dart code:

 `flutter format .`

## Project Layout

- `lib/` : Main application code and UI.
- `lib/gen/` : Generated helpers for assets and fonts.
- `assets/` : Images and other static assets.
- `fonts/` : Custom font files used by the app.
- `android/`, `windows/`, `web/` : Platform-specific project folders.

## Development Notes

- Linting and static analysis are configured in `analysis_options.yaml`.
- Prefer small, focused commits and feature branches. Follow the branch naming
 convention used in this repository (e.g. `feature/*`, `fix/*`, `chore/*`).

## Contributing

- Open an issue to discuss larger changes or feature requests.
- Send pull requests against the `main` branch (or target branch used by the
 project). Include tests and a brief description of the change.

## License

- See the `LICENSE` file at the repository root for license terms.

## Contact

- Project owner: Kevin (repository owner `KevinTo-Stuff`). Open issues or PRs on
 GitHub for questions or contributions.

---

If you'd like, I can also:

- run `flutter pub get` now to fetch packages,
- run the test suite, or
- open a branch and add a CONTRIBUTING.md with contribution guidelines.
