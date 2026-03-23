import 'package:flutter/material.dart';

import '../sds_colors.dart';

/// 상태/카테고리 라벨 태그
///
/// ```dart
/// SdsBadge(text: '인사캠', variant: SdsBadgeVariant.weak, color: SdsBadgeColor.blue, size: SdsBadgeSize.xsmall)
/// SdsBadge(text: '운행중', variant: SdsBadgeVariant.fill, color: SdsBadgeColor.green, size: SdsBadgeSize.xsmall)
/// ```
class SdsBadge extends StatelessWidget {
  final String text;
  final SdsBadgeVariant variant;
  final SdsBadgeSize size;
  final SdsBadgeColor color;
  final Widget? icon;

  const SdsBadge({
    super.key,
    required this.text,
    required this.variant,
    required this.size,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = _colorScheme;
    final ms = _metrics;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ms.hPad, vertical: ms.vPad),
      decoration: BoxDecoration(
        color: cs.bg,
        borderRadius: BorderRadius.circular(ms.radius),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: IconThemeData(size: ms.fontSize + 1, color: cs.fg),
                  child: icon!,
                ),
                const SizedBox(width: 3),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'WantedSans',
                    fontSize: ms.fontSize,
                    fontWeight: FontWeight.w600,
                    color: cs.fg,
                    height: 1.5,
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(
                fontFamily: 'WantedSans',
                fontSize: ms.fontSize,
                fontWeight: FontWeight.w600,
                color: cs.fg,
                height: 1.5,
              ),
            ),
    );
  }

  ({Color bg, Color fg}) get _colorScheme {
    final isFill = variant == SdsBadgeVariant.fill;
    return switch (color) {
      SdsBadgeColor.blue => (
        bg: isFill ? SdsColors.blue500 : SdsColors.blue50,
        fg: isFill ? Colors.white : SdsColors.blue500,
      ),
      SdsBadgeColor.teal => (
        bg: isFill ? SdsColors.teal500 : SdsColors.teal50,
        fg: isFill ? Colors.white : SdsColors.teal500,
      ),
      SdsBadgeColor.green => (
        bg: isFill ? SdsColors.green500 : SdsColors.green50,
        fg: isFill ? Colors.white : SdsColors.green500,
      ),
      SdsBadgeColor.red => (
        bg: isFill ? SdsColors.red500 : SdsColors.red50,
        fg: isFill ? Colors.white : SdsColors.red500,
      ),
      SdsBadgeColor.yellow => (
        bg: isFill ? SdsColors.yellow500 : SdsColors.yellow50,
        fg: isFill ? SdsColors.grey900 : SdsColors.yellow800,
      ),
      SdsBadgeColor.elephant => (
        bg: isFill ? SdsColors.grey600 : SdsColors.grey100,
        fg: isFill ? Colors.white : SdsColors.grey600,
      ),
    };
  }

  ({double hPad, double vPad, double fontSize, double radius}) get _metrics =>
      switch (size) {
    SdsBadgeSize.xsmall => (hPad: 6.0, vPad: 2.0, fontSize: 11.0, radius: 6.0),
    SdsBadgeSize.small => (hPad: 8.0, vPad: 3.0, fontSize: 12.0, radius: 8.0),
    SdsBadgeSize.medium => (hPad: 10.0, vPad: 4.0, fontSize: 13.0, radius: 10.0),
    SdsBadgeSize.large => (hPad: 12.0, vPad: 5.0, fontSize: 14.0, radius: 12.0),
  };
}

enum SdsBadgeVariant { fill, weak }

enum SdsBadgeSize { xsmall, small, medium, large }

enum SdsBadgeColor { blue, teal, green, red, yellow, elephant }
