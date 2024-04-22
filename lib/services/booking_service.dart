import 'dart:convert';
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
    // Tạo URL endpoint với ID của booking
    final url = Uri.parse('http://10.0.2.2:8080/api/v3/bookings/$id');

    try {
      // Gửi request HTTP để lấy thông tin của booking từ server
      final response = await http.get(url);

      // Kiểm tra status code của response
      if (response.statusCode == 200) {
        // Nếu request thành công, chuyển đổi dữ liệu JSON nhận được thành đối tượng Booking
        final jsonData = json.decode(response.body);
        final bookingDetail = BookingDetail.fromJson((jsonData));
        return bookingDetail;
      } else {
        // Nếu request không thành công, in ra thông báo lỗi
        throw Exception('Failed to load booking');
      }
    } catch (e) {
      // Nếu có lỗi xảy ra trong quá trình gửi request, in ra thông báo lỗi
      throw Exception('Failed to load booking: $e');
    }
  }

}
