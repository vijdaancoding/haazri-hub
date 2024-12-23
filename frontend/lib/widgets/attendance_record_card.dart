import 'package:flutter/material.dart';
import '/utils/app_colors.dart';
import '/utils/app_styles.dart';

class AttendanceRecordCard extends StatelessWidget {
  final List<String> detectedObjects; // Now takes the list of IDs

  AttendanceRecordCard({required this.detectedObjects});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detected Objects',
              style: AppStyles.heading1.copyWith(fontSize: 20),
            ),
            SizedBox(height: 5),
            // Display the list of detected objects
            ...detectedObjects.map((id) => Text(id, style: AppStyles.bodyText)).toList(),
          ],
        ),
      ),
    );
  }
}