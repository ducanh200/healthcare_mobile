import 'dart:ffi';

class ResultDetail {
  final int id;
  final String requestTest;
  final double expense;
  final String diagnoseEnd;
  final int bookingId;
  final DateTime examinationday;
  final String doctorName;
  final String doctorEmail;
  final String doctorPhone;


  ResultDetail({
    required this.id,
    required this.requestTest,
    required this.expense,
    required this.diagnoseEnd,
    required this.bookingId,
    required this.examinationday,
    required this.doctorName,
    required this.doctorEmail,
    required this.doctorPhone
  });

  factory ResultDetail.fromJson(Map<String, dynamic> json) {
    return ResultDetail(
      id: json['id'] as int,
      requestTest: json['requestTest'] as String,
      expense: json['expense'] as double,
      diagnoseEnd: json['diagnoseEnd'] as String,
      bookingId: json['booking']['id'] as int,
      examinationday: DateTime.parse(json['booking']['date'] as String),
      doctorName: json['doctor']['name'] as String,
      doctorEmail: json['doctor']['email'] as String,
      doctorPhone: json['doctor']['phonenumber'] as String,
    );
  }
}
