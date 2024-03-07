class AttendanceRecordViewModel {
  final int id;
  final int employeeId;
  final DateTime timestampStart;
  final DateTime timestampEnd;
  final String locationStart;
  final String locationEnd;
  final String name;

  AttendanceRecordViewModel({
    required this.id,
    required this.employeeId,
    required this.timestampStart,
    required this.timestampEnd,
    required this.locationStart,
    required this.locationEnd,
    required this.name,
  });

  factory AttendanceRecordViewModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordViewModel(
      id: json['id'],
      employeeId: json['employee_id'],
      timestampStart: DateTime.parse(json['timestamp_start']),
      timestampEnd: DateTime.parse(json['timestamp_end']),
      locationStart: json['location_start'],
      locationEnd: json['location_end'],
      name: json['name'],
    );
  }
}
