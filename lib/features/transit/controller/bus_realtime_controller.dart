import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';

import 'package:skkumap/features/transit/model/bus_group.dart';
import 'package:skkumap/features/transit/model/realtime_data.dart';
import 'package:skkumap/features/transit/model/realtime_station.dart';
import 'package:skkumap/features/transit/data/bus_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/services/ad_service.dart';
import 'package:skkumap/core/services/analytics_service.dart';
import 'package:skkumap/core/utils/app_logger.dart';

// life cycle
class BusRealtimeLifeCycle extends GetxController with WidgetsBindingObserver {
  BusRealtimeController controller = Get.find<BusRealtimeController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      controller.fetchRealtimeData();
      update();
    }
  }
}

// main controller
class BusRealtimeController extends GetxController {
  final _busRepo = Get.find<BusRepository>();
  final _adService = Get.find<AdService>();

  Timer? _timer;

  late BusGroup group;
  bool _configSet = false;

  // Static data from config (set once)
  late List<RealtimeStation> stations;
  late int lastStationIndex;

  // Polled data
  var realtimeData = Rx<RealtimeData?>(null);
  var loadingdone = false.obs;

  void setRouteConfig(BusGroup config) {
    if (_configSet) return; // prevent re-init on widget rebuild
    _configSet = true;
    group = config;
    Get.find<AnalyticsService>().logBusRouteOpen(
      routeId: config.id,
      routeLabel: config.label,
      screenType: config.screenType,
    );

    // Parse static stations from config (one-time)
    stations = group.realtimeStations;
    lastStationIndex = group.lastStationIndex;

    // Set up single data poll
    final interval = group.refreshInterval;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: interval), (_) {
      fetchRealtimeData();
    });
    fetchRealtimeData();
  }

  Future<void> fetchRealtimeData() async {
    final endpoint = group.dataEndpoint;
    if (endpoint == null) return;
    final result = await _busRepo.getRealtimeData(endpoint);
    switch (result) {
      case Ok(:final data):
        realtimeData.value = data;
      case Err(:final failure):
        logger.e("Error fetchRealtimeData: $failure");
    }
    loadingdone.value = true;
  }

  /// Get ETA text for a given station index, or empty string if none.
  String etaForStation(int stationIndex) {
    final etas = realtimeData.value?.stationEtas ?? [];
    return etas
            .where((e) => e.stationIndex == stationIndex)
            .firstOrNull
            ?.eta ??
        '';
  }

  @override
  void onClose() {
    _timer?.cancel();
    _adService.recycleBanner('bus_realtime');
    super.onClose();
  }
}
