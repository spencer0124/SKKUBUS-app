import 'snappingsheet_controller.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:skkumap/app/model/station_model.dart';
import 'package:skkumap/app/model/mainpage_buslist_model.dart';
import 'package:skkumap/app/model/sdui_section.dart';
import 'package:skkumap/app/data/campus_service_defaults.dart';
import 'package:skkumap/app/data/repositories/station_repository.dart';
import 'package:skkumap/app/data/repositories/ui_repository.dart';
import 'package:skkumap/app/data/repositories/ad_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/utils/app_logger.dart';

class MainpageLifeCycle extends GetxController with WidgetsBindingObserver {
  MainpageController mainpageController = Get.find<MainpageController>();

  final controller = Get.find<MainpageController>();

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
      // 여기에 화면에 돌아왔을때 사용할 코드 작성하기
      mainpageController.mainPageBusListFetch();
      mainpageController.stationDataFetch();
      mainpageController.fetchMainpageAd();
    }
  }
}

class MainpageController extends GetxController {
  final _stationRepo = Get.find<StationRepository>();
  final _uiRepo = Get.find<UiRepository>();
  final _adRepo = Get.find<AdRepository>();

  var snappingSheetIsExpanded = false.obs;

  Timer? _timer;

  // BottomNavigation 현재 선택된 index 저장
  var bottomNavigationIndex = 2.obs;

  // 필터에서 선택된 캠퍼스
  // 0: 인사캠, 1: 자과캠
  var selectedCampus = 0.obs;

  // 정류장 정보를 담을 변수
  var stationData = Rx<StationResponse?>(null);

  Future<void> stationDataFetch() async {
    final result = await _stationRepo.getStationData('01592');
    switch (result) {
      case Ok(:final data):
        stationData.value = data;
      case Err(:final failure):
        logger.e('Error fetching station: $failure');
    }
  }

  var campusSections = <SduiSection>[].obs;
  var isCampusLoading = true.obs;

  Future<void> campusSectionsFetch() async {
    final result = await _uiRepo.getCampusSections();
    switch (result) {
      case Ok(:final data):
        campusSections.value = data.sections;
      case Err(:final failure):
        logger.e('Error fetching campus sections: $failure');
        if (campusSections.isEmpty) {
          campusSections.value = defaultCampusSections;
        }
    }
    isCampusLoading.value = false;
  }

  var mainpageBusList = Rx<MainPageBusListResponse?>(null);

  Future<void> mainPageBusListFetch() async {
    final result = await _uiRepo.getMainpageBusList();
    switch (result) {
      case Ok(:final data):
        mainpageBusList.value = data;
      case Err(:final failure):
        logger.e('Error fetching bus list: $failure');
    }
  }

  var _hasTrackedAdView = false;

  // 메인화면 광고 텍스트 불러오기
  var showmainpageAdText = false.obs;
  var mainpageAdText = ''.obs;
  var mainpageAdLink = ''.obs;
  var showmainpageNoticeText = false.obs;
  var mainpageNoticeText = ''.obs;
  var mainpageNoticeLink = ''.obs;

  void fetchMainpageAd() async {
    final result = await _adRepo.getPlacements();
    switch (result) {
      case Ok(:final data):
        // main_banner placement (server returns only enabled ads)
        final banner = data['main_banner'];
        showmainpageAdText.value = banner != null;
        if (banner != null) {
          mainpageAdText.value = banner.text ?? '';
          mainpageAdLink.value = banner.linkUrl;
        }

        // main_notice placement
        final notice = data['main_notice'];
        showmainpageNoticeText.value = notice != null;
        if (notice != null) {
          mainpageNoticeText.value = notice.text ?? '';
          mainpageNoticeLink.value = notice.linkUrl;
        }

        if (!_hasTrackedAdView && banner != null) {
          _adRepo.trackEvent('main_banner', 'view', adId: banner.adId);
          _hasTrackedAdView = true;
        }
      case Err(:final failure):
        logger.e('Error fetching ad: $failure');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      fetchMainpageAd();
      stationDataFetch();
      campusSectionsFetch();
      await mainPageBusListFetch();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        snaptoInitPosition();
        _timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
          stationDataFetch();
          fetchMainpageAd();
        });
      });
    } catch (e) {
      logger.e('MainpageController init error: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
