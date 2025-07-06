import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScrollRowContainer extends StatelessWidget {
  final String text;
  final String svgPath;

  final Color color;
  final bool ischecked;

  const ScrollRowContainer({
    Key? key,
    required this.text,
    required this.svgPath,
    required this.ischecked,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 30.h,
      decoration: BoxDecoration(
        color: ischecked ? null : color,
        gradient: ischecked
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // Color(0xFF97fdac),
                  Color(0xFF6feaa7),
                  Color(0xFF32cda1),
                  Color(0xFF13be9e),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(25.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //     offset: const Offset(0, 1),
        //   ),
        // ],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(svgPath,
              // color: ischecked ? Colors.white : Colors.black,
              height: 15.sp,
              width: 15.sp),
          // Icon(icon,
          //     color: ischecked ? Colors.white : Colors.black, size: 15.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: ischecked ? Colors.white : Colors.black,
              fontFamily: 'WantedSansMedium',
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
