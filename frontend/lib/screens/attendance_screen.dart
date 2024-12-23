import 'package:flutter/material.dart';
import '/models/attendance_data.dart';
import '/services/api_service.dart';
import '/utils/app_colors.dart';
import '/utils/app_styles.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _apiService = ApiService();
  List<AttendanceData> _attendanceData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _attendanceData = await _apiService.getAttendanceRecords();
    } catch (e) {
      print('Error fetching attendance data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch attendance data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records', style: AppStyles.heading1),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      )
          : _attendanceData.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No attendance records found.',
                style: AppStyles.bodyText),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchAttendanceData,
              child: Text('Retry',
                  style: AppStyles.bodyText
                      .copyWith(color: AppColors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchAttendanceData,
        child: ListView.builder(
          itemCount: _attendanceData.length,
          itemBuilder: (context, index) {
            final attendance = _attendanceData[index];
            return ExpansionTile(
              title: Text(
                'Date: ${attendance.date}',
                style: AppStyles.heading1.copyWith(
                    fontSize: 18.0,
                    color: AppColors.primaryDark
                ),
              ),
              backgroundColor: AppColors.white,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: attendance.records.length,
                  itemBuilder: (context, index) {
                    final record = attendance.records[index];
                    return Container(
                      color: const Color.fromARGB(255, 255, 255, 255), // Alternate row color
                      child: ListTile(
                        title: Text(
                          '${record.regNum}',
                          style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 21, 112, 176)),
                        ),
                        
                        trailing: Text(
                          record.status == 'P' ? 'Present' : 'Absent',
                          style: TextStyle(
                            color: record.status == 'P'
                                ? AppColors.successColor
                                : AppColors.errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}   