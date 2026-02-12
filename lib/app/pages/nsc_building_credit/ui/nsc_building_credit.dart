import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NSCBuildingCredit extends StatelessWidget {
  const NSCBuildingCredit({super.key});

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
            title: '자과캠 건물지도'.tr,
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
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "자과캠 벤젠고리관 건물지도 제공",
                  style: TextStyle(fontSize: 13, fontFamily: 'WantedSansBold'),
                ),
                const SizedBox(
                  height: 3,
                ),
                const Text(
                  "@고소림",
                  style:
                      TextStyle(fontSize: 13, fontFamily: 'WantedSansRegular'),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (await canLaunchUrl(
                        Uri.parse("https://linktr.ee/gosolim"))) {
                      await launchUrl(Uri.parse("https://linktr.ee/gosolim"));
                    }
                  },
                  child: const Text(
                    "https://linktr.ee/gosolim",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'WantedSansRegular',
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.only(left: 60, right: 60),
            child: Image.asset('assets/images/benzenmapcredit.png'),
          )
        ],
      ),
    );
  }
}
