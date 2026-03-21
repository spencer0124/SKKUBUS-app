import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:skkumap/core/admob/ad_helper.dart';

import 'dart:async';

import 'package:skkumap/features/transit/model/bus_group.dart';
import 'package:skkumap/features/transit/model/realtime_data.dart';
import 'package:skkumap/features/transit/model/realtime_station.dart';
import 'package:skkumap/features/transit/data/bus_repository.dart';
import 'package:skkumap/core/repositories/ad_repository.dart';
import 'package:skkumap/core/data/result.dart';
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
  final _adRepo = Get.find<AdRepository>();

  Timer? _timer;

  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;
  RxBool isBannerAdLoaded = false.obs;
  RxnInt expectedAdHeight = RxnInt();

  late BusGroup group;
  bool _configSet = false;

  // Static data from config (set once)
  late List<RealtimeStation> stations;
  late int lastStationIndex;

  // Polled data
  var realtimeData = Rx<RealtimeData?>(null);
  var loadingdone = false.obs;

  bool _isLoadingAd = false;

  @override
  void onInit() {
    super.onInit();
    fetchMainpageAd();
  }

  void setRouteConfig(BusGroup config, {required int screenWidth}) {
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

    _initializeBannerAd(screenWidth);
  }

  Future<void> _initializeBannerAd(int width) async {
    if (_isLoadingAd) return;
    _isLoadingAd = true;

    // Dispose existing ad to prevent memory leak
    _bannerAd?.dispose();
    _bannerAd = null;
    isBannerAdLoaded.value = false;

    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adSize == null) {
      _isLoadingAd = false;
      return;
    }

    expectedAdHeight.value = adSize.height;

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          update();
          isBannerAdLoaded.value = true;
          _isLoadingAd = false;
        },
        onAdFailedToLoad: (ad, err) {
          logger.e('Failed to load a banner ad: ${err.message}');
          ad.dispose();
          isBannerAdLoaded.value = false;
          expectedAdHeight.value = null;
          _isLoadingAd = false;
        },
      ),
    )..load();
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

// 하단 이미지 광고
  var belowAdLink = ''.obs;
  var belowAdImage = ''.obs;

  void fetchMainpageAd() async {
    final result = await _adRepo.getPlacements();
    switch (result) {
      case Ok(:final data):
        final busBottom = data['bus_bottom'];
        if (busBottom != null) {
          belowAdLink.value = busBottom.linkUrl;
          belowAdImage.value = busBottom.imageUrl ?? '';
          _adRepo.trackEvent('bus_bottom', 'view', adId: busBottom.adId);
        }
      case Err(:final failure):
        logger.e('Error fetching ad: $failure');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _bannerAd?.dispose();
    super.onClose();
  }
}
