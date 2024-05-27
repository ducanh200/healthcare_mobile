import 'package:healthcare/screen/auth/login_screen.dart';
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


        Provider.of<AuthTokenProvider>(context, listen: false).token = token;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error signing in: $e');
      throw Exception('An error occurred while signing in');
    }
  }
  Future<Map<String, dynamic>> getProfile(BuildContext context) async {
    try {
      String? token = Provider.of<AuthTokenProvider>(context, listen: false).token;

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to load profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
      throw Exception('An error occurred while fetching profile');
    }
  }
  Future<void> logout(BuildContext context) async {
    Provider.of<AuthTokenProvider>(context, listen: false).token = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}