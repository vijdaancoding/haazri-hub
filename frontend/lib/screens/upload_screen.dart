import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../utils/api_service.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

  Future<void> _uploadImage(BuildContext context) async {
    try {
      // Open file picker to select an image
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Upload image to API
        final response = await ApiService.uploadImage(file);

        // Hide loading indicator
        Navigator.of(context).pop();

        if (response["detected_objects"] != null) {
          // Show detected objects in a dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Detected Students"),
                content: Text(response["detected_objects"].join(", ")),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          // Show error
          throw Exception("Invalid response from the server");
        }
      }
    } catch (e) {
      Navigator.of(context).pop(); // Ensure dialog is closed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to upload image: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _uploadImage(context),
          child: const Text('Select and Upload Image'),
        ),
      ),
    );
  }
}
