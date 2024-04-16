class Department {
  final int? id;
  final String? name;
  final double? expense;
  final int? maxBooking;
  final String? description;
  final String? thumbnail;

  Department({
    this.id,
    this.name,
    this.expense,
    this.maxBooking,
    this.description,
    this.thumbnail,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      expense: json['expense']?.toDouble(),
      maxBooking: json['maxBooking'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }
}
