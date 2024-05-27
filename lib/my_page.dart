import 'package:flutter/material.dart';
import 'package:healthcare/screen/%20result/%20result_screen.dart';
import 'package:healthcare/screen/booking/%20booking_history_screen.dart';
import 'package:healthcare/screen/booking/booking_screen.dart';
import 'package:healthcare/screen/home/home_screen.dart';
import 'package:healthcare/screen/profile/profile_screen.dart';


class MyPage extends StatefulWidget{
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>{
  int _selectedIndex = 2;
  _changeTab(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<Widget> _screens = [
    BookingScreen(),
    BookingHistoryScreen(),
    HomeScreen(),
    ResultScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Image.asset(
            "assets/images/logo.png",
            width: 100,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black45,
        onTap: (index) => _changeTab(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_outlined,
              size: _selectedIndex == 0 ? 35.0 : 25.0,
            ),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: _selectedIndex == 1 ? 35.0 : 25.0,
            ),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: _selectedIndex == 2 ? 35.0 : 25.0,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_outlined,
              size: _selectedIndex == 3 ? 35.0 : 25.0,
            ),
            label: "Result",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: _selectedIndex == 4 ? 35.0 : 25.0,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}