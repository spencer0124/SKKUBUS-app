import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:skkumap/features/building_map/nsc/controller/nsc_building_map_controller.dart';
import 'package:skkumap/core/routes/app_routes.dart';

import 'package:skkumap/core/widgets/custom_navigation.dart';
import 'package:skkumap/core/utils/screensize.dart';

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
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          CustomNavigationBar(
            title: '자과캠 건물지도'.tr,
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: () {
              Get.back();
            },
            rightBtnAction: () {
              Get.toNamed(Routes.mapNscCredit);
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
