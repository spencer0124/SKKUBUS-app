import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap_controller.dart';
import 'package:skkumap/app/utils/screensize.dart';

/// SnappingSheet의 배경을 담당하는 위젯입니다.
/// Naver 지도와 그 위에 표시되는 검색창, 버튼 등의 UI 요소를 포함합니다.
/// 현재 선택된 하단 네비게이션 탭에 따라 UI가 동적으로 변경됩니다.
class MainPageBackground extends GetView<MainpageController> {
  const MainPageBackground({Key? key}) : super(key: key);

  /// '캠퍼스' 탭(index 1)에서 보일 대학교 선택 UI를 생성합니다.
  Widget _buildCampusSelector(BuildContext context, var statusBarHeight) {
    return Column(
      children: [
        Container(
          height: statusBarHeight,
          width: double.infinity,
          color: Colors.white,
        ),
        GestureDetector(
          onTap: () {
            print("대학교 선택창 탭됨");
          },
          child: Container(
            // height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(25.0),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     blurRadius: 5,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // TODO: 컨트롤러에서 현재 선택된 캠퍼스 이름 가져오기
                const Text(
                  '성균관대학교 (인사캠)',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'WantedSansBold',
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(
                  "assets/tossface/toss_arrow_down.svg",
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Container(height: 10, color: Colors.white),
      ],
    );
  }

  /// '버스' 탭(index 2)에서 보일 UI 예시를 생성합니다.
  Widget _buildBusInfo(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '실시간 버스 정보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  /// `bottomNavigationIndex`에 따라 지도 위에 표시될 위젯 목록을 반환합니다.
  List<Widget> _buildTopOverlay(
    BuildContext context,
    int index,
    double statusBarHeight,
  ) {
    switch (index) {
      case 0: // '주변' 탭
        return [
          // Positioned(
          //   left: 15,
          //   right: 15,
          //   top: statusBarHeight + 10,
          //   child: const CustomSearchBar(),
          // ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   top: statusBarHeight + 10 + 60, // 검색창 아래에 위치
          //   child: const Center(child: ScrollableRow()),
          // ),
        ];
      case 1: // '캠퍼스' 탭
        return [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: _buildCampusSelector(context, statusBarHeight),
          ),
        ];
      case 2: // '버스' 탭
        return [
          Positioned(
            left: 15,
            right: 15,
            top: statusBarHeight + 10,
            child: _buildBusInfo(context),
          ),
        ];
      default: // 기본값 (아무것도 표시하지 않음)
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);
    final double statusBarHeight = ScreenSize.statusBarHeight(context);
    final ultimateController = Get.find<UltimateNMapController>();

    return Obx(() {
      final int currentIndex = controller.bottomNavigationIndex.value;

      // 현재 탭에 따라 현재 위치 버튼의 상단 여백을 계산합니다.
      double locationButtonTop;
      switch (currentIndex) {
        case 0:
          locationButtonTop = statusBarHeight + 10 + 105; // 검색창 + 스크롤 열 아래
          break;
        case 1:
        case 2:
          locationButtonTop = statusBarHeight + 10 + 65; // 상단 위젯 아래
          break;
        default:
          locationButtonTop = statusBarHeight + 10;
      }

      return Stack(
        children: [
          // Naver 지도는 항상 배경에 표시됩니다.
          SizedBox(
            height: screenHeight - 47,
            width: screenWidth,
            child: buildMap(), // navermap.dart에 정의된 함수로 가정
          ),

          // 현재 탭에 맞는 상단 UI 요소를 동적으로 추가합니다.
          ..._buildTopOverlay(context, currentIndex, statusBarHeight),

          // 현재 위치로 이동하는 버튼
          Positioned(
            top: locationButtonTop,
            right: 15,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                ultimateController.moveToCurrentLocation();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.my_location, color: Colors.black54),
              ),
            ),
          ),
        ],
      );
    });
  }
}
