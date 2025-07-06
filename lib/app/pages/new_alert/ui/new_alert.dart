import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// late SharedPreferences prefs;

// 여기는 lifecycle 그거 설정안해줬다는 거 주의하기

class NewAlert extends StatelessWidget {
  const NewAlert({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10331a),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   alignment: Alignment.topCenter,
              //   color: AppColors.green_main,
              //   // color: Colors.red,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              //     child: GestureDetector(
              //       onTap: () {
              //         Get.toNamed('/busData');
              //       },
              //       child: const Text(
              //         '새로운 기능 알림',
              //         style: TextStyle(
              //           fontSize: 20,
              //           color: Colors.white,
              //           fontFamily: 'WantedSansBold',
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 120.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/eskara1398.png',
                    width: 360.w,
                  ),
                ],
              ),

              SizedBox(
                height: 40.h,
              ),
              const Text(
                '에스카라 인자셔틀 정보를 추가했어요',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WantedSansBold',
                    fontSize: 16),
                textAlign: TextAlign.start,
              ),

              const Text(
                '화면 상단의 \'에스카라 인자셔틀\'을 클릭해보세요',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WantedSansBold',
                    fontSize: 16),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 38.h,
            child: Image.asset(
              'assets/newalert_iphone1.png',
              height: 400.h,
            ),
          ),
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 38.h,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('newalertdone', true);
                FirebaseAnalytics.instance.logEvent(
                  name: 'newalert_nextclicked',
                );
                Get.toNamed('/busData');
                Get.toNamed('/eskara');
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Text(
                  '지금 확인해보기',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'WantedSansBold',
                      fontSize: 14),
                  // textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
