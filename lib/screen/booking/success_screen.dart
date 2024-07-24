import 'package:flutter/material.dart';
import 'package:healthcare/models/boooking_detail.dart';
import 'package:healthcare/my_page.dart';
import 'package:healthcare/services/booking_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessScreen extends StatefulWidget {
  final int bookingId;

  const SuccessScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late BookingDetail _bookingDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookingDetail();
  }

  void _fetchBookingDetail() async {
    try {
      final bookingDetail = await BookingService.getBookingById(widget.bookingId);
      setState(() {
        _bookingDetail = bookingDetail;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching booking detail: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }
  String generateGoogleCalendarLink(String date, String time, String departmentName) {
    String formattedDateTime = '$date $time';
    DateTime startDateTime = DateTime.parse(formattedDateTime);
    DateTime endDateTime = startDateTime.add(Duration(minutes: 30));

    String formattedStartDateTime = DateFormat('yyyyMMddTHHmmss').format(startDateTime.toUtc());
    String formattedEndDateTime = DateFormat('yyyyMMddTHHmmss').format(endDateTime.toUtc());

    String googleCalendarUrl =
        'https://calendar.google.com/calendar/render?action=TEMPLATE&dates=${formattedStartDateTime}Z/${formattedEndDateTime}Z&details=Doccure+Appointment&location=${Uri.encodeComponent(departmentName)}&text=${Uri.encodeComponent(departmentName)}+medical+Appointment';

    return googleCalendarUrl;
  }
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookingDetail != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.blueAccent,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Booking successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent,),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking ID: ${_bookingDetail.id}',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Text(
                      'Patient: ${_bookingDetail.patientName}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Department: ${_bookingDetail.departmentName}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Date: ${formatDate(_bookingDetail.date)}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Time: ${_bookingDetail.shiftTime} (${_bookingDetail.session})',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Date Created: ${dateFormat.format(_bookingDetail.bookingAt)}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures buttons stretch to full width
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPage(initialIndex: 1)),
                    );
                  },
                  child: Text(
                    'Go To The Appointment List',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Adds space between buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final googleCalendarLink = generateGoogleCalendarLink(
                      _bookingDetail!.date,
                      _bookingDetail!.shiftTime,
                      _bookingDetail!.departmentName,
                    );
                    _launchURL(googleCalendarLink);
                  },
                  child: Text(
                    'Add to Google Calendar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )


          ],
        ),
      )
          : Center(child: Text('Failed to load booking detail')),
    );
  }
}