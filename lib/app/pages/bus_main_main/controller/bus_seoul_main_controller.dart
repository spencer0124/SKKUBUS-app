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

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
          print('Failed to load a banner ad: ${err.message}');
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
      print('BusStations.value: ${mainBusStationList.value}');
    } catch (e) {
      print("Error fetchMainBusStations: $e");
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
      print("Error fetchMainBusLocation: $e");
    }
  }

// 하단 이미지 광고
  var belowAdLink = ''.obs;
  var belowAdImage = ''.obs;

  void fetchMainpageAd() async {
    try {
      final response =
          await http.get(Uri.parse('http://43.200.90.214:3000/ad/v1/addetail'));
      // 'http://localhost:3000/ad/v1/addetail'));

      if (response.statusCode == 200) {
        try {
          http.get(Uri.parse(
              'http://43.200.90.214:3000/ad/v1/statistics/menu3/view'));
        } catch (e) {
          print('Error: $e');
        }

        final data = jsonDecode(response.body);

        belowAdLink.value = data['link'];
        belowAdImage.value = data['image2'];
      } else {
        print('Server error1');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _bannerAd?.dispose();
    super.onClose();
  }
}
