class ResultList {
  final int id;
  final DateTime examinationday;
  final int departmentId;
  final String doctor;

  ResultList({
    required this.id,
    required this.examinationday,
    required this.departmentId,
    required this.doctor,
  });

  factory ResultList.fromJson(Map<String, dynamic> json) {
    return ResultList(
      id: json['id'] as int,
      examinationday: DateTime.parse(json['booking']['date'] as String),
      departmentId: json['booking']['departmentId'] as int,
      doctor: json['doctor']['name'] as String,
    );
  }

}
