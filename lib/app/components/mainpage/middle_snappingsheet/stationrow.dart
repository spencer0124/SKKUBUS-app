import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/stationrow_component.dart'; // Import the ScrollRowContainer widget
import 'package:get/get.dart';
import 'package:skkumap/app/types/bus_type.dart';

final double dwidth =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

class CustomRow2 extends StatelessWidget {
  final IconData iconData;
  final String titleText;
  final String subtitleText1;
  final String subtitleText2;
  final Color containerColor;
  final String containerText;
  final String routeName;
  final bool isLoading;

  const CustomRow2({
    super.key,
    required this.iconData,
    required this.titleText,
    required this.subtitleText1,
    required this.subtitleText2,
    required this.containerColor,
    required this.containerText,
    required this.routeName,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(routeName);
      },
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 14.h,
              ),
              Container(
                width: dwidth,
                height: 100,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 10, 0),
                          child: Image.asset(
                            'assets/images/flaticon_stop1.png',
                            width: 22.w,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  titleText,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'WantedSansMedium',
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const Text(
                                  '  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'WantedSansBold',
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Get.toNamed('/MainbusMain', arguments: {
                                          'bustype': BusType.jongro07Bus,
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          const StationRowComponent(
                                            containerColor: Colors.green,
                                            containerText: '종로07',
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            subtitleText1,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              // fontFamily: 'WantedSansMedium',
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Get.toNamed('/MainbusMain', arguments: {
                                          'bustype': BusType.hsscBus,
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          const StationRowComponent(
                                            containerColor:
                                                AppColors.green_main,
                                            containerText: '인사캠',
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            subtitleText2,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              // fontFamily: 'WantedSansMedium',
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 0.7,
                endIndent: 0,
                indent: dwidth * 0.145,
              ),
            ],
          ),
          Positioned(
            right: 10.w,
            top: 19.2.h,
            // bottom: 0,
            child: GestureDetector(
              onTap: () {
                // Get.toNamed('kingologin');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontFamily: 'WantedSansMedium',
                      fontSize: 12.5,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
