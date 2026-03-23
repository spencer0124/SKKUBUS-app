import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sds_colors.dart';
import '../sds_typo.dart';

/// 앱바 — 화면 상단 내비게이션
///
/// ```dart
/// SdsTop(title: '삼성학술정보관')
/// SdsTop(title: '설정', rightActions: [IconButton(...)])
/// ```
class SdsTop extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leftAction;
  final List<Widget>? rightActions;
  final bool showBorder;

  const SdsTop({
    super.key,
    this.title,
    this.leftAction,
    this.rightActions,
    this.showBorder = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                // Left action
                leftAction ??
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: SdsColors.grey900,
                      ),
                    ),
                // Title
                Expanded(
                  child: title != null
                      ? Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: SdsTypo.t5(weight: FontWeight.w600)
                              .copyWith(color: SdsColors.grey900),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const SizedBox.shrink(),
                ),
                // Right actions
                if (rightActions != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: rightActions!,
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),
          if (showBorder)
            const Divider(height: 1, thickness: 1, color: SdsColors.grey200),
        ],
      ),
    );
  }
}
