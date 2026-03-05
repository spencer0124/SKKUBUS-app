import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/pages/bus_campus/controller/bus_inja_main_controller.dart';
import 'package:skkumap/app/routes/app_routes.dart';
import 'package:skkumap/app/model/bus_schedule.dart';

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

class ESKARA extends StatelessWidget {
  const ESKARA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InjaMainController>();
    return DefaultTabController(
      length: 2,
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
                  _buildTitleBar(),
                  _buildDirectionTabs(),
                  _buildDaySelector(controller),
                ],
              ),
            ),
            // ── Content ──
            Expanded(
              child: TabBarView(
                children: [
                  _buildScheduleContent(
                    controller,
                    controller.injaBusSchedule,
                    '인사캠 → 자과캠'.tr,
                    controller.injaEtaMs,
                  ),
                  _buildScheduleContent(
                    controller,
                    controller.jainBusSchedule,
                    '자과캠 → 인사캠'.tr,
                    controller.jainEtaMs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Title Bar ──────────────────────────────────────────────────

  Widget _buildTitleBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Text(
              '‹',
              style: TextStyle(fontSize: 22, color: _textColor),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '인자셔틀'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFamily: 'WantedSansBold',
                color: _textColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.webview, arguments: {
              'title': '인자셔틀'.tr,
              'color': '003626',
              'webviewLink':
                  'https://webview.skkuuniverse.com/#/bus/campus/info',
            }),
            child: Text(
              '정보'.tr,
              style: const TextStyle(
                fontSize: 14,
                color: _heroGreen,
                fontWeight: FontWeight.w600,
                fontFamily: 'WantedSansMedium',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Direction Tabs ─────────────────────────────────────────────

  Widget _buildDirectionTabs() {
    return TabBar(
      labelColor: _heroGreen,
      unselectedLabelColor: _gray,
      labelStyle: const TextStyle(
        fontFamily: 'WantedSansBold',
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'WantedSansMedium',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: _heroGreen,
      indicatorWeight: 2,
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      tabs: [
        Tab(text: '인사캠 → 자과캠'.tr),
        Tab(text: '자과캠 → 인사캠'.tr),
      ],
    );
  }

  // ── Day Selector (Toss-style pills) ────────────────────────────

  Widget _buildDaySelector(InjaMainController controller) {
    final todayIndex = DateTime.now().weekday - 1;
    final noServiceDays = {5, 6}; // 토, 일

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Obx(() {
        return Row(
          children: List.generate(7, (index) {
            final isSelected = controller.selectedDayIndex.value == index;
            final isToday = index == todayIndex;
            final isWeekend = noServiceDays.contains(index);

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.onDaySelected(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isWeekend ? _grayLight : _heroGreen)
                        : _grayBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        controller.shortDayLabels[index].tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: isSelected || isToday
                              ? 'WantedSansBold'
                              : 'WantedSansRegular',
                          fontWeight:
                              isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : isWeekend
                                  ? _grayLight
                                  : isToday
                                      ? _heroGreen
                                      : _gray,
                        ),
                      ),
                      // Today dot indicator
                      if (isToday && !isSelected)
                        Positioned(
                          bottom: -2,
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
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  // ── Schedule Content (per tab) ─────────────────────────────────

  Widget _buildScheduleContent(
    InjaMainController controller,
    RxList<BusSchedule> scheduleList,
    String directionLabel,
    RxInt etaMs,
  ) {
    return Obx(() {
      controller.tick.value; // observe 1-min ticker for ETA refresh

      // Show nothing while initial data is loading (prevents "no service" flash)
      if (controller.isLoading.value) {
        return const SizedBox.shrink();
      }

      final schedules = scheduleList.toList();
      final isNoService = controller.isNoServiceSchedule(schedules);
      final isFriday = controller.hasMultipleRouteTypes(schedules);

      if (isNoService) {
        return _buildNoServiceCard(controller);
      }

      final heroBus = controller.getHeroBus(schedules);

      return Column(
        children: [
          // Hero card — fixed at top
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: _buildHeroCard(
                controller, heroBus, directionLabel, isFriday, etaMs.value),
          ),
          // Schedule list — scrollable
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                _buildScheduleList(controller, schedules, isFriday),
                const SizedBox(height: 12),
                // Footer
                Center(
                  child: Text(
                    '${controller.shortDayLabels[controller.selectedDayIndex.value].tr}${'요일'.tr} ${'시간표'.tr} · ${'총'.tr} ${schedules.length}${'편'.tr}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: _grayLight,
                      fontFamily: 'WantedSansRegular',
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

  // ── No Service Card ────────────────────────────────────────────

  Widget _buildNoServiceCard(InjaMainController controller) {
    final dayLabel =
        controller.shortDayLabels[controller.selectedDayIndex.value].tr;
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
                '$dayLabel${'요일은'.tr} ${'운행하지 않아요'.tr}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'WantedSansBold',
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '인자셔틀은 월요일부터 금요일까지'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: _gray,
                  fontFamily: 'WantedSansRegular',
                  height: 1.6,
                ),
              ),
              Text(
                '운행합니다'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: _gray,
                  fontFamily: 'WantedSansRegular',
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Card ──────────────────────────────────────────────────

  Widget _buildHeroCard(
    InjaMainController controller,
    BusSchedule? heroBus,
    String directionLabel,
    bool isFriday,
    int etaMs,
  ) {
    final isToday = controller.isViewingToday;
    final hasNextBus = heroBus != null;
    final cardColor = !hasNextBus
        ? _gray
        : isToday
            ? _heroGreen
            : const Color(0xFF8A9AA0); // muted grey-green for non-today
    final heroLabel =
        isToday ? '다음 셔틀'.tr : '첫 운행'.tr;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative circles
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
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 120),
              child: hasNextBus
                  ? _buildHeroContent(controller, heroBus, directionLabel,
                      heroLabel, isFriday, isToday, etaMs)
                  : _buildHeroEnded(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroContent(
    InjaMainController controller,
    BusSchedule bus,
    String directionLabel,
    String heroLabel,
    bool isFriday,
    bool isToday,
    int etaMs,
  ) {
    final etaMinutes = isToday ? controller.getMinutesUntil(bus) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtitle
        Text(
          '$heroLabel · $directionLabel',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.75),
            fontWeight: FontWeight.w500,
            fontFamily: 'WantedSansMedium',
          ),
        ),
        const SizedBox(height: 6),
        // Time + Bus count
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bus.operatingHours,
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                fontFamily: 'WantedSansBold',
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
                    fontFamily: 'WantedSansRegular',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${bus.busCount}대',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'WantedSansBold',
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Badges row
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (etaMinutes != null)
              _heroBadge(
                '${controller.formatETA(etaMinutes)} ${'출발'.tr}',
                Colors.white.withValues(alpha: 0.22),
              ),
            if (isToday && etaMs > 0)
              _heroBadge(
                '${controller.formatDuration(etaMs)} ${'소요 예상'.tr}',
                Colors.white.withValues(alpha: 0.15),
              ),
            if (bus.specialNotes != null && bus.specialNotes!.isNotEmpty)
              _heroBadge(
                '📌 ${bus.specialNotes!.replaceAll(r'\n', ' ')}',
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
            fontFamily: 'WantedSansMedium',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '운행 종료'.tr,
          style: const TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            fontFamily: 'WantedSansBold',
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
          fontFamily: 'WantedSansBold',
          color: Colors.white,
        ),
      ),
    );
  }

  // ── Schedule List ──────────────────────────────────────────────

  Widget _buildScheduleList(
    InjaMainController controller,
    List<BusSchedule> schedules,
    bool isFriday,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Column header
          _buildColumnHeader(isFriday),
          // Rows
          ...List.generate(schedules.length, (index) {
            return _buildScheduleRow(
              controller,
              schedules[index],
              index,
              schedules.length,
              isFriday,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(bool isFriday) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15), // dot space
          SizedBox(
            width: isFriday ? 80 : 105,
            child: Text(
              '시간'.tr,
              style: const TextStyle(
                fontSize: 11,
                color: _grayLight,
                fontWeight: FontWeight.w600,
                fontFamily: 'WantedSansMedium',
              ),
            ),
          ),
          if (isFriday)
            SizedBox(
              width: 68,
              child: Text(
                '노선'.tr,
                style: const TextStyle(
                  fontSize: 11,
                  color: _grayLight,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'WantedSansMedium',
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
                fontFamily: 'WantedSansMedium',
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
                fontFamily: 'WantedSansMedium',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(
    InjaMainController controller,
    BusSchedule schedule,
    int index,
    int total,
    bool isFriday,
  ) {
    final isPast = controller.isPastBus(schedule);
    final isNext = controller.isViewingToday && schedule.isFastestBus;
    final textColor = isPast ? _grayLight : isNext ? _heroGreen : _textColor;

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
                  ? _grayLight // non-today: all dots grey
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
            width: isFriday ? 80 : 105,
            child: Row(
              children: [
                Text(
                  schedule.operatingHours,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                    fontFamily:
                        isNext ? 'WantedSansBold' : 'WantedSansMedium',
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
                        fontFamily: 'WantedSansBold',
                        color: _heroGreen,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Route type (Friday only)
          if (isFriday)
            SizedBox(
              width: 68,
              child: Text(
                schedule.routeType == 'hakbu' ? '학부대학'.tr : '일반'.tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'WantedSansMedium',
                  color: isPast ? _grayLight : _textColor,
                ),
              ),
            ),
          // Bus count
          SizedBox(
            width: 44,
            child: Text(
              '${schedule.busCount}대',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'WantedSansMedium',
                color: isPast ? _grayLight : _textColor,
              ),
            ),
          ),
          // Special notes
          Expanded(
            child: Text(
              schedule.specialNotes?.replaceAll(r'\n', ' ') ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: schedule.specialNotes != null
                    ? FontWeight.w600
                    : FontWeight.w400,
                fontFamily: schedule.specialNotes != null
                    ? 'WantedSansMedium'
                    : 'WantedSansRegular',
                color: isPast
                    ? _grayLight
                    : schedule.specialNotes != null
                        ? _orange
                        : _grayLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
