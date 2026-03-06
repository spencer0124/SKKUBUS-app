import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/bus_schedule.dart';
import 'package:skkumap/app/model/bus_route_config.dart';
import 'package:skkumap/app/utils/app_logger.dart';

/*
LifeCycleGetx2, WidgetsBindingObserver
라이프사이클을 이용해 앱이 백그라운드에서 포그라운드로 돌아올때
탑승 가능한 가장 빠른 버스 시간을 표시하기 위한 로직
 */

class BusCampusLifeCycle extends GetxController with WidgetsBindingObserver {
  BusCampusController campusController = Get.find<BusCampusController>();

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
      campusController.today = BusCampusController.getCurrentWeekday().obs;
      campusController.selectedEnglishDay = campusController
          .translateDayToEnglish(campusController.selectedDay.value ?? '월요일')
          .obs;

      campusController._fetchAllDirections(
          campusController.selectedEnglishDay.value ?? 'monday');
    }
  }
}

/*
BusCampusController
메인 컨트롤러
*/
class BusCampusController extends GetxController {
  final _busRepo = Get.find<BusRepository>();

  late BusRouteConfig routeConfig;
  bool _configSet = false;

  // Dynamic direction schedules
  var directionSchedules = <RxList<BusSchedule>>[].obs;
  var directionEtaMs = <RxInt>[].obs;

  // Day selector
  var selectedDayIndex = 0.obs;
  final shortDayLabels = ['월', '화', '수', '목', '금', '토', '일'];

  // 1-minute ticker: forces Obx rebuild so ETA & past-bus greying stay fresh
  Timer? _etaTimer;
  var tick = 0.obs;

  // Loading state: prevents flash of "no service" card on initial fetch
  var isLoading = true.obs;

  void setRouteConfig(BusRouteConfig config) {
    if (_configSet) return; // prevent re-init on widget rebuild
    _configSet = true;
    routeConfig = config;
    final directions = routeConfig.schedule!.directions;

    // Initialize dynamic lists for each direction
    directionSchedules.value =
        List.generate(directions.length, (_) => <BusSchedule>[].obs);
    directionEtaMs.value =
        List.generate(directions.length, (_) => 0.obs);
  }

  @override
  void onInit() {
    super.onInit();
    final todayIdx = DateTime.now().weekday - 1; // 0=Mon...6=Sun
    selectedDayIndex.value = todayIdx;

    today = getCurrentWeekday().obs;
    selectedDay = getCurrentWeekday().obs;
    selectedEnglishDay = translateDayToEnglish(selectedDay.value ?? '월요일').obs;

    _startEtaTicker();
  }

  /// Called after setRouteConfig to load initial data
  Future<void> loadInitialData() async {
    try {
      await Future.wait([
        _fetchAllDirections(selectedEnglishDay.value ?? 'monday'),
        fetchCampusEta(),
      ]);
      _initialize();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAllDirections(String dayType) async {
    final directions = routeConfig.schedule!.directions;
    await Future.wait(
      List.generate(directions.length, (i) =>
        _fetchDirectionSchedule(i, directions[i].id, dayType)),
    );
  }

  Future<void> _fetchDirectionSchedule(
      int index, String prefix, String dayType) async {
    final result = await _busRepo.getSchedule(prefix, dayType);
    switch (result) {
      case Ok(:final data):
        directionSchedules[index].value = data;
      case Err(:final failure):
        logger.e('$prefix schedule fetch failed: $failure');
    }
  }

  Future<void> fetchCampusEta() async {
    final result = await _busRepo.getCampusEta();
    switch (result) {
      case Ok(:final data):
        // Map ETA data to directions by lowercase id
        final directions = routeConfig.schedule!.directions;
        for (int i = 0; i < directions.length; i++) {
          final key = directions[i].id.toLowerCase();
          directionEtaMs[i].value = data[key] ?? 0;
        }
      case Err(:final failure):
        logger.e('Campus ETA fetch failed: $failure');
    }
  }

  /// Format milliseconds into localized duration string.
  String formatDuration(int ms) {
    final totalMinutes = (ms / 60000).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h > 0 && m > 0) return '$h${'시간_unit'.tr} $m${'분'.tr}';
    if (h > 0) return '$h${'시간_unit'.tr}';
    return '$m${'분'.tr}';
  }

  @override
  void onClose() {
    _etaTimer?.cancel();
    super.onClose();
  }

  Future<void> _initialize() async {
    try {
      await FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'injashuttle_screen');
    } catch (e) {
      logger.e('Analytics error: $e');
    }
  }

  void _startEtaTicker() {
    _etaTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      tick.value++;
    });
  }

  // ── Day selection ──────────────────────────────────────────────

  void onDaySelected(int index) {
    selectedDayIndex.value = index;
    selectedDay.value = dateitems[index];
    selectedEnglishDay.value = translateDayToEnglish(dateitems[index]);
    _fetchAllDirections(selectedEnglishDay.value ?? 'monday');
  }

  // ── Service day check (using server config) ────────────────────

  bool isServiceDay(int dayIndex) {
    // Build a DateTime for the selected day index to check against calendar
    final now = DateTime.now();
    final todayIdx = now.weekday - 1;
    final diff = dayIndex - todayIdx;
    final targetDate = now.add(Duration(days: diff));
    return routeConfig.schedule!.serviceCalendar.isServiceDay(targetDate);
  }

  // ── Today awareness ────────────────────────────────────────────

  int get _todayIndex => DateTime.now().weekday - 1;

  bool get isViewingToday => selectedDayIndex.value == _todayIndex;

  // ── Hero bus ───────────────────────────────────────────────────

  BusSchedule? getHeroBus(List<BusSchedule> schedules) {
    if (schedules.isEmpty) return null;
    if (isViewingToday) {
      try {
        final next = schedules.firstWhere((s) => s.isFastestBus);
        if (getMinutesUntil(next) != null) return next;
        return null;
      } catch (_) {
        return null;
      }
    }
    return schedules.firstOrNull;
  }

  int? getMinutesUntil(BusSchedule bus) {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final parts = bus.operatingHours.split(':');
    final busMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final diff = busMinutes - currentMinutes;
    return diff > 0 ? diff : null;
  }

  String formatETA(int minutes) {
    if (minutes < 60) return '$minutes${'분'.tr} ${'후'.tr}';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m > 0) return '$h${'시간_unit'.tr} $m${'분'.tr} ${'후'.tr}';
    return '$h${'시간_unit'.tr} ${'후'.tr}';
  }

  // ── Schedule helpers ───────────────────────────────────────────

  bool hasMultipleRouteTypes(List<BusSchedule> schedules) =>
      schedules.map((s) => s.routeType).toSet().length > 1;

  /// Get display name for a route type from server config
  String getRouteTypeLabel(String routeType) {
    return routeConfig.schedule?.routeTypes[routeType] ?? routeType;
  }

  bool isPastBus(BusSchedule bus) {
    if (!isViewingToday) return false;
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final parts = bus.operatingHours.split(':');
    final busMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    return busMinutes <= currentMinutes;
  }

  bool isNoServiceSchedule(List<BusSchedule> schedules) {
    if (schedules.isEmpty) return true;
    return schedules.length == 1 && schedules[0].operatingHours == '-';
  }

  // ── Existing properties ────────────────────────────────────────

  var duration = ''.obs;
  final Dio _dio = Dio();

  Rx<String?> today = '월요일'.obs;
  Rx<String?> selectedDay = '월요일'.obs;
  Rx<String?> selectedEnglishDay = 'monday'.obs;

  final List<String> dateitems = [
    '월요일',
    '화요일',
    '수요일',
    '목요일',
    '금요일',
    '토요일',
    '일요일'
  ];

  static String getCurrentWeekday() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    Map<int, String> weekdayMap = {
      1: '월요일',
      2: '화요일',
      3: '수요일',
      4: '목요일',
      5: '금요일',
      6: '토요일',
      7: '일요일'
    };
    return weekdayMap[weekday] ?? '월요일';
  }

  String translateDayToEnglish(String koreanDay) {
    Map<String, String> translationMap = {
      '월요일': 'monday',
      '화요일': 'tuesday',
      '수요일': 'wednesday',
      '목요일': 'thursday',
      '금요일': 'friday',
      '토요일': 'saturday',
      '일요일': 'sunday'
    };
    return translationMap[koreanDay] ?? 'Monday';
  }

  // ── Map helpers (kept for /injadetail) ─────────────────────────

  Future<void> getDrivingDuration() async {
    try {
      final response = await _dio.get(
        'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=126.993688,37.587308&goal=126.975532,37.292345',
        options: Options(
          headers: {
            'X-NCP-APIGW-API-KEY-ID': dotenv.env['navernewClientId'],
            'X-NCP-APIGW-API-KEY': dotenv.env['navernewClientSecret'],
          },
        ),
      );

      final data = response.data;
      if (data['code'] == 0) {
        final durationInMillis =
            data['route']['traoptimal'][0]['summary']['duration'];
        final durationInHours = (durationInMillis / (1000 * 60 * 60)).floor();
        final durationInMinutes =
            ((durationInMillis % (1000 * 60 * 60)) / (1000 * 60)).floor();

        duration.value = '$durationInHours시간 $durationInMinutes분';
      } else {
        logger.w('error1');
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> executeMap({
    required String type,
    required String mapNameEn,
    required String mapNameKr,
    required Uri mapUri,
    required String playStoreLink,
    required String appStoreLink,
  }) async {
    FirebaseAnalytics.instance.logEvent(
      name: 'injashuttle_${type}_$mapNameEn',
    );

    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri);

      FirebaseAnalytics.instance.logEvent(
        name: 'injashuttle_${type}_${mapNameEn}_success',
      );
    } else {
      var windowTitlefinal = '$mapNameKr가 설치되어 있지 않아요';

      if (mapNameKr == "카카오맵" || mapNameKr == "카카오 맵") {
        windowTitlefinal = '$mapNameKr이 설치되어 있지 않아요';
      }

      final result = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: windowTitlefinal,
        text: '$mapNameKr 설치 페이지로 이동할까요?',
        negativeButtonTitle: "이동",
        positiveButtonTitle: "취소",
      );

      if (result == CustomButton.positiveButton) {
        FirebaseAnalytics.instance.logEvent(
          name: 'injashuttle_${type}_${mapNameEn}_fail_cancel',
        );
      }

      if (result == CustomButton.negativeButton) {
        FirebaseAnalytics.instance.logEvent(
          name: 'injashuttle_${type}_${mapNameEn}_fail_move',
        );
        if (Platform.isAndroid) {
          if (await canLaunchUrl(Uri.parse(playStoreLink))) {
            await launchUrl(Uri.parse(playStoreLink));
          }
        }
        if (Platform.isIOS) {
          if (await canLaunchUrl(Uri.parse(appStoreLink))) {
            await launchUrl(Uri.parse(appStoreLink));
          }
        }
      }
    }
  }
}
