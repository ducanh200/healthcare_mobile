import 'package:flutter/material.dart';
import 'package:healthcare/models/result_detail.dart';
import 'package:healthcare/services/result_sevice.dart';
import 'package:intl/intl.dart';

class ResultDetailScreen extends StatelessWidget {
  final int resultId;

  ResultDetailScreen({Key? key, required this.resultId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultDetail>(
      future: ResultService.getResultById(resultId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: Center(child: Text('Error fetching result detail: ${snapshot.error}')),
          );
        } else {
          final resultDetail = snapshot.data;
          return Scaffold(
            appBar: _buildAppBar(),
            body: resultDetail != null
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  _buildDetailRow('Booking ID', '${resultDetail.id}'),
                  _buildDetailRow('Department ID', '${resultDetail.departmentId}'),
                  _buildDetailRow('Request Test', '${resultDetail.requestTest}'),
                  _buildDetailRow('Diagnose End', '${resultDetail.diagnoseEnd}'),
                  _buildDetailRow('Expense', '${resultDetail.expense}'),
                  _buildDetailRow('Booking ID', '${resultDetail.bookingId}'),
                  _buildDetailRow('Doctor ID', '${resultDetail.doctorId}'),
                  _buildDetailRow('Doctor Name', '${resultDetail.doctorName}'),
                  _buildDetailRow('Doctor Email', '${resultDetail.doctorEmail}'),
                  _buildDetailRow('Doctor Phone', '${resultDetail.doctorPhone}'),
                  _buildDetailRow('Examination Day', '${DateFormat('dd/MM/yyyy').format(resultDetail.examinationday)}'),
                ],
              ),
            )
                : Center(child: Text('No result detail available')),
          );
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Result Detail',
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
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
