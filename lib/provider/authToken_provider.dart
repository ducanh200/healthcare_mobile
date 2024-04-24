import 'package:flutter/material.dart';

class AuthTokenProvider extends ChangeNotifier {
  AuthTokenProvider() {
    _token = null;
  }
  late String? _token; // Sử dụng kiểu dữ liệu nullable

  String? get token => _token; // Getter cho _token

  set token(String? token) {
    _token = token;
    notifyListeners();
  }
}
