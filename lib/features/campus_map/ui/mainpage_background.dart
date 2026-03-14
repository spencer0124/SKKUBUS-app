import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/features/campus_map/widgets/searchbar.dart';
import 'package:skkumap/features/campus_map/widgets/filter.dart';
import 'package:skkumap/core/utils/screensize.dart';
import 'package:skkumap/features/campus_map/ui/navermap/navermap.dart';
import 'package:skkumap/features/campus_map/ui/navermap/coord_picker.dart';
import 'package:skkumap/features/campus_map/ui/filter/filter_sheet.dart';
import 'package:skkumap/features/campus_map/controller/campus_map_controller.dart';
import 'package:skkumap/features/campus_map/controller/map_layer_controller.dart';

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
                          Positioned(
                            left: 10,
                            top: statusBarHeight + 10 + 50,
                            child: _CampusToggle(),
                          ),
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

class _CampusToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CampusMapController>();
    final layerCtrl = Get.find<MapLayerController>();

    return Obx(() {
      final selected = controller.selectedCampus.value;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildItem('인사캠', 0, selected == 0, () {
              controller.selectedCampus.value = 0;
              layerCtrl.onCampusChanged();
            }),
            _buildItem('자과캠', 1, selected == 1, () {
              controller.selectedCampus.value = 1;
              layerCtrl.onCampusChanged();
            }),
          ],
        ),
      );
    });
  }

  Widget _buildItem(
      String label, int index, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenMain : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'WantedSansMedium',
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
