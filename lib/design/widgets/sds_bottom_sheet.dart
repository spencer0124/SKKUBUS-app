import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 바텀시트
///
/// ```dart
/// SdsBottomSheet.show(
///   title: '건물 정보',
///   child: ListView(...),
/// );
/// ```
class SdsBottomSheet extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget child;
  final Widget? cta;

  const SdsBottomSheet({
    super.key,
    this.title,
    this.description,
    required this.child,
    this.cta,
  });

  /// 바텀시트를 표시하는 정적 메서드
  static Future<T?> show<T>({
    String? title,
    String? description,
    required Widget child,
    Widget? cta,
    bool isScrollControlled = true,
    bool isDismissible = true,
  }) {
    return Get.bottomSheet<T>(
      SdsBottomSheet(
        title: title,
        description: description,
        cta: cta,
        child: child,
      ),
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: SdsColors.greyOpacity800,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SdsRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: SdsSpacing.md),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: SdsColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(
                top: SdsSpacing.lg,
                left: SdsSpacing.lg,
                right: SdsSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: SdsTypo.t4(weight: FontWeight.w700)
                        .copyWith(color: SdsColors.grey900),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: SdsSpacing.xs),
                    Text(
                      description!,
                      style: SdsTypo.t6().copyWith(color: SdsColors.grey500),
                    ),
                  ],
                ],
              ),
            ),
          // Content (with gradient overlay when CTA exists)
          if (cta != null)
            Flexible(
              child: Stack(
                children: [
                  child,
                  // Gradient fade above CTA
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        height: 34,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00FFFFFF),
                              Color(0xFFFFFFFF),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Flexible(child: child),
          // CTA
          if (cta != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(SdsSpacing.lg),
                child: cta,
              ),
            ),
        ],
      ),
    );
  }
}
