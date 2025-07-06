import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:get/get.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class LostAndFound extends StatelessWidget {
  const LostAndFound({super.key});

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
            title: '분실물'.tr,
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
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
            alignment: Alignment.centerLeft,
            width: screenWidth * 0.92,
            // height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "유실물 접수 및 처리 절차".tr,
                  style: const TextStyle(
                      fontSize: 13, fontFamily: 'WantedSansBold'),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  "→  최초 발견자 습득 시, 1~2일 내 학생지원팀 이관\n→  학생지원팀: 유실물 게시판에 1개월 동안 공지\n→  1년 보관 후 폐기"
                      .tr,
                  style: const TextStyle(
                      fontSize: 13, fontFamily: 'WantedSansRegular'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 0),
            // color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 5,
                    ),
                    Text(
                      '학생지원팀'.tr,
                      style: const TextStyle(
                        color: AppColors.green_main,
                        fontFamily: 'WantedSansBold',
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인사캠: 600주년기념관 1층\n자과캠: 학생회관 종합행정실 1층\n운영시간: 평일 09:00~17:30'
                            .tr,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: 'WantedSansRegular',
                            fontSize: 13),
                        textAlign: TextAlign.start,
                      ),
                      Row(
                        children: [
                          Text(
                            '이메일: '.tr,
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: 'WantedSansRegular',
                                fontSize: 13),
                            textAlign: TextAlign.start,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await Clipboard.setData(const ClipboardData(
                                text: 'studentaid@skku.edu',
                              ));
                              await FlutterPlatformAlert.showCustomAlert(
                                windowTitle: '복사 완료!'.tr,
                                text: '이메일 주소 복사가 완료되었습니다'.tr,
                                positiveButtonTitle: "확인".tr,
                              );
                            },
                            child: const Text(
                              'studentaid@skku.edu',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'WantedSansRegular',
                                  fontSize: 13),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '인사캠 학생지원팀  '.tr,
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontFamily: 'WantedSansRegular',
                          fontSize: 13),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await FlutterPhoneDirectCaller.callNumber(
                              '027601077');
                        } catch (e) {
                          print("Failed to make a call due to ${e.toString()}");
                        }
                      },
                      child: const Row(
                        children: [
                          Text(
                            '02-760-1077',
                            style: TextStyle(
                                color: AppColors.green_main,
                                fontFamily: 'WantedSansBold',
                                fontSize: 13),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '자과캠 학생지원팀  '.tr,
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontFamily: 'WantedSansRegular',
                          fontSize: 13),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await FlutterPhoneDirectCaller.callNumber(
                              '0312905034');
                        } catch (e) {
                          print("Failed to make a call due to ${e.toString()}");
                        }
                      },
                      child: const Row(
                        children: [
                          Text(
                            '031-290-5034',
                            style: TextStyle(
                                color: AppColors.green_main,
                                fontFamily: 'WantedSansBold',
                                fontSize: 13),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
                Row(
                  children: [
                    // Icon(
                    //   Icons.location_on,
                    //   color: AppColors.green_main,
                    // ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '분실물 게시판'.tr,
                      style: const TextStyle(
                        color: AppColors.green_main,
                        fontFamily: 'WantedSansBold',
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(
                        "https://www.skku.edu/skku/campus/support/lost_and_found_2.do"))) {
                      await launchUrl(Uri.parse(
                          "https://www.skku.edu/skku/campus/support/lost_and_found_2.do"));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.link_outlined,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '물건을 찾습니다'.tr,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontFamily: 'WantedSansRegular',
                              fontSize: 13),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(
                        "https://www.skku.edu/skku/campus/support/lost_and_found_3.do"))) {
                      await launchUrl(Uri.parse(
                          "https://www.skku.edu/skku/campus/support/lost_and_found_3.do"));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.link_outlined,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '주인을 찾습니다'.tr,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontFamily: 'WantedSansRegular',
                              fontSize: 13),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
