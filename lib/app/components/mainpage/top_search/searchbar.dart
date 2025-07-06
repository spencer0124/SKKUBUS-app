import 'package:flutter/material.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      alignment: Alignment.centerLeft,
      height: 49,
      // width: screenWidth * 0.8,
      width: screenWidth - 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.5),
          //   spreadRadius: 1,
          //   blurRadius: 5,
          //   offset: const Offset(0, 3), // changes position of shadow
          // ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.toNamed('/searchlist');
        },
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/tossface/toss_search_left.svg',
              width: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              '성균관대 건물코드 검색'.tr,
              style: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'WantedSansMedium',
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
