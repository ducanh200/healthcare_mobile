class BookingDetail {
  final int id;
  final DateTime bookingAt;
  final String date;
  final String patientName;
  final String departmentName;
  final String session;
  final String shiftTime;

  BookingDetail({
    required this.id,
    required this.bookingAt,
    required this.date,
    required this.patientName,
    required this.departmentName,
    required this.session,
    required this.shiftTime,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      id: json['id'] as int,
      bookingAt: DateTime.parse(json['bookingAt'] as String),
      date: json['date'] as String,
      patientName: json['patient']['name'] as String,
      departmentName: json['department']['name'] as String,
      session:json['shift']['session'] as String,
      shiftTime: json['shift']['time'] as String,
    );
  }

}
