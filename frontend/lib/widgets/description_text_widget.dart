import 'package:flutter/material.dart';
import '/utils/app_styles.dart'; // Assuming you have this file

class DescriptionTextWidget extends StatelessWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add some padding around the text
      child: Text(
        text,
        style: AppStyles.desctext, // Use a style from your app_styles.dart
        textAlign: TextAlign.center, // Center the text
      ),
    );
  }
}