import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/features/transit/controller/bus_campus_controller.dart';
import 'package:skkumap/core/routes/app_routes.dart';
import 'package:skkumap/features/transit/model/bus_group.dart';
import 'package:skkumap/features/transit/model/smart_schedule.dart';
import 'package:skkumap/core/utils/color_utils.dart';
import 'package:skkumap/core/widgets/custom_navigation.dart';

// ── Colors ───────────────────────────────────────────────────────

const _heroGreen = Color(0xFF1A7F4B);
const _greenLight = Color(0xFFF0FAF4);
const _greenBadge = Color(0xFFD9F2E6);
const _greenMid = Color(0xFF1BC47D);
const _orange = Color(0xFFE87A3B);
const _textColor = Color(0xFF191F28);
const _gray = Color(0xFF9EA4AA);
const _grayLight = Color(0xFFC9CDD2);
const _grayBg = Color(0xFFF5F6F8);

// ── Main Screen ──────────────────────────────────────────────────

class BusCampusScreen extends StatelessWidget {
  const BusCampusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusScheduleController>();
    final BusGroup group = Get.arguments['busConfig'];
    controller.setGroup(group);
    controller.loadInitialData();

    final services = group.services;
    final infoFeature = group.features
        .where((f) => f['type'] == 'info')
        .firstOrNull;

    return DefaultTabController(
      length: services.length,
      child: Scaffold(
        backgroundColor: _grayBg,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: Column(
          children: [
            // ── White header section ──
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  CustomNavigationBar(
                    title: group.label,
                    isDisplayLeftBtn: true,
                    isDisplayRightBtn: infoFeature != null,
                    leftBtnAction: () => Get.back(),
                    rightBtnAction: () {
                      if (infoFeature != null) {
                        Get.toNamed(Routes.webview, arguments: {
                          'title': group.label,
                          'color': group.card.themeColor
                              .toARGB32()
                              .toRadixString(16)
                              .substring(2),
                          'webviewLink': infoFeature['url'],
                          'screenName': group.id,
                        });
                      }
                    },
                    rightBtnType: CustomNavigationBtnType.info,
                  ),
                ],
              ),
            ),
            _buildNotices(controller),
            Container(
              color: Colors.white,
              child: _buildServiceTabs(controller, services),
            ),
            // ── Content ──
            Expanded(
              child: Obx(() {
                controller.tick.value; // observe ticker

                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: _heroGreen),
                  );
                }

                if (controller.hasError.value &&
                    controller.schedule.value == null) {
                  return _buildErrorState(controller);
                }

                final s = controller.schedule.value;
                if (s == null) return const SizedBox.shrink();

                if (s.isSuspended) return _buildSuspendedState(s);
                if (s.isNoData) return _buildNoDataState(s);

                // active — show day selector, notices, schedule
                return Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          _buildDaySelector(controller),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildActiveContent(controller, group),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Service Tabs ──────────────────────────────────────────────

  Widget _buildServiceTabs(
      BusScheduleController controller, List<BusService> services) {
    return TabBar(
      labelColor: _heroGreen,
      unselectedLabelColor: _gray,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: _heroGreen,
      indicatorWeight: 2,
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: (index) => controller.switchService(services[index]),
      tabs: services.map((s) => Tab(text: s.label)).toList(),
    );
  }

  // ── Suspended State ────────────────────────────────────────────

  Widget _buildSuspendedState(SmartSchedule s) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pause_circle_outline,
                  size: 48, color: _gray),
              const SizedBox(height: 14),
              if (s.message != null)
                Text(
                  s.message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),
              if (s.resumeDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  s.resumeDate!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _gray,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── No Data State ──────────────────────────────────────────────

  Widget _buildNoDataState(SmartSchedule s) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 48, color: _gray),
              const SizedBox(height: 14),
              if (s.message != null)
                Text(
                  s.message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Error State ────────────────────────────────────────────────

  Widget _buildErrorState(BusScheduleController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: _gray),
              const SizedBox(height: 14),
              Text(
                '데이터를 불러올 수 없어요'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: controller.retry,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: _heroGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '다시 시도'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Day Selector (date-based chips) ───────────────────────────

  Widget _buildDaySelector(BusScheduleController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
      child: Obx(() {
        final s = controller.schedule.value;
        if (s == null || !s.isActive) return const SizedBox.shrink();
        final todayStr = _formatDate(DateTime.now());

        // Check if any day has a label — if so, all chips reserve label space.
        final hasAnyLabel = s.days.any((d) => d.label != null);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(s.days.length, (index) {
              final day = s.days[index];
              final isSelected = controller.selectedDayIndex.value == index;
              final isToday = day.date == todayStr;
              final isHidden = day.isHidden;
              final isNoService = day.isNoService;

              final dateObj = DateTime.parse(day.date);
              final dateLabel = '${dateObj.month}/${dateObj.day}';
              final dayName = _shortDayName(day.dayOfWeek);

              return Expanded(
                child: GestureDetector(
                  onTap:
                      isHidden ? null : () => controller.onDaySelected(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isNoService ? _grayLight : _heroGreen)
                          : _grayBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dateLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected || isToday
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isHidden
                                ? _grayLight.withValues(alpha: 0.5)
                                : isSelected
                                    ? Colors.white
                                    : isNoService
                                        ? _grayLight
                                        : isToday
                                            ? _heroGreen
                                            : _gray,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              dayName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isHidden
                                    ? _grayLight.withValues(alpha: 0.5)
                                    : isSelected
                                        ? Colors.white
                                        : isNoService
                                            ? _grayLight
                                            : isToday
                                                ? _heroGreen
                                                : _gray,
                              ),
                            ),
                            if (isToday && !isSelected)
                              Positioned(
                                bottom: -4,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: _heroGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (hasAnyLabel) ...[
                          const SizedBox(height: 2),
                          Text(
                            day.label ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8,
                              color: day.label != null
                                  ? (isSelected ? Colors.white70 : _gray)
                                  : Colors.transparent,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  // ── Notices ────────────────────────────────────────────────────

  Widget _buildNotices(BusScheduleController controller) {
    return Obx(() {
      final notices = controller.dayNotices;
      if (notices.isEmpty) return const SizedBox.shrink();

      return Column(
        children: notices.map((notice) {
          final isWarning = notice.style == 'warning';
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isWarning
                ? const Color(0xFFFFF3E0)
                : const Color(0xFFE3F2FD),
            child: Row(
              children: [
                Icon(
                  isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
                  size: 16,
                  color: isWarning
                      ? const Color(0xFFE65100)
                      : const Color(0xFF1565C0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notice.text,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isWarning
                          ? const Color(0xFFE65100)
                          : const Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  // ── Active Content ─────────────────────────────────────────────

  Widget _buildActiveContent(
      BusScheduleController controller, BusGroup group) {
    return Obx(() {
      controller.tick.value;

      final day = controller.selectedDay;
      if (day == null) return const SizedBox.shrink();

      switch (day.display) {
        case 'noService':
          return _buildNoServiceCard(controller, day);
        case 'hidden':
          return const SizedBox.shrink();
        default: // 'schedule'
          return _buildScheduleContent(controller, group);
      }
    });
  }

  // ── Schedule Content ──────────────────────────────────────────

  Widget _buildScheduleContent(
      BusScheduleController controller, BusGroup group) {
    return Obx(() {
      controller.tick.value;
      final entries = controller.currentEntries;
      final showRouteBadges = controller.hasMultipleRouteTypes(entries);
      final heroBus = controller.getHeroBus(entries);

      return Column(
        children: [
          // Hero card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: _buildHeroCard(controller, heroBus, showRouteBadges),
          ),
          // Schedule list
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                _buildScheduleList(
                    controller, entries, showRouteBadges, heroBus),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    '${'시간표'.tr} · ${'총'.tr} ${entries.length}${'편'.tr}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: _grayLight,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      );
    });
  }

  // ── No Service Card ───────────────────────────────────────────

  Widget _buildNoServiceCard(
      BusScheduleController controller, DaySchedule day) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🚌', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              Text(
                '운행하지 않아요'.tr,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
              if (day.label != null) ...[
                const SizedBox(height: 8),
                Text(
                  day.label!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _gray,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Card ─────────────────────────────────────────────────

  Widget _buildHeroCard(
    BusScheduleController controller,
    ScheduleEntry? heroBus,
    bool showRouteBadges,
  ) {
    final isToday = controller.isViewingToday;
    final hasNextBus = heroBus != null;
    final cardColor = !hasNextBus
        ? _gray
        : isToday
            ? _heroGreen
            : const Color(0xFF8A9AA0);
    final heroLabel = isToday ? '다음 셔틀'.tr : '첫 운행'.tr;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120),
              child: hasNextBus
                  ? _buildHeroContent(
                      controller, heroBus, heroLabel, showRouteBadges, isToday)
                  : _buildHeroEnded(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroContent(
    BusScheduleController controller,
    ScheduleEntry bus,
    String heroLabel,
    bool showRouteBadges,
    bool isToday,
  ) {
    final etaMinutes = isToday ? controller.getMinutesUntil(bus) : null;
    final badge = controller.getRouteBadge(bus.routeType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$heroLabel · ${controller.currentService.value.label}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.75),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bus.time,
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1.5,
                height: 1,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '운영대수'.tr,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${bus.busCount}대',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (etaMinutes != null)
              _heroBadge(
                '${controller.formatETA(etaMinutes)} ${'출발'.tr}',
                Colors.white.withValues(alpha: 0.22),
              ),
            if (showRouteBadges)
              _heroBadge(
                badge.label,
                Colors.white.withValues(alpha: 0.15),
              ),
            if (bus.notes != null && bus.notes!.isNotEmpty)
              _heroBadge(
                bus.notes!,
                Colors.white.withValues(alpha: 0.15),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroEnded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '다음 셔틀'.tr,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.75),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '운행 종료'.tr,
          style: const TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -1.5,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _heroBadge(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ── Schedule List ─────────────────────────────────────────────

  Widget _buildScheduleList(
    BusScheduleController controller,
    List<ScheduleEntry> entries,
    bool showRouteBadges,
    ScheduleEntry? heroBus,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildColumnHeader(showRouteBadges),
          ...List.generate(entries.length, (index) {
            return _buildScheduleRow(
              controller,
              entries[index],
              index,
              entries.length,
              showRouteBadges,
              heroBus,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(bool showRouteBadges) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          SizedBox(
            width: showRouteBadges ? 80 : 105,
            child: Text(
              '시간'.tr,
              style: const TextStyle(
                fontSize: 11,
                color: _grayLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showRouteBadges)
            SizedBox(
              width: 68,
              child: Text(
                '노선'.tr,
                style: const TextStyle(
                  fontSize: 11,
                  color: _grayLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(
            width: 44,
            child: Text(
              '대수'.tr,
              style: const TextStyle(
                fontSize: 11,
                color: _grayLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '특이사항'.tr,
              style: const TextStyle(
                fontSize: 11,
                color: _grayLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(
    BusScheduleController controller,
    ScheduleEntry entry,
    int index,
    int total,
    bool showRouteBadges,
    ScheduleEntry? heroBus,
  ) {
    final isPast = controller.isPastBus(entry);
    final isNext =
        controller.isViewingToday && heroBus?.index == entry.index;
    final textColor = isPast ? _grayLight : isNext ? _heroGreen : _textColor;
    final badge = controller.getRouteBadge(entry.routeType);
    final badgeColor = parseHexColor(badge.color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      decoration: BoxDecoration(
        color: isNext ? _greenLight : Colors.white,
        border: index < total - 1
            ? const Border(bottom: BorderSide(color: _grayBg))
            : null,
      ),
      child: Row(
        children: [
          // Timeline dot
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: !controller.isViewingToday
                  ? _grayLight
                  : isPast
                      ? const Color(0xFFE4E6E8)
                      : isNext
                          ? _heroGreen
                          : _greenMid,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          // Time + "다음" badge
          SizedBox(
            width: showRouteBadges ? 80 : 105,
            child: Row(
              children: [
                Text(
                  entry.time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (isNext) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _greenBadge,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '다음'.tr,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _heroGreen,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Route type badge
          if (showRouteBadges)
            SizedBox(
              width: 68,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPast
                      ? _grayBg
                      : badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPast ? _grayLight : badgeColor,
                  ),
                ),
              ),
            ),
          // Bus count
          SizedBox(
            width: 44,
            child: Text(
              '${entry.busCount}대',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPast ? _grayLight : _textColor,
              ),
            ),
          ),
          // Notes
          Expanded(
            child: Text(
              entry.notes?.replaceAll(r'\n', ' ') ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: entry.notes != null
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isPast
                    ? _grayLight
                    : entry.notes != null
                        ? _orange
                        : _grayLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────

  String _shortDayName(int dayOfWeek) {
    const names = ['월', '화', '수', '목', '금', '토', '일'];
    if (dayOfWeek >= 1 && dayOfWeek <= 7) return names[dayOfWeek - 1];
    return '';
  }

  static String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
