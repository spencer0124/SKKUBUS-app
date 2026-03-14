class WeekSchedule {
  final String serviceId;
  final String? requestedFrom;
  final String from;
  final List<DaySchedule> days;

  const WeekSchedule({
    required this.serviceId,
    this.requestedFrom,
    required this.from,
    required this.days,
  });

  factory WeekSchedule.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return WeekSchedule(
      serviceId: data['serviceId'] as String,
      requestedFrom: data['requestedFrom'] as String?,
      from: data['from'] as String,
      days: (data['days'] as List)
          .map((d) => DaySchedule.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  DaySchedule? today(DateTime now) {
    final dateStr = _formatDate(now);
    return days.where((d) => d.date == dateStr).firstOrNull;
  }

  static String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
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
