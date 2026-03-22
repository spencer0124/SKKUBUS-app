import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/features/transit/controller/bus_realtime_controller.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/core/services/ad_service.dart';
import 'package:skkumap/core/utils/ad_widget.dart';
import 'package:skkumap/app_theme.dart';

import 'package:skkumap/core/widgets/custom_navigation.dart';
import 'package:skkumap/features/transit/widgets/buslist_component.dart';
import 'package:skkumap/features/transit/widgets/refresh_button.dart';
import 'package:skkumap/features/transit/model/bus_group.dart';
import 'package:skkumap/features/transit/widgets/topinfo.dart';

import 'package:skkumap/core/types/bus_status.dart';
import 'package:skkumap/core/types/time_format.dart';
import 'package:skkumap/features/transit/widgets/businfo_component.dart';

class BusRealtimeScreen extends GetView<BusRealtimeController> {
  const BusRealtimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BusGroup group = Get.arguments['busConfig'];
    controller.setRouteConfig(group);
    final themeColor = group.card.themeColor;

    // Find info feature from screen data
    final features = group.screen['features'] as List? ?? [];
    final infoFeature = features
        .cast<Map<String, dynamic>>()
        .where((f) => f['type'] == 'info')
        .firstOrNull;

    final adService = Get.find<AdService>();

    return Scaffold(
      // floating action button
      floatingActionButton: RefreshButton(
          themeColor: themeColor,
          onRefresh: () {
            controller.fetchRealtimeData();
          }),
      // 화면 하단 광고
      bottomNavigationBar: Obx(() {
        if (adService.isLoaded('bus_realtime').value) {
          return BottomAppBar(
            padding: EdgeInsets.zero,
            color: Colors.white,
            child: AdWidgetContainer(
              bannerAd: adService.getBanner('bus_realtime'),
            ),
          );
        }
        final height = adService.expectedHeight('bus_realtime').value;
        if (height != null) {
          return BottomAppBar(
            padding: EdgeInsets.zero,
            color: Colors.white,
            child: SizedBox(height: height.toDouble()),
          );
        }
        return const SizedBox.shrink();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // 상단 커스텀 내비게이션 바
          CustomNavigationBar(
            title: group.label,
            isDisplayLeftBtn: true,
            isDisplayRightBtn: infoFeature != null,
            leftBtnAction: () {
              Get.back();
            },
            rightBtnAction: () {
              final infoUrl = infoFeature?['url'] as String?;
              if (infoUrl != null) {
                Get.toNamed(Routes.webview, arguments: {
                  'title': group.label,
                  'color': group.card.themeColor
                      .toARGB32()
                      .toRadixString(16)
                      .substring(2),
                  'webviewLink': infoUrl,
                  'screenName': group.id,
                });
              }
            },
            rightBtnType: CustomNavigationBtnType.info,
          ),

          // 상단 정보 부분
          Obx(() {
            final meta = controller.realtimeData.value?.meta;
            return TopInfo(
              isLoaded: true,
              currentTime: meta?.currentTime ?? '00:00 AM',
              timeFormat: TimeFormat.format12Hour,
              busCount: meta?.totalBuses ?? 0,
              busStatus: (meta?.totalBuses ?? 0) > 0
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
            // Reference realtimeData to trigger reactive rebuild on poll
            final data = controller.realtimeData.value;
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
                              color: AppColors.greenMain,
                            ),
                          );
                        }
                        // Reference realtimeData again for ETA updates
                        controller.realtimeData.value;
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.stations.length,
                              itemBuilder: (context, index) {
                                final station = controller.stations[index];
                                return BusListComponent(
                                  stationName: station.name,
                                  subtitle: station.subtitle,
                                  eta: controller
                                      .etaForStation(station.index),
                                  isFirstStation: station.isFirstStation,
                                  isLastStation: station.isLastStation,
                                  isRotationStation:
                                      station.isRotationStation,
                                  themeColor: themeColor,
                                  transferLines: station.transferLines,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
                    // 번호판 && 버스 현재 위치 정보 부분
                    ...(data?.buses ?? []).map(
                          (bus) => BusInfoComponent(
                            elapsedSeconds: bus.estimatedTime,
                            currentStationIndex: bus.stationIndex,
                            lastStationIndex: controller.lastStationIndex,
                            plateNumber: bus.carNumber,
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
