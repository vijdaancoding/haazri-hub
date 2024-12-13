import 'package:flutter/material.dart';
import '../utils/api_service.dart';

class ViewAttendanceScreen extends StatelessWidget {
  const ViewAttendanceScreen({super.key});

  Future<List<String>> fetchAttendance() async {
    return await ApiService.getAttendanceRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchAttendance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('hehe Error: ${snapshot.error}'));
          } else {
            final records = snapshot.data ?? [];
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(records[index]),
              ),
            );
          }
        },
      ),
    );
  }
}
