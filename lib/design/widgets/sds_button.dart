import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../sds_colors.dart';
import '../sds_duration.dart';
import '../sds_radius.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';
import 'sds_loader.dart';

/// 버튼 — fill/weak × primary/dark/danger/light × 4 sizes
///
/// TDS 원본: https://tossmini-docs.toss.im/tds-mobile/components/button/
///
/// ```dart
/// SdsButton(text: '확인하기', onPressed: () {})
/// SdsButton(text: '삭제하기', color: SdsButtonColor.danger, onPressed: () {})
/// SdsButton(text: '닫기', variant: SdsButtonVariant.weak, color: SdsButtonColor.dark, onPressed: () {})
/// SdsButton(text: '검색', icon: Icon(Icons.search), onPressed: () {})
/// SdsButton(text: '다음', display: SdsButtonDisplay.full, size: SdsButtonSize.xlarge, onPressed: () {})
/// ```
class SdsButton extends StatefulWidget {
  /// 버튼 텍스트 (필수)
  final String text;

  /// 텍스트 왼쪽 아이콘. 크기·색상은 버튼 size/color에 맞춰 자동 적용.
  final Widget? icon;

  /// 시각적 스타일: fill(채움) 또는 weak(연한 배경)
  final SdsButtonVariant variant;

  /// 의미 색상: primary(파랑), dark(진회), danger(빨강), light(연회)
  final SdsButtonColor color;

  /// 높이 프리셋: small(32), medium(40), large(48), xlarge(56)
  final SdsButtonSize size;

  /// 너비 제어 모드
  final SdsButtonDisplay display;

  /// true이면 로딩 스피너 표시, 인터랙션 비활성
  final bool isLoading;

  /// true이면 비활성 외관, 인터랙션 비활성
  final bool disabled;

  /// 탭 콜백
  final VoidCallback? onPressed;

  /// 탭 시 햅틱 피드백 여부
  final bool enableHaptics;

  const SdsButton({
    super.key,
    required this.text,
    this.icon,
    this.variant = SdsButtonVariant.fill,
    this.color = SdsButtonColor.primary,
    this.size = SdsButtonSize.medium,
    this.display = SdsButtonDisplay.inline,
    this.isLoading = false,
    this.disabled = false,
    this.onPressed,
    this.enableHaptics = true,
  });

  @override
  State<SdsButton> createState() => _SdsButtonState();

  // ── 컬러 모델 ──

  ({Color bg, Color pressedBg, Color loadingBg, Color fg}) get _colors {
    final isFill = variant == SdsButtonVariant.fill;
    return switch (color) {
      SdsButtonColor.primary => (
        bg: isFill ? SdsColors.blue500 : SdsColors.blue50,
        pressedBg: isFill ? SdsColors.blue600 : const Color(0xFFD6E8FF),
        loadingBg: isFill
            ? SdsColors.blue500.withValues(alpha: 0.7)
            : SdsColors.blue50.withValues(alpha: 0.7),
        fg: isFill ? Colors.white : SdsColors.blue500,
      ),
      SdsButtonColor.dark => (
        bg: isFill ? SdsColors.grey900 : SdsColors.grey100,
        pressedBg: isFill ? const Color(0xFF0F1318) : SdsColors.grey200,
        loadingBg: isFill
            ? SdsColors.grey900.withValues(alpha: 0.7)
            : SdsColors.grey100.withValues(alpha: 0.7),
        fg: isFill ? Colors.white : SdsColors.grey800,
      ),
      SdsButtonColor.danger => (
        bg: isFill ? SdsColors.red500 : SdsColors.red50,
        pressedBg: isFill ? const Color(0xFFD93B48) : const Color(0xFFFFDDDD),
        loadingBg: isFill
            ? SdsColors.red500.withValues(alpha: 0.7)
            : SdsColors.red50.withValues(alpha: 0.7),
        fg: isFill ? Colors.white : SdsColors.red500,
      ),
      SdsButtonColor.light => (
        bg: SdsColors.grey100,
        pressedBg: SdsColors.grey200,
        loadingBg: SdsColors.grey100.withValues(alpha: 0.7),
        fg: SdsColors.grey800,
      ),
    };
  }

  // ── 사이즈 메트릭 (토큰 기반) ──

  ({
    double height,
    double hPad,
    double iconTextGap,
    TextStyle textStyle,
    double radius,
    double loaderSize,
    double iconSize,
  }) get _metrics => switch (size) {
    SdsButtonSize.small => (
      height: 32.0,
      hPad: SdsSpacing.md,
      iconTextGap: SdsSpacing.xs,
      textStyle: SdsTypo.t7(weight: FontWeight.w600),
      radius: SdsRadius.sm,
      loaderSize: 14.0,
      iconSize: 16.0,
    ),
    SdsButtonSize.medium => (
      height: 40.0,
      hPad: SdsSpacing.base,
      iconTextGap: SdsSpacing.xs,
      textStyle: SdsTypo.t6(weight: FontWeight.w600),
      radius: SdsRadius.sm,
      loaderSize: 16.0,
      iconSize: 18.0,
    ),
    SdsButtonSize.large => (
      height: 48.0,
      hPad: SdsSpacing.lg,
      iconTextGap: SdsSpacing.sm,
      textStyle: SdsTypo.sub10(weight: FontWeight.w600),
      radius: SdsRadius.md,
      loaderSize: 18.0,
      iconSize: 20.0,
    ),
    SdsButtonSize.xlarge => (
      height: 56.0,
      hPad: SdsSpacing.xl,
      iconTextGap: SdsSpacing.sm,
      textStyle: SdsTypo.t5(weight: FontWeight.w600),
      radius: SdsRadius.lg,
      loaderSize: 20.0,
      iconSize: 22.0,
    ),
  };
}

class _SdsButtonState extends State<SdsButton> {
  bool _pressed = false;

  bool get _enabled => !widget.disabled && !widget.isLoading;

  void _handleTapDown(TapDownDetails _) {
    if (_enabled) setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_pressed) {
      setState(() => _pressed = false);
      if (widget.enableHaptics) {
        HapticFeedback.lightImpact();
      }
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (_pressed) setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget._colors;
    final ms = widget._metrics;

    // 상태별 배경색 결정
    Color bgColor;
    if (widget.isLoading) {
      bgColor = colors.loadingBg;
    } else if (_pressed) {
      bgColor = colors.pressedBg;
    } else {
      bgColor = colors.bg;
    }

    // 내용 빌드
    Widget child;
    if (widget.isLoading) {
      child = SdsLoader(
        size: ms.loaderSize,
        color: colors.fg,
        strokeWidth: 2,
      );
    } else {
      final textWidget = Text(
        widget.text,
        style: ms.textStyle.copyWith(color: colors.fg),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

      if (widget.icon != null) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(size: ms.iconSize, color: colors.fg),
              child: widget.icon!,
            ),
            SizedBox(width: ms.iconTextGap),
            Flexible(child: textWidget),
          ],
        );
      } else {
        child = textWidget;
      }
    }

    // disabled 시 전체 content opacity
    if (widget.disabled) {
      child = Opacity(opacity: 0.4, child: child);
    }

    // 버튼 컨테이너
    final button = Semantics(
      button: true,
      enabled: _enabled,
      label: widget.text,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: SdsDuration.instant,
          curve: SdsCurves.standard,
          height: ms.height,
          padding: EdgeInsets.symmetric(horizontal: ms.hPad),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(ms.radius),
          ),
          child: child,
        ),
      ),
    );

    // display 모드 적용
    return switch (widget.display) {
      SdsButtonDisplay.inline => button,
      SdsButtonDisplay.block => button,
      SdsButtonDisplay.full => SizedBox(width: double.infinity, child: button),
    };
  }
}

// ── Enums ──

enum SdsButtonVariant { fill, weak }

enum SdsButtonColor { primary, dark, danger, light }

enum SdsButtonSize { small, medium, large, xlarge }

/// 너비 제어 모드
/// - inline: 내용 크기만큼 (기본)
/// - block: 부모 Expanded/Flexible에 맞춤
/// - full: width: double.infinity
enum SdsButtonDisplay { inline, block, full }
