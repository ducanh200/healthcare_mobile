class BookingList {
  final int id;
  final DateTime bookingAt;
  final String date;
  final int status;

  BookingList({
    required this.id,
    required this.bookingAt,
    required this.date,
    required this.status,
  });

  factory BookingList.fromJson(Map<String, dynamic> json) {
    return BookingList(
      id: json['id'] as int,
      bookingAt: DateTime.parse(json['bookingAt'] as String),
      date: json['date'] as String,
      status: json['status'] as int,
    );
  }

  String getStatusText() {
    switch (status) {
      case 1:
        return 'BOOKED';
      case 2:
        return 'WAITING FOR MEDICAL EXAMINATION';
      case 3:
        return 'BEING MEDICAL EXAMINATION';
      default:
        return 'FINISHED';
    }
  }
}
