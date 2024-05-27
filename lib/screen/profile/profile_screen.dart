import 'package:flutter/material.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:intl/intl.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    AuthService authService = AuthService();
    try {
      var profileData = await authService.getProfile(context);
      setState(() {
        _profileData = profileData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Error handling is already done in the getProfile method
    }
  }
  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }
  Future<void> _logout() async {
    AuthService authService = AuthService();
    await authService.logout(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _profileData == null
          ? Center(child: Text('Failed to load profile'))
          : ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${_profileData!['name']}'),
              Text('Email: ${_profileData!['email']}'),
              Text('Gender: ${_profileData!['gender']}'),
              Text('Birthday: ${formatDate(_profileData!['birthday'])}'),
              Text('Phone Number: ${_profileData!['phonenumber']}'),
              Text('Address: ${_profileData!['address']}'),
              Text('City: ${_profileData!['city']}'),
            ],
          ),
          SizedBox(height: 20), // Spacing between user info and logout button
          ElevatedButton(
            onPressed: _logout,
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
