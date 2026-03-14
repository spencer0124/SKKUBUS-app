import 'package:flutter/material.dart';
import 'package:skkumap/app_theme.dart';
import 'package:get/get.dart';

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
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15), // Shadow color with opacity
            spreadRadius: 2,
            blurRadius: 10, // Adjust blur radius to control the shadow's spread
            offset: const Offset(0, -1), // Vertical offset for the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
        child: Row(
          children: [
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                onItemTapped(1);
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/flaticon_campus.png',
                    width: 22,
                    color: index == 1 ? AppColors.greenMain : Colors.grey,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '캠퍼스'.tr,
                    style: TextStyle(
                      color: index == 1 ? AppColors.greenMain : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                onItemTapped(2);
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/flaticon_bus1.png',
                    width: 22,
                    color: index == 2 ? AppColors.greenMain : Colors.grey,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '버스'.tr,
                    style: TextStyle(
                      color: index == 2 ? AppColors.greenMain : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
