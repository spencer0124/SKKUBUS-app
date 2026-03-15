import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/features/building/controller/building_detail_controller.dart';
import 'package:skkumap/features/building/model/building_detail.dart';
import 'package:skkumap/features/building/model/building_models.dart';

class BuildingDetailSheet extends StatelessWidget {
  final int skkuId;

  const BuildingDetailSheet({super.key, required this.skkuId});

  /// Show the building detail bottom sheet.
  static Future<void> show(int skkuId) {
    final ctrl = Get.find<BuildingDetailController>();
    ctrl.loadDetail(skkuId);
    return Get.bottomSheet(
      BuildingDetailSheet(skkuId: skkuId),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BuildingDetailController>();
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Obx(() {
          if (ctrl.isLoading.value) {
            return _buildLoading();
          }
          if (ctrl.hasError.value) {
            return _buildError(ctrl);
          }
          final detail = ctrl.detail.value;
          if (detail == null) return const SizedBox.shrink();
          return _buildContent(detail, scrollController);
        });
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(color: AppColors.greenMain),
      ),
    );
  }

  Widget _buildError(BuildingDetailController ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '건물 정보를 불러올 수 없습니다'.tr,
              style: const TextStyle(
                fontFamily: 'WantedSansMedium',
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ctrl.loadDetail(skkuId),
              child: Text(
                '다시 시도'.tr,
                style: const TextStyle(color: AppColors.greenMain),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildingDetail detail, ScrollController scrollController) {
    final building = detail.building;
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        // Drag handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Building image
        if (building.image != null)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              building.image!.url,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Building name
              Text(
                building.name.localized,
                style: const TextStyle(
                  fontFamily: 'WantedSansBold',
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),

              // displayNo + campus badge
              Row(
                children: [
                  if (building.displayNo != null) ...[
                    Text(
                      building.displayNo!,
                      style: TextStyle(
                        fontFamily: 'WantedSansMedium',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.greenMain.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      building.campus == 'hssc' ? '인사캠'.tr : '자과캠'.tr,
                      style: const TextStyle(
                        fontFamily: 'WantedSansMedium',
                        fontSize: 12,
                        color: AppColors.greenMain,
                      ),
                    ),
                  ),
                ],
              ),

              // Accessibility
              if (building.accessibility != null &&
                  building.accessibility!.hasAny) ...[
                const SizedBox(height: 12),
                _buildAccessibilityRow(building.accessibility!),
              ],

              // Description
              if (building.description != null &&
                  building.description!.localized.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  building.description!.localized,
                  style: TextStyle(
                    fontFamily: 'WantedSansRegular',
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],

              // Floors section
              if (detail.hasFloors) ...[
                const SizedBox(height: 20),
                Text(
                  '층별 정보'.tr,
                  style: const TextStyle(
                    fontFamily: 'WantedSansBold',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...detail.floors
                    .map((floor) => _buildFloorSection(floor)),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityRow(Accessibility accessibility) {
    return Row(
      children: [
        if (accessibility.elevator) ...[
          Icon(Icons.elevator, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '엘리베이터'.tr,
            style: TextStyle(
              fontFamily: 'WantedSansRegular',
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (accessibility.toilet) ...[
          Icon(Icons.accessible, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '장애인 화장실'.tr,
            style: TextStyle(
              fontFamily: 'WantedSansRegular',
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFloorSection(FloorInfo floor) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        floor.floor.localized,
        style: const TextStyle(
          fontFamily: 'WantedSansMedium',
          fontSize: 14,
        ),
      ),
      trailing: Text(
        '${floor.spaces.length}',
        style: TextStyle(
          fontFamily: 'WantedSansRegular',
          fontSize: 13,
          color: Colors.grey[500],
        ),
      ),
      children: floor.spaces
          .map((space) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        space.name.localized,
                        style: const TextStyle(
                          fontFamily: 'WantedSansRegular',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      space.spaceCd,
                      style: TextStyle(
                        fontFamily: 'WantedSansRegular',
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
