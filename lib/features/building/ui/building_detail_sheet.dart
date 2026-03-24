import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/design/sds_design.dart';
import 'package:skkumap/features/building/controller/building_detail_controller.dart';
import 'package:skkumap/features/building/model/building.dart';
import 'package:skkumap/features/building/model/building_detail.dart';
import 'package:skkumap/features/building/model/building_models.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/core/services/ad_service.dart';
import 'package:skkumap/core/services/analytics_service.dart';
import 'package:skkumap/core/utils/native_ad_widget.dart';

class BuildingDetailSheet extends StatefulWidget {
  final int skkuId;

  const BuildingDetailSheet({super.key, required this.skkuId});

  /// Show the building detail bottom sheet.
  static Future<void> show(
    int skkuId, {
    String? highlightFloor,
    String? highlightSpaceCd,
    String? source,
  }) {
    final ctrl = Get.find<BuildingDetailController>();
    ctrl.loadDetail(
      skkuId,
      highlightFloor: highlightFloor,
      highlightSpaceCd: highlightSpaceCd,
      source: source,
    );
    return Get.bottomSheet(
      BuildingDetailSheet(skkuId: skkuId),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
    ).then((_) {
      Get.find<AdService>().recycleNative('native_building');
    });
  }

  @override
  State<BuildingDetailSheet> createState() => _BuildingDetailSheetState();
}

class _BuildingDetailSheetState extends State<BuildingDetailSheet> {
  final _sheetCtrl = DraggableScrollableController();
  double _extent = 0.55;
  bool _showTitleInBar = false;

  @override
  void initState() {
    super.initState();
    _sheetCtrl.addListener(_onExtentChanged);
  }

  void _onExtentChanged() {
    if (mounted) setState(() => _extent = _sheetCtrl.size);
  }

  @override
  void dispose() {
    _sheetCtrl.dispose();
    super.dispose();
  }

  bool get _isFullScreen => _extent > 0.95;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BuildingDetailController>();
    return DraggableScrollableSheet(
      controller: _sheetCtrl,
      initialChildSize: 0.55,
      minChildSize: 0.15,
      maxChildSize: 1.0,
      snap: true,
      snapSizes: const [0.55, 1.0],
      shouldCloseOnMinExtent: true,
      expand: false,
      builder: (context, scrollController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(_isFullScreen ? 0 : SdsRadius.full),
            ),
          ),
          child: Obx(() {
            if (ctrl.isLoading.value) return _buildLoading();
            if (ctrl.hasError.value) return _buildError(ctrl);
            final detail = ctrl.detail.value;
            if (detail == null) return const SizedBox.shrink();
            return _buildContent(detail, ctrl, scrollController);
          }),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(color: SdsColors.brand),
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
              '건물 정보를 불러오지 못했어요'.tr,
              style: SdsTypo.t6(weight: FontWeight.w500)
                  .copyWith(color: SdsColors.grey900),
            ),
            const SizedBox(height: SdsSpacing.md),
            TextButton(
              onPressed: () => ctrl.loadDetail(widget.skkuId),
              child: Text(
                '다시 시도'.tr,
                style: const TextStyle(color: SdsColors.brand),
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
    final hasDescription = building.description != null &&
        building.description!.localized.isNotEmpty;
    final hasAccessibility =
        building.accessibility != null && building.accessibility!.hasAny;
    final hasPhoto = building.image != null;

    final topPad = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        // Top bar (fullscreen) or drag handle (half-expanded)
        if (_isFullScreen)
          _buildTopBar(building, topPad)
        else
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                top: SdsSpacing.md,
                bottom: SdsSpacing.xs,
              ),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: SdsColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

        // Scrollable content
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.depth != 0) return false;
              final offset = notification.metrics.pixels;
              final threshold = hasPhoto ? 240.0 : 80.0;
              final shouldShow = offset > threshold;
              if (shouldShow != _showTitleInBar) {
                setState(() => _showTitleInBar = shouldShow);
              }
              return false;
            },
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                // ══ Photo with gradient + floating buttons ══
                if (hasPhoto) _buildPhoto(building),

                // ══ Header ══
                _buildHeader(building, showClose: !hasPhoto),

                // ══ Tags row (accessibility) ══
                if (hasAccessibility) _buildTagsRow(building.accessibility!),

                // ══ Section: 층별 안내 ══
                if (detail.hasFloors) ...[
                  _sectionGap(),
                  SdsListHeader(title: '층별 안내'.tr),
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

                // ══ Section: 건물 정보 (description) ══
                if (hasDescription) ...[
                  _sectionGap(),
                  SdsListHeader(title: '건물 정보'.tr),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SdsSpacing.xl,
                    ),
                    child: SdsParagraph(
                      text: building.description!.localized,
                      maxLines: 3,
                    ),
                  ),
                ],

                // ══ Section: 연결 건물 ══
                if (detail.hasConnections) ...[
                  _sectionGap(),
                  _buildConnectionsSection(detail),
                ],

                // ══ Section: 광고 ══
                Obx(() {
                  final adService = Get.find<AdService>();
                  if (!adService.isNativeLoaded('native_building').value) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      _sectionGap(),
                      NativeAdContainer(
                        nativeAd: adService.getNativeAd('native_building'),
                        height: kNativeSmallHeight,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Top bar (fullscreen mode) ──

  Widget _buildTopBar(Building building, double topPad) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: topPad),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: SdsSpacing.xs),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      _showTitleInBar ? SdsColors.grey100 : Colors.transparent,
                ),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: SdsSpacing.base),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _showTitleInBar ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            building.name.localized,
                            style: SdsTypo.t6(weight: FontWeight.w600)
                                .copyWith(color: SdsColors.grey900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (building.displayNo != null) ...[
                          const SizedBox(width: SdsSpacing.sm),
                          SdsBadge(
                            text: building.displayNo!,
                            variant: SdsBadgeVariant.weak,
                            color: SdsBadgeColor.brand,
                            size: SdsBadgeSize.xsmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close,
                      size: 20, color: SdsColors.grey400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Photo with gradient overlay and floating action buttons ──

  Widget _buildPhoto(Building building) {
    const photoHeight = 240.0;

    return Stack(
      children: [
        // Photo with grey fallback
        Container(
          height: photoHeight,
          width: double.infinity,
          color: SdsColors.grey100,
          child: Image.network(
            building.image!.url,
            headers: const {'Referer': 'https://www.skku.edu/'},
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.expand(),
          ),
        ),

        // Gradient: transparent → white
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.white],
              ),
            ),
          ),
        ),

        // Floating action buttons (fade out when fullscreen — top bar takes over)
        Positioned(
          top: SdsSpacing.sm,
          left: SdsSpacing.base,
          right: SdsSpacing.base,
          child: IgnorePointer(
            ignoring: _isFullScreen,
            child: AnimatedOpacity(
              opacity: _isFullScreen ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  const Spacer(),
                  _circleButton(Icons.close, onTap: () => Get.back()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Floating circle button (glass morphism style) ──

  Widget _circleButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: SdsColors.grey800),
      ),
    );
  }

  // ── Header ──

  Widget _buildHeader(Building building, {bool showClose = true}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SdsSpacing.xl,
        SdsSpacing.md,
        SdsSpacing.sm,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name row: 건물명 + 번호 뱃지
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        building.name.localized,
                        style: SdsTypo.t3(weight: FontWeight.w700)
                            .copyWith(color: SdsColors.grey900),
                      ),
                    ),
                    if (building.displayNo != null) ...[
                      const SizedBox(width: SdsSpacing.sm),
                      SdsBadge(
                        text: building.displayNo!,
                        variant: SdsBadgeVariant.weak,
                        color: SdsBadgeColor.brand,
                        size: SdsBadgeSize.xsmall,
                      ),
                    ],
                  ],
                ),
                // Campus subtitle
                const SizedBox(height: SdsSpacing.xs),
                Text(
                  building.campusLabel,
                  style: SdsTypo.t7().copyWith(color: SdsColors.grey500),
                ),
              ],
            ),
          ),
          if (showClose)
            IconButton(
              onPressed: () => Get.back(),
              icon:
                  const Icon(Icons.close, size: 20, color: SdsColors.grey400),
              padding: const EdgeInsets.all(SdsSpacing.sm),
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  // ── Tags row (accessibility) ──

  Widget _buildTagsRow(Accessibility accessibility) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SdsSpacing.xl, SdsSpacing.md, SdsSpacing.xl, 0,
      ),
      child: Wrap(
        spacing: SdsSpacing.sm,
        runSpacing: SdsSpacing.sm,
        children: [
          if (accessibility.elevator)
            SdsBadge(
              icon: const Icon(Icons.elevator_outlined),
              text: '엘리베이터'.tr,
              variant: SdsBadgeVariant.weak,
              color: SdsBadgeColor.elephant,
              size: SdsBadgeSize.small,
            ),
          if (accessibility.toilet)
            SdsBadge(
              icon: const Icon(Icons.accessible),
              text: '장애인 화장실'.tr,
              variant: SdsBadgeVariant.weak,
              color: SdsBadgeColor.elephant,
              size: SdsBadgeSize.small,
            ),
        ],
      ),
    );
  }

  // ── Section gap (8px grey50) ──

  Widget _sectionGap() {
    return Container(
      height: 8,
      color: SdsColors.grey50,
      margin: const EdgeInsets.only(top: SdsSpacing.lg),
    );
  }

  // ── Connections section ──

  Widget _buildConnectionsSection(BuildingDetail detail) {
    final grouped = <int, List<BuildingConnection>>{};
    for (final c in detail.connections) {
      grouped.putIfAbsent(c.targetSkkuId, () => []).add(c);
    }
    final groups = grouped.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SdsListHeader(title: '연결 건물'.tr),

        // CTA row
        SdsListRow(
          left: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SdsColors.brandLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.hub_outlined,
              size: 20,
              color: SdsColors.brand,
            ),
          ),
          contents: SdsListRowTexts.twoRow(
            top: '건물 연결지도 보기'.tr,
            bottom: '층별 연결 통로를 확인할 수 있어요'.tr,
          ),
          withArrow: true,
          border: SdsListRowBorder.none,
          horizontalPadding: SdsListRowHPad.small,
          onTap: () {
            final d = Get.find<BuildingDetailController>().detail.value;
            if (d != null) {
              Get.find<AnalyticsService>().logConnectionMapOpen(
                campus: d.building.campus,
              );
            }
            Get.toNamed(Routes.mapHssc);
          },
        ),

        // Connection list
        ...groups.asMap().entries.map((entry) {
          final group = entry.value.value;
          final first = group.first;

          return SdsListRow(
            left: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SdsColors.grey100,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                first.targetDisplayNo ?? '',
                style: SdsTypo.t7(weight: FontWeight.w700)
                    .copyWith(color: SdsColors.grey600),
              ),
            ),
            contents: SdsListRowTexts.twoRow(
              top: first.targetName.localized,
              bottom: _connectionFloorDesc(group),
            ),
            withArrow: true,
            border: SdsListRowBorder.indentedLight,
            horizontalPadding: SdsListRowHPad.small,
            onTap: () {
              Get.find<AnalyticsService>().logConnectionTap(
                fromSkkuId: widget.skkuId,
                targetSkkuId: first.targetSkkuId,
              );
              Get.back();
              Future.delayed(const Duration(milliseconds: 300), () {
                BuildingDetailSheet.show(first.targetSkkuId,
                    source: 'connection');
              });
            },
          );
        }),
      ],
    );
  }
}

// ─── Floor shortcode helpers ───

String _floorShortCode(LocalizedText floor) {
  final ko = floor.ko;
  final basement = RegExp(r'지하\s*(\d+)').firstMatch(ko);
  if (basement != null) return 'B${basement.group(1)}';
  final num = RegExp(r'(\d+)').firstMatch(ko);
  if (num != null) return '${num.group(1)}F';
  return ko.length > 3 ? ko.substring(0, 3) : ko;
}


/// Builds "3층 연결통로" or "1층 · 5층 · 8층 연결통로" from grouped connections.
String _connectionFloorDesc(List<BuildingConnection> group) {
  final floors = group.map((c) => c.fromFloor.localized).toList();
  return '${floors.join(' · ')} ${'연결통로'.tr}';
}

// ─── Floor Tile (accordion) ───

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

      return SdsListRow(
        border: index == 0
            ? SdsListRowBorder.none
            : SdsListRowBorder.indentedLight,
        horizontalPadding: SdsListRowHPad.small,
        verticalPadding: SdsListRowVPad.large,
        left: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isExpanded ? SdsColors.grey900 : SdsColors.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            _floorShortCode(floor.floor),
            style: SdsTypo.t7(weight: FontWeight.w700).copyWith(
              color: isExpanded ? Colors.white : SdsColors.grey600,
            ),
          ),
        ),
        contents: SdsListRowTexts.twoRow(
          top: floor.floor.localized,
          bottom: '${'호실'.tr} ${floor.spaces.length}${'개'.tr}',
        ),
        right: _buildConnectionTags(),
        isExpanded: isExpanded,
        expandedContent: _buildSpaceList(),
        onTap: () => ctrl.toggleFloor(index),
      );
    });
  }

  Widget? _buildConnectionTags() {
    final tags = connections
        .where((c) => c.fromFloor.ko == floor.floor.ko)
        .map((c) => c.targetName.localized)
        .toSet()
        .toList();
    if (tags.isEmpty) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: tags
          .map((name) => Padding(
                padding: const EdgeInsets.only(right: SdsSpacing.sm),
                child: SdsBadge(
                  icon: const Icon(Icons.arrow_forward, size: 10),
                  text: name,
                  variant: SdsBadgeVariant.weak,
                  color: SdsBadgeColor.brand,
                  size: SdsBadgeSize.xsmall,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSpaceList() {
    return Obx(() {
      final showAll = ctrl.showAllSpaces[index] == true;
      final spaces = floor.spaces;
      const maxVisible = 5;
      final visibleSpaces =
          showAll ? spaces : spaces.take(maxVisible).toList();
      final remaining = spaces.length - maxVisible;

      return Padding(
        // TODO: indent = SdsListRow hPad + left width + left gap.
        // If SdsListRow layout changes, update this value.
        // 76px = hPad(20) + badge(40) + gap(16)
        padding: const EdgeInsets.fromLTRB(76, 0, SdsSpacing.lg, SdsSpacing.md),
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
                  color: isHighlighted ? SdsColors.brandLight : null,
                  border: !isLastVisible
                      ? const Border(
                          bottom: BorderSide(
                            color: SdsColors.grey50,
                            width: 1,
                          ),
                        )
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        space.name.localized,
                        style: SdsTypo.t7(
                          weight: isHighlighted
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ).copyWith(
                          color: isHighlighted
                              ? SdsColors.brand
                              : SdsColors.grey700,
                        ),
                      ),
                    ),
                    const SizedBox(width: SdsSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SdsSpacing.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? SdsColors.brandLight
                            : SdsColors.grey100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        space.spaceCd,
                        style: SdsTypo.sub12(weight: FontWeight.w600)
                            .copyWith(
                          color: isHighlighted
                              ? SdsColors.brand
                              : SdsColors.grey400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // "+ N개 더보기"
            if (!showAll && remaining > 0)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ctrl.showAllSpacesFor(index),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        '+ $remaining${'개 더보기'.tr}',
                        style: SdsTypo.sub12(weight: FontWeight.w600)
                            .copyWith(color: SdsColors.brand),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
