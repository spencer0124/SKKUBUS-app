import 'package:flutter/material.dart';
import 'package:skkumap/app_theme.dart';

class CustomFilter extends StatelessWidget {
  final VoidCallback onFilterTap;

  const CustomFilter({Key? key, required this.onFilterTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onFilterTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, size: 16, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text(
              '필터',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontFamily: 'WantedSansMedium',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
