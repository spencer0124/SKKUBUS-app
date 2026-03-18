class SmartSchedule {
  final String serviceId;
  final String status; // "active" | "suspended" | "noData"
  final String? from;
  final String? selectedDate;
  final List<DaySchedule> days;
  final String? resumeDate;
  final String? message;

  const SmartSchedule({
    required this.serviceId,
    required this.status,
    this.from,
    this.selectedDate,
    required this.days,
    this.resumeDate,
    this.message,
  });

  factory SmartSchedule.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return SmartSchedule(
      serviceId: data['serviceId'] as String,
      status: data['status'] as String,
      from: data['from'] as String?,
      selectedDate: data['selectedDate'] as String?,
      days: (data['days'] as List)
          .map((d) => DaySchedule.fromJson(d as Map<String, dynamic>))
          .toList(),
      resumeDate: data['resumeDate'] as String?,
      message: data['message'] as String?,
    );
  }

  bool get isActive => status == 'active';
  bool get isSuspended => status == 'suspended';
  bool get isNoData => status == 'noData';

  int get selectedDayIndex {
    if (selectedDate == null || days.isEmpty) return 0;
    final idx = days.indexWhere((d) => d.date == selectedDate);
    return idx >= 0 ? idx : 0;
  }
}

class DaySchedule {
  final String date; // "2026-03-09"
  final int dayOfWeek; // 1(Mon)~7(Sun)
  final String display; // "schedule" | "noService" | "hidden"
  final String? label;
  final List<ScheduleNotice> notices;
  final List<ScheduleEntry> schedule;

  const DaySchedule({
    required this.date,
    required this.dayOfWeek,
    required this.display,
    this.label,
    required this.notices,
    required this.schedule,
  });

  bool get hasSchedule => display == 'schedule';
  bool get isNoService => display == 'noService';
  bool get isHidden => display == 'hidden';

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      date: json['date'] as String,
      dayOfWeek: json['dayOfWeek'] as int,
      display: json['display'] as String,
      label: json['label'] as String?,
      notices: (json['notices'] as List)
          .map((n) => ScheduleNotice.fromJson(n as Map<String, dynamic>))
          .toList(),
      schedule: (json['schedule'] as List)
          .map((e) => ScheduleEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ScheduleEntry {
  final int index;
  final String time; // "07:00"
  final String routeType; // "regular" | "hakbu" | "fasttrack"
  final int busCount;
  final String? notes;

  const ScheduleEntry({
    required this.index,
    required this.time,
    required this.routeType,
    required this.busCount,
    this.notes,
  });

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) {
    return ScheduleEntry(
      index: json['index'] as int,
      time: json['time'] as String,
      routeType: json['routeType'] as String,
      busCount: json['busCount'] as int,
      notes: json['notes'] as String?,
    );
  }
}

class ScheduleNotice {
  final String style; // "info" | "warning"
  final String text;
  final String source; // "service" | "override"

  const ScheduleNotice({
    required this.style,
    required this.text,
    required this.source,
  });

  factory ScheduleNotice.fromJson(Map<String, dynamic> json) {
    return ScheduleNotice(
      style: json['style'] as String,
      text: json['text'] as String,
      source: json['source'] as String,
    );
  }
}
