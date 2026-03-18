# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SKKUBUS (스꾸버스) — a Flutter mobile app for Sungkyunkwan University (SKKU) students providing real-time shuttle bus tracking, campus maps, building info, cafeteria menus, lost & found, and announcements. Targets both Android and iOS from a single Dart codebase.

## Build & Run Commands

```bash
flutter pub get              # Install dependencies
flutter run                  # Debug mode
flutter build apk --release  # Android release build
flutter build ios --release  # iOS release build
flutter analyze              # Static analysis (uses flutter_lints)
flutter test                 # Run tests
```

Requires a `.env` file in the project root with API keys (e.g., `navernewClientId` for Naver Map SDK). This file is not committed to the repo.

## OTA Updates

Shorebird is configured for code-push OTA updates (see `shorebird.yaml`). Use `shorebird` CLI for patch releases.

## Architecture

**Framework:** Flutter 3.x with Dart >=3.7.0, **State management:** GetX (package `get`)

### Page Structure (MVC + GetX Bindings)

Each feature page under `lib/app/pages/<feature>/` follows this layout:
- `binding/` — GetX dependency bindings
- `controller/` — business logic (GetxController subclasses)
- `ui/` or `view/` or `screen/` — widget tree

### Key Directories

| Path | Purpose |
|---|---|
| `lib/main.dart` | App entry point: Firebase, Naver Map SDK, AdMob, and GetX dependency initialization |
| `lib/app/routes/app_routes.dart` | All named routes (GetPage definitions). Initial route `/` is `SplashAd` |
| `lib/app/model/` | Data models (bus locations, station lists, campus markers, search) |
| `lib/app/types/` | Enums and type definitions (bus status, bus type, campus type, time format) |
| `lib/app/utils/` | Shared utilities — API fetch helpers (`api_fetch/`), screen size, geolocator, constants, ad widget |
| `lib/app/components/` | Reusable UI components (navigation bar, bus widgets, main page sections) |
| `lib/admob/` | AdMob ad helper |
| `lib/notification/` | Push notification handling (Firebase Messaging) |
| `lib/languages.dart` | i18n translations (GetX `Translations`) |

### Major Feature Areas

- **Shuttle bus (Seoul/인사캠):** `bus_main_main` (list), `bus_main_detail` (route detail)
- **Shuttle bus (Suwon/자과캠):** `bus_inja_main` (list), `bus_inja_detail` (route detail)
- **Campus map:** `mainpage` — Naver Map integration with markers, snapping sheet, search
- **Building info:** `hssc_building_map` (인사캠 HSSC), `nsc_building_map` (자과캠 NSC), with credit pages
- **Kingo login/info:** `KingoLogin`, `KingoInfo` — university portal authentication
- **Search:** `search_list`, `search_detail`
- **Webview:** generic in-app browser for external links
- **Lost & found:** `lostandfound`
- **Splash ad:** `splash_ad` — initial launch screen with ad

### External Services

- **Firebase:** Auth, Firestore, Crashlytics (release only), Analytics, Cloud Messaging
- **Naver Map SDK:** via `flutter_naver_map` — initialized with client ID from `.env`
- **Google AdMob:** banner/interstitial ads
- **Dio / http:** API requests for bus location data and station lists

### Design

- Screen dimensions designed for 390×844 (iPhone 14 baseline) via `flutter_screenutil`
- Custom fonts: WantedSans (Bold, Regular, Medium) in `assets/fonts/`
- Supports Korean (ko) and English (en) locales with fallback to en_US
