import 'package:flutter/material.dart';

class AuthTokenProvider extends ChangeNotifier {
  AuthTokenProvider() {
    _token = null;
  }
  late String? _token;

  String? get token => _token;

  set token(String? token) {
    _token = token;
    notifyListeners();
  }
}