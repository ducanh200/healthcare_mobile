import 'package:flutter/material.dart';
import 'package:healthcare/screen/auth/changePassword_screen.dart';
import 'package:healthcare/screen/auth/fogotPassword_screen.dart';
import 'package:healthcare/screen/auth/login_screen.dart';
import 'package:healthcare/screen/auth/register_screen.dart';
import 'package:healthcare/screen/dashboard.dart';

class MyPage extends StatefulWidget{
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>{
  final List<Widget> _screen = [
    LoginScreen(),
    ChangePasswordScreen(),
    FogotPasswordScreeen(),
    RegisterScreen(),
    DashboardScreen()
  ];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ChangePasswordScreen(),
    FogotPasswordScreeen(),
    LoginScreen(),
    RegisterScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Doccure",
            style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  title: const Text('Dashboard'),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 16), // Add some space between the last item and logout button
              ],
            ),
            Container(
              color: Colors.red, // Background color of the logout button
              child: ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white), // Icon for logout
                title: Text('Log Out', style: TextStyle(color: Colors.white)), // Text for logout
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),


    );
  }
}