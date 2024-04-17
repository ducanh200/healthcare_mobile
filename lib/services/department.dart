import 'dart:convert';

class Department {
  final String thumbnail;

  Department({required this.thumbnail});

  factory Department.fromJson(Map<String, dynamic> json) {
    String thumbnailUrl = json['thumbnail'] ?? '';
    thumbnailUrl = thumbnailUrl.replaceAll('localhost:8080', '10.0.2.2:8080');

    return Department(thumbnail: thumbnailUrl);
  }
}