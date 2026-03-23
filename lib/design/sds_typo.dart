import 'package:flutter/material.dart';

/// SDS 타이포그래피 토큰 — TDS 7+13 레벨 체계
///
/// 메서드로 호출하며, weight 파라미터로 굵기 조절 가능.
/// fontFamily를 명시적으로 포함하여 ThemeData 없이도 올바른 폰트 적용.
class SdsTypo {
  SdsTypo._();

  static const _fontFamily = 'WantedSans';

  // ── 메인 레벨 (t1~t7) ──

  /// 30px / 40 line-height — 매우 큰 제목 (히어로)
  static TextStyle t1({FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 30, height: 40 / 30, fontWeight: weight);

  /// 26px / 35 line-height — 큰 제목
  static TextStyle t2({FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 26, height: 35 / 26, fontWeight: weight);

  /// 22px / 31 line-height — 화면 제목 (가장 많이 씀)
  static TextStyle t3({FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 22, height: 31 / 22, fontWeight: weight);

  /// 20px / 29 line-height — 작은 제목, 섹션 헤더
  static TextStyle t4({FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 20, height: 29 / 20, fontWeight: weight);

  /// 17px / 25.5 line-height — 일반 본문 (기본)
  static TextStyle t5({FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 17, height: 25.5 / 17, fontWeight: weight);

  /// 15px / 22.5 line-height — 작은 본문
  static TextStyle t6({FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 15, height: 22.5 / 15, fontWeight: weight);

  /// 13px / 19.5 line-height — 캡션, 메타 정보
  static TextStyle t7({FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 13, height: 19.5 / 13, fontWeight: weight);

  // ── 서브 레벨 (자주 쓰는 것) ──

  /// 24px / 33 line-height — 조금 큰 제목 (t3~t4 사이)
  static TextStyle sub5({FontWeight weight = FontWeight.w700}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 24, height: 33 / 24, fontWeight: weight);

  /// 19px / 28 line-height — 조금 큰 본문 (t4~t5 사이)
  static TextStyle sub8({FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 19, height: 28 / 19, fontWeight: weight);

  /// 16px / 24 line-height — 리스트 아이템 본문 (t5~t6 사이)
  static TextStyle sub10({FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 16, height: 24 / 16, fontWeight: weight);

  /// 12px / 18 line-height — 작은 캡션
  static TextStyle sub12({FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 12, height: 18 / 12, fontWeight: weight);

  /// 11px / 16.5 line-height — 가장 작은 텍스트 (뱃지)
  static TextStyle sub13({FontWeight weight = FontWeight.w600}) =>
      TextStyle(fontFamily: _fontFamily, fontSize: 11, height: 16.5 / 11, fontWeight: weight);
}
