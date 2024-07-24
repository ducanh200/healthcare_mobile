class ResultList {
  final int id;
  final DateTime consultingday;
  final int departmentId;
  final String doctor;

  ResultList({
    required this.id,
    required this.consultingday,
    required this.departmentId,
    required this.doctor,
  });

  factory ResultList.fromJson(Map<String, dynamic> json) {
    return ResultList(
      id: json['id'] as int,
      consultingday: DateTime.parse(json['booking']['date'] as String),
      departmentId: json['booking']['departmentId'] as int,
      doctor: json['doctor']['name'] as String,
    );
  }

}
