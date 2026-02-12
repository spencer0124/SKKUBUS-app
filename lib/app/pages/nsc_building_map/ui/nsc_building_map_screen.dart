import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:skkumap/app/pages/nsc_building_map/controller/nsc_building_map_controller.dart';

import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:skkumap/app/utils/screensize.dart';

class NSCBuildingMap extends StatelessWidget {
  const NSCBuildingMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);

    final controller = Get.find<NSCBuildingMapController>();
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
            title: '자과캠 건물지도'.tr,
            backgroundColor: AppColors.green_main,
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: () {
              Get.back();
            },
            rightBtnAction: () {
              Get.toNamed('/nscbuildingcredit');
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
    );
  }
}
