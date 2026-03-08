import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:skkumap/admob/ad_helper.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';

import 'package:skkumap/app/model/main_bus_location.dart';

import 'dart:async';

import 'package:skkumap/app/model/bus_group.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/repositories/ad_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/utils/app_logger.dart';

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
      controller.localfetchBusLocation();
      controller.localfetchBusStations();
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

  late BusGroup group;
  bool _configSet = false;

  @override
  void onInit() {
    super.onInit();
    _initializeBannerAd();
    fetchMainpageAd();
  }

  void setRouteConfig(BusGroup config) {
    if (_configSet) return; // prevent re-init on widget rebuild
    _configSet = true;
    group = config;

    // Realtime screen data from group.screen
    final screenData = group.screen;
    final interval = (screenData['refreshInterval'] as num?)?.toInt() ?? 15;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: interval), (Timer t) {
      localfetchBusLocation();
      localfetchBusStations();
    });
    localfetchBusStations();
    localfetchBusLocation();
  }

  void _initializeBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          update();
          isBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          logger.e('Failed to load a banner ad: ${err.message}');
          ad.dispose();
          isBannerAdLoaded.value = false;
        },
      ),
    )..load();
  }

  var mainBusStationList = Rx<MainBusStationList?>(null);

  var loadingdone = false.obs;

  Future<void> localfetchBusStations() async {
    final endpoint = group.screen['stationsEndpoint'] as String?;
    if (endpoint == null) return;
    final result = await _busRepo.getStationsByPath(endpoint);
    switch (result) {
      case Ok(:final data):
        mainBusStationList.value = data;
        logger.d('BusStations.value: ${mainBusStationList.value}');
      case Err(:final failure):
        logger.e("Error fetchMainBusStations: $failure");
    }
    loadingdone.value = true;
  }

  var mainBusLocation = Rx<List<MainBusLocation>>([]);
  Future<void> localfetchBusLocation() async {
    final endpoint = group.screen['locationsEndpoint'] as String?;
    if (endpoint == null) return;
    final result = await _busRepo.getLocationsByPath(endpoint);
    switch (result) {
      case Ok(:final data):
        mainBusLocation.value = data;
      case Err(:final failure):
        logger.e("Error fetchMainBusLocation: $failure");
    }
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
