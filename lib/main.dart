import 'package:flutter/material.dart';
import 'package:healthcare/my_page.dart';
import 'package:healthcare/screen/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthcare/Provider/authToken_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthTokenProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthcare App',
        theme: ThemeData(
        ),
        home: LoginScreen(),
      ),
    );
  }
}