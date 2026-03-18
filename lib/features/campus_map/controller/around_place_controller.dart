import 'package:get/get.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:skkumap/core/data/api_client.dart';
import 'package:skkumap/core/data/api_endpoints.dart';
import 'package:skkumap/core/data/result.dart';
import 'package:skkumap/core/utils/app_logger.dart';
import 'package:skkumap/features/campus_map/ui/navermap/navermap_controller.dart';
import 'package:skkumap/features/campus_map/model/campusmarker_model.dart';

class AroundPlaceController extends GetxController {
  final ApiClient _api = Get.find<ApiClient>();

  Future<void> fetchAroundPlaceData(NLatLngBounds bounds) async {
    final swLat = bounds.southWest.latitude;
    final swLon = bounds.southWest.longitude;
    final neLat = bounds.northEast.latitude;
    final neLon = bounds.northEast.longitude;

    final result = await _api.safeGetRaw(
      ApiEndpoints.aroundPlace(),
      queryParameters: {
        'southWestlat': swLat,
        'southWestlon': swLon,
        'northEastlat': neLat,
        'northEastlon': neLon,
      },
    );

    switch (result) {
      case Ok(:final data):
        final list = data['result'] as List?;
        if (list == null || list.isEmpty) {
          await FlutterPlatformAlert.showCustomAlert(
            windowTitle: '검색 결과 없음!',
            text: '',
            positiveButtonTitle: '확인',
          );
          return;
        }
        final ultimateCtrl = Get.find<UltimateNMapController>();
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
            hasrank: interactionmeta['hasrank'] as bool,
          );
        }).toList();
        ultimateCtrl.updateMarkers(campusMarkers);
      case Err(:final failure):
        logger.e('Error fetching place data: $failure');
    }
  }
}
