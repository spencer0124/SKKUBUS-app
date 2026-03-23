import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';
import 'sds_skeleton.dart';

/// 리스트 로우 — 앱에서 가장 많이 쓰는 컴포넌트
///
/// 건물 목록, 호실 목록, 정류장, 검색 결과, 설정 항목 등 모든 리스트에 사용.
///
/// ```dart
/// SdsListRow(
///   left: Icon(Icons.apartment, size: 24),
///   contents: SdsListRowTexts.twoRow(top: '삼성학술정보관', bottom: '자과캠 · 48'),
///   withArrow: true,
///   onTap: () {},
/// )
/// ```
///
/// ### 아코디언(Expandable) 지원
///
/// [expandedContent]를 넘기면 아코디언 모드가 활성화됨.
/// 화살표가 자동 표시되며 [isExpanded] 상태에 따라 회전 애니메이션.
///
/// ```dart
/// SdsListRow(
///   left: badge,
///   contents: SdsListRowTexts.twoRow(top: '1층', bottom: '호실 10개'),
///   isExpanded: isExpanded,
///   expandedContent: spaceListWidget,
///   onTap: () => toggle(),
/// )
/// ```
class SdsListRow extends StatelessWidget {
  final Widget? left;
  final CrossAxisAlignment leftAlignment;
  final Widget contents;
  final Widget? right;
  final CrossAxisAlignment rightAlignment;
  final SdsListRowBorder border;
  final SdsListRowVPad verticalPadding;
  final SdsListRowHPad horizontalPadding;
  final bool withArrow;
  final bool withTouchEffect;
  final bool disabled;
  final VoidCallback? onTap;

  /// 펼침 영역 콘텐츠. non-null이면 아코디언 모드 활성화 + arrow 자동 표시.
  final Widget? expandedContent;

  /// 펼침 상태. [expandedContent]가 non-null일 때만 의미 있음.
  final bool isExpanded;

  const SdsListRow({
    super.key,
    this.left,
    this.leftAlignment = CrossAxisAlignment.center,
    required this.contents,
    this.right,
    this.rightAlignment = CrossAxisAlignment.center,
    this.border = SdsListRowBorder.indented,
    this.verticalPadding = SdsListRowVPad.medium,
    this.horizontalPadding = SdsListRowHPad.medium,
    this.withArrow = false,
    this.withTouchEffect = false,
    this.disabled = false,
    this.onTap,
    this.expandedContent,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = switch (horizontalPadding) {
      SdsListRowHPad.small => SdsSpacing.lg,
      SdsListRowHPad.medium => SdsSpacing.xl,
    };
    final vPad = switch (verticalPadding) {
      SdsListRowVPad.small => SdsSpacing.sm,
      SdsListRowVPad.medium => SdsSpacing.md,
      SdsListRowVPad.large => SdsSpacing.base,
      SdsListRowVPad.xlarge => SdsSpacing.xl,
    };

    final hasExpandable = expandedContent != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (border == SdsListRowBorder.indented ||
            border == SdsListRowBorder.indentedLight)
          Padding(
            padding: EdgeInsets.only(left: hPad),
            child: Divider(
              height: 1,
              thickness: 1,
              color: border == SdsListRowBorder.indentedLight
                  ? SdsColors.grey100
                  : SdsColors.grey200,
            ),
          ),
        GestureDetector(
          onTap: disabled ? null : onTap,
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: disabled ? 0.4 : 1.0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: vPad,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (left != null) ...[
                    _aligned(left!, leftAlignment),
                    const SizedBox(width: SdsSpacing.base),
                  ],
                  Expanded(child: contents),
                  if (right != null) ...[
                    const SizedBox(width: SdsSpacing.sm),
                    _aligned(right!, rightAlignment),
                  ],
                  // Arrow: expandedContent → animated, withArrow → static
                  if (hasExpandable) ...[
                    const SizedBox(width: SdsSpacing.xs),
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: isExpanded
                            ? SdsColors.grey600
                            : SdsColors.grey400,
                      ),
                    ),
                  ] else if (withArrow) ...[
                    const SizedBox(width: SdsSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: SdsColors.grey300,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Expandable content with smooth height animation
        if (hasExpandable)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: isExpanded
                ? expandedContent!
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _aligned(Widget child, CrossAxisAlignment alignment) {
    if (alignment == CrossAxisAlignment.start) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [child],
      );
    }
    return child;
  }
}

// ── Enums ──

enum SdsListRowBorder { indented, indentedLight, none }

enum SdsListRowVPad { small, medium, large, xlarge }

enum SdsListRowHPad { small, medium }

// ── Contents Helper ──

/// ListRow의 contents에 사용하는 텍스트 레이아웃 헬퍼
class SdsListRowTexts extends StatelessWidget {
  final String top;
  final String? mid;
  final String? bottom;

  const SdsListRowTexts._({
    required this.top,
    this.mid,
    this.bottom,
  });

  /// 한 줄 텍스트
  factory SdsListRowTexts.oneRow({required String top}) =>
      SdsListRowTexts._(top: top);

  /// 두 줄 텍스트 (제목 + 설명)
  factory SdsListRowTexts.twoRow({
    required String top,
    required String bottom,
  }) =>
      SdsListRowTexts._(top: top, bottom: bottom);

  /// 세 줄 텍스트 (제목 + 중간 + 설명)
  factory SdsListRowTexts.threeRow({
    required String top,
    required String mid,
    required String bottom,
  }) =>
      SdsListRowTexts._(top: top, mid: mid, bottom: bottom);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          top,
          style: SdsTypo.t5(weight: FontWeight.w500)
              .copyWith(color: SdsColors.grey900),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (mid != null) ...[
          const SizedBox(height: 2),
          Text(
            mid!,
            style: SdsTypo.t6().copyWith(color: SdsColors.grey600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (bottom != null) ...[
          const SizedBox(height: 2),
          Text(
            bottom!,
            style: SdsTypo.t7().copyWith(color: SdsColors.grey500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

// ── Skeleton ──

/// ListRow 스켈레톤 로더
///
/// ```dart
/// SdsListRowSkeleton(type: SdsListRowSkeletonType.circle)
/// ```
class SdsListRowSkeleton extends StatelessWidget {
  final SdsListRowSkeletonType type;

  const SdsListRowSkeleton({
    super.key,
    this.type = SdsListRowSkeletonType.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SdsSpacing.xl,
        vertical: SdsSpacing.md,
      ),
      child: Row(
        children: [
          _buildLeft(),
          const SizedBox(width: SdsSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SdsSkeleton.rect(width: 120, height: 16, borderRadius: 4),
                SizedBox(height: 6),
                SdsSkeleton.rect(width: 80, height: 12, borderRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: SdsSpacing.sm),
          const SdsSkeleton.rect(width: 48, height: 20, borderRadius: 4),
        ],
      ),
    );
  }

  Widget _buildLeft() => switch (type) {
    SdsListRowSkeletonType.circle => const SdsSkeleton.circle(size: 40),
    SdsListRowSkeletonType.square =>
      const SdsSkeleton.rect(width: 40, height: 40, borderRadius: 8),
    SdsListRowSkeletonType.bar =>
      const SdsSkeleton.rect(width: 4, height: 40, borderRadius: 2),
  };
}

enum SdsListRowSkeletonType { circle, square, bar }
