class Shift {
  final int id;
  final String time;
  final String session;
  final int status;

  Shift({required this.id, required this.time, required this.session, required this.status});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] as int,
      time: json['time'] as String,
      session: json['session'] as String,
      status: json['status'] as int
    );
  }
}
