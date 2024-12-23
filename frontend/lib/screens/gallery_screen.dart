import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '/services/api_service.dart'; // Correct import path
import '/utils/app_colors.dart'; // Correct import path
import '/utils/app_styles.dart'; // Correct import path

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  dynamic _imageFile;
  final _apiService = ApiService();
  bool _isProcessing = false;

  Future<void> _getImage() async {
    if (kIsWeb) {
      // Web: Use file picker to select image
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _imageFile = result.files.first; // Store as bytes
          _isProcessing = true;
        });
        _processImage(_imageFile);
      }
    } else {
      // Mobile: Use image picker to select image
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isProcessing = true;
        });
        _processImage(_imageFile);
      }
    }
  }

  Future<void> _processImage(dynamic imageFile) async {
    try {
      String message =
          await _apiService.sendImageForDetection(imageFile);
      _showSuccessMessage(message); // Show success message
    } catch (e) {
      print('Error processing image: $e');
      _showErrorMessage(e.toString());
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors
            .surfaceColor, // Set the background color of the AlertDialog
        title: Text(
          'Success',
          style: AppStyles.heading1.copyWith(
            color: AppColors.successColor,
          ),
        ),
        content: Text(
          message,
          style: AppStyles.bodyText,
        ),
        actions: [
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors
                .surfaceColor, // Set the background color of the AlertDialog
            title: Text(
              'Error',
              style: AppStyles.heading1.copyWith(
                color: AppColors.errorColor,
              ),
            ),
            content: Text(
              message,
              style: AppStyles.bodyText,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: AppColors.primaryColor),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload from Gallery', style: AppStyles.heading1),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: _isProcessing
            ? CircularProgressIndicator(color: AppColors.accentColor)
            : Text('No image selected.', style: AppStyles.bodyText),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentColor,
        onPressed: _getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}