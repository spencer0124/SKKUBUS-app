import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_typo.dart';

/// 토스트 메시지 — 하단 중앙, 2초 후 자동 사라짐
///
/// ```dart
/// SdsToast.show('복사했어요');
/// ```
class SdsToast {
  SdsToast._();

  static void show(String message) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: SdsColors.grey900.withValues(alpha: 0.9),
      borderRadius: SdsRadius.md,
      margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: SdsTypo.t6().copyWith(color: Colors.white),
      ),
    );
  }
}
