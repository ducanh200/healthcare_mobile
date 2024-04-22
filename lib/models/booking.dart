class Booking {
  final DateTime bookingAt;
  final int status;
  final String date;
  final int patientId;
  final int departmentId;
  final int shiftId;

  Booking({
    required this.bookingAt,
    required this.status,
    required this.date,
    required this.patientId,
    required this.departmentId,
    required this.shiftId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingAt: DateTime.parse(json['bookingAt'] as String),
      status: json['status'] as int,
      date: json['date'] as String,
      patientId: json['patientId'] as int,
      departmentId: json['departmentId'] as int,
      shiftId: json['shiftId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingAt': bookingAt.toIso8601String(),
      'status': status,
      'date': date,
      'patientId': patientId,
      'departmentId': departmentId,
      'shiftId': shiftId,
    };
  }
}
