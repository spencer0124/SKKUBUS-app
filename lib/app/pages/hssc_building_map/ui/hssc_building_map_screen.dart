import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:skkumap/app/pages/hssc_building_map/controller/hssc_building_map_controller.dart';

import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:skkumap/app/utils/screensize.dart';

class HSSCBuildingMap extends StatelessWidget {
  const HSSCBuildingMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);

    final controller = Get.find<HSSCBuildingMapController>();
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
      body: Stack(
        children: [
          Column(
            children: [
              CustomNavigationBar(
                title: '인사캠 건물지도'.tr,
                backgroundColor: AppColors.green_main,
                isDisplayLeftBtn: true,
                isDisplayRightBtn: true,
                leftBtnAction: () {
                  Get.back();
                },
                rightBtnAction: () {
                  Get.toNamed('/hsscbuildingcredit');
                },
                rightBtnType: CustomNavigationBtnType.info,
              ),
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.82,
                child: WebViewWidget(controller: controller.webcontroller),
              )
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(() {
                return controller.showInfoTap.value == true
                    ? Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, -5),
                            ),
                          ],
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                        ),
                        height: 120,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Spacer(),

                                      Container(
                                        width: screenWidth * 0.88,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          // color: Color(
                                          //   int.parse(
                                          //       "0xFF${controller.leftColor.value}"),
                                          // ),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(int.parse(
                                                  "0xFF${controller.leftColor.value}")),
                                              Color(int.parse(
                                                  "0xFF${controller.rightColor.value}")),
                                            ],
                                            stops: const [
                                              0.5,
                                              0.5
                                            ], // Split the gradient evenly
                                          ),
                                        ),
                                        child: Row(children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Obx(() {
                                            return Row(
                                              children: [
                                                if (controller
                                                        .previousPlace.value !=
                                                    "")
                                                  const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.white,
                                                      size: 8),
                                                if (controller
                                                        .previousPlace.value !=
                                                    "")
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                Text(
                                                  controller
                                                      .previousPlace.value,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                controller.afterPlace.value,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              if (controller.afterPlace.value !=
                                                  "")
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                              if (controller.afterPlace.value !=
                                                  "")
                                                const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                    size: 8)
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ]),
                                      ),

                                      const Spacer(),
                                      // Text(controller.previousPlace.value),
                                      // Text(controller.placeName.value),
                                      // Text(controller.afterPlace.value),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.time.value == ""
                                            ? '시간 정보 없음'
                                            : controller.time.value,
                                        style: TextStyle(
                                          color: controller.time.value == ""
                                              ? Colors.grey[500]
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        controller.placeInfo.value == ""
                                            ? '장소 정보 없음'
                                            : controller.placeInfo.value,
                                        style: TextStyle(
                                          color:
                                              controller.placeInfo.value == ""
                                                  ? Colors.grey[500]
                                                  : Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 12,
                              left:
                                  screenWidth * 0.44 - 65 + screenWidth * 0.06,
                              child: Container(
                                alignment: Alignment.center,
                                width: 130,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller.leftColor.value ==
                                            controller.rightColor.value
                                        ? Color(
                                            int.parse(
                                                "0xFF${controller.leftColor.value}"),
                                          )
                                        : Colors.grey[400]!,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  controller.placeName.value,
                                  style: const TextStyle(
                                    fontFamily: 'WantedSansRegular',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0.5,
                      );
              }))
        ],
      ),
    );
  }
}
