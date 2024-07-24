import 'package:flutter/material.dart';
import 'package:healthcare/models/booking.dart';
import 'package:healthcare/screen/booking/success_screen.dart';
import 'package:healthcare/services/booking_service.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:healthcare/services/email_service.dart';
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
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
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
                        SizedBox(height: 30), // Add some spacing
                        Text(
                          'Please review the information above carefully before proceeding with the booking.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
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
                                  'Date: ${formatDate(Date)}',
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
                    final emailService = EmailService();
                    final emailSubject = 'Notification of successful Booking ID: ${createdBooking.id}';
                    final emailBody =  '''
                      Dear ${patientInfo['name']},

                      Your booking has been successfully confirmed. Below are the details of your booking:

                      Department: $DepartmentName
                      Date: ${formatDate(Date)}
                      Time: $Time ($Session)
                                     
                      Date Created: ${dateFormat.format(createdBooking.bookingAt)}

                      Thank you for choosing our service. We look forward to seeing you!

                      Best regards,
                      Your Healthcare Team
                    ''';

                    await emailService.sendBookingConfirmationEmail(patientInfo['email'], emailSubject, emailBody);
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
                'Booking',
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
