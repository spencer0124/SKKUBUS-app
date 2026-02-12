import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skkumap/app/utils/constants.dart';
import 'package:skkumap/app/utils/app_logger.dart';

/*
LifeCycleGetx2, WidgetsBindingObserver
라이프사이클을 이용해 앱이 백그라운드에서 포그라운드로 돌아올때 
탑승 가능한 가장 빠른 버스 시간을 표시하기 위한 로직
 */

class InjaMainLifeCycle extends GetxController with WidgetsBindingObserver {
  InjaMainController injaMainController = Get.find<InjaMainController>();

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
      injaMainController.today = InjaMainController.getCurrentWeekday().obs;
      injaMainController.selectedEnglishDay = injaMainController
          .translateDayToEnglish(injaMainController.selectedDay.value ?? '월요일')
          .obs;

      injaMainController.fetchinjaBusSchedule(
          injaMainController.selectedEnglishDay.value ?? 'monday');
      injaMainController.fetchjainBusSchedule(
          injaMainController.selectedEnglishDay.value ?? 'monday');
      // injaMainController.determineNextBus();
    }
  }
}

/*
ESKARAController
메인 컨트롤러
*/
class InjaMainController extends GetxController {
  var injaBusSchedule = <BusSchedule>[].obs;
  var jainBusSchedule = <BusSchedule>[].obs;

  @override
  void onInit() async {
    // getDrivingDuration();
    today = getCurrentWeekday().obs;
    selectedDay = getCurrentWeekday().obs;
    selectedEnglishDay = translateDayToEnglish(selectedDay.value ?? '월요일').obs;

    fetchinjaBusSchedule(selectedEnglishDay.value ?? 'monday');
    fetchjainBusSchedule(selectedEnglishDay.value ?? 'monday');
    try {
      await FirebaseAnalytics.instance
          .setCurrentScreen(screenName: 'injashuttle_screen');
    } catch (e) {
      logger.e(e);
    }
    super.onInit();
    // determineNextBus();
  }

  // 현재 날짜와 요일을 가져오는 함수

  var duration = ''.obs;

  final Dio _dio = Dio();

  // 인자셔틀 이동 소요시간 체크해주는 함수
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
        // Handle API error or any other condition as per your requirement
        logger.w('error1');
      }
    } catch (e) {
      // Handle Dio exception or any other exception as per your requirement
      logger.e(e);
    }
  }

  // 지도 앱 실행 가능한지 확인 후 분기처리해주는 함수
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
      // 이, 가 조사 분기처리
      // 카카오맵: ~이 설치되어 있지 않아요
      // 네이버지도, 애플지도: ~가 설치되어 있지 않아요.

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

  static String getCurrentWeekday() {
    DateTime now = DateTime.now();
    int weekday = now
        .weekday; // Dart's DateTime class treats Monday as 1 and Sunday as 7.

    // Map Dart's weekday to Korean weekdays
    Map<int, String> weekdayMap = {
      1: '월요일',
      2: '화요일',
      3: '수요일',
      4: '목요일',
      5: '금요일',
      6: '토요일',
      7: '일요일'
    };

    return weekdayMap[weekday] ??
        '월요일'; // Default to '월요일' if something unexpected happens
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

    return translationMap[koreanDay] ??
        'Monday'; // Default to 'Monday' if there is no match
  }

  final List<String> dateitems = [
    '월요일',
    '화요일',
    '수요일',
    '목요일',
    '금요일',
    '토요일',
    '일요일'
  ];

// 선택된 요일 저장하는 변수
  Rx<String?> today = '월요일'.obs;
  Rx<String?> selectedDay = '월요일'.obs;
  Rx<String?> selectedEnglishDay = 'monday'.obs;
// 인자셔틀 정보 가져와서 변수에 담아주기

  // Function to fetch bus schedules from the API
  void fetchinjaBusSchedule(String type) async {
    try {
      var url =
          Uri.parse('${ApiConfig.baseUrl}/campus/v1/campus/INJA_$type');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        injaBusSchedule.clear();
        var jsonData = json.decode(response.body)['result'];
        for (var item in jsonData) {
          injaBusSchedule.add(BusSchedule.fromJson(item));
        }
      } else {
        Get.snackbar('Error', 'Failed to load bus schedules');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchjainBusSchedule(String type) async {
    try {
      var url =
          Uri.parse('${ApiConfig.baseUrl}/campus/v1/campus/JAIN_$type');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        jainBusSchedule.clear();
        var jsonData = json.decode(response.body)['result'];
        for (var item in jsonData) {
          jainBusSchedule.add(BusSchedule.fromJson(item));
        }
      } else {
        Get.snackbar('Error', 'Failed to load bus schedules');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

class BusSchedule {
  String operatingHours;
  int busCount;
  String? specialNotes;
  bool isFastestBus;

  BusSchedule({
    required this.operatingHours,
    required this.busCount,
    this.specialNotes,
    required this.isFastestBus,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      operatingHours: json['operatingHours'],
      busCount: json['busCount'],
      specialNotes: json['specialNotes'],
      isFastestBus: json['isFastestBus'],
    );
  }
}
