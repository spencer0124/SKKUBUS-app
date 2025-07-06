import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:get/get.dart';

class HSSCBuildingCredit extends StatelessWidget {
  const HSSCBuildingCredit({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: AppColors.green_main,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          CustomNavigationBar(
            title: '인사캠 건물지도'.tr,
            backgroundColor: AppColors.green_main,
            isDisplayLeftBtn: true,
            isDisplayRightBtn: false,
            leftBtnAction: () {
              Get.back();
            },
            rightBtnAction: () {},
            rightBtnType: CustomNavigationBtnType.info,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.centerLeft,
            width: screenWidth * 0.92,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "인사캠 건물지도 '빠를지도' 제공",
                  style: TextStyle(fontSize: 13, fontFamily: 'WantedSansBold'),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "@문화예술캡스톤디자인 2조\n김찬호 김서연 전윤아 왕희문 손주연 신해령",
                  style:
                      TextStyle(fontSize: 13, fontFamily: 'WantedSansRegular'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Image.asset('assets/images/fastmapcredit.png'),
          )
        ],
      ),
    );
  }
}
