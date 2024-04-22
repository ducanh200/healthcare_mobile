import 'package:flutter/material.dart';
import 'package:healthcare/screen/auth/changePassword_screen.dart';
import 'package:healthcare/screen/auth/fogotPassword_screen.dart';
import 'package:healthcare/screen/auth/login_screen.dart';
import 'package:healthcare/screen/auth/register_screen.dart';
import 'package:healthcare/screen/booking/booking_screen.dart';
import 'package:healthcare/screen/booking/department_screen.dart';


class MyPage extends StatefulWidget{
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>{
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<Widget> _screen = [
    LoginScreen(),
  ];
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DepartmentScreen(),
    LoginScreen(),
    ChangePasswordScreen(),
    FogotPasswordScreeen(),
    RegisterScreen()
  ];

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
                  selected: _selectedIndex == 1,
                  onTap: () {
                    _onItemTapped(1);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),


    );
  }
}