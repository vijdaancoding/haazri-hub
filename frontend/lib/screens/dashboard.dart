import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              label: 'Capture',
              onPressed: () => Navigator.pushNamed(context, '/capture'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Upload Picture',
              onPressed: () => Navigator.pushNamed(context, '/upload'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'View Attendance',
              onPressed: () => Navigator.pushNamed(context, '/view'),
            ),
          ],
        ),
      ),
    );
  }
}