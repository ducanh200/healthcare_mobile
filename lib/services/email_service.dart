import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  final String apiUrl = 'http://10.0.2.2:8080/api/v3/send_email';

  Future<void> sendBookingConfirmationEmail(String to, String subject, String message) async {
    final url = Uri.parse('$apiUrl');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'to': to,
        'subject': subject,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }
}
