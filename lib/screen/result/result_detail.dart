import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:healthcare/models/result_detail.dart';
import 'package:healthcare/models/test_list.dart';
import 'package:healthcare/models/medicine.dart';
import 'package:healthcare/screen/booking/appointment_detail_screen.dart';
import 'package:healthcare/services/result_sevice.dart';
import 'package:healthcare/services/test_service.dart';
import 'package:healthcare/services/medicine_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ResultDetailScreen extends StatefulWidget {
  final int resultId;

  ResultDetailScreen({Key? key, required this.resultId}) : super(key: key);

  @override
  _ResultDetailScreenState createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  late int _currentResultId;
  String _viewType = 'detail'; // Variable to check the type of data to display
  late Future<List<TestList>> _futureTests;
  late Future<List<Medicine>> _futureMedicines;

  @override
  void initState() {
    super.initState();
    _currentResultId = widget.resultId;
    _futureTests = TestService().getTestByResultId(_currentResultId);
    _futureMedicines = MedicineService().getMedicineByResultId(_currentResultId);
  }

  void _navigateToBookingDetail(int bookingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailScreen(bookingId: bookingId),
      ),
    );
  }

  void _showImageViewer(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<ResultDetail>(
        future: ResultService.getResultById(_currentResultId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching result detail: ${snapshot.error}'));
          } else {
            final resultDetail = snapshot.data;
            return resultDetail != null
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _viewType = 'detail';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _viewType == 'detail' ? Colors.blueAccent : Colors.white,
                            ),
                            child: Text(
                              'Detail',
                              style: TextStyle(
                                color: _viewType == 'detail' ? Colors.white : Colors.blueAccent,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _viewType = 'test';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _viewType == 'test' ? Colors.blueAccent : Colors.white,
                            ),
                            child: Text(
                              'List Test',
                              style: TextStyle(
                                color: _viewType == 'test' ? Colors.white : Colors.blueAccent,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _viewType = 'medicine';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _viewType == 'medicine' ? Colors.blueAccent : Colors.white,
                            ),
                            child: Text(
                              'Medicine',
                              style: TextStyle(
                                color: _viewType == 'medicine' ? Colors.white : Colors.blueAccent,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: _viewType == 'detail'
                        ? Card(
                      color: Colors.white, // Card background color
                      elevation: 4, // Card elevation
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('ID', '${resultDetail.id}'),
                            Divider(thickness: 1, color: Colors.grey[300]),
                            Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Text(
                                'Examination Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            _buildDetailRow('Request Test', '${resultDetail.requestTest}'),
                            _buildDetailRow('Diagnose End', '${resultDetail.diagnoseEnd}'),
                            _buildDetailRow('Examination Day', '${DateFormat('dd/MM/yyyy').format(resultDetail.examinationday)}'),
                            Divider(thickness: 1, color: Colors.grey[300]),
                            Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Text(
                                'Doctor Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            _buildDetailRow('Name', '${resultDetail.doctorName}'),
                            _buildDetailRow('Phone', '${resultDetail.doctorPhone}'),
                            _buildDetailRow('Email', '${resultDetail.doctorEmail}'),
                            Divider(thickness: 1, color: Colors.grey[300]),
                            _buildDetailRow('Total Expense', '\$${NumberFormat('#,##0').format(resultDetail.expense)}'),
                          ],
                        ),
                      ),
                    )
                        : _viewType == 'test'
                        ? FutureBuilder<List<TestList>>(
                      future: _futureTests,
                      builder: (context, testSnapshot) {
                        if (testSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (testSnapshot.hasError) {
                          return Center(child: Text('Error fetching tests: ${testSnapshot.error}'));
                        } else {
                          final tests = testSnapshot.data;
                          return tests != null
                              ? tests.isNotEmpty
                              ? ListView.builder(
                            itemCount: tests.length,
                            itemBuilder: (context, index) {
                              final test = tests[index];
                              return Card(
                                color: Colors.white,
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Test ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          _showImageViewer(test.thumbnail);
                                        },
                                        child: Image.network(test.thumbnail),
                                      ),
                                      SizedBox(height: 16),
                                      _buildDetailRow('Diagnose', test.diagnose),
                                      _buildDetailRow('Device', test.deviceName),
                                      _buildDetailRow('Expense', '\$${NumberFormat('#,##0').format(test.expense)}'),
                                      _buildDetailRow('Doctor', test.doctorName),
                                      _buildDetailRow('DateTime', DateFormat('dd/MM/yyyy HH:mm:ss').format(test.testAt)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                              : Center(child: Text('Patients do not need to be tested'))
                              : Center(child: Text('Patients do not need to be tested'));
                        }
                      },
                    )
                        : _viewType == 'medicine'
                        ? FutureBuilder<List<Medicine>>(
                      future: _futureMedicines,
                      builder: (context, medicineSnapshot) {
                        if (medicineSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (medicineSnapshot.hasError) {
                          return Center(child: Text('Error fetching medicines: ${medicineSnapshot.error}'));
                        } else {
                          final medicines = medicineSnapshot.data;
                          return medicines != null
                              ? medicines.isNotEmpty
                              ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Quantity',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Note',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Divider(thickness: 1, color: Colors.grey[300]),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: medicines.length,
                                        itemBuilder: (context, index) {
                                          final medicine = medicines[index];
                                          return Container(
                                            margin: EdgeInsets.symmetric(vertical: 16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    medicine.name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    medicine.quantity.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    medicine.description,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : Center(child: Text('The patient does not need medication'))
                              : Center(child: Text('The patient does not need medication'));
                        }
                      },
                    )
                        : SizedBox.shrink(),
                  ),
                  if (_viewType == 'detail')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            _navigateToBookingDetail(resultDetail.bookingId);
                          },
                          child: Text(
                            'Appointment Information',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
                : Center(child: Text('No result detail available'));
          }
        },
      ),
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
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  ImageViewerScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
        backgroundColor: Colors.blueAccent,
      ),
      body: PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

Future<void> downloadImage(String url, String filename) async {
  try {
    await requestStoragePermission();
    await ensurePicturesDirectoryExists();

    Dio dio = Dio();
    var dir = await getExternalStorageDirectory();
    await dio.download(url, '${dir!.path}/Downloads/$filename');
    print(': ${dir.path}/Downloads/$filename');
  } catch (e) {
    print(': $e');
  }
}

Future<void> ensurePicturesDirectoryExists() async {
  final directory = await getExternalStorageDirectory();
  final picturesDir = Directory('${directory!.path}/Downloads');
  if (!await picturesDir.exists()) {
    await picturesDir.create(recursive: true);
  }
}
