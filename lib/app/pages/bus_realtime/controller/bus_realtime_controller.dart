import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:skkumap/admob/ad_helper.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';

import 'package:skkumap/app/model/main_bus_location.dart';

import 'dart:async';

import 'package:skkumap/app/types/bus_type.dart';
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
      // 화면 다시 돌아왔을때 할 일 정해주기
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

  BusType busType = BusType.hsscBus;

  @override
  void onInit() {
    super.onInit();
    _initializeBannerAd();

    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      localfetchBusLocation();
      localfetchBusStations();
    });
    update();

    fetchMainpageAd();
  }

  void setBusType(BusType type) {
    busType = type;
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
          update(); // Call update to refresh UI if needed
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

  // 역 목록을 불러오고 적용하기까지 로딩을 보여주기 위한 값
  var loadingdone = false.obs;

  Future<void> localfetchBusStations() async {
    final result = await _busRepo.getStations(busType);
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
    final result = await _busRepo.getLocations(busType);
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
