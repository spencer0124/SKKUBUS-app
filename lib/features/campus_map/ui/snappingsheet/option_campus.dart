import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:skkumap/features/campus_map/controller/campus_map_controller.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/core/widgets/sdui/sdui_section_builder.dart';
import 'package:skkumap/core/model/sdui_section.dart';
import 'package:skkumap/core/services/ad_service.dart';
import 'package:skkumap/core/utils/native_ad_widget.dart';
import 'package:skkumap/design/sds_design.dart';

// '캠퍼스' 탭
// 서버에서 받아온 섹션 목록을 SDUI로 렌더링

class OptionCampus extends StatelessWidget {
  OptionCampus({Key? key}) : super(key: key);

  final controller = Get.find<CampusMapController>();
  final _adService = Get.find<AdService>();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      constraints: BoxConstraints(minHeight: screenHeight * 0.9),
      child: Obx(() {
        if (controller.isCampusLoading.isTrue) {
          return _buildShimmer();
        }

        final sections = controller.campusSections;
        if (sections.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: SdsButton(
                  text: 'SDS Button 테스트',
                  icon: const Icon(Icons.palette_outlined),
                  variant: SdsButtonVariant.weak,
                  color: SdsButtonColor.primary,
                  size: SdsButtonSize.small,
                  onPressed: () => Get.toNamed(Routes.devButtonTest),
                ),
              ),
            ..._buildSectionsWithAd(sections),
          ],
        );
      }),
    );
  }

  List<Widget> _buildSectionsWithAd(List<SduiSection> sections) {
    final widgets = <Widget>[];
    bool adInserted = false;

    for (final section in sections) {
      widgets.add(buildSection(section));

      // Insert native ad once, after the first button grid
      if (!adInserted && section is SduiButtonGrid) {
        adInserted = true;
        widgets.add(
          Obx(() {
            if (!_adService.isNativeLoaded('native_campus').value) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: NativeAdContainer(
                nativeAd: _adService.getNativeAd('native_campus'),
                height: kNativeSmallHeight,
              ),
            );
          }),
        );
      }
    }
    return widgets;
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer for section title
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.white,
            child: Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        // Shimmer for button grid (4 items)
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
          child: Row(
            children: [
              for (int i = 0; i < 4; i++) ...[
                Shimmer.fromColors(
                  baseColor: Colors.grey[100]!,
                  highlightColor: Colors.white,
                  child: Container(
                    width: 77,
                    height: 77,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (i < 3) const Spacer(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
