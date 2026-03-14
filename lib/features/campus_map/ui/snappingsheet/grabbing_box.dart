import 'package:flutter/material.dart';
import 'package:skkumap/features/campus_map/controller/snappingsheet_controller.dart';
import 'package:skkumap/core/utils/screensize.dart';

class GrabbingBox extends StatelessWidget {
  const GrabbingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);

    return Container(
      height: grabbingHeight,
      width: screenWidth,
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 2,
              color: Colors.white,
              offset: Offset(0, 10),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
