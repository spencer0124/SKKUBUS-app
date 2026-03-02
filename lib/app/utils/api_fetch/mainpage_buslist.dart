import 'package:get/get.dart';
import 'package:skkumap/app/data/repositories/ui_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/mainpage_buslist_model.dart';

/// Backward-compat wrapper — delegates to [UiRepository].
Future<MainPageBusListResponse> fetchMainpageBusList() async {
  final result = await Get.find<UiRepository>().getMainpageBusList();
  return switch (result) {
    Ok(:final data) => data,
    Err(:final failure) => throw Exception(failure.message),
  };
}
