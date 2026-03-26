import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_spacing.dart';

/// 구분선 — indented(왼쪽 들여쓰기) / full(전체 너비)
///
/// ```dart
/// SdsBorder(style: SdsBorderStyle.indented)
/// SdsBorder(style: SdsBorderStyle.full)
/// ```
class SdsBorder extends StatelessWidget {
  final SdsBorderStyle style;

  const SdsBorder({super.key, this.style = SdsBorderStyle.indented});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: style == SdsBorderStyle.indented
          ? const EdgeInsets.only(left: SdsSpacing.lg)
          : EdgeInsets.zero,
      height: 1,
      color: SdsColors.grey200,
    );
  }
}

enum SdsBorderStyle { indented, full }
