import 'package:flutter/material.dart';
import 'package:healthcare/screen/auth/changePassword_screen.dart';
import 'package:healthcare/screen/auth/update_profile_screen.dart';
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
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Name: ${_profileData!['name']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Email: ${_profileData!['email']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Gender: ${_profileData!['gender']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Birthday: ${formatDate(_profileData!['birthday'])}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Phone Number: ${_profileData!['phonenumber']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Address: ${_profileData!['address']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'City: ${_profileData!['city']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(profileData: _profileData!),
                  ),
                );
              },
              child: Text(
                'Update Profile',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size.fromHeight(50),
              ),
              onPressed: () {
                // Navigate to ChangePasswordScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(
                      profileId: _profileData!['id'], // Ensure profile ID is passed correctly
                    ),
                  ),
                );
              },
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size.fromHeight(50),
              ),
              onPressed: _logout,
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

