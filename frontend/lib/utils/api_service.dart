import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/detect-objects/');
    final request = http.MultipartRequest('POST', url);

    // Attach the image file
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Parse the response
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          "Error uploading image: ${response.statusCode} - ${response.body}");
    }
  }
}