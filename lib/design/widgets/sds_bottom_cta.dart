import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_spacing.dart';

/// 하단 CTA 버튼 영역 — single / double 모드
///
/// ```dart
/// // Single
/// SdsBottomCTA(
///   primary: SdsButton(text: '다음', onPressed: () {}),
/// )
///
/// // Double
/// SdsBottomCTA(
///   secondary: SdsButton(text: '닫기', variant: SdsButtonVariant.weak, color: SdsButtonColor.dark),
///   primary: SdsButton(text: '확인하기', onPressed: () {}),
/// )
/// ```
class SdsBottomCTA extends StatelessWidget {
  final Widget primary;
  final Widget? secondary;

  const SdsBottomCTA({
    super.key,
    required this.primary,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: SdsColors.grey200, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: SdsSpacing.sm,
            horizontal: SdsSpacing.lg,
          ),
          child: secondary != null
              ? Row(
                  children: [
                    Expanded(flex: 35, child: secondary!),
                    const SizedBox(width: SdsSpacing.sm),
                    Expanded(flex: 65, child: primary),
                  ],
                )
              : SizedBox(width: double.infinity, child: primary),
        ),
      ),
    );
  }
}
