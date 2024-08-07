import 'dart:convert';
import 'package:healthcare/models/booking_list.dart';
import 'package:healthcare/models/boooking_detail.dart';
import 'package:http/http.dart' as http;
import 'package:healthcare/models/booking.dart';

class BookingService {
  final String baseUrl = 'http://10.0.2.2:8080/api/v3/bookings';

  Future<int> getBookingCountForDepartment(DateTime selectedDate, int departmentId, int shiftId) async {
    try {
      final url = Uri.parse('$baseUrl?date=${selectedDate.toIso8601String()}&shiftId=$shiftId&departmentId=$departmentId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> bookingsData = json.decode(response.body);
        // Filter bookings for the selected date, department, and shift
        final bookingsForSelectedTimeAndDate = bookingsData.where((booking) =>
        booking['shiftId'] == shiftId &&
            booking['date'] == selectedDate.toIso8601String().substring(0, 10) &&
            booking['departmentId'] == departmentId);

        return bookingsForSelectedTimeAndDate.length;
      } else {
        throw Exception('Failed to get booking count for department');
      }
    } catch (e) {
      throw Exception('Failed to get booking count for department: $e');
    }
  }


  Future<Booking> createBooking(Booking booking) async {
    final url = Uri.parse(baseUrl); // Thay đổi đường dẫn API nếu cần
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(booking.toJson()),
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create booking');
    }
  }
  static Future<BookingDetail> getBookingById(int id) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/v3/bookings/$id');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final bookingDetail = BookingDetail.fromJson((jsonData));
        return bookingDetail;
      } else {
        throw Exception('Failed to load booking');
      }
    } catch (e) {
      throw Exception('Failed to load booking: $e');
    }
  }
  Future<List<BookingList>> getBookingsByPatientId(int patientId) async {
    try {
      final url = Uri.parse('$baseUrl/getByPatientId/$patientId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<BookingList> booking_list = responseData
            .map((data) =>BookingList.fromJson(data))
            .toList();
        return booking_list;
      } else {
        throw Exception('Failed to get bookings for patient');
      }
    } catch (e) {
      throw Exception('Failed to get bookings for patient: $e');
    }
  }

}
