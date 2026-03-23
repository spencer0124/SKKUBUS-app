import 'package:flutter/material.dart';

import '../sds_colors.dart';

/// 로딩 인디케이터
///
/// ```dart
/// SdsLoader()
/// SdsLoader(size: 16, color: Colors.white)
/// ```
class SdsLoader extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const SdsLoader({
    super.key,
    this.size = 24,
    this.color = SdsColors.blue500,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
