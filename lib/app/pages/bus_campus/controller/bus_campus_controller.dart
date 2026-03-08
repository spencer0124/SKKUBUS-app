import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skkumap/app/data/repositories/bus_repository.dart';
import 'package:skkumap/app/data/result.dart';
import 'package:skkumap/app/model/bus_group.dart';
import 'package:skkumap/app/model/week_schedule.dart';
import 'package:skkumap/app/utils/app_logger.dart';

// ── Lifecycle observer ─────────────────────────────────────────────

class BusScheduleLifeCycle extends GetxController with WidgetsBindingObserver {
  BusScheduleController controller = Get.find<BusScheduleController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      controller._resetToToday();
      controller._fetchCurrentWeek();
    }
  }
}

// ── Main controller ────────────────────────────────────────────────

class BusScheduleController extends GetxController {
  final _busRepo = Get.find<BusRepository>();

  late BusGroup group;
  bool _configSet = false;
  bool _dataLoaded = false;

  // Current service (tab)
  late Rx<BusService> currentService;

  // Week schedule data
  var weekSchedule = Rx<WeekSchedule?>(null);
  var selectedDayIndex = 0.obs;
  var isLoading = true.obs;

  // ETag cache per serviceId
  final _etagMap = <String, String>{};

  // 1-minute ticker for ETA refresh
  Timer? _etaTimer;
  var tick = 0.obs;

  void setGroup(BusGroup g) {
    if (_configSet) return;
    _configSet = true;
    group = g;
    currentService = Rx(group.services.firstWhere(
      (s) => s.serviceId == group.defaultServiceId,
      orElse: () => group.services.first,
    ));
  }

  @override
  void onInit() {
    super.onInit();
    _startEtaTicker();
  }

  /// Called after setGroup to load initial data
  Future<void> loadInitialData() async {
    if (_dataLoaded) return;
    _dataLoaded = true;
    try {
      await _fetchCurrentWeek();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Service tab switching ─────────────────────────────────────────

  void switchService(BusService service) {
    currentService.value = service;
    weekSchedule.value = null;
    selectedDayIndex.value = 0;
    isLoading.value = true;
    _fetchCurrentWeek().then((_) => isLoading.value = false);
  }

  // ── Week data fetch ───────────────────────────────────────────────

  Future<void> _fetchCurrentWeek({String? from}) async {
    final svc = currentService.value;
    final etag = _etagMap[_etagKey(svc.serviceId, from)];

    final result = await _busRepo.getWeekSchedule(
      svc.weekEndpoint,
      from: from,
      ifNoneMatch: etag,
    );

    switch (result) {
      case Ok(:final data):
        if (!data.notModified && data.data != null) {
          weekSchedule.value = data.data;
          _etagMap[_etagKey(svc.serviceId, from)] = data.etag ?? '';
          _autoSelectToday();
        }
      case Err(:final failure):
        logger.e('Schedule fetch failed: $failure');
    }
  }

  String _etagKey(String serviceId, String? from) => '$serviceId:${from ?? ''}';

  // ── Week navigation ───────────────────────────────────────────────

  void goToPreviousWeek() {
    final ws = weekSchedule.value;
    if (ws == null) return;
    final current = DateTime.parse(ws.from);
    final prev = current.subtract(const Duration(days: 7));
    selectedDayIndex.value = 0;
    isLoading.value = true;
    _fetchCurrentWeek(from: _formatDate(prev)).then((_) {
      isLoading.value = false;
    });
  }

  void goToNextWeek() {
    final ws = weekSchedule.value;
    if (ws == null) return;
    final current = DateTime.parse(ws.from);
    final next = current.add(const Duration(days: 7));
    selectedDayIndex.value = 0;
    isLoading.value = true;
    _fetchCurrentWeek(from: _formatDate(next)).then((_) {
      isLoading.value = false;
    });
  }

  // ── Day selection ─────────────────────────────────────────────────

  void onDaySelected(int index) {
    final day = weekSchedule.value?.days[index];
    if (day == null || day.isHidden) return;
    selectedDayIndex.value = index;
  }

  void _autoSelectToday() {
    final ws = weekSchedule.value;
    if (ws == null) return;
    final todayStr = _formatDate(DateTime.now());
    final idx = ws.days.indexWhere((d) => d.date == todayStr);
    selectedDayIndex.value = idx >= 0 ? idx : 0;
  }

  void _resetToToday() {
    _autoSelectToday();
  }

  // ── Computed getters ──────────────────────────────────────────────

  DaySchedule? get selectedDay {
    final ws = weekSchedule.value;
    if (ws == null || selectedDayIndex.value >= ws.days.length) return null;
    return ws.days[selectedDayIndex.value];
  }

  List<ScheduleEntry> get currentEntries => selectedDay?.schedule ?? [];

  bool get isNoService => selectedDay?.isNoService ?? false;

  String? get dayLabel => selectedDay?.label;

  List<ScheduleNotice> get dayNotices => selectedDay?.notices ?? [];

  bool get isViewingToday {
    final day = selectedDay;
    if (day == null) return false;
    return day.date == _formatDate(DateTime.now());
  }

  // ── Hero bus ──────────────────────────────────────────────────────

  ScheduleEntry? getHeroBus(List<ScheduleEntry> entries) {
    if (entries.isEmpty) return null;
    if (isViewingToday) {
      final showUntil = group.heroCard?.showUntilMinutesBefore ?? 0;
      final now = DateTime.now();
      final currentMinutes = now.hour * 60 + now.minute;
      for (final entry in entries) {
        final entryMinutes = _parseTimeMinutes(entry.time);
        if (entryMinutes == null) continue;
        // Skip entries that are too close to departure
        if (showUntil > 0 && (entryMinutes - showUntil) < currentMinutes) {
          continue;
        }
        if (entryMinutes > currentMinutes) return entry;
      }
      return null; // all buses departed
    }
    return entries.firstOrNull;
  }

  int? getMinutesUntil(ScheduleEntry entry) {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final entryMinutes = _parseTimeMinutes(entry.time);
    if (entryMinutes == null) return null;
    final diff = entryMinutes - currentMinutes;
    return diff > 0 ? diff : null;
  }

  String formatETA(int minutes) {
    if (minutes < 60) return '$minutes${'분'.tr} ${'후'.tr}';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m > 0) return '$h${'시간_unit'.tr} $m${'분'.tr} ${'후'.tr}';
    return '$h${'시간_unit'.tr} ${'후'.tr}';
  }

  String formatDuration(int ms) {
    final totalMinutes = (ms / 60000).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h > 0 && m > 0) return '$h${'시간_unit'.tr} $m${'분'.tr}';
    if (h > 0) return '$h${'시간_unit'.tr}';
    return '$m${'분'.tr}';
  }

  // ── Route badge lookup ────────────────────────────────────────────

  RouteBadge getRouteBadge(String routeType) {
    final badge =
        group.routeBadges.where((b) => b.id == routeType).firstOrNull;
    return badge ??
        RouteBadge(id: routeType, label: routeType, color: '9E9E9E');
  }

  bool hasMultipleRouteTypes(List<ScheduleEntry> entries) =>
      entries.map((e) => e.routeType).toSet().length > 1;

  // ── Schedule helpers ──────────────────────────────────────────────

  bool isPastBus(ScheduleEntry entry) {
    if (!isViewingToday) return false;
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final entryMinutes = _parseTimeMinutes(entry.time);
    if (entryMinutes == null) return false;
    return entryMinutes <= currentMinutes;
  }

  // ── ETA fetch (for hero card) ─────────────────────────────────────

  var directionEtaMs = <String, int>{}.obs;

  Future<void> fetchCampusEta() async {
    final result = await _busRepo.getCampusEta();
    switch (result) {
      case Ok(:final data):
        directionEtaMs.value = data;
      case Err(:final failure):
        logger.e('Campus ETA fetch failed: $failure');
    }
  }

  // ── Private helpers ───────────────────────────────────────────────

  int? _parseTimeMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  void _startEtaTicker() {
    _etaTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      tick.value++;
    });
  }

  static String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  void onClose() {
    _etaTimer?.cancel();
    super.onClose();
  }
}
