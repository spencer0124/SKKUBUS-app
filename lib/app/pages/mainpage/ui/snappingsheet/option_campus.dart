import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:skkumap/app/pages/mainpage/controller/mainpage_controller.dart';
import 'package:skkumap/app/components/sdui/sdui_section_builder.dart';

// '캠퍼스' 탭
// 서버에서 받아온 섹션 목록을 SDUI로 렌더링

class OptionCampus extends StatelessWidget {
  OptionCampus({Key? key}) : super(key: key);

  final controller = Get.find<MainpageController>();

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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...sections.map(buildSection),
            ],
          ),
        );
      }),
    );
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
