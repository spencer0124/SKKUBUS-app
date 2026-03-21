import 'package:flutter/material.dart';
import 'package:skkumap/app_theme.dart';

class CustomServiceBtn extends StatelessWidget {
  final String title;
  final String emoji;
  final VoidCallback onTap;
  final double size;

  const CustomServiceBtn({
    Key? key,
    required this.title,
    required this.emoji,
    required this.onTap,
    this.size = 77,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.bgGrey,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Text(
                emoji,
                style: const TextStyle(
                  fontFamily: 'Tossface',
                  fontSize: 30,
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: const TextStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
