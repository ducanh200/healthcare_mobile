import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthcare/models/shift.dart';

class ShiftService {
  static const String apiUrl = 'http://10.0.2.2:8080/api/v3/shifts';

  static Future<List<Shift>> fetchShifts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => Shift.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shifts');
    }
  }

}
