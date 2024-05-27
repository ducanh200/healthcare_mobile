import 'package:flutter/material.dart';
import 'package:healthcare/models/boooking_detail.dart';
import 'package:healthcare/my_page.dart';
import 'package:healthcare/services/booking_service.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      'Booking Detail ID: ${_bookingDetail.id}',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Text(
                      'Patient Name: ${_bookingDetail.patientName}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Department: ${_bookingDetail.departmentName}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Date: ${_bookingDetail.date}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Time: ${_bookingDetail.shiftTime} (${_bookingDetail.session})',
                      style: TextStyle(fontSize: 20),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              },
              child: Text(
                'Back To Home',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: Text('Failed to load booking detail')),
    );
  }
}