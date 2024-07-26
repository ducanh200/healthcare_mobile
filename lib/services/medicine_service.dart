import 'dart:convert';
import 'package:healthcare/models/medicine.dart';
import 'package:http/http.dart' as http;

class MedicineService {
  final String baseUrl = 'http://10.0.2.2:8080/api/v3/result_medicine';
  Future<List<Medicine>> getMedicineByResultId(int resultId) async {
    try {
      final url = Uri.parse('$baseUrl/resultId/$resultId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Medicine> medicine = responseData
            .map((data) =>Medicine.fromJson(data))
            .toList();
        return medicine;
      } else {
        throw Exception('Failed to get medicine for result');
      }
    } catch (e) {
      throw Exception('Failed to get medicine for result: $e');
    }
  }
}
