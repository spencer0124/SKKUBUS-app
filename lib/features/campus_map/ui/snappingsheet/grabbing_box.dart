import 'package:flutter/material.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/features/campus_map/controller/snappingsheet_controller.dart';
import 'package:skkumap/core/utils/screensize.dart';

class GrabbingBox extends StatelessWidget {
  const GrabbingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: grabbingHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -1,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
