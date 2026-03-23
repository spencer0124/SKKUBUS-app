import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 리스트 하단 안내 텍스트
///
/// ```dart
/// SdsListFooter(text: '마지막 업데이트: 2024.03.22')
/// ```
class SdsListFooter extends StatelessWidget {
  final String text;

  const SdsListFooter({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: SdsSpacing.base,
        horizontal: SdsSpacing.xl,
      ),
      child: Text(
        text,
        style: SdsTypo.t7().copyWith(color: SdsColors.grey400),
      ),
    );
  }
}
