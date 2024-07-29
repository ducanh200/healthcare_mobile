import 'dart:convert';
import 'package:healthcare/models/result_detail.dart';
import 'package:healthcare/models/result_list.dart';
import 'package:http/http.dart' as http;

class ResultService {
  final String baseUrl = 'http://10.0.2.2:8080/api/v3/results';

  Future<List<ResultList>> getResultsByPatientId(int patientId) async {
    try {
      final url = Uri.parse('$baseUrl/GetByPatientId/$patientId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Decode response body using UTF-8
        final List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        final List<ResultList> resultList = responseData
            .map((data) => ResultList.fromJson(data))
            .toList();
        return resultList;
      } else {
        throw Exception('Failed to get results for patient');
      }
    } catch (e) {
      throw Exception('Failed to get results for patient: $e');
    }
  }

  static Future<ResultDetail> getResultById(int id) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/v3/results/findById/$id');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Decode response body using UTF-8
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final resultDetail = ResultDetail.fromJson(jsonData);
        return resultDetail;
      } else {
        throw Exception('Failed to load result');
      }
    } catch (e) {
      throw Exception('Failed to load result: $e');
    }
  }
}
