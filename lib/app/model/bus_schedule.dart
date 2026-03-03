class BusSchedule {
  String operatingHours;
  int busCount;
  String? specialNotes;
  bool isFastestBus;

  BusSchedule({
    required this.operatingHours,
    required this.busCount,
    this.specialNotes,
    required this.isFastestBus,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      operatingHours: json['operatingHours'],
      busCount: json['busCount'],
      specialNotes: json['specialNotes'],
      isFastestBus: json['isFastestBus'],
    );
  }
}
