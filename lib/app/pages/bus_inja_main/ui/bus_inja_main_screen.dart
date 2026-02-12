import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/components/mainpage/middle_snappingsheet/stationrow.dart';
import 'package:skkumap/app/pages/bus_inja_main/controller/bus_inja_main_controller.dart';
import 'package:skkumap/app_theme.dart';

import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app/utils/constants.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:skkumap/app/components/liveactivitiy/liveactivity_bus_eta.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

// Map deep links using centralized coordinates
final Uri seoulCampusMapNaver = Uri.parse(
  'nmap://route/public?dlat=${CampusCoordinates.seoulCampusLat}&dlng=${CampusCoordinates.seoulCampusLon}&dname=${CampusCoordinates.seoulCampusDestnameEncode}',
);
final Uri seoulCampusMapKakao = Uri.parse(
  'kakaomap://route?ep=${CampusCoordinates.seoulCampusLat},${CampusCoordinates.seoulCampusLon}&by=PUBLICTRANSIT&eName=${CampusCoordinates.seoulCampusDestnameEncode}',
);
final Uri seoulCampusMapApple = Uri.parse(
  'maps://?t=r&daddr=${CampusCoordinates.seoulCampusLat},${CampusCoordinates.seoulCampusLon}&dirflg=2',
);

final Uri suwonCampusMapNaver = Uri.parse(
  'nmap://route/public?dlat=${CampusCoordinates.suwonCampusLat}&dlng=${CampusCoordinates.suwonCampusLon}&dname=${CampusCoordinates.suwonCampusDestnameEncode}',
);
final Uri suwonCampusMapKakao = Uri.parse(
  'kakaomap://route?ep=${CampusCoordinates.suwonCampusLat},${CampusCoordinates.suwonCampusLon}&by=PUBLICTRANSIT&eName=${CampusCoordinates.suwonCampusDestnameEncode}',
);
final Uri suwonCampusMapApple = Uri.parse(
  'maps://?t=r&daddr=${CampusCoordinates.suwonCampusLat},${CampusCoordinates.suwonCampusLon}&dirflg=2',
);

final Uri seoulMapNaver = Uri.parse(
  'nmap://route/walk?dlat=${CampusCoordinates.seoulShuttleLat}&dlng=${CampusCoordinates.seoulShuttleLon}&dname=${CampusCoordinates.seoulShuttleDestnameEncode}',
);
final Uri seoulMapKakao = Uri.parse(
  'kakaomap://route?ep=${CampusCoordinates.seoulShuttleLat},${CampusCoordinates.seoulShuttleLon}&by=FOOT&eName=${CampusCoordinates.seoulShuttleDestnameEncode}',
);
final Uri seoulMapApple = Uri.parse(
  'maps://?t=m&daddr=${CampusCoordinates.seoulShuttleLat},${CampusCoordinates.seoulShuttleLon}',
);

final Uri suwonMapNaver = Uri.parse(
  'nmap://route/walk?dlat=${CampusCoordinates.suwonShuttleLat}&dlng=${CampusCoordinates.suwonShuttleLon}&dname=${CampusCoordinates.suwonShuttleDestnameEncode}',
);
final Uri suwonMapKakao = Uri.parse(
  'kakaomap://route?ep=${CampusCoordinates.suwonShuttleLat},${CampusCoordinates.suwonShuttleLon}&by=FOOT&eName=${CampusCoordinates.suwonShuttleDestnameEncode}',
);
final Uri suwonMapApple = Uri.parse(
  'maps://?t=m&daddr=${CampusCoordinates.suwonShuttleLat},${CampusCoordinates.suwonShuttleLon}',
);

final seoulMarker = NMarker(
  id: 'seoul_marker',
  position: const NLatLng(
      CampusCoordinates.seoulShuttleLat, CampusCoordinates.seoulShuttleLon),
);
const seoulCameraPosition = NCameraPosition(
  target: NLatLng(
      CampusCoordinates.seoulShuttleLat, CampusCoordinates.seoulShuttleLon),
  zoom: 15,
  bearing: 45,
  tilt: 30,
);

final suwonMarker = NMarker(
  id: 'suwon_marker',
  position: const NLatLng(
      CampusCoordinates.suwonShuttleLat, CampusCoordinates.suwonShuttleLon),
);
const suwonCameraPosition = NCameraPosition(
  target: NLatLng(
      CampusCoordinates.suwonShuttleLat, CampusCoordinates.suwonShuttleLon),
  zoom: 15,
  bearing: 45,
  tilt: 30,
);

class ESKARA extends StatelessWidget {
  const ESKARA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = ScreenSize.height(context);
    final double screenWidth = ScreenSize.width(context);
    final controller = Get.find<InjaMainController>();
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
            title: '인자셔틀'.tr,
            backgroundColor: AppColors.green_main,
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: () {
              Get.back();
            },
            rightBtnAction: () {
              Get.toNamed('/injadetail');
            },
            rightBtnType: CustomNavigationBtnType.info,
          ),
          Container(height: 0.5, color: Colors.grey[300]),
          Container(height: 0.5, color: Colors.grey[300]),
          Container(height: 0.5, color: Colors.grey[300]),
          Container(
            height: 30,
            color: Colors.grey[100],
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                // 현재 날짜
                // Text(
                //   "2025-04-27", // 자동으로 업데이트 되는 날짜
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey[800],
                //   ),
                // ),
                // const SizedBox(width: 3),
                // Text(
                //   "일", // 자동으로 업데이트 되는 요일
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey[800],
                //   ),
                // ),
                const Spacer(),

                // 날짜 선택
                Obx(
                  () => Container(
                    alignment: Alignment.centerRight,
                    width: 150,
                    height: 50,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: controller.selectedDay.value,
                        onChanged: (String? value) {
                          controller.selectedDay.value = value;

                          controller.selectedEnglishDay =
                              controller
                                  .translateDayToEnglish(
                                    controller.selectedDay.value ?? '월요일',
                                  )
                                  .obs;
                          controller.fetchinjaBusSchedule(
                            controller.selectedEnglishDay.value ?? 'monday',
                          );
                          controller.fetchjainBusSchedule(
                            controller.selectedEnglishDay.value ?? 'monday',
                          );
                        },
                        hint: Text(
                          '요일 선택'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                        items:
                            controller.dateitems
                                .map(
                                  (String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      "${item.tr} ${"시간표".tr}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Scrollbar(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 3, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            const SizedBox(width: 5),
                            Text(
                              '${'인자셔틀'.tr} ${'[인사캠 → 자과캠]'.tr}',
                              style: const TextStyle(
                                color: AppColors.green_main,
                                fontFamily: 'WantedSansBold',
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            // InkWell(
                            //   onTap: () {
                            //     print("승하차 장소 클릭됨");
                            //     print("네이버지도: $seoulCampusMapNaver");
                            //     print("카카오맵: $seoulCampusMapKakao");
                            //     print("애플지도: $seoulCampusMapApple");
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.place_rounded,
                            //           color: Colors.grey[800], size: 15),
                            //       const SizedBox(width: 1),
                            //       Text(
                            //         '승하차 장소',
                            //         style: TextStyle(
                            //           color: Colors.grey[800],
                            //           fontFamily: 'WantedSansBold',
                            //         ),
                            //         textAlign: TextAlign.start,
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                        // const SizedBox(
                        //   height: 18,
                        // ),
                        // Row(
                        //   children: [
                        //     // live activity bus eta
                        //     LiveActivityBusETA(
                        //       screenWidth: MediaQuery.of(context).size.width,
                        //       title: '인사캠 → 자과캠 셔틀',
                        //       duration: '1시간 30분',
                        //       distance: '131.1km',
                        //       timeRange: '17:00 ~ 18:30',
                        //       isAvailable: false,
                        //     ),

                        //     const Spacer(),

                        //     InkWell(
                        //       onTap: () async {
                        //         var result =
                        //             await FlutterPlatformAlert.showCustomAlert(
                        //           windowTitle: "대중교통 길찾기",
                        //           text: "원하는 지도 앱을 선택해주세요",
                        //           positiveButtonTitle: "네이버지도",
                        //           neutralButtonTitle: "카카오맵",
                        //           negativeButtonTitle: "애플지도",
                        //         );

                        //         // 네이버지도 선택
                        //         if (result == CustomButton.positiveButton) {
                        //           controller.executeMap(
                        //               type: 'seoul',
                        //               mapNameEn: 'naver_map',
                        //               mapNameKr: '네이버 지도',
                        //               mapUri: seoulCampusMapNaver,
                        //               playStoreLink:
                        //                   'https://play.google.com/store/apps/details?id=com.nhn.android.nmap&hl=ko&gl=US',
                        //               appStoreLink:
                        //                   'https://apps.apple.com/kr/app/naver-map-navigation/id311867728?l=en-GB');
                        //         }
                        //         // 카카오맵 선택
                        //         else if (result == CustomButton.neutralButton) {
                        //           controller.executeMap(
                        //               type: 'seoul',
                        //               mapNameEn: 'kakao_map',
                        //               mapNameKr: '카카오맵',
                        //               mapUri: seoulCampusMapKakao,
                        //               playStoreLink:
                        //                   'https://play.google.com/store/apps/details?id=net.daum.android.map&hl=ko&gl=US',
                        //               appStoreLink:
                        //                   'https://apps.apple.com/kr/app/kakaomap-korea-no-1-map/id304608425?l=en-GB');
                        //         } else {
                        //           controller.executeMap(
                        //               type: 'seoul',
                        //               mapNameEn: 'apple_map',
                        //               mapNameKr: '애플 지도',
                        //               mapUri: seoulCampusMapApple,
                        //               playStoreLink:
                        //                   'https://apps.apple.com/kr/app/maps/id915056765?l=en-GB',
                        //               appStoreLink:
                        //                   'https://apps.apple.com/kr/app/maps/id915056765?l=en-GB');
                        //         }
                        //       },
                        //       child: LiveActivityBusETA(
                        //         screenWidth: MediaQuery.of(context).size.width,
                        //         title: '대중교통',
                        //         duration: '1시간 32분',
                        //         distance: '150.1km',
                        //         timeRange: '15:00 ~ 16:32',
                        //         isAvailable: true,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                          child: Obx(() {
                            return DataTable(
                              columnSpacing: 35,
                              columns: [
                                DataColumn(label: Text('운영시간'.tr)),
                                DataColumn(label: Text('운영대수'.tr)),
                                DataColumn(label: Text('특이사항'.tr)),
                              ],
                              rows:
                                  controller.injaBusSchedule.map((schedule) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              const SizedBox(width: 5),
                                              Text(
                                                schedule.operatingHours,
                                                style: TextStyle(
                                                  fontWeight:
                                                      (schedule.isFastestBus &&
                                                              controller
                                                                      .selectedDay ==
                                                                  controller
                                                                      .today)
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  color:
                                                      (schedule.isFastestBus &&
                                                              controller
                                                                      .selectedDay ==
                                                                  controller
                                                                      .today)
                                                          ? AppColors.green_main
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              const SizedBox(width: 15),
                                              Text(
                                                schedule.busCount.toString(),
                                                style: TextStyle(
                                                  fontWeight:
                                                      (schedule.isFastestBus &&
                                                              controller
                                                                      .selectedDay ==
                                                                  controller
                                                                      .today)
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  color:
                                                      (schedule.isFastestBus &&
                                                              controller
                                                                      .selectedDay ==
                                                                  controller
                                                                      .today)
                                                          ? AppColors.green_main
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            schedule.specialNotes?.replaceAll(
                                                  r'\n',
                                                  '\n',
                                                ) ??
                                                ' ',
                                            style: TextStyle(
                                              fontWeight:
                                                  (schedule.isFastestBus &&
                                                          controller
                                                                  .selectedDay ==
                                                              controller.today)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color:
                                                  (schedule.isFastestBus &&
                                                          controller
                                                                  .selectedDay ==
                                                              controller.today)
                                                      ? AppColors.green_main
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 3, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Divider(color: Colors.grey[300]),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 5),
                            Text(
                              '${'자인셔틀'.tr} ${'[자과캠 → 인사캠]'.tr}',
                              style: const TextStyle(
                                color: AppColors.green_main,
                                fontFamily: 'WantedSansBold',
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            // InkWell(
                            //   onTap: () {
                            //     print("자인 승하차 장소 클릭됨");
                            //     print("네이버지도: $suwonCampusMapNaver");
                            //     print("카카오맵: $suwonCampusMapKakao");
                            //     print("애플지도: $suwonCampusMapApple");
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.place_rounded,
                            //           color: Colors.grey[800], size: 15),
                            //       const SizedBox(width: 1),
                            //       Text(
                            //         '승하차 장소',
                            //         style: TextStyle(
                            //           color: Colors.grey[800],
                            //           fontFamily: 'WantedSansBold',
                            //         ),
                            //         textAlign: TextAlign.start,
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   children: [
                        //     // live activity bus eta
                        //     LiveActivityBusETA(
                        //       screenWidth: MediaQuery.of(context).size.width,
                        //       title: '인사캠 → 자과캠 셔틀',
                        //       duration: '1시간 30분',
                        //       distance: '131.1km',
                        //       timeRange: '17:00 ~ 18:30',
                        //       isAvailable: false,
                        //     ),

                        //     const Spacer(),

                        //     InkWell(
                        //       onTap: () async {
                        //         var result =
                        //             await FlutterPlatformAlert.showCustomAlert(
                        //           windowTitle: "대중교통 길찾기",
                        //           text: "원하는 지도 앱을 선택해주세요",
                        //           positiveButtonTitle: "네이버지도",
                        //           neutralButtonTitle: "카카오맵",
                        //           negativeButtonTitle: "애플지도",
                        //         );

                        //         // 네이버지도 선택
                        //         if (result == CustomButton.positiveButton) {
                        //           controller.executeMap(
                        //               type: 'seoul',
                        //               mapNameEn: 'naver_map',
                        //               mapNameKr: '네이버 지도',
                        //               mapUri: suwonCampusMapNaver,
                        //               playStoreLink:
                        //                   'https://play.google.com/store/apps/details?id=com.nhn.android.nmap&hl=ko&gl=US',
                        //               appStoreLink:
                        //                   'https://apps.apple.com/kr/app/naver-map-navigation/id311867728?l=en-GB');
                        //         }
                        //         // 카카오맵 선택
                        //         else if (result == CustomButton.neutralButton) {
                        //           controller.executeMap(
                        //               type: 'seoul',
                        //               mapNameEn: 'kakao_map',
                        //               mapNameKr: '카카오맵',
                        //               mapUri: suwonCampusMapKakao,
                        //               playStoreLink:
                        //                   'https://play.google.com/store/apps/details?id=net.daum.android.map&hl=ko&gl=US',
                        //               appStoreLink:
                        //                   'https://apps.apple.com/kr/app/kakaomap-korea-no-1-map/id304608425?l=en-GB');
                        //         } else {
                        //           controller.executeMap(
                        //               type: 'seoul',
                        //               mapNameEn: 'apple_map',
                        //               mapNameKr: '애플 지도',
                        //               mapUri: suwonCampusMapApple,
                        //               playStoreLink:
                        //                   'https://apps.apple.com/kr/app/maps/id915056765?l=en-GB',
                        //               appStoreLink:
                        //                   'https://apps.apple.com/kr/app/maps/id915056765?l=en-GB');
                        //         }
                        //       },
                        //       child: LiveActivityBusETA(
                        //         screenWidth: MediaQuery.of(context).size.width,
                        //         title: '대중교통',
                        //         duration: '1시간 32분',
                        //         distance: '150.1km',
                        //         timeRange: '15:00 ~ 16:32',
                        //         isAvailable: true,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 3, 20, 0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                      child: Obx(() {
                        return DataTable(
                          columnSpacing: 35,
                          columns: [
                            DataColumn(label: Text('운영시간'.tr)),
                            DataColumn(label: Text('운영대수'.tr)),
                            DataColumn(label: Text('특이사항'.tr)),
                          ],
                          rows:
                              controller.jainBusSchedule.map((schedule) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          const SizedBox(width: 5),
                                          Text(
                                            schedule.operatingHours,
                                            style: TextStyle(
                                              fontWeight:
                                                  (schedule.isFastestBus &&
                                                          controller
                                                                  .selectedDay ==
                                                              controller.today)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color:
                                                  (schedule.isFastestBus &&
                                                          controller
                                                                  .selectedDay ==
                                                              controller.today)
                                                      ? AppColors.green_main
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          Text(
                                            schedule.busCount.toString(),
                                            style: TextStyle(
                                              fontWeight:
                                                  (schedule.isFastestBus &&
                                                          controller
                                                                  .selectedDay ==
                                                              controller.today)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color:
                                                  (schedule.isFastestBus &&
                                                          controller
                                                                  .selectedDay ==
                                                              controller.today)
                                                      ? AppColors.green_main
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        child: Text(
                                          schedule.specialNotes?.replaceAll(
                                                r'\n',
                                                '\n',
                                              ) ??
                                              ' ',
                                          style: TextStyle(
                                            fontWeight:
                                                (schedule.isFastestBus &&
                                                        controller
                                                                .selectedDay ==
                                                            controller.today)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                (schedule.isFastestBus &&
                                                        controller
                                                                .selectedDay ==
                                                            controller.today)
                                                    ? AppColors.green_main
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
