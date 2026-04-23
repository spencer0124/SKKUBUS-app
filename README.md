> [!IMPORTANT]
> **이 저장소는 [spencer0124/skkuverse-app](https://github.com/spencer0124/skkuverse-app)로 이동했습니다.**
> 최신 버전의 스꾸버스는 새 저장소에서 개발되고 있어요. 여기 Flutter 코드베이스는 아카이브 목적으로 남아 있어요.
>
> **This repository has moved to [spencer0124/skkuverse-app](https://github.com/spencer0124/skkuverse-app).**
> Active development of Skkuverse continues in the new repo. This Flutter codebase is kept for reference only.

---

# SKKUBUS

<div align="center">

**Real-time campus transit and utilities for Sungkyunkwan University — solo-built with Flutter.**

<br>

![DAU](https://img.shields.io/badge/DAU-500+-4CAF50?style=for-the-badge)
![Campus Penetration](https://img.shields.io/badge/Campus_Penetration-50%25-FF6F00?style=for-the-badge)
![iOS Users](https://img.shields.io/badge/iOS_Users-80%25-000000?style=for-the-badge&logo=apple&logoColor=white)

<br>

[![App Store](https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white)](https://shorturl.ac/skkubus_ios)
[![Google Play](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://shorturl.ac/skkubus_and)

<br>

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![GetX](https://img.shields.io/badge/GetX-8A2BE2?style=flat)](https://pub.dev/packages/get)

</div>

---

## About

SKKUBUS is an all-in-one campus app used daily by 500+ students at Sungkyunkwan University. It provides real-time shuttle bus tracking, interactive campus maps, building directories, and campus utilities — all from a single Flutter codebase shipping to both iOS and Android. Solo-developed end-to-end: planning, design, development, marketing, and operations.

---

## Features

- **Live Shuttle Tracking** — real-time GPS positions and ETAs for Seoul campus shuttles
- **Suwon Campus Bus** — station shuttle and campus loop schedules
- **Campus Map** — interactive Naver Map with detailed building markers
- **Building Directory** — room-level info for HSSC (Seoul) and NSC (Suwon)
- **Search** — unified lookup across buildings, classrooms, and facilities
- **Lost & Found** — report and browse items on campus
- **Announcements** — university notices in real time

---

## Tech Stack

| | |
| :--- | :--- |
| **Frontend** | Flutter 3.x, Dart, GetX |
| **Map** | Naver Map SDK |
| **Backend** | Express.js, Swagger |
| **Cloud** | Firebase (Auth, Firestore, Messaging, Analytics, Crashlytics) |
| **OTA** | Shorebird Code Push |
| **Libraries** | Dio, Geolocator, WebView Flutter, Lottie |

---

## Architecture

- **Server-Driven UI** — update content and layouts without app store releases
- **OTA Code Push** — deploy Dart patches in under 10 minutes, no store review
- **WebView JS Bridge** — bidirectional Flutter-WebView communication for building maps
- **Hybrid Updates** — OTA for Dart, SDUI for content, WebView for complex changes, store for native

---

## Getting Started

```bash
# 1. Clone
git clone https://github.com/spencer0124/SKKUBUS.git && cd SKKUBUS

# 2. Install dependencies
flutter pub get

# 3. Add environment variables
#    Create .env in project root with API keys (e.g. Naver Map client ID)

# 4. Run
flutter run
```

---

## Media

> Featured in **SKKU Official Webzine** — 18K+ views
>
> [Read the interview](https://webzine.skku.edu/skkuzine/section/people01.do?articleNo=109617&pager.offset=0&pagerLimit=10)

---

<div align="center">
<sub>Copyright &copy; 2024 SKKUBUS. All rights reserved.</sub>
</div>
