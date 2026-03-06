import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';
import 'package:skkumap/app/pages/bus_realtime/controller/bus_realtime_controller.dart';
import 'package:skkumap/app/routes/app_routes.dart';
import 'package:skkumap/app/utils/ad_widget.dart';
import 'package:skkumap/app_theme.dart';

import 'package:skkumap/app/components/NavigationBar/custom_navigation.dart';
import 'package:skkumap/app/components/bus/buslist_component.dart';
import 'package:skkumap/app/components/bus/refresh_button.dart';
import 'package:skkumap/app/model/bus_route_config.dart';
import 'package:skkumap/app/components/bus/topinfo.dart';

import 'package:skkumap/app/types/bus_status.dart';
import 'package:skkumap/app/types/time_format.dart';
import 'package:skkumap/app/components/bus/businfo_component.dart';
import 'package:skkumap/app/model/main_bus_location.dart';

import 'package:shimmer/shimmer.dart';
import 'package:skkumap/app/utils/screensize.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skkumap/app/data/repositories/ad_repository.dart';

class BusRealtimeScreen extends GetView<BusRealtimeController> {
  const BusRealtimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ScreenSize.width(context);
    final BusRouteConfig routeConfig = Get.arguments['busConfig'];
    controller.setRouteConfig(routeConfig);
    final themeColor = routeConfig.display.themeColor;

    return Scaffold(
      // floating action button
      floatingActionButton: RefreshButton(
          themeColor: themeColor,
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
                                  Get.find<AdRepository>().trackEvent('bus_bottom', 'click');
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
          backgroundColor: themeColor,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // 상단 커스텀 내비게이션 바
          CustomNavigationBar(
            title: routeConfig.display.name,
            backgroundColor: themeColor,
            isDisplayLeftBtn: true,
            isDisplayRightBtn: routeConfig.features.info != null,
            leftBtnAction: () {
              Get.back();
            },
            rightBtnAction: () {
              final infoUrl = routeConfig.features.info?.url;
              if (infoUrl != null) {
                Get.toNamed(Routes.webview, arguments: {
                  'title': routeConfig.display.name,
                  'color': routeConfig.display.themeColor.value
                      .toRadixString(16)
                      .substring(2),
                  'webviewLink': infoUrl,
                });
              }
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
                                    themeColor: themeColor,
                                    transferLines: station.transferLines,
                                  );
                                } else {
                                  return const SizedBox
                                      .shrink();
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
                            themeColor: themeColor,
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
