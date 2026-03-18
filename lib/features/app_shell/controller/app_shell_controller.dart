import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skkumap/core/repositories/ad_repository.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/utils/app_logger.dart';
import 'package:skkumap/features/transit/controller/transit_controller.dart';

class AppShellLifeCycle extends GetxController with WidgetsBindingObserver {
  final controller = Get.find<AppShellController>();

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
      Get.find<TransitController>().mainPageBusListFetch();
      Get.find<TransitController>().stationDataFetch();
      controller.fetchMainpageAd();
    }
  }
}

class AppShellController extends GetxController {
  static const _tabKey = 'last_tab_index';
  final _adRepo = Get.find<AdRepository>();

  Timer? _timer;

  // BottomNavigation 현재 선택된 index 저장 (기본값: 캠퍼스)
  var bottomNavigationIndex = 1.obs;

  void setTab(int index) {
    bottomNavigationIndex.value = index;
    _saveTabIndex(index);
  }

  Future<void> _saveTabIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tabKey, index);
  }

  Future<void> _loadTabIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_tabKey);
    if (saved != null && (saved == 1 || saved == 2)) {
      bottomNavigationIndex.value = saved;
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
      await _loadTabIndex();
      fetchMainpageAd();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
          Get.find<TransitController>().stationDataFetch();
          fetchMainpageAd();
        });
      });
    } catch (e) {
      logger.e('AppShellController init error: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
