class BusSchedule {
  String operatingHours;
  int busCount;
  String? specialNotes;
  bool isFastestBus;
  String routeType;

  BusSchedule({
    required this.operatingHours,
    required this.busCount,
    this.specialNotes,
    required this.isFastestBus,
    this.routeType = 'regular',
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      operatingHours: json['operatingHours'],
      busCount: json['busCount'],
      specialNotes: json['specialNotes'],
      isFastestBus: json['isFastestBus'],
      routeType: json['routeType'] ?? 'regular',
    );
  }
}
