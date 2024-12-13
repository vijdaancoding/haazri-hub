import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<String>> getAttendanceRecords() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/attendance/list/'));

      if (response.statusCode == 200) {
        // Parse and return the JSON data
        return List<String>.from(json.decode(response.body));
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch attendance records 11');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch attendance records 22');
    }
  }
}
