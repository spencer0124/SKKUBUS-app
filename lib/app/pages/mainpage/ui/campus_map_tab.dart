import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/pages/mainpage/controller/snappingsheet_controller.dart';
import 'package:skkumap/app/pages/mainpage/ui/snappingsheet/option_campus.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/grabbing_box.dart';
import 'package:skkumap/app/pages/mainpage/ui/maingpage_background.dart';
import 'package:skkumap/app/utils/screensize.dart';

class CampusMapTab extends StatelessWidget {
  const CampusMapTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final controller = Get.find<MainpageController>();
    final ScrollController sheetChildScrollController = ScrollController();

    return SnappingSheet(
      controller: snappingSheetController,
      onSheetMoved: (sheetPosition) {
        final isExpanded = sheetPosition.pixels > screenHeight * 0.7;
        controller.snappingSheetIsExpanded.value = isExpanded;
      },
      lockOverflowDrag: true,
      snappingPositions: getSnappingPositions(),
      grabbingHeight: grabbingHeight,
      grabbing: const GrabbingBox(),
      sheetBelow: SnappingSheetContent(
        childScrollController: sheetChildScrollController,
        draggable: true,
        child: Obx(() {
          final scrollEnabled = controller.snappingSheetIsExpanded.value;
          final physics = scrollEnabled
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics();
          return SingleChildScrollView(
            controller: sheetChildScrollController,
            physics: physics,
            padding: EdgeInsets.zero,
            child: Column(
              children: [OptionCampus()],
            ),
          );
        }),
      ),
      child: const MainPageBackground(),
    );
  }
}
