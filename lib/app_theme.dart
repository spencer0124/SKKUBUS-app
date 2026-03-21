import 'dart:ui';

import 'package:flutter/material.dart';

class AppFonts {
  static const String wantedSans = 'WantedSans';

  /// ko/en → WantedSans, 그 외(zh 등) → 시스템 기본 폰트
  static String? fontFamily(Locale? locale) {
    final lang = locale?.languageCode;
    if (lang == 'ko' || lang == 'en') return wantedSans;
    return null;
  }
}

class AppColors {
  // ── Brand (CTA, 선택 상태에만 포인트로 사용) ──
  static const Color brand = Color(0xFF1A7F4B);
  static const Color brandLight = Color(0xFFE8F5EE);

  // ── Greyscale ──
  static const Color textPrimary = Color(0xFF191F28);
  static const Color textSecondary = Color(0xFF4E5968);
  static const Color textTertiary = Color(0xFF8B95A1);
  static const Color textDisabled = Color(0xFFB0B8C1);

  static const Color border = Color(0xFFE5E8EB);
  static const Color bgGrey = Color(0xFFF2F4F6);
  static const Color divider = Color(0xFFF2F4F6);

  // ── Legacy alias ──
  @Deprecated('Use AppColors.brand')
  static const Color greenMain = brand;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 50;
}

class AppSpacing {
  static const double screenH = 20;
}
