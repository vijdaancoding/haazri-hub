import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import '/services/api_service.dart';
import '/utils/app_colors.dart';
import '/utils/app_styles.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  File? _image;
  final _apiService = ApiService();
  bool _isProcessing = false;
  bool _isCameraInitialized = false;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        controller = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await controller!.initialize();

        _isCameraInitialized = true;
      } else {
        print('No cameras available!');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || !controller!.value.isInitialized) {
      print('Camera is not initialized yet!');
      return;
    }

    try {
      final XFile image = await controller!.takePicture();
      setState(() {
        _image = File(image.path);
        _showPreview = true;
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _processImage() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      String message = await _apiService.sendImageForDetection(_image!);
      _showSuccessMessage(message); // Show success message
    } catch (e) {
      print('Error processing image: $e');
      _showErrorMessage(e.toString()); // Handle error and show error message
    } finally {
      setState(() {
        _isProcessing = false;
        _showPreview = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
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
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
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
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
  }

  void _retry() {
    setState(() {
      _image = null;
      _showPreview = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || controller == null || !controller!.value.isInitialized) {
      return Container(
        color: AppColors.backgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.accentColor,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _showPreview
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPreview = false;
                    });
                  },
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : FittedBox(
            fit: BoxFit.cover, // Ensure the camera preview covers the whole screen
            child: SizedBox(
              width: controller!.value.previewSize!.height,
              height: controller!.value.previewSize!.width,
              child: CameraPreview(controller!),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              ),
            ),
          if (_showPreview && !_isProcessing)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      heroTag: 'retry',
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.close, size: 30),
                      onPressed: _retry,
                    ),
                    FloatingActionButton(
                      heroTag: 'proceed',
                      backgroundColor: AppColors.accentColor,
                      child: Icon(Icons.check, size: 30),
                      onPressed: _processImage,
                    ),
                  ],
                ),
              ),
            ),
          if (!_showPreview)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  backgroundColor: AppColors.accentColor,
                  child: Icon(Icons.camera, size: 30),
                  onPressed: _takePicture,
                ),
              ),
            ),
        ],
      ),
    );
  }
}