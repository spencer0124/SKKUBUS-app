import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';
import 'sds_button.dart';

/// 다이얼로그
///
/// ```dart
/// SdsDialog.show(
///   title: '건물 정보를\n불러오지 못했어요',
///   description: '잠시 후 다시 시도해 주세요',
///   confirmText: '다시 시도',
///   onConfirm: () {},
/// );
/// ```
class SdsDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String closeText;
  final String? confirmText;
  final VoidCallback? onClose;
  final VoidCallback? onConfirm;

  const SdsDialog({
    super.key,
    required this.title,
    this.description,
    this.closeText = '닫기',
    this.confirmText,
    this.onClose,
    this.onConfirm,
  });

  /// 다이얼로그를 표시하는 정적 메서드
  static Future<void> show({
    required String title,
    String? description,
    String closeText = '닫기',
    String? confirmText,
    VoidCallback? onClose,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    return Get.dialog(
      SdsDialog(
        title: title,
        description: description,
        closeText: closeText,
        confirmText: confirmText,
        onClose: onClose,
        onConfirm: onConfirm,
      ),
      barrierColor: SdsColors.greyOpacity800,
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.only(
            top: SdsSpacing.xl,
            left: SdsSpacing.lg,
            right: SdsSpacing.lg,
            bottom: SdsSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SdsRadius.xl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: SdsTypo.t4(weight: FontWeight.w700)
                    .copyWith(color: SdsColors.grey800),
              ),
              // Description
              if (description != null) ...[
                const SizedBox(height: SdsSpacing.sm),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: SdsTypo.t6(weight: FontWeight.w500)
                      .copyWith(color: SdsColors.grey600),
                ),
              ],
              const SizedBox(height: SdsSpacing.lg),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SdsButton(
                      text: closeText,
                      variant: SdsButtonVariant.weak,
                      color: SdsButtonColor.dark,
                      size: SdsButtonSize.large,
                      onPressed: () {
                        Get.back();
                        onClose?.call();
                      },
                    ),
                  ),
                  if (confirmText != null) ...[
                    const SizedBox(width: SdsSpacing.sm),
                    Expanded(
                      child: SdsButton(
                        text: confirmText!,
                        variant: SdsButtonVariant.fill,
                        color: SdsButtonColor.primary,
                        size: SdsButtonSize.large,
                        onPressed: () {
                          Get.back();
                          onConfirm?.call();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
