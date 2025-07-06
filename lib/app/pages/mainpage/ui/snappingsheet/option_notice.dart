import 'package:flutter/material.dart';
import 'package:skkumap/app/components/mainpage/busrow.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/stationrow.dart';
import 'package:skkumap/app_theme.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class OptionBus extends StatelessWidget {
  OptionBus({Key? key}) : super(key: key);

  final controller = Get.find<MainpageController>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);

    return Container(
      color: Colors.white,
      child: Obx(() {
        if (controller.mainpageBusList.value == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final busList = controller.mainpageBusList.value!.busList;

          final busWidgets = busList.map((bus) {
            return CustomRow1(
              title: bus.title.tr,
              subtitle: bus.subtitle,
              busTypeText: bus.busTypeText,
              busTypeBgColor: bus.busTypeBgColor,
              pageLink: bus.pageLink,
              altPageLink: bus.altPageLink,
              pageWebviewLink: bus.pageWebviewLink,
              noticeText: bus.noticeText,
              useAltPageLink: bus.useAltPageLink,
              showAnimation: bus.showAnimation,
              showNoticeText: bus.showNoticeText,
            );
          }).toList();

          // Use a Column to display your widgets in a scrollable view
          return SingleChildScrollView(
            child: Column(
              children: [
                // 상단 container -> notice area
                const SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (controller.mainpageAdLink.value != '') {
                      if (await canLaunchUrl(
                          Uri.parse(controller.mainpageAdLink.value))) {
                        await launchUrl(
                            Uri.parse(controller.mainpageAdLink.value));
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
                                  // Text(
                                  //   '상세정보'.tr,
                                  //   style: TextStyle(
                                  //     color: Colors.grey[900],
                                  //     fontFamily: 'WantedSansMedium',
                                  //     fontSize: 12.5,
                                  //   ),
                                  // ),
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
                  () {
                    if (controller.showmainpageNoticeText.value == true) {
                      return Column(
                        children: [
                          Divider(
                            color: Colors.grey[300],
                            height: 0,
                            thickness: 0.7,
                            endIndent: 0,
                            indent: screenWidth * 0.145,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              if (controller.mainpageNoticeLink.value != '') {
                                if (await canLaunchUrl(Uri.parse(
                                    controller.mainpageNoticeLink.value))) {
                                  await launchUrl(Uri.parse(
                                      controller.mainpageNoticeLink.value));
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 19,
                                  ),
                                  Obx(() =>
                                      controller.mainpageNoticeText.value == ''
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
                                              controller
                                                  .mainpageNoticeText.value,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'WantedSansMedium',
                                                fontSize: 12.5,
                                              ),
                                            )),
                                  const Spacer(),
                                  Obx(() =>
                                      controller.mainpageAdText.value == ''
                                          ? const SizedBox(
                                              width: 1,
                                              height: 1,
                                            )
                                          : const Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Text(
                                                //   '상세정보'.tr,
                                                //   style: TextStyle(
                                                //     color: Colors.grey[900],
                                                //     fontFamily: 'WantedSansMedium',
                                                //     fontSize: 12.5,
                                                //   ),
                                                // ),
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
                        ],
                      );
                    }
                    return const SizedBox(
                      width: 0.1,
                    );
                  },
                ),

                const SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 0,
                  thickness: 0.7,
                  endIndent: 0,
                  indent: screenWidth * 0.145,
                ),
                Container(color: Colors.white, height: 10),
                ...busWidgets,
                const SizedBox(height: 5),
              ],
            ),
          );
        }
      }),
    );
  }
}
