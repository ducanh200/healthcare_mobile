import 'package:flutter/material.dart';
import 'package:healthcare/models/department.dart';
import 'package:healthcare/models/result_list.dart';
import 'package:healthcare/my_page.dart';
import 'package:healthcare/screen/booking/appointment_detail_screen.dart';
import 'package:healthcare/screen/result/result_detail.dart';
import 'package:healthcare/services/department_service.dart';
import 'package:healthcare/services/result_sevice.dart';
import 'package:intl/intl.dart';
import 'package:healthcare/models/booking_list.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:healthcare/services/booking_service.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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

  void _navigateToBookingDetail(int resultId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultDetailScreen(resultId: resultId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Result List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            );
          },
        ),
      ),
      body: _buildResultScreen(),
    );
  }

  Widget _buildResultScreen() {
    int? userId = _profileData?['id'];

    return FutureBuilder<List<ResultList>>(
      future: userId != null ? ResultService().getResultsByPatientId(userId) : Future.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("You don't have any results yet."));
        } else {
          List<ResultList> result = snapshot.data!;
          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (context, index) => _buildResultItem(context, result[index]),
          );
        }
      },
    );
  }

  Widget _buildResultItem(BuildContext context, ResultList result) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String formattedDate = dateFormat.format(result.examinationday);
    DateTime currentDate = DateTime.now();
    DateTime resultDate = DateTime(result.examinationday.year, result.examinationday.month, result.examinationday.day);
    DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    String daysAgoText = resultDate == today
        ? 'Today'
        : resultDate == yesterday
        ? 'Yesterday'
        : '${today.difference(resultDate).inDays} days ago';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FutureBuilder<Department>(
          future: DepartmentService.fetchDepartmentById(result.departmentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListTile(
                title: Text('Consulting Day: $formattedDate'),
                subtitle: Text('Loading department...'),
                trailing: SizedBox(width: 100),
              );
            } else if (snapshot.hasError) {
              return ListTile(
                title: Text('Consulting Day: $formattedDate'),
                subtitle: Text('Error loading department'),
                trailing: SizedBox(width: 100),
              );
            } else if (!snapshot.hasData) {
              return ListTile(
                title: Text('Consulting Day: $formattedDate'),
                subtitle: Text('No department data available'),
                trailing: SizedBox(width: 100),
              );
            }

            final department = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Examination Day: $formattedDate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ID: ${result.id}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Doctor: ${result.doctor}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Department: ${department.name}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    daysAgoText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToBookingDetail(result.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text(
                        'View medical examination results',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
