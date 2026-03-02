import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:skkumap/admob/ad_helper.dart';
import 'package:skkumap/app/model/main_bus_stationlist.dart';

import 'package:skkumap/app/model/main_bus_location.dart';
import 'package:skkumap/app/utils/api_fetch/bus_location.dart';

import 'dart:async';

import 'package:skkumap/app/utils/api_fetch/bus_stationlist.dart';
import 'package:skkumap/app/types/bus_type.dart';

import 'package:skkumap/app/utils/api_fetch/fetch_ad.dart';
import 'package:skkumap/app/utils/app_logger.dart';

// life cycle
class SeoulMainLifeCycle extends GetxController with WidgetsBindingObserver {
  BusDataController controller = Get.find<BusDataController>();

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
class BusDataController extends GetxController {
  Timer? _timer;

  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;
  RxBool isBannerAdLoaded = false.obs;

  BusType busType = BusType.hsscBus;

  @override
  void onInit() async {
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
    try {
      mainBusStationList.value = await fetchMainBusStations(busType: busType);
      logger.d('BusStations.value: ${mainBusStationList.value}');
    } catch (e) {
      logger.e("Error fetchMainBusStations: $e");
    } finally {
      loadingdone.value = true;
    }
  }

  var mainBusLocation = Rx<List<MainBusLocation>>([]);
  Future<void> localfetchBusLocation() async {
    try {
      mainBusLocation.value = await fetchMainBusLocation(busType: busType);
      // print('BusLocations.value: ${BusLocations.value}');
    } catch (e) {
      logger.e("Error fetchMainBusLocation: $e");
    }
  }

// 하단 이미지 광고
  var belowAdLink = ''.obs;
  var belowAdImage = ''.obs;

  void fetchMainpageAd() async {
    try {
      final adData = await fetchAdPlacements();
      final busBottom = adData['bus_bottom'];

      if (busBottom != null) {
        belowAdLink.value = busBottom.linkUrl;
        belowAdImage.value = busBottom.imageUrl ?? '';
        trackAdEvent('bus_bottom', 'view', adId: busBottom.adId);
      }
    } catch (e) {
      logger.e('Error fetching ad: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _bannerAd?.dispose();
    super.onClose();
  }
}
