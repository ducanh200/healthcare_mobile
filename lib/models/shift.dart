class Shift {
  final int id;
  final String time;
  final String session;

  Shift({required this.id, required this.time, required this.session});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] as int,
      time: json['time'] as String,
      session: json['session'] as String,
    );
  }
}
