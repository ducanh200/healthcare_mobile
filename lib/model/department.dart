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
    String thumbnailUrl = json['thumbnail'] ?? '';
    thumbnailUrl = thumbnailUrl.replaceAll('localhost:8080', '10.0.2.2:8080');

    return Department(
      id: json['id'],
      name: json['name'],
      expense: json['expense']?.toDouble(),
      maxBooking: json['maxBooking'],
      description: json['description'],
      thumbnail: thumbnailUrl,
    );
  }
}
