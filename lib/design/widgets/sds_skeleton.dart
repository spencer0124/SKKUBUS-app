import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../sds_colors.dart';

/// 스켈레톤 로딩 플레이스홀더
///
/// ```dart
/// SdsSkeleton.rect(width: 120, height: 16, borderRadius: 4)
/// SdsSkeleton.circle(size: 40)
/// ```
class SdsSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const SdsSkeleton._({
    this.width,
    required this.height,
    this.borderRadius = 0,
    this.shape = BoxShape.rectangle,
  });

  /// 사각형 스켈레톤
  const factory SdsSkeleton.rect({
    double? width,
    required double height,
    double borderRadius,
  }) = _RectSkeleton;

  /// 원형 스켈레톤
  const factory SdsSkeleton.circle({required double size}) = _CircleSkeleton;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: SdsColors.grey200,
      highlightColor: SdsColors.grey100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: SdsColors.grey200,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius)
              : null,
        ),
      ),
    );
  }
}

class _RectSkeleton extends SdsSkeleton {
  const _RectSkeleton({
    double? width,
    required super.height,
    double borderRadius = 4,
  }) : super._(width: width, borderRadius: borderRadius);
}

class _CircleSkeleton extends SdsSkeleton {
  const _CircleSkeleton({required double size})
      : super._(
          width: size,
          height: size,
          shape: BoxShape.circle,
        );
}
