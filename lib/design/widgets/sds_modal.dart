import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sds_colors.dart';
import '../sds_typo.dart';

/// 전체 화면 모달
///
/// ```dart
/// SdsModal.show(
///   title: '이용약관',
///   child: SingleChildScrollView(child: Text(...)),
/// );
/// ```
class SdsModal extends StatelessWidget {
  final String? title;
  final Widget child;

  const SdsModal({
    super.key,
    this.title,
    required this.child,
  });

  static Future<T?> show<T>({
    String? title,
    required Widget child,
  }) async {
    return Get.to<T>(
      () => SdsModal(title: title, child: child),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, size: 24, color: SdsColors.grey900),
        ),
        title: title != null
            ? Text(
                title!,
                style: SdsTypo.t5(weight: FontWeight.w600)
                    .copyWith(color: SdsColors.grey900),
              )
            : null,
        centerTitle: true,
      ),
      body: child,
    );
  }
}
