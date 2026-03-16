import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/features/building/controller/building_detail_controller.dart';
import 'package:skkumap/features/building/model/building_detail.dart';
import 'package:skkumap/features/building/model/building_models.dart';
import 'package:skkumap/core/routes/app_routes.dart';

class BuildingDetailSheet extends StatelessWidget {
  final int skkuId;

  const BuildingDetailSheet({super.key, required this.skkuId});

  /// Show the building detail bottom sheet.
  static Future<void> show(
    int skkuId, {
    String? highlightFloor,
    String? highlightSpaceCd,
  }) {
    final ctrl = Get.find<BuildingDetailController>();
    ctrl.loadDetail(
      skkuId,
      highlightFloor: highlightFloor,
      highlightSpaceCd: highlightSpaceCd,
    );
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
          return _buildContent(detail, ctrl, scrollController);
        });
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(color: AppColors.brand),
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
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ctrl.loadDetail(skkuId),
              child: Text(
                '다시 시도'.tr,
                style: const TextStyle(color: AppColors.brand),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildingDetail detail,
    BuildingDetailController ctrl,
    ScrollController scrollController,
  ) {
    final building = detail.building;
    final hasDescription = (building.description != null &&
            building.description!.localized.isNotEmpty) ||
        (building.accessibility != null && building.accessibility!.hasAny);

    return Column(
      children: [
        // Drag handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Scrollable content
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // ══ Section 1: Image + Header ══
              if (building.image != null)
                Image.network(
                  building.image!.url,
                  headers: const {'Referer': 'https://www.skku.edu/'},
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            building.name.localized,
                            style: const TextStyle(
                              fontFamily: 'WantedSansMedium',
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (building.displayNo != null) ...[
                                Text(
                                  building.displayNo!,
                                  style: const TextStyle(
                                    fontFamily: 'WantedSansMedium',
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.bgGrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  building.campus == 'hssc'
                                      ? '인사캠'.tr
                                      : '자과캠'.tr,
                                  style: const TextStyle(
                                    fontFamily: 'WantedSansMedium',
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close,
                          size: 20, color: AppColors.textTertiary),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // ══ Section 2: Description (if exists) ══
              if (hasDescription) ...[
                const Divider(
                    height: 0.5, thickness: 0.5, color: AppColors.divider),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (building.accessibility != null &&
                          building.accessibility!.hasAny) ...[
                        _buildAccessibilityRow(building.accessibility!),
                        if (building.description != null &&
                            building.description!.localized.isNotEmpty)
                          const SizedBox(height: 8),
                      ],
                      if (building.description != null &&
                          building.description!.localized.isNotEmpty)
                        Text(
                          building.description!.localized,
                          style: const TextStyle(
                            fontFamily: 'WantedSansRegular',
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.55,
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              // ══ 6px thick divider ══
              if (detail.hasFloors)
                Container(height: 6, color: AppColors.bgGrey),

              // ══ Section 3: Floors ══
              if (detail.hasFloors) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Text(
                    '층별 정보'.tr,
                    style: const TextStyle(
                      fontFamily: 'WantedSansMedium',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ...detail.floors.asMap().entries.map((entry) {
                  final index = entry.key;
                  final floor = entry.value;
                  final isLast = index == detail.floors.length - 1;
                  return _FloorTile(
                    floor: floor,
                    index: index,
                    isLast: isLast,
                    ctrl: ctrl,
                    connections: detail.connections,
                  );
                }),
              ],

              // ══ Section 4: Connections ══
              if (detail.hasConnections) ...[
                Container(height: 6, color: AppColors.bgGrey),
                _buildConnectionsSection(detail),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionsSection(BuildingDetail detail) {
    // Group connections by targetSkkuId
    final grouped = <int, List<BuildingConnection>>{};
    for (final c in detail.connections) {
      grouped.putIfAbsent(c.targetSkkuId, () => []).add(c);
    }
    final groups = grouped.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Text(
            '연결 건물'.tr,
            style: const TextStyle(
              fontFamily: 'WantedSansMedium',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // CTA card — "건물 연결지도 보기"
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.toNamed(Routes.mapHssc),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.bgGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.brandLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.hub_outlined,
                      size: 20,
                      color: AppColors.brand,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '건물 연결지도 보기'.tr,
                          style: const TextStyle(
                            fontFamily: 'WantedSansMedium',
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${detail.building.name.localized} ${'위치가 표시돼요'.tr}',
                          style: const TextStyle(
                            fontFamily: 'WantedSansRegular',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.textDisabled,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Connection list
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider, width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: groups.asMap().entries.map((entry) {
                final idx = entry.key;
                final group = entry.value.value;
                final first = group.first;
                final isLast = idx == groups.length - 1;

                // Floor text: "2층↔3층, 5층↔5층"
                final floorText = group
                    .map((c) =>
                        '${c.fromFloor.localized}↔${c.toFloor.localized}')
                    .join(', ');

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.back();
                    Future.delayed(const Duration(milliseconds: 300), () {
                      BuildingDetailSheet.show(first.targetSkkuId);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: !isLast
                          ? const Border(
                              bottom: BorderSide(
                                  color: AppColors.divider, width: 0.5))
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Display number badge
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.bgGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            first.targetDisplayNo ?? '',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name + floor connections
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                first.targetName.localized,
                                style: const TextStyle(
                                  fontFamily: 'WantedSansMedium',
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                floorText,
                                style: const TextStyle(
                                  fontFamily: 'WantedSansRegular',
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textDisabled,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityRow(Accessibility accessibility) {
    return Row(
      children: [
        if (accessibility.elevator) ...[
          const Icon(Icons.elevator, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Text(
            '엘리베이터'.tr,
            style: const TextStyle(
              fontFamily: 'WantedSansRegular',
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (accessibility.toilet) ...[
          const Icon(Icons.accessible, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Text(
            '장애인 화장실'.tr,
            style: const TextStyle(
              fontFamily: 'WantedSansRegular',
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Floor Tile (header + expandable space list) ───

class _FloorTile extends StatelessWidget {
  final FloorInfo floor;
  final int index;
  final bool isLast;
  final BuildingDetailController ctrl;
  final List<BuildingConnection> connections;

  const _FloorTile({
    required this.floor,
    required this.index,
    required this.isLast,
    required this.ctrl,
    required this.connections,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = ctrl.expandedFloorIndex.value == index;

      return Column(
        children: [
          // Floor header row
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ctrl.toggleFloor(index),
            child: Container(
              color: isExpanded ? AppColors.bgGrey : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(
                      floor.floor.localized,
                      style: TextStyle(
                        fontFamily: 'WantedSansMedium',
                        fontSize: 14,
                        color: isExpanded
                            ? AppColors.brand
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${'호실'.tr} ${floor.spaces.length}${'개'.tr}',
                    style: const TextStyle(
                      fontFamily: 'WantedSansRegular',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  // Connection badges for this floor
                  ...connections
                      .where((c) => c.fromFloor.ko == floor.floor.ko)
                      .map((c) => c.targetName.localized)
                      .toSet()
                      .map((name) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.bgGrey,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                '→ $name',
                                style: const TextStyle(
                                  fontFamily: 'WantedSansRegular',
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )),
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: isExpanded
                          ? AppColors.brand
                          : AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded space list
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isExpanded
                ? _buildSpaceList()
                : const SizedBox.shrink(),
          ),

          // Bottom border (except last item when collapsed)
          if (!isLast || isExpanded)
            const Divider(
              height: 0.5,
              thickness: 0.5,
              color: AppColors.divider,
              indent: 0,
              endIndent: 0,
            ),
        ],
      );
    });
  }

  Widget _buildSpaceList() {
    return Obx(() {
      final showAll = ctrl.showAllSpaces[index] == true;
      final spaces = floor.spaces;
      const maxVisible = 5;
      final visibleSpaces =
          showAll ? spaces : spaces.take(maxVisible).toList();
      final remaining = spaces.length - maxVisible;

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          children: [
            ...visibleSpaces.asMap().entries.map((entry) {
              final spaceIdx = entry.key;
              final space = entry.value;
              final isHighlighted = ctrl.highlightSpaceCd != null &&
                  space.spaceCd == ctrl.highlightSpaceCd;
              final isLastVisible = spaceIdx == visibleSpaces.length - 1 &&
                  (showAll || remaining <= 0);

              return Container(
                decoration: BoxDecoration(
                  color: isHighlighted ? AppColors.brandLight : null,
                  border: !isLastVisible
                      ? const Border(
                          bottom: BorderSide(
                            color: AppColors.divider,
                            width: 0.5,
                          ),
                        )
                      : null,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        space.name.localized,
                        style: TextStyle(
                          fontFamily: isHighlighted
                              ? 'WantedSansMedium'
                              : 'WantedSansRegular',
                          fontSize: 13,
                          color: isHighlighted
                              ? AppColors.brand
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      space.spaceCd,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isHighlighted
                            ? AppColors.brand
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // "+ N개 더보기" button
            if (!showAll && remaining > 0)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ctrl.showAllSpacesFor(index),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '+ $remaining${'개 더보기'.tr}',
                    style: const TextStyle(
                      fontFamily: 'WantedSansRegular',
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
