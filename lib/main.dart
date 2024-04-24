import 'package:flutter/material.dart';
import 'package:healthcare/screen/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthcare/Provider/authToken_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Care',
      theme: ThemeData(
        // Định nghĩa theme của ứng dụng nếu cần
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthTokenProvider()),
          // Thêm các provider khác nếu cần
        ],
        child: LoginScreen(),
        // Đặt trang đăng nhập làm trang mặc định
      ),
    );
  }
}
