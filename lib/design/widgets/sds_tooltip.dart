import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 툴팁 — grey900 배경, white 텍스트, 화살표
///
/// ```dart
/// SdsTooltip(
///   message: '여기를 눌러보세요',
///   child: Icon(Icons.info),
/// )
/// ```
class SdsTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final SdsTooltipDirection direction;

  const SdsTooltip({
    super.key,
    required this.message,
    required this.child,
    this.direction = SdsTooltipDirection.below,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: direction == SdsTooltipDirection.below,
      decoration: BoxDecoration(
        color: SdsColors.grey900,
        borderRadius: BorderRadius.circular(SdsRadius.sm),
      ),
      textStyle: SdsTypo.t7().copyWith(color: Colors.white),
      padding: const EdgeInsets.symmetric(
        horizontal: SdsSpacing.md,
        vertical: SdsSpacing.sm,
      ),
      child: child,
    );
  }
}

enum SdsTooltipDirection { above, below }
