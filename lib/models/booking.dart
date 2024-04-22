class Booking {
  final int? id; // Sử dụng kiểu dữ liệu optional để id có thể null
  final DateTime bookingAt;
  final int status;
  final String date;
  final int patientId;
  final int departmentId;
  final int shiftId;

  Booking({
    this.id, // Đặt id là optional
    required this.bookingAt,
    required this.status,
    required this.date,
    required this.patientId,
    required this.departmentId,
    required this.shiftId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int?, // Lấy id từ JSON, có thể là null
      bookingAt: DateTime.parse(json['bookingAt'] as String),
      status: json['status'] as int,
      date: json['date'] as String,
      patientId: json['patientId'] as int,
      departmentId: json['departmentId'] as int,
      shiftId: json['shiftId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'bookingAt': bookingAt.toIso8601String(),
      'status': status,
      'date': date,
      'patientId': patientId,
      'departmentId': departmentId,
      'shiftId': shiftId,
    };
    if (id != null) {
      data['id'] = id; // Thêm id vào JSON nếu nó không phải là null
    }
    return data;
  }
}
