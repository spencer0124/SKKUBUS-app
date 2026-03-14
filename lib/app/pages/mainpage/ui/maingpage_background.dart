import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/components/mainpage/top_search/searchbar.dart';
import 'package:skkumap/app/components/mainpage/top_search/filter.dart';
import 'package:skkumap/app/components/mainpage/top_scrollrow/scrollrow.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/coord_picker.dart';
import 'package:skkumap/app/pages/mainpage/ui/filter/filter_sheet.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap_controller.dart';

/*
snappingsheet의 child로 들어갈 background
상단 검색 창, 옵션, 네이버지도로 구성되어 있음
 */
class MainPageBackground extends StatelessWidget {
  const MainPageBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);
    final double statusBarHeight = ScreenSize.statusBarHeight(context);
    final ultimateController = Get.find<UltimateNMapController>();

    return Column(
      children: [
        Container(
          width: screenWidth,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: screenHeight - 47,
                            width: screenWidth,
                            child: buildMap(),
                          ),
                          Positioned(
                            left: 10,
                            right: 10,
                            top: statusBarHeight + 10,
                            child: Row(
                              children: [
                                const Expanded(child: CustomSearchBar()),
                                const SizedBox(width: 8),
                                CustomFilter(onFilterTap: () {
                                  Get.bottomSheet(const FilterSheet());
                                }),
                              ],
                            ),
                          ),
                          // scrollableRow 임시 비활성화
                          // Positioned(
                          //   left: 0,
                          //   right: 0,
                          //   top: (statusBarHeight + 10 + 60),
                          //   child: const Center(child: ScrollableRow()),
                          // ),
                          const CoordPickerPanel(),
                          // 현재위치 GPS 버튼 비활성화
                          // Positioned(
                          //   top: statusBarHeight + 10 + 100 - 40,
                          //   right: 10,
                          //   child: GestureDetector(
                          //     behavior: HitTestBehavior.translucent,
                          //     onTap: () {
                          //       ultimateController.moveToCurrentLocation();
                          //     },
                          //     child: Container(
                          //       padding: const EdgeInsets.all(10),
                          //       decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(10),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withOpacity(0.2),
                          //             blurRadius: 4,
                          //             offset: const Offset(0, 2),
                          //           ),
                          //         ],
                          //       ),
                          //       child: const Icon(Icons.my_location),
                          //     ),
                          //   ),
                          // ),
                          // Positioned(
                          //   top: statusBarHeight + 10 + 150,
                          //   right: 10,
                          //   child: GestureDetector(
                          //     behavior: HitTestBehavior.translucent,
                          //     onTap: () {
                          //       ultimateController.moveToCurrentLocation();
                          //     },
                          //     child: Container(
                          //       padding: const EdgeInsets.all(10),
                          //       decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(10),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withOpacity(0.2),
                          //             blurRadius: 4,
                          //             offset: const Offset(0, 2),
                          //           ),
                          //         ],
                          //       ),
                          //       child: const Icon(Icons.my_location),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
