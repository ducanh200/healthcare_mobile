import 'package:flutter/material.dart';
import 'package:healthcare/screen/booking/appointment_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:healthcare/models/booking_list.dart';
import 'package:healthcare/services/auth_service.dart';
import 'package:healthcare/services/booking_service.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
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
  void _navigateToBookingDetail(int bookingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailScreen(bookingId: bookingId),
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
        automaticallyImplyLeading: false,
        title: Text(
          'Appointment List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: _buildAppointmentScreen(),
    );
  }

  Widget _buildAppointmentScreen() {
    int? userId = _profileData?['id'];

    return FutureBuilder<List<BookingList>>(
      future: BookingService().getBookingsByPatientId(userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<BookingList> bookings = snapshot.data!;
          if (bookings.isEmpty) {
            return Center(child: Text('No appointments found.'));
          }
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) => _buildAppointmentItem(context, bookings[index]),
          );
        }
      },
    );
  }

  Widget _buildAppointmentItem(BuildContext context, BookingList booking) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String formattedDate = dateFormat.format(booking.bookingAt);
    String statusText = booking.getStatusText();
    DateTime currentDate = DateTime.now();
    DateTime bookingDate = DateTime(booking.bookingAt.year, booking.bookingAt.month, booking.bookingAt.day);
    DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    String daysAgoText = bookingDate == today
        ? 'Today'
        : bookingDate == yesterday
        ? 'Yesterday'
        : '${today.difference(bookingDate).inDays} days ago';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text(
            'Date Created: $formattedDate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: ${booking.id}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Status: $statusText',
                style: TextStyle(
                  fontSize: 16,
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
            ],
          ),
          trailing: Container(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                _navigateToBookingDetail(booking.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                'View',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
