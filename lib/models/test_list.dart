import 'dart:ffi';

class TestList {
  final int id;
  final String diagnose;
  final String thumbnail;
  final double expense;
  final String deviceName;
  final String doctorName;
  final DateTime testAt;

  TestList({
    required this.id,
    required this.diagnose,
    required this.thumbnail,
    required this.expense,
    required this.deviceName,
    required this.doctorName,
    required this.testAt
  });

  factory TestList.fromJson(Map<String, dynamic> json) {
    String thumbnailUrl = json['thumbnail'] ?? '';
    thumbnailUrl = thumbnailUrl.replaceAll('localhost:8080', '10.0.2.2:8080');
    return TestList(
      id: json['id'] as int,
      diagnose: json['diagnose'] as String,
      thumbnail: thumbnailUrl,
      expense: json['expense'] as double,
      deviceName: json['device']['name'] as String,
      doctorName: json['doctor']['name'] as String,
      testAt: DateTime.parse(json['testAt']as String),
    );
  }

}
