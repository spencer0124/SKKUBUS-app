import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app/pages/mainpage/ui/snappingsheet/option_bus.dart';

// '주변' 탭

class OptionAround extends StatelessWidget {
  OptionAround({Key? key}) : super(key: key);

  final controller = Get.find<MainpageController>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);
    final double screenHeight = ScreenSize.height(context);

    return Container(
      color: Colors.white,
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenHeight * 0.9),
      child: const SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            // Text("hi"),
            // 여기서부터 메인 컨텐츠 화면
          ],
        ),
      ),
    );
  }
}
