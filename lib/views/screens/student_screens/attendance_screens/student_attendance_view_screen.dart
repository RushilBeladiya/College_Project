import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/Student/home/student_home_controller.dart';
import '../../../../core/utils/colors.dart'; // Import AppColor

class StudentAttendanceViewScreen extends StatefulWidget {
  const StudentAttendanceViewScreen({super.key});

  @override
  _StudentAttendanceViewScreenState createState() =>
      _StudentAttendanceViewScreenState();
}

class _StudentAttendanceViewScreenState
    extends State<StudentAttendanceViewScreen> {
  final StudentHomeController studentHomeController = Get.find();
  RxMap<String, List<Map<String, dynamic>>> subjectWiseAttendance =
      <String, List<Map<String, dynamic>>>{}.obs;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('attendance');

  DateTime startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchAttendanceRecords();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      fetchAttendanceRecords();
    }
  }

  void fetchAttendanceRecords() async {
    try {
      String loggedInUserSpid = studentHomeController.currentStudent.value.spid;
      String stream = studentHomeController.currentStudent.value.stream;
      String semester = studentHomeController.currentStudent.value.semester;
      String division = studentHomeController.currentStudent.value.division;

      if (loggedInUserSpid.isEmpty ||
          stream.isEmpty ||
          semester.isEmpty ||
          division.isEmpty) {
        Get.snackbar("Error", "Student details are missing.");
        return;
      }

      DatabaseEvent event =
          await _dbRef.child(stream).child(semester).child(division).once();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> subjects =
            event.snapshot.value as Map<dynamic, dynamic>;

        Map<String, List<Map<String, dynamic>>> groupedAttendance = {};

        subjects.forEach((subjectName, dates) {
          if (dates is Map<dynamic, dynamic>) {
            List<Map<String, dynamic>> attendanceList = [];

            dates.forEach((dateKey, studentRecords) {
              if (studentRecords is Map<dynamic, dynamic>) {
                DateTime recordDate = DateFormat('yyyy-MM-dd').parse(dateKey);
                if (recordDate.isAfter(startDate) &&
                    recordDate.isBefore(endDate)) {
                  if (studentRecords.containsKey(loggedInUserSpid)) {
                    var details = studentRecords[loggedInUserSpid];
                    attendanceList.add({
                      'date': dateKey,
                      'status': details['status']?.toString() ?? 'Absent',
                    });
                  }
                }
              }
            });

            if (attendanceList.isNotEmpty) {
              groupedAttendance[subjectName] = attendanceList;
            }
          }
        });

        subjectWiseAttendance.value = groupedAttendance;
      } else {
        subjectWiseAttendance.value = {}; // Clear data if no records found
        Get.snackbar("Info", "No attendance records found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch attendance records: $e");
    }
  }

  double calculateAttendancePercentage(List<Map<String, dynamic>> records) {
    int totalLectures = records.length;
    int presentCount = records
        .where(
            (record) => record['status'].toString().toLowerCase() == 'present')
        .length;
    return (totalLectures == 0) ? 0.0 : (presentCount / totalLectures) * 100;
  }

  int calculateTotalPresentLectures(List<Map<String, dynamic>> records) {
    return records
        .where(
            (record) => record['status'].toString().toLowerCase() == 'present')
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Attendance Report',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primaryColor,
        elevation: 5,
      ),
      body: Obx(() {
        final attendanceData = subjectWiseAttendance;

        int overallTotalLectures = attendanceData.values
            .fold(0, (sum, records) => sum + records.length);
        int overallPresentLectures = attendanceData.values.fold(
            0, (sum, records) => sum + calculateTotalPresentLectures(records));
        double overallAttendancePercentage = (overallTotalLectures == 0)
            ? 0.0
            : (overallPresentLectures / overallTotalLectures) * 100;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Overall Attendance Card with Date Range Button Inside
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.primaryColor, Colors.blue.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Overall Attendance',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 130,
                            height: 130,
                            child: CircularProgressIndicator(
                              value: overallAttendancePercentage / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              color: Colors.greenAccent,
                            ),
                          ),
                          Text(
                            '${overallAttendancePercentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Total Lectures: $overallTotalLectures',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Present Lectures: $overallPresentLectures',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _selectDateRange(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Select Date Range'),
                      ),
                    ],
                  ),
                ),
              ),

              // Subject-wise Attendance List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attendanceData.length,
                itemBuilder: (context, index) {
                  String subject = attendanceData.keys.elementAt(index);
                  List<Map<String, dynamic>> records = attendanceData[subject]!;

                  return Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 5,
                    child: ExpansionTile(
                      title: Text(subject,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Lectures: ${records.length}, Present: ${calculateTotalPresentLectures(records)}',
                      ),
                      trailing: Text(
                        '${calculateAttendancePercentage(records).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: records.map((record) {
                              return ListTile(
                                title: Text(record['date']),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: record['status']
                                                .toString()
                                                .toLowerCase() ==
                                            'present'
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    record['status'].toString(),
                                    style: TextStyle(
                                      color: record['status']
                                                  .toString()
                                                  .toLowerCase() ==
                                              'present'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
