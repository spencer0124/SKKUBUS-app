import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/app_theme.dart';
import 'package:skkumap/features/campus_map/widgets/searchbar.dart';
import 'package:skkumap/core/services/analytics_service.dart';
import 'package:skkumap/features/search/controller/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<PlaceSearchController>();
    _textController.addListener(() {
      controller.onSearchChanged(_textController.text);
    });
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _onItemTap(SearchDisplayItem item) async {
    final analytics = Get.find<AnalyticsService>();
    switch (item) {
      case BuildingDisplayItem(:final building):
        analytics.logSearchResultTap(
          resultType: 'building',
          resultName: building.name.ko,
          campus: building.campus,
          skkuId: building.skkuId,
        );
        Get.back(result: BuildingNavPayload(
          skkuId: building.skkuId,
          lat: building.lat,
          lng: building.lng,
          campus: building.campus,
        ));
      case SpaceDisplayItem(:final group, :final space):
        if (group.skkuId == null) return;
        analytics.logSearchResultTap(
          resultType: 'space',
          resultName: space.name.ko,
          campus: group.campus,
          skkuId: group.skkuId,
        );
        // Look up building coordinates from cached building list.
        final controller = Get.find<PlaceSearchController>();
        final building = await controller.findBuildingById(group.skkuId!);
        if (building != null) {
          Get.back(result: BuildingNavPayload(
            skkuId: group.skkuId!,
            lat: building.lat,
            lng: building.lng,
            campus: group.campus,
            highlightFloor: space.floor.ko,
            highlightSpaceCd: space.spaceCd,
          ));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlaceSearchController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Search bar
          _buildSearchBar(screenWidth),
          // Summary bar
          _buildSummaryBar(controller, screenWidth),
          const SizedBox(height: 10),
          // Campus tabs
          _buildCampusTabs(controller),
          const SizedBox(height: 10),
          // Results list
          _buildResultsList(controller, screenWidth),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      alignment: Alignment.centerLeft,
      height: 49,
      width: screenWidth * 0.95,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              size: 23,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 70,
              child: TextField(
                autofocus: true,
                controller: _textController,
                autocorrect: false,
                enableSuggestions: false,
                enableIMEPersonalizedLearning: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                cursorHeight: 19,
                cursorColor: AppColors.greenMain,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '성균관대 건물/공간 검색'.tr,
                  isDense: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.transparent),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(PlaceSearchController controller, double screenWidth) {
    return Container(
      alignment: Alignment.center,
      width: screenWidth,
      height: 25,
      color: Colors.grey[200],
      child: Obx(() {
        final result = controller.searchResult.value;
        final bCount = result?.buildingCount ?? 0;
        final sCount = result?.spaceCount ?? 0;
        return Row(
          children: [
            const SizedBox(width: 15),
            Text(
              '${'건물'.tr} $bCount${'건'.tr}, ${'공간'.tr} $sCount${'건'.tr}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCampusTabs(PlaceSearchController controller) {
    return Obx(() {
      return Row(
        children: [
          const SizedBox(width: 20),
          _buildTabChip(controller, SearchTab.all, '전체'.tr),
          const SizedBox(width: 8),
          _buildTabChip(controller, SearchTab.hssc, '인사캠'.tr),
          const SizedBox(width: 8),
          _buildTabChip(controller, SearchTab.nsc, '자과캠'.tr),
        ],
      );
    });
  }

  Widget _buildTabChip(
      PlaceSearchController controller, SearchTab tab, String label) {
    final isSelected = controller.currentTab.value == tab;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => controller.updateFilter(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandLight : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.brand : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.brand : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(PlaceSearchController controller, double screenWidth) {
    return Obx(() {
      final items = controller.filteredItems;
      if (items.isEmpty) {
        return Center(
          child: Text('찾는 건물이 없어요'.tr),
        );
      }
      return Expanded(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _onItemTap(item),
              child: switch (item) {
                BuildingDisplayItem(:final building) =>
                    _buildBuildingRow(building, screenWidth),
                SpaceDisplayItem(:final group, :final space) =>
                    _buildSpaceRow(group, space, screenWidth),
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildBuildingRow(
      dynamic building, double screenWidth) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.apartment, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.name.localized,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      building.campusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (building.displayNo != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        building.displayNo!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceRow(
      dynamic group, dynamic space, double screenWidth) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      height: 65,
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: Text(
                      space.name.localized,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '[${group.campusLabel}] ${group.buildingName.localized} ${space.floor.localized}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              space.spaceCd,
              style: TextStyle(
                color: Colors.grey[500],
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
