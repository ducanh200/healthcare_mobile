import 'package:flutter/material.dart';
import 'package:healthcare/models/booking.dart';
import 'package:healthcare/screen/booking/success_screen.dart';
import 'package:healthcare/services/booking_service.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:healthcare/services/department_service.dart';
import 'package:intl/intl.dart';
class ConfirmationScreen extends StatelessWidget {
  final int DepartmentId;
  final String DepartmentName;
  final String Date;
  final String Session;
  final int TimeId;
  final String Time;
  late int maxBooking = 0;

  ConfirmationScreen({
    required this.DepartmentId,
    required this.DepartmentName,
    required this.Date,
    required this.Session,
    required this.TimeId,
    required this.Time,
  });

  Future<Map<String, dynamic>> getPatientInfo(BuildContext context) async {
    AuthService authService = AuthService();
    return await authService.getProfile(context);
  }
  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          'Confirm Information',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
              future: getPatientInfo(context),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient Information',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text('Name: ${snapshot.data!['name']}',style: TextStyle(fontSize: 16),),
                                Text('Email: ${snapshot.data!['email']}',style: TextStyle(fontSize: 16),),
                                Text('Gender: ${snapshot.data!['gender']}',style: TextStyle(fontSize: 16),),
                                Text('Birthday: ${formatDate(snapshot.data!['birthday'])}',style: TextStyle(fontSize: 16),),
                                Text('Phone Number: ${snapshot.data!['phonenumber']}',style: TextStyle(fontSize: 16),),
                                Text('Address: ${snapshot.data!['address']}',style: TextStyle(fontSize: 16),),
                                Text('City: ${snapshot.data!['city']}',style: TextStyle(fontSize: 16),),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Appointment Detail',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  'Department: $DepartmentName',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Date: $Date',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Time: $Time ($Session)',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                try {
                  final patientInfo = await getPatientInfo(context);
                  final booking = Booking(
                    bookingAt: DateTime.now(),
                    status: 1,
                    date: Date.toString().substring(0, 10),
                    patientId: patientInfo['id'],
                    departmentId: DepartmentId,
                    shiftId: TimeId,
                  );

                  final department = await DepartmentService.fetchDepartmentById(DepartmentId);
                  maxBooking = department.maxBooking ?? 0;
                  final bookingCountForCurrentDepartment = await BookingService().getBookingCountForDepartment(DateTime.parse(Date.substring(0, 10)), DepartmentId, TimeId);
                  if (bookingCountForCurrentDepartment <= maxBooking) {
                    final createdBooking = await BookingService().createBooking(booking);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuccessScreen(bookingId: createdBooking.id ?? 0),
                      ),
                    );
                    print('Booking created: $createdBooking');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Another user booked this department, time frame, and date during your confirmation.')),
                    );
                  }
                } catch (e) {
                  print('Error creating booking: $e');
                }
              },
              child: Text(
                'Confirm Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
