import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skkumap/features/building/ui/building_detail_sheet.dart';
import 'package:skkumap/features/campus_map/controller/campus_map_controller.dart';
import 'package:skkumap/features/campus_map/controller/map_layer_controller.dart';
import 'package:skkumap/features/campus_map/ui/navermap/navermap_controller.dart';

/// Payload returned from the search screen when a result is tapped.
class BuildingNavPayload {
  final int skkuId;
  final double lat;
  final double lng;
  final String campus;
  final String? highlightFloor;
  final String? highlightSpaceCd;

  const BuildingNavPayload({
    required this.skkuId,
    required this.lat,
    required this.lng,
    required this.campus,
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
          final route = ModalRoute.of(context);
          final result = await Get.toNamed(Routes.search);
          if (result is BuildingNavPayload) {
            // ── Step 1: 검색 화면 pop 애니메이션 완료 대기 ──
            if (route != null) {
              final anim = route.secondaryAnimation;
              if (anim != null &&
                  anim.status != AnimationStatus.dismissed) {
                final c = Completer<void>();
                void onStatus(AnimationStatus s) {
                  if (s == AnimationStatus.dismissed) {
                    anim.removeStatusListener(onStatus);
                    if (!c.isCompleted) c.complete();
                  }
                }
                anim.addStatusListener(onStatus);
                await c.future;
              }
            }

            // ── Step 2: 캠퍼스 전환 (토글 UI 변경이 사용자에게 보임) ──
            final campusCtrl = Get.find<CampusMapController>();
            final layerCtrl = Get.find<MapLayerController>();
            final currentKey =
                campusCtrl.selectedCampus.value == 0 ? 'hssc' : 'nsc';
            final needsCampusSwitch = result.campus != currentKey;

            if (needsCampusSwitch) {
              campusCtrl.selectedCampus.value =
                  result.campus == 'hssc' ? 0 : 1;
              layerCtrl.onCampusChanged(skipCamera: true);
            }

            // ── Step 3: 카메라 이동 ──
            final nmapCtrl = Get.find<UltimateNMapController>();
            nmapCtrl.cameraPosition.value = NCameraPosition(
              target: NLatLng(result.lat, result.lng),
              zoom: 17.5,
            );

            // ── Step 4: 마커/카메라 렌더링 대기 후 상세 sheet ──
            await Future.delayed(
              Duration(milliseconds: needsCampusSwitch ? 150 : 50),
            );

            BuildingDetailSheet.show(
              result.skkuId,
              highlightFloor: result.highlightFloor,
              highlightSpaceCd: result.highlightSpaceCd,
              source: 'search',
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
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
