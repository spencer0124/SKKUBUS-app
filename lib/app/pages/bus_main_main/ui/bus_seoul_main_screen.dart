import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';
import 'package:skkumap/app/pages/bus_main_main/controller/bus_seoul_main_controller.dart';
import 'package:skkumap/app/utils/ad_widget.dart';
import 'package:skkumap/app_theme.dart';

import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:skkumap/app/components/bus/buslist_component.dart';
import 'package:skkumap/app/components/bus/refresh_button.dart';
// import 'package:skkumap/app/utils/screensize.dart';
import 'package:skkumap/app/types/bus_type.dart';
import 'package:skkumap/app/components/bus/topinfo.dart';

import 'package:skkumap/app/types/bus_status.dart';
import 'package:skkumap/app/types/time_format.dart';
import 'package:skkumap/app/components/bus/businfo_component.dart';
import 'package:skkumap/app/model/main_bus_location.dart';

import 'package:skkumap/app/types/bus_type.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skkumap/app/utils/api_fetch/fetch_ad.dart';

class BusDataScreen extends GetView<BusDataController> {
  const BusDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);
    // final double screenHeight = ScreenSize.height(context);
    // final double screenWidth = ScreenSize.width(context);
    controller.setBusType(Get.arguments['bustype']);
    // controller.busType = Get.arguments['bustype'];
    final BusType busType = Get.arguments['bustype'];
    // controller.busType = busType;

    return Scaffold(
      // floating action button
      floatingActionButton: RefreshButton(
          busType: busType,
          onRefresh: () {
            controller.localfetchBusLocation();
            controller.localfetchBusStations();
          }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],

        // 화면 하단 광고
        child: Obx(
          () => controller.isBannerAdLoaded.value
              ? ((controller.belowAdImage.value) != '')
                  ? SizedBox(
                      height: 55,
                      child: (controller.belowAdImage.value) != ''
                          ? GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                if (await canLaunchUrl(
                                    Uri.parse(controller.belowAdLink.value))) {
                                  await launchUrl(
                                      Uri.parse(controller.belowAdLink.value));
                                  trackAdEvent('bus_bottom', 'click');
                                } else {
                                  Get.snackbar('오류', '해당 링크를 열 수 없습니다.');
                                }
                              },
                              child:
                                  Image.network(controller.belowAdImage.value))
                          : Shimmer.fromColors(
                              baseColor: Colors.grey[100]!,
                              highlightColor: Colors.white,
                              child: Container(
                                width: screenWidth * 0.75,
                                height: 20,
                                color: Colors.grey,
                              ),
                            ))
                  : SizedBox(
                      height: 55,
                      child: AdWidgetContainer(
                        bannerAd: controller.bannerAd,
                      ),
                    )
              : Container(
                  height: 55,
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: busType.color,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // 상단 커스텀 내비게이션 바
          CustomNavigationBar(
            title: busType.title.tr,
            backgroundColor: busType.color,
            isDisplayLeftBtn: true,
            isDisplayRightBtn: busType == BusType.hsscBus ? true : false,
            leftBtnAction: () {
              Get.back();
            },
            rightBtnAction: () {
              Get.toNamed('/MainbusDetail');
            },
            rightBtnType: CustomNavigationBtnType.info,
          ),

          // 상단 정보 부분
          Container(
            height: 0.5,
            color: Colors.grey[300],
          ),
          Obx(() {
            return TopInfo(
              isLoaded: true,
              currentTime:
                  controller.mainBusStationList.value?.metadata.currentTime ??
                      '00:00 AM',
              timeFormat: TimeFormat.format12Hour,
              busCount:
                  controller.mainBusStationList.value?.metadata.totalBuses ?? 0,
              busStatus:
                  (controller.mainBusStationList.value?.metadata.totalBuses ??
                              0) >
                          0
                      ? BusStatus.active
                      : BusStatus.inactive,
            );
          }),
          Container(
            height: 0.5,
            color: Colors.grey[300],
          ),

          // 버스 정보 부분
          Obx(() {
            return Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Stack(
                  children: [
                    Obx(
                      () {
                        if (controller.loadingdone.value == false) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.green_main,
                            ),
                          );
                        }
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller
                                  .mainBusStationList.value?.stations.length,
                              itemBuilder: (context, index) {
                                final station = controller
                                    .mainBusStationList.value?.stations[index];
                                if (station != null) {
                                  return BusListComponent(
                                    stationName: station.stationName,
                                    stationNumber: station.stationNumber,
                                    eta: station.eta,
                                    isFirstStation: station.isFirstStation,
                                    isLastStation: station.isLastStation,
                                    isRotationStation:
                                        station.isRotationStation,
                                    busType: busType,
                                  );
                                } else {
                                  return const SizedBox
                                      .shrink(); // Return an empty widget if station is null
                                }
                              },
                            ),
                            const SizedBox(
                              height: 55,
                            )
                          ],
                        );
                      },
                    ),
                    // 번호판 && 버스 현재 위치 정보 부분
                    ...controller.mainBusLocation.value.asMap().entries.map(
                          (e) => BusInfoComponent(
                            elapsedSeconds: e.value.estimatedTime,
                            currentStationIndex:
                                int.parse(e.value.sequence) - 1,
                            lastStationIndex: controller.mainBusStationList
                                    .value?.metadata.lastStationIndex ??
                                10,
                            plateNumber: e.value.carNumber,
                            busType: busType,
                            onDataUpdated: (Function callback) {
                              callback();
                            },
                          ),
                        )
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
