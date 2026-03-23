import 'package:flutter/material.dart';

import '../sds_colors.dart';
import '../sds_radius.dart';
import '../sds_shadows.dart';
import '../sds_spacing.dart';
import '../sds_typo.dart';

/// 드롭다운 메뉴
///
/// ```dart
/// SdsMenu(
///   items: [
///     SdsMenuItem(text: '수정하기', icon: Icons.edit),
///     SdsMenuItem(text: '삭제하기', icon: Icons.delete, isDestructive: true),
///   ],
///   onSelected: (i) {},
///   child: Icon(Icons.more_vert),
/// )
/// ```
class SdsMenu extends StatelessWidget {
  final List<SdsMenuItem> items;
  final ValueChanged<int> onSelected;
  final Widget child;

  const SdsMenu({
    super.key,
    required this.items,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SdsRadius.full),
      ),
      color: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      itemBuilder: (context) => List.generate(items.length, (i) {
        final item = items[i];
        return PopupMenuItem<int>(
          value: i,
          padding: const EdgeInsets.symmetric(
            horizontal: SdsSpacing.base,
            vertical: SdsSpacing.md,
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 20,
                  color: item.isDestructive
                      ? SdsColors.red500
                      : SdsColors.grey600,
                ),
                const SizedBox(width: SdsSpacing.sm),
              ],
              Text(
                item.text,
                style: SdsTypo.t6().copyWith(
                  color: item.isDestructive
                      ? SdsColors.red500
                      : SdsColors.grey900,
                ),
              ),
            ],
          ),
        );
      }),
      child: Container(
        decoration: const BoxDecoration(boxShadow: SdsShadows.elevated),
        child: child,
      ),
    );
  }
}

class SdsMenuItem {
  final String text;
  final IconData? icon;
  final bool isDestructive;

  const SdsMenuItem({
    required this.text,
    this.icon,
    this.isDestructive = false,
  });
}
