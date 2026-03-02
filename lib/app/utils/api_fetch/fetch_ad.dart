import 'package:get/get.dart';
import 'package:skkumap/app/data/repositories/ad_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/ad_model.dart';
import 'package:skkumap/app/utils/app_logger.dart';

// Re-export models so existing importers don't break.
export 'package:skkumap/app/model/ad_model.dart';

/// Backward-compat wrapper — delegates to [AdRepository].
Future<AdPlacementsResponse> fetchAdPlacements() async {
  final result = await Get.find<AdRepository>().getPlacements();
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw Exception(failure.message),
  };
}

/// Backward-compat wrapper — delegates to [AdRepository].
void trackAdEvent(String placement, String event, {String? adId}) {
  try {
    Get.find<AdRepository>().trackEvent(placement, event, adId: adId);
  } catch (e) {
    logger.e('Error tracking ad event: $e');
  }
}
