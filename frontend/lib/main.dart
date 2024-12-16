import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/capture_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/view_attendance_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desktop Attendance System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Dashboard(),
        '/capture': (context) => const CaptureScreen(),
        '/upload': (context) => const UploadScreen(),
        // '/view': (context) => const ViewAttendanceScreen(),
      },
    );
  }
}
