import 'package:flutter/material.dart';
import 'package:skkumap/app/components/mainpage/busrow.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/stationrow.dart';
import 'package:skkumap/app_theme.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

// 정류장 탭

class OptionStation extends StatelessWidget {
  OptionStation({Key? key}) : super(key: key);

  final controller = Get.find<MainpageController>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                if (controller.mainpageAdLink.value != '') {
                  if (await canLaunchUrl(
                      Uri.parse(controller.mainpageAdLink.value))) {
                    await launchUrl(Uri.parse(controller.mainpageAdLink.value));
                    try {
                      http.get(Uri.parse(
                          'http://43.200.90.214:3000/ad/v1/statistics/menu2/click'));
                    } catch (e) {
                      print('Error: $e');
                    }
                  } else {
                    Get.snackbar('오류', '해당 링크를 열 수 없습니다.');
                  }
                } else {
                  Get.snackbar('오류2', '해당 링크를 열 수 없습니다.');
                }
              },
              child: Container(
                width: screenWidth * 0.95,
                height: 33,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 14,
                    ),
                    Image.asset(
                      'assets/images/flaticon_megaphone.png',
                      width: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 19,
                    ),
                    Obx(() => controller.mainpageAdText.value == ''
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[100]!,
                            highlightColor: Colors.white,
                            child: Container(
                              width: screenWidth * 0.75,
                              height: 20,
                              color: Colors.grey,
                            ),
                          )
                        : Text(
                            controller.mainpageAdText.value,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'WantedSansMedium',
                              fontSize: 12.5,
                            ),
                          )),
                    const Spacer(),
                    Obx(() => controller.mainpageAdText.value == ''
                        ? const SizedBox(
                            width: 1,
                            height: 1,
                          )
                        : const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                CupertinoIcons.right_chevron,
                                size: 12,
                                color: Colors.black,
                              ),
                            ],
                          )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Obx(
              () => Column(
                children: [
                  Divider(
                    color: Colors.grey[300],
                    height: 0,
                    thickness: 0.7,
                    endIndent: 0,
                    indent: screenWidth * 0.145,
                  ),
                  CustomRow2(
                    isLoading: true,
                    iconData: Icons.stop_circle_rounded,
                    titleText: '혜화역 1번 출구',
                    subtitleText1: controller
                            .stationData.value?.stationData[0].msg1Message ??
                        "정보 없음",
                    subtitleText2: controller
                            .stationData.value?.stationData[1].msg1Message ??
                        "정보 없음",
                    containerColor: Colors.black,
                    containerText: '정류장',
                    routeName: '/MainbusMain',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
