import 'dart:ffi';

class Medicine {
  final String name;
  final int quantity;
  final String description;


  Medicine({
    required this.name,
    required this.quantity,
    required this.description,

  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['medicine']['name'] as String,
      quantity: json['quantity'] as int,
      description: json['description'] as String,
    );
  }

}
