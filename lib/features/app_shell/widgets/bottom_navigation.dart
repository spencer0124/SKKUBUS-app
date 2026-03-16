import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';

class Bottomnavigation extends StatelessWidget {
  const Bottomnavigation({
    Key? key,
    required this.index,
    required this.onItemTapped,
  }) : super(key: key);
  final int index;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              _TabItem(
                icon: Icons.map_outlined,
                activeIcon: Icons.map,
                label: '캠퍼스'.tr,
                isSelected: index == 1,
                onTap: () => onItemTapped(1),
              ),
              _TabItem(
                icon: Icons.near_me_outlined,
                activeIcon: Icons.near_me,
                label: '이동'.tr,
                isSelected: index == 2,
                onTap: () => onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.textPrimary : AppColors.textDisabled;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontFamily:
                    isSelected ? 'WantedSansMedium' : 'WantedSansRegular',
                color: color,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
