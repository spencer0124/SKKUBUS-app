import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_duration.dart';

/// 수평 프로그레스 바
///
/// ```dart
/// SdsProgressBar(progress: 0.6)
/// ```
class SdsProgressBar extends StatelessWidget {
  final double progress;
  final Color? color;
  final double height;

  const SdsProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            // Track
            Container(color: SdsColors.grey200),
            // Bar
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: AnimatedContainer(
                duration: SdsDuration.slower,
                curve: SdsCurves.standard,
                decoration: BoxDecoration(
                  color: color ?? SdsColors.blue400,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
