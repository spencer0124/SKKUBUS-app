import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_spacing.dart';

/// 화면 하단 안내 영역
///
/// ```dart
/// SdsBottomInfo(child: Text('서비스 이용약관...'))
/// ```
class SdsBottomInfo extends StatelessWidget {
  final Widget child;

  const SdsBottomInfo({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: SdsSpacing.base,
        horizontal: SdsSpacing.lg,
      ),
      color: SdsColors.grey50,
      child: child,
    );
  }
}
