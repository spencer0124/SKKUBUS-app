import 'package:flutter/animation.dart';

/// SDS 애니메이션 Duration 토큰
///
/// 모든 컴포넌트 애니메이션에서 inline Duration() 대신 이 토큰을 사용할 것.
class SdsDuration {
  SdsDuration._();

  /// 100ms — 버튼 press 피드백
  static const instant = Duration(milliseconds: 100);

  /// 150ms — 체크박스 토글
  static const fast = Duration(milliseconds: 150);

  /// 200ms — 세그먼트 전환, 페이드
  static const normal = Duration(milliseconds: 200);

  /// 250ms — 아코디언 펼침/접힘
  static const slow = Duration(milliseconds: 250);

  /// 500ms — 프로그레스바 채움
  static const slower = Duration(milliseconds: 500);

  /// 2초 — 토스트 표시 시간
  static const toast = Duration(seconds: 2);
}

/// SDS 애니메이션 커브 토큰
class SdsCurves {
  SdsCurves._();

  /// 대부분의 컴포넌트 전환에 사용
  static const standard = Curves.easeOutCubic;
}
