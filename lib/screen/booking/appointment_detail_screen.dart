import 'package:flutter/material.dart';
import 'package:healthcare/models/boooking_detail.dart';
import 'package:healthcare/services/booking_service.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final int bookingId;

  AppointmentDetailScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookingDetail>(
      future: BookingService.getBookingById(bookingId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Appointment Detail',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Appointment Detail',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Center(child: Text('Error fetching booking detail: ${snapshot.error}')),
          );
        } else {
          final bookingDetail = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Appointment Detail',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: bookingDetail != null
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  _buildDetailRow('Booking ID', '${bookingDetail.id}'),
                  Divider(height: 50, thickness: 2),
                  _buildDetailRow('Date Created', '${DateFormat('dd/MM/yyyy').format(bookingDetail.bookingAt)}'),
                  Divider(height: 50, thickness: 2),
                  _buildDetailRow('Patient', '${bookingDetail.patientName}'),
                  Divider(height: 50, thickness: 2),
                  _buildDetailRow('Department', '${bookingDetail.departmentName}'),
                  Divider(height: 50, thickness: 2),
                  _buildDetailRow('Date', '${bookingDetail.date}'),
                  Divider(height: 50, thickness: 2),
                  _buildDetailRow('Time', '${bookingDetail.shiftTime}(${bookingDetail.session})'),
                  Divider(height: 50, thickness: 2),
                  _buildDetailRow('Status', '${bookingDetail.getStatusText()}'),

                ],
              ),
            )
                : Center(child: Text('No booking detail available')),
          );
        }
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
