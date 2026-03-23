import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_shadows.dart';
import '../sds_typo.dart';

/// 세그먼트 컨트롤 — 토스 스타일 (화이트 인디케이터 + 그림자)
///
/// ```dart
/// SdsSegmentedControl(
///   labels: ['지도', '목록'],
///   selectedIndex: 0,
///   onChanged: (i) {},
/// )
/// ```
class SdsSegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SdsSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: SdsColors.grey100,
        borderRadius: BorderRadius.circular(SdsRadius.lg),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:
                      selected ? SdsShadows.segmentedIndicator : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: SdsTypo.t7(
                    weight: selected ? FontWeight.w600 : FontWeight.w400,
                  ).copyWith(
                    color: selected ? SdsColors.grey900 : SdsColors.grey600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
