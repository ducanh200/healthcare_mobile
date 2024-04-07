import 'package:flutter/material.dart';
import 'package:healthcare/screen/auth/changePassword_screen.dart';
import 'package:healthcare/screen/auth/fogotPassword_screen.dart';

class MyPage extends StatefulWidget{
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>{
  final List<Widget> _screen = [

    FogotPasswordScreeen()
  ];
  int _selectedIndex = 0;

  _changeTab(int index){
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
      body: _screen[_selectedIndex],

    );
  }
}