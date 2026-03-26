import 'package:flutter/material.dart';

/// SDS 그림자 토큰
class SdsShadows {
  SdsShadows._();

  /// 카드 — `0 1px 3px rgba(0,0,0,0.04)`
  static const card = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      color: Color(0x0A000000),
    ),
  ];

  /// 떠있는 요소 (FAB 등) — `0 4px 12px rgba(0,0,0,0.08)`
  static const elevated = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 12,
      color: Color(0x14000000),
    ),
  ];

  /// 바텀시트 — `0 -2px 8px rgba(0,0,0,0.06)`
  static const bottomSheet = [
    BoxShadow(
      offset: Offset(0, -2),
      blurRadius: 8,
      color: Color(0x0F000000),
    ),
  ];

  /// 세그먼트 컨트롤 선택 인디케이터 — `0 1px 2px rgba(0,0,0,0.09)`
  static const segmentedIndicator = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color(0x17000000),
    ),
  ];
}
