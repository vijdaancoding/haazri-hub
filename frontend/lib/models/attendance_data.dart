class AttendanceData {
  final String date;
  final List<AttendanceRecord> records;

  AttendanceData({required this.date, required this.records});

  factory AttendanceData.fromJson(String date, List<dynamic> jsonRecords) {
    List<AttendanceRecord> records = jsonRecords
        .map((record) => AttendanceRecord.fromJson(record))
        .toList();
    return AttendanceData(date: date, records: records);
  }

  // Added toJson() method
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'records': records.map((record) => record.toJson()).toList(),
    };
  }
}

class AttendanceRecord {
  final String regNum;
  final String? name;
  final String status;

  AttendanceRecord({required this.regNum, required this.name, required this.status});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      regNum: json['reg_num'],
      name: json['name'],
      status: json['status'],
    );
  }

  // Added toJson() method
  Map<String, dynamic> toJson() {
    return {
      'reg_num': regNum,
      'name': name,
      'status': status,
    };
  }
}