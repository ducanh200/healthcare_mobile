import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthcare/models/department.dart';

class DepartmentService {
  static const String apiUrl = 'http://10.0.2.2:8080/api/v3/departments';

  static Future<Department> fetchDepartmentById(int id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final department = Department.fromJson(responseData);
        return department;
      } else {
        throw Exception('Failed to load department');
      }
    } catch (e) {
      print('Error fetching department: $e');
      throw Exception('Failed to load department');
    }
  }

  static Future<List<Department>> fetchDepartments() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Department> departments = responseData
            .map((data) => Department.fromJson(data))
            .toList();

        return departments;
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print('Error fetching departments: $e');
      throw Exception('Failed to load departments');
    }
  }
}