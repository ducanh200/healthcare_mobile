import 'package:healthcare/my_page.dart';
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
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
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

  Future<void> changePassword(BuildContext context, String profileId, String newPassword) async {
    try {
      String? token = Provider.of<AuthTokenProvider>(context, listen: false).token;

      if (token == null) {
        throw Exception('Token is null');
      }

      Map<String, String> data = {
        'password': newPassword,
      };
      String jsonData = jsonEncode(data);

      final response = await http.put(
        Uri.parse('$baseUrl/changePasswordById/$profileId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyPage(initialIndex: 4,)),
        );
      } else {
        String errorMessage = 'Failed to change password. Status code: ${response.statusCode}';
        print(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error changing password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error changing password: $e')),
      );
      throw Exception('An error occurred while changing password: $e');
    }
  }
  Future<void> updateProfile(BuildContext context, Map<String, String> updatedData) async {
    try {
      String? token = Provider.of<AuthTokenProvider>(context, listen: false).token;

      String profileId = updatedData['profileId']!;
      String jsonData = jsonEncode(updatedData);

      final response = await http.put(
        Uri.parse('$baseUrl/$profileId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyPage(initialIndex: 4,)),
        );
      } else {
        throw Exception('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
      throw Exception('An error occurred while updating profile');
    }
  }
  Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String gender,
    required String birthday,
    required String phoneNumber,
    required String address,
    required String city,
  }) async {
    try {
      Map<String, String> data = {
        'name': name,
        'email': email,
        'password': password,
        'gender': gender,
        'birthday': birthday,
        'phonenumber': phoneNumber,
        'address': address,
        'city': city,
      };
      String jsonData = jsonEncode(data);
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('Error registering: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering: $e')),
      );
      throw Exception('An error occurred while registering');
    }
  }
}
