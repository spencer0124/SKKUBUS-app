import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 탭 — underline / pill 스타일
///
/// ```dart
/// SdsTab(
///   tabs: ['인사캠→자과캠', '자과캠→인사캠'],
///   selectedIndex: 0,
///   onChanged: (i) {},
/// )
/// SdsTab(
///   tabs: ['3/23월', '3/24화', '3/25수'],
///   selectedIndex: 0,
///   onChanged: (i) {},
///   style: SdsTabStyle.pill,
///   scrollable: true,
/// )
/// ```
class SdsTab extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final SdsTabStyle style;
  final bool scrollable;

  const SdsTab({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.style = SdsTabStyle.underline,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      SdsTabStyle.underline => _buildUnderline(),
      SdsTabStyle.pill => _buildPill(),
    };
  }

  Widget _buildUnderline() {
    final children = List.generate(tabs.length, (i) {
      final selected = i == selectedIndex;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(i),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: SdsSpacing.md),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: SdsTypo.t5(
                    weight: selected ? FontWeight.w700 : FontWeight.w400,
                  ).copyWith(
                    color: selected ? SdsColors.grey800 : SdsColors.grey600,
                  ),
                ),
              ),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: selected ? SdsColors.grey800 : Colors.transparent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: children),
        const Divider(height: 1, thickness: 1, color: SdsColors.grey200),
      ],
    );
  }

  Widget _buildPill() {
    final children = List.generate(tabs.length, (i) {
      final selected = i == selectedIndex;
      return Padding(
        padding: EdgeInsets.only(
          left: i == 0 ? SdsSpacing.lg : SdsSpacing.xs,
          right: i == tabs.length - 1 ? SdsSpacing.lg : 0,
        ),
        child: GestureDetector(
          onTap: () => onChanged(i),
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? SdsColors.grey900 : SdsColors.grey100,
              borderRadius: BorderRadius.circular(SdsRadius.full),
            ),
            alignment: Alignment.center,
            child: Text(
              tabs[i],
              style: SdsTypo.t7(
                weight: selected ? FontWeight.w600 : FontWeight.w400,
              ).copyWith(
                color: selected ? Colors.white : SdsColors.grey600,
              ),
            ),
          ),
        ),
      );
    });

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      );
    }
    return Row(children: children);
  }
}

enum SdsTabStyle { underline, pill }
