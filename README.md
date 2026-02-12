# 🚌 스꾸버스 (SKKUBUS)

<div align="center">

<img width="300" alt="SKKUBUS Logo" src="https://github.com/spencer0124/SKKUBUS/assets/62795814/a40906c8-732d-4dfc-bd07-856bc1cef6fa">

**성균관대학교 셔틀버스 실시간 위치 및 캠퍼스 정보 통합 앱**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![GetX](https://img.shields.io/badge/GetX-State%20Management-blue?style=flat-square)](https://pub.dev/packages/get)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)](https://firebase.google.com/)

[다운로드 (Android)](https://shorturl.ac/skkubus_and) | [다운로드 (iOS)](https://shorturl.ac/skkubus_ios)

</div>

---

## 📖 소개 (About)

**스꾸버스**는 성균관대학교 학생들의 편리한 학교 생활을 위해 개발된 **올인원 캠퍼스 모빌리티 & 정보 앱**입니다.
인사캠(서울) 셔틀버스의 실시간 위치 조회뿐만 아니라, 양 캠퍼스(인사캠/자과캠)의 건물 정보, 학식, 공지사항 등 다양한 편의 기능을 제공합니다.
Flutter 프레임워크를 사용하여 하나의 소스 코드로 Android와 iOS 환경을 모두 지원합니다.

## ✨ 주요 기능 (Key Features)

### 🚍 실시간 셔틀버스 정보 (Shuttle Bus)
- **인사캠 셔틀**: 실시간 위치 추적 및 도착 예정 시간 확인
- **자과캠 버스**: 역사 셔틀 및 교내 순환 버스 정보 제공

### 🗺️ 캠퍼스 맵 & 건물 정보 (Campus Map)
- **상세 지도**: 네이버 지도를 기반으로 한 캠퍼스 상세 맵
- **건물 정보**: HSSC(인사캠) 및 NSC(자과캠) 건물별 강의실, 시설 정보 조회
- **운영 시간**: 건물별 개방 시간 및 학식 운영 시간 확인

### 🔍 통합 검색 (Search)
- 건물명, 강의실, 편의시설 등 교내 모든 장소 검색 지원

### 🛠️ 유틸리티 (Utilities)
- **분실물 센터**: 교내 분실물 습득/분실 신고 및 조회
- **공지사항**: 학교 주요 공지사항 실시간 확인
- **학사 일정**: 주요 학사 일정 캘린더 제공

## 🛠️ 기술 스택 (Tech Stack)

| Category | Technology |
| --- | --- |
| **Framework** | ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat-square&logo=Flutter&logoColor=white) |
| **Language** | ![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=flat-square&logo=dart&logoColor=white) |
| **State Management** | **GetX** |
| **Map SDK** | **Naver Map SDK** (flutter_naver_map) |
| **Backend / Cloud** | **Firebase** (Auth, Firestore, Messaging, Analytics, Crashlytics) |
| **Key Libraries** | Dio, Url Launcher, Geolocator, Webview Flutter |

## 📱 설치 및 실행 (Getting Started)

이 프로젝트를 로컬에서 실행하려면 Flutter SDK가 설치되어 있어야 합니다.

### 1. 레포지토리 클론
```bash
git clone https://github.com/spencer0124/SKKUBUS.git
cd SKKUBUS
```

### 2. 의존성 설치
```bash
flutter pub get
```

### 3. 환경 변수 설정 (.env)
루트 디렉토리에 `.env` 파일을 생성하고 필요한 API 키를 입력해야 합니다.
(보안상 레포지토리에는 포함되어 있지 않습니다.)

### 4. 앱 실행
```bash
# Debug 모드 실행
flutter run

# Release 모드 빌드 (Android)
flutter build apk --release

# Release 모드 빌드 (iOS)
flutter build ios --release
```

## 📰 언론 보도 (Media)

**성균웹진 '성대생은 지금' 인터뷰**
> "학우들의 발이 되어주는 스꾸버스 개발팀을 만나다"

[👉 인터뷰 기사 보러가기](https://webzine.skku.edu/skkuzine/section/people01.do?articleNo=109617&pager.offset=0&pagerLimit=10)

## 🔗 다운로드 (Download)

| Platform | Link |
| --- | --- |
| **Google Play Store** | [바로가기](https://shorturl.ac/skkubus_and) |
| **Apple App Store** | [바로가기](https://shorturl.ac/skkubus_ios) |

---
Copyright © 2024 SKKUBUS Team. All rights reserved.
