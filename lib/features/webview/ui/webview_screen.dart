import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:skkumap/features/webview/controller/webview_controller.dart';

import 'package:skkumap/core/widgets/custom_navigation.dart';
import 'package:skkumap/core/utils/screensize.dart';
import 'package:skkumap/core/utils/app_logger.dart';

class CustomWebViewScreen extends StatelessWidget {
  const CustomWebViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pageTitle = Get.arguments['title'];
    final String pageColor = Get.arguments['color'];
    final String pageWebviewLink = Get.arguments['webviewLink'];

    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);

    final controller = Get.find<CustomWebViewController>();
    controller.initializeWebView(pageWebviewLink);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        //didPop == true , 뒤로가기 제스쳐가 감지되면 호출 된다.
        if (didPop) {
          logger.d('didPop호출');
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Color(int.parse("0xFF$pageColor")),
            elevation: 0,
          ),
        ),
        body: Column(
          children: [
            CustomNavigationBar(
              title: pageTitle,
              backgroundColor: Color(int.parse("0xFF$pageColor")),
              isDisplayLeftBtn: true,
              isDisplayRightBtn: false,
              leftBtnAction: () {
                Get.back();
              },
              rightBtnAction: () {},
              rightBtnType: CustomNavigationBtnType.info,
            ),
            Expanded(
              // width: screenWidth,
              // height: screenHeight * 0.82,
              child: WebViewWidget(controller: controller.webcontroller),
            ),
          ],
        ),
      ),
    );
  }
}
