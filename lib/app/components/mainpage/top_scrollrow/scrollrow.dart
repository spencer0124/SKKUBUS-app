import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/snappingsheet_controller.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap_controller.dart';
import 'scrollrow_component.dart'; // Import the ScrollRowContainer widget
import 'package:skkumap/app/pages/mainpage/controller/around_place_controller.dart';

class ScrollableRow extends StatelessWidget {
  const ScrollableRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get map controller for content bounds
    final ultimateNampController = Get.find<UltimateNMapController>();
    // controller to fetch place data
    final aroundCtrl = Get.put(AroundPlaceController());
    return SingleChildScrollView(
      clipBehavior: Clip.none, // 그림자가 제대로 표시되지 않는 문제 해결
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              // Debug current visible map bounds
              final bounds = await ultimateNampController.mapController.value
                  ?.getContentBounds();
              print('Current map bounds: $bounds');
              if (bounds != null) {
                await aroundCtrl.fetchAroundPlaceData(bounds);
              }
              // Snap sheet to smallest position
              snappingSheetController.snapToPosition(
                getSnappingPositions()[0],
              );
              // After 3 seconds, snap to middle position
              Future.delayed(const Duration(seconds: 3), () {
                snappingSheetController.snapToPosition(
                  getSnappingPositions()[1],
                );
              });
              // Navigate to detail map
              // Get.toNamed('/hsscbuildingmap');
            },
            child: ScrollRowContainer(
              text: '음식점'.tr,
              svgPath: 'assets/tossface/toss_forkandknife.svg',
              ischecked: false,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.toNamed('/nscbuildingmap');
            },
            child: ScrollRowContainer(
              text: '카페'.tr,
              svgPath: 'assets/tossface/toss_coffee.svg',
              ischecked: false,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.toNamed('/lostandfound');
            },
            child: ScrollRowContainer(
              text: '술집'.tr,
              svgPath: 'assets/tossface/toss_beer.svg',
              ischecked: false,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.toNamed('/lostandfound');
            },
            child: ScrollRowContainer(
              text: '새로오픈'.tr,
              svgPath: 'assets/tossface/toss_arrow2_up.svg',
              ischecked: false,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.toNamed('/lostandfound');
            },
            child: ScrollRowContainer(
              text: '더보기'.tr,
              svgPath: 'assets/tossface/toss_plus.svg',
              ischecked: false,
            ),
          ),
        ],
      ),
    );
  }
}
