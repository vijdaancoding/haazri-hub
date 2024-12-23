import 'package:flutter/material.dart';
import '/utils/app_colors.dart';
import '/utils/app_styles.dart';

class DetectionResultDialog extends StatelessWidget {
  final List<String> detectedObjects;

  DetectionResultDialog({required this.detectedObjects});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detection Results', style: AppStyles.heading1),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: detectedObjects.length,
          itemBuilder: (context, index) {
            final detectedObject = detectedObjects[index];
            return ListTile(
              title: Text(detectedObject, style: AppStyles.bodyText),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('Close', style: TextStyle(color: AppColors.primaryColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}