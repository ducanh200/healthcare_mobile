import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare/Provider/authToken_provider.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8080/api/v3/patients';

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      Map<String, String> data = {
        'email': email,
        'password': password,
      };
      String jsonData = jsonEncode(data);
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        String token = jsonResponse['token'];

        // Gán token cho Provider
        Provider.of<AuthTokenProvider>(context, listen: false).token = token;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error signing in: $e');
      throw Exception('An error occurred while signing in');
    }
  }
}
