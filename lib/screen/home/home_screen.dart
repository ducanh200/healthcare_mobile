import 'package:flutter/material.dart';
import 'package:healthcare/screen/booking/appointment_screen.dart';
import 'package:healthcare/screen/booking/booking_screen.dart';
import 'package:healthcare/screen/result/result_screen.dart';
import 'package:healthcare/services/auth_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100.0),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _profileData != null
                      ? Text(
                    "Welcome, ${_profileData!['name']}",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                      : const Text(
                    "Unable to load profile data",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Proactive health care with HEALTHCARE",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Main Options Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "BOOKING NOW",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingScreen()),
                            );
                          },
                          child: Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                children: const [
                                  Icon(Icons.local_hospital,
                                      size: 50, color: Colors.white),
                                  SizedBox(height: 8),
                                  Text(
                                    "Click here!",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Make an appointment quickly and simply!",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Utilities Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "UTILITIES",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildUtilityButton(
                          Icons.calendar_month_outlined, "View appointments", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentScreen()),
                        );
                      }),
                      _buildUtilityButton(
                          Icons.assignment_outlined, "View          results", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultScreen()),
                        );
                      }),
                      _buildUtilityButton(Icons.more_horiz, "More features", () {
                        // Add navigation or functionality for "More features" if needed
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.asset(
                'assets/images/1520097974050.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.blueAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
