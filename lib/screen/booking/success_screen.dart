import 'package:flutter/material.dart';
import 'package:healthcare/models/boooking_detail.dart';
import 'package:healthcare/screen/booking/department_screen.dart';
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
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookingDetail != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Booking successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking ID: ${_bookingDetail.id}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text('Date: ${_bookingDetail.date}'),
                  Text('Time: ${_bookingDetail.shiftTime}'),
                  Text('Department: ${_bookingDetail.departmentName}'),
                  Text('Patient: ${_bookingDetail.patientName}'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to DepartmentScreen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => DepartmentScreen()),
                          (route) => false, // Remove all routes below DepartmentScreen
                    );
                  },
                  child: Text('Back to Department'),
                ),
              ],
            ),
          ],
        ),
      )
          : Center(child: Text('Failed to load booking detail')),
    );
  }
}
