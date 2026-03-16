import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skkumap/features/building/ui/building_detail_sheet.dart';
import 'package:skkumap/features/campus_map/ui/navermap/navermap_controller.dart';

/// Payload returned from the search screen when a result is tapped.
class BuildingNavPayload {
  final int skkuId;
  final double lat;
  final double lng;
  final String? highlightFloor;
  final String? highlightSpaceCd;

  const BuildingNavPayload({
    required this.skkuId,
    required this.lat,
    required this.lng,
    this.highlightFloor,
    this.highlightSpaceCd,
  });
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          final result = await Get.toNamed(Routes.search);
          if (result is BuildingNavPayload) {
            // Move camera to building location
            final nmapCtrl = Get.find<UltimateNMapController>();
            nmapCtrl.cameraPosition.value = NCameraPosition(
              target: NLatLng(result.lat, result.lng),
              zoom: 17.5,
            );
            // Show building detail bottom sheet
            BuildingDetailSheet.show(
              result.skkuId,
              highlightFloor: result.highlightFloor,
              highlightSpaceCd: result.highlightSpaceCd,
            );
          }
        },
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/tossface/toss_search_left.svg',
              width: 20,
            ),
            const SizedBox(width: 10),
            Text(
              '성균관대 건물/공간 검색'.tr,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontFamily: 'WantedSansMedium',
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
