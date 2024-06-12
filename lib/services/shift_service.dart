import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthcare/models/shift.dart';

class ShiftService {
  static const String apiUrl = 'http://10.0.2.2:8080/api/v3/shifts/available';

  static Future<List<Shift>> fetchShifts(DateTime date, int departmentId) async {
    final String formattedDate = '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)}';
    final String url = '$apiUrl?date=$formattedDate&departmentId=$departmentId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => Shift.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shifts');
    }
  }
  static String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}

