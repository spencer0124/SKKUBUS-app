import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/pages/mainpage/ui/snappingsheet/option_campus.dart';
import 'package:skkumap/app/pages/mainpage/ui/snappingsheet/option_around.dart';

import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:skkumap/app/components/mainpage/bottom/bottomnavigation.dart';

import '../controller/snappingsheet_controller.dart';
import 'snappingsheet/option_bus.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/grabbing_box.dart';
import 'package:skkumap/app/pages/mainpage/ui/maingpage_background.dart';
import 'package:skkumap/app/utils/screensize.dart';

class Mainpage extends GetView<MainpageController> {
  const Mainpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);
    final ScrollController sheetChildScrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size(0, 0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SnappingSheet(
            controller: snappingSheetController,
            onSheetMoved: (sheetPosition) {
              final isExpanded = sheetPosition.pixels > screenHeight * 0.7;
              controller.snappingSheetIsExpanded.value = isExpanded;
            },
            onSnapCompleted: (sheetPosition, snappingPosition) {
              // checkCurrentPosition(screenHeight, sheetPosition, snappingPosition);
            },
            lockOverflowDrag: true,
            snappingPositions: getSnappingPositions(),
            grabbingHeight: grabbingHeight,
            grabbing: const GrabbingBox(),
            sheetBelow: SnappingSheetContent(
                childScrollController: sheetChildScrollController,
                draggable: true,
                // snappingsheet에 어떤 child가 들어갈지 결정
                child: Obx(
                  () {
                    return _getSnappingSheetContent(
                        controller.bottomNavigationIndex.value,
                        sheetChildScrollController,
                        controller.snappingSheetIsExpanded.value);
                  },
                )),
            child: const MainPageBackground(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () {
                return Bottomnavigation(
                  index: controller.bottomNavigationIndex.value,
                  onItemTapped: (int index) {
                    controller.bottomNavigationIndex.value = index;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget _getSnappingSheetContent(
    int index, ScrollController scrollController, bool scrollEnabled) {
  final physics = scrollEnabled
      ? const ClampingScrollPhysics()
      : const NeverScrollableScrollPhysics();

  switch (index) {
    case 0:
      return SingleChildScrollView(
        controller: scrollController,
        physics: physics,
        padding: EdgeInsets.zero,
        child: Column(
          children: [OptionAround()],
        ),
      );
    case 1:
      return SingleChildScrollView(
        controller: scrollController,
        physics: physics,
        padding: EdgeInsets.zero,
        child: Column(
          children: [OptionCampus()],
        ),
      );
    case 2:
      return OptionCampus();
    default:
      return OptionBus(); // Default case
  }
}
