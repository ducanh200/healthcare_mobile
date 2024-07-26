import 'dart:convert';
import 'package:healthcare/models/test_list.dart';
import 'package:http/http.dart' as http;

class TestService {
  final String baseUrl = 'http://10.0.2.2:8080/api/v3/tests';
  Future<List<TestList>> getTestByResultId(int resultId) async {
    try {
      final url = Uri.parse('$baseUrl/resultId/$resultId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<TestList> test_list = responseData
            .map((data) =>TestList.fromJson(data))
            .toList();
        return test_list;
      } else {
        throw Exception('Failed to get test for result');
      }
    } catch (e) {
      throw Exception('Failed to get test for result: $e');
    }
  }
}
