import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import '/models/detection_result.dart';
import '/models/attendance_data.dart';

class ApiService {
  final String baseUrl = 'http://192.168.3.3:8000/api'; // Replace
  final Dio _dio = Dio();

  Future<List<AttendanceData>> getAttendanceRecords() async {
    final url = '$baseUrl/get-attendance/';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        List<AttendanceData> attendanceDataList = [];

        jsonData.forEach((date, records) {
          attendanceDataList.add(AttendanceData.fromJson(date, records));
        });

        return attendanceDataList;
      } else {
        throw Exception(
            'Failed to load attendance data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Failed to load attendance data: ${e.response!.statusCode}');
      } else {
        throw Exception('Error fetching attendance data: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error fetching attendance data: $e');
    }
  }

  Future<String> sendImageForDetection(dynamic file) async {
    final url = '$baseUrl/detect-objects/';

    try {
      late FormData formData;

      if (kIsWeb) {
        // Web-specific implementation using FormData
        final bytes = await file.readAsBytes();
        formData = FormData.fromMap({
          'image': MultipartFile.fromBytes(
            bytes,
            filename: 'image.jpg',
          ),
        });
      } else {
        // Mobile (dart:io) implementation
        formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            file.path,
            filename: 'image.jpg',
          ),
        });
      }

      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200) {
        // Now expecting a message in the response
        Map<String, dynamic> responseData = response.data;
        return responseData['message']; // Return the success message
      } else {
        throw Exception('Failed to process image: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Failed to process image: ${e.response!.statusCode}');
      } else {
        throw Exception('Error sending image: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error sending image: $e');
    }
  }
}