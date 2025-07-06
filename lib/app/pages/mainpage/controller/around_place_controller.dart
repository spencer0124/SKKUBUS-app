import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:skkumap/app/pages/mainpage/ui/navermap/navermap_controller.dart';
import 'package:skkumap/app/model/campusmarker_model.dart';

class AroundPlaceController extends GetxController {
  // 현재 카메라 지도 영역에 대한 정보를 가져오는 메서드
  // getContentBounds abstract method
  // https://pub.dev/documentation/flutter_naver_map/latest/flutter_naver_map/NaverMapController/getContentBounds.html

  Future<void> fetchAroundPlaceData(NLatLngBounds bounds) async {
    // 영역 좌표값 예시
    //  NLatLngBounds: {southWest: {lat: 37.58343008457714, lng: 126.99205729542365}, northEast: {lat: 37.59129170783923, lng: 126.99690070457643}}
    final swLat = bounds.southWest.latitude;
    final swLon = bounds.southWest.longitude;
    final neLat = bounds.northEast.latitude;
    final neLon = bounds.northEast.longitude;

    // [1] 해당 영역에 속하고
    // [2] 적용한 필터 값이 일치하는 장소 데이터 가져오기
    final uri = Uri.parse('http://localhost:3000/map/v1/getaroundplacedata?'
        'southWestlat=$swLat&southWestlon=$swLon&'
        'northEastlat=$neLat&northEastlon=$neLon');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('decoded: $decoded');
        final list = decoded['result'] as List?;
        if (list == null || list.isEmpty) {
          await FlutterPlatformAlert.showCustomAlert(
            windowTitle: '검색 결과 없음!',
            text: '',
            positiveButtonTitle: '확인',
          );
          return;
        }
        final ultimateCtrl = Get.find<UltimateNMapController>();
        // convert API results into CampusMarker list and update via controller
        final campusMarkers = list.map((item) {
          final dataMeta = item['data_metadata'] as Map<String, dynamic>;
          final placeMeta = item['place_metadata'] as Map<String, dynamic>;
          final interactionmeta =
              item['interaction_metadata'] as Map<String, dynamic>;
          final lat = (placeMeta['latitude'] as num).toDouble();
          final lon = (placeMeta['longitude'] as num).toDouble();
          return CampusMarker(
            idNumber: dataMeta['uniqueid'] as String,
            position: NLatLng(lat, lon),
            name: placeMeta['place_nm'] as String,
            // todo: has_rank로 api 바꾸고 여기서도 바꾸기.
            hasrank: interactionmeta['hasrank'] as bool,
          );
        }).toList();
        ultimateCtrl.updateMarkers(campusMarkers);
      }
    } catch (e) {
      print('Error fetching place data: $e');
    }
  }
}
