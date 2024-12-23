import 'package:flutter/material.dart';
import '/screens/dashboard_screen.dart';
import '/utils/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hazari Hub',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch, // Use your custom color scheme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}