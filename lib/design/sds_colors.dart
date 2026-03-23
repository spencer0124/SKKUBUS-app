import 'package:flutter/material.dart';

/// SDS 컬러 토큰 — TDS(Toss Design System) 공식 값 기반
///
/// 모든 스타일링에서 하드코딩 HEX 대신 이 토큰을 사용할 것.
class SdsColors {
  SdsColors._();

  // ── Grey Scale ──

  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF2F4F6);
  static const grey200 = Color(0xFFE5E8EB);
  static const grey300 = Color(0xFFD1D6DB);
  static const grey400 = Color(0xFFB0B8C1);
  static const grey500 = Color(0xFF8B95A1);
  static const grey600 = Color(0xFF6B7684);
  static const grey700 = Color(0xFF4E5968);
  static const grey800 = Color(0xFF333D4B);
  static const grey900 = Color(0xFF191F28);

  // ── Grey Opacity (오버레이/딤) ──

  static const greyOpacity50 = Color(0x05001733);
  static const greyOpacity200 = Color(0x1A001B37);
  static const greyOpacity500 = Color(0x75031832);
  static const greyOpacity800 = Color(0xCC000C1E);
  static const greyOpacity900 = Color(0xE8020913);

  // ── Blue (액션, 링크, 강조) ──

  static const blue50 = Color(0xFFE8F3FF);
  static const blue200 = Color(0xFF90C2FF);
  static const blue400 = Color(0xFF4593FC);
  static const blue500 = Color(0xFF3182F6);
  static const blue600 = Color(0xFF2272EB);
  static const blue700 = Color(0xFF1B64DA);

  // ── Red (에러, 위험) ──

  static const red50 = Color(0xFFFFEEEE);
  static const red500 = Color(0xFFF04452);

  // ── Green (성공, 운행중) ──

  static const green50 = Color(0xFFF0FAF6);
  static const green500 = Color(0xFF03B26C);

  // ── Orange (주의, 하차전용) ──

  static const orange50 = Color(0xFFFFF3E0);
  static const orange500 = Color(0xFFFE9800);

  // ── Yellow (경고 배경) ──

  static const yellow50 = Color(0xFFFFF9E7);
  static const yellow400 = Color(0xFFFFD158);
  static const yellow500 = Color(0xFFFFC342);
  static const yellow800 = Color(0xFFEE8F11);
  static const yellow900 = Color(0xFFDD7D02);

  // ── Teal ──

  static const teal50 = Color(0xFFEDF8F8);
  static const teal500 = Color(0xFF18A5A5);

  // ── Purple ──

  static const purple500 = Color(0xFFA234C7);

  // ── 배경 ──

  static const background = Color(0xFFFFFFFF);
  static const greyBackground = grey100;
  static const layeredBackground = Color(0xFFFFFFFF);
  static const floatedBackground = Color(0xFFFFFFFF);

  // ── 앱 브랜드 (마이그레이션용) ──

  static const brand = Color(0xFF1A7F4B);
  static const brandLight = Color(0xFFE8F5EE);
}
