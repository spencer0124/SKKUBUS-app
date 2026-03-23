import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 리스트 섹션 헤더
///
/// ```dart
/// SdsListHeader(title: '층별 안내')
/// SdsListHeader(title: '결제 방법', description: '셔틀버스 요금 400원')
/// SdsListHeader(title: '건물', right: Text('5곳'))
/// ```
class SdsListHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? right;

  const SdsListHeader({
    super.key,
    required this.title,
    this.description,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: SdsSpacing.xl,
        right: SdsSpacing.xl,
        top: SdsSpacing.xl,
        bottom: SdsSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: SdsTypo.t5(weight: FontWeight.w700)
                      .copyWith(color: SdsColors.grey900),
                ),
              ),
              if (right != null) right!,
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: SdsSpacing.xs),
            Text(
              description!,
              style: SdsTypo.t7().copyWith(color: SdsColors.grey500),
            ),
          ],
        ],
      ),
    );
  }
}
