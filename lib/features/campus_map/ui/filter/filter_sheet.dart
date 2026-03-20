import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/features/campus_map/ui/snappingsheet/grabbing_box.dart';
import 'package:skkumap/features/campus_map/ui/filter/filter_campus_component.dart';
import 'package:skkumap/features/campus_map/controller/campus_map_controller.dart';
import 'package:skkumap/features/campus_map/controller/map_layer_controller.dart';
import 'package:skkumap/features/campus_map/ui/filter/filter_info_component.dart';
import 'package:skkumap/features/campus_map/data/map_config_repository.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CampusMapController>();
    final layerCtrl = Get.find<MapLayerController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const GrabbingBox(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                const Text(
                  "필터",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'WantedSansBold',
                    fontSize: 17,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.textTertiary, size: 20),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.divider,
            thickness: 0.5,
            height: 0.5,
          ),
          const SizedBox(height: 20),

          // ── Campus selector ──
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "캠퍼스",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'WantedSansBold',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "지도에 표시할 캠퍼스를 선택하세요",
              style: TextStyle(
                color: AppColors.textTertiary,
                fontFamily: 'WantedSansRegular',
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Obx(
              () {
                return Row(
                  children: [
                    FilterCampusComponent(
                      selected: controller.selectedCampus.value == 0,
                      index: 0,
                      text: "인사캠",
                      onCampusItemTapped: (int index) {
                        controller.switchCampus(index);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          layerCtrl.onCampusChanged();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterCampusComponent(
                      selected: controller.selectedCampus.value == 1,
                      index: 1,
                      text: "자과캠",
                      onCampusItemTapped: (int index) {
                        controller.switchCampus(index);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          layerCtrl.onCampusChanged();
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Layer toggles (config-driven) ──
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "지도 레이어",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'WantedSansBold',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "지도에 표시할 정보를 선택하세요",
              style: TextStyle(
                color: AppColors.textTertiary,
                fontFamily: 'WantedSansRegular',
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Obx(() {
              final layers = Get.find<MapConfigRepository>().layers;
              return Wrap(
                spacing: 8,
                runSpacing: 10,
                children: layers.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final layer = entry.value;
                  final isActive =
                      layerCtrl.layerStates[layer.id]?.visible ?? false;
                  return FilterInfoComponent(
                    text: layer.label,
                    index: idx,
                    selected: isActive,
                    onInfoItemTapped: (_) => layerCtrl.toggleLayer(layer.id),
                  );
                }).toList(),
              );
            }),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
