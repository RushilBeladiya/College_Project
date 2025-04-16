// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../../../controller/Student/home/student_home_controller.dart';
// import '../../../../core/utils/colors.dart'; // Import AppColor

// class StudentAttendanceViewScreen extends StatefulWidget {
//   const StudentAttendanceViewScreen({super.key});

//   @override
//   _StudentAttendanceViewScreenState createState() =>
//       _StudentAttendanceViewScreenState();
// }

// class _StudentAttendanceViewScreenState
//     extends State<StudentAttendanceViewScreen> {
//   final StudentHomeController studentHomeController = Get.find();
//   final RxMap<String, List<Map<String, dynamic>>> subjectWiseAttendance = RxMap<
//       String, List<Map<String, dynamic>>>(); // Ensure proper initialization
//   final DatabaseReference _dbRef =
//       FirebaseDatabase.instance.ref().child('attendance');

//   DateTime startDate = DateTime.now().subtract(Duration(days: 30));
//   DateTime endDate = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     fetchAttendanceRecords();
//   }

//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       initialDateRange: DateTimeRange(start: startDate, end: endDate),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         startDate = picked.start;
//         endDate = picked.end;
//       });
//       fetchAttendanceRecords();
//     }
//   }

//   void fetchAttendanceRecords() async {
//     try {
//       String loggedInUserSpid = studentHomeController.currentStudent.value.spid;
//       String stream = studentHomeController.currentStudent.value.stream;
//       String semester = studentHomeController.currentStudent.value.semester;
//       String division = studentHomeController.currentStudent.value.division;

//       if (loggedInUserSpid.isEmpty ||
//           stream.isEmpty ||
//           semester.isEmpty ||
//           division.isEmpty) {
//         Get.snackbar("Error", "Student details are missing.");
//         return;
//       }

//       DatabaseEvent event =
//           await _dbRef.child(stream).child(semester).child(division).once();

//       if (event.snapshot.value != null) {
//         Map<dynamic, dynamic> subjects =
//             event.snapshot.value as Map<dynamic, dynamic>;

//         Map<String, List<Map<String, dynamic>>> groupedAttendance = {};

//         subjects.forEach((subjectName, dates) {
//           if (dates is Map<dynamic, dynamic>) {
//             List<Map<String, dynamic>> attendanceList = [];

//             dates.forEach((dateKey, studentRecords) {
//               if (studentRecords is Map<dynamic, dynamic>) {
//                 DateTime recordDate = DateFormat('yyyy-MM-dd').parse(dateKey);
//                 if (recordDate.isAfter(startDate) &&
//                     recordDate.isBefore(endDate)) {
//                   if (studentRecords.containsKey(loggedInUserSpid)) {
//                     var details = studentRecords[loggedInUserSpid];
//                     attendanceList.add({
//                       'date': dateKey,
//                       'status': details['status']?.toString() ?? 'Absent',
//                     });
//                   }
//                 }
//               }
//             });

//             if (attendanceList.isNotEmpty) {
//               groupedAttendance[subjectName] = attendanceList;
//             }
//           }
//         });

//         subjectWiseAttendance
//             .assignAll(groupedAttendance); // Use assignAll to update RxMap
//       } else {
//         subjectWiseAttendance.clear(); // Clear data if no records found
//         Get.snackbar("Info", "No attendance records found.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch attendance records: $e");
//     }
//   }

//   double calculateAttendancePercentage(List<Map<String, dynamic>> records) {
//     int totalLectures = records.length;
//     int presentCount = records
//         .where(
//             (record) => record['status'].toString().toLowerCase() == 'present')
//         .length;
//     return (totalLectures == 0) ? 0.0 : (presentCount / totalLectures) * 100;
//   }

//   int calculateTotalPresentLectures(List<Map<String, dynamic>> records) {
//     return records
//         .where(
//             (record) => record['status'].toString().toLowerCase() == 'present')
//         .length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Attendance Report',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: AppColor.primaryColor,
//         elevation: 5,
//       ),
//       body: Obx(() {
//         final attendanceData = subjectWiseAttendance;

//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               // Subject-wise Attendance List
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: attendanceData.length,
//                 itemBuilder: (context, index) {
//                   String subject = attendanceData.keys.elementAt(index);
//                   List<Map<String, dynamic>> records = attendanceData[subject]!;

//                   return Card(
//                     margin: const EdgeInsets.all(12),
//                     elevation: 5,
//                     child: ExpansionTile(
//                       title: Text(subject,
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Text(
//                         'Lectures: ${records.length}, Present: ${calculateTotalPresentLectures(records)}',
//                       ),
//                       trailing: Text(
//                         '${calculateAttendancePercentage(records).toStringAsFixed(1)}%',
//                         style: TextStyle(
//                           color: AppColor.primaryColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Column(
//                             children: records.map((record) {
//                               return ListTile(
//                                 title: Text(record['date']),
//                                 trailing: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 12, vertical: 6),
//                                   decoration: BoxDecoration(
//                                     color: record['status']
//                                                 .toString()
//                                                 .toLowerCase() ==
//                                             'present'
//                                         ? Colors.green.withOpacity(0.2)
//                                         : Colors.red.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Text(
//                                     record['status'].toString(),
//                                     style: TextStyle(
//                                       color: record['status']
//                                                   .toString()
//                                                   .toLowerCase() ==
//                                               'present'
//                                           ? Colors.green
//                                           : Colors.red,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/Student/home/student_home_controller.dart';
import '../../../../core/utils/colors.dart';

class StudentAttendanceViewScreen extends StatefulWidget {
  const StudentAttendanceViewScreen({super.key});

  @override
  _StudentAttendanceViewScreenState createState() =>
      _StudentAttendanceViewScreenState();
}

class _StudentAttendanceViewScreenState
    extends State<StudentAttendanceViewScreen> {
  final StudentHomeController studentHomeController = Get.find();
  final RxMap<String, List<Map<String, dynamic>>> subjectWiseAttendance =
      RxMap<String, List<Map<String, dynamic>>>();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('attendance');

  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  bool isLoading = false;

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      fetchAttendanceRecords();
    }
  }

  Future<void> fetchAttendanceRecords() async {
    setState(() => isLoading = true);
    try {
      String loggedInUserSpid = studentHomeController.currentStudent.value.spid;
      String stream = studentHomeController.currentStudent.value.stream;
      String semester = studentHomeController.currentStudent.value.semester;
      String division = studentHomeController.currentStudent.value.division;

      if (loggedInUserSpid.isEmpty ||
          stream.isEmpty ||
          semester.isEmpty ||
          division.isEmpty) {
        // Get.snackbar("Error", "Student details are missing.");
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

        subjectWiseAttendance.assignAll(groupedAttendance);
      } else {
        subjectWiseAttendance.clear();
        Get.snackbar("Info", "No attendance records found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch attendance records: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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

  Color getPercentageColor(double percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 65) return Colors.orange;
    return Colors.red.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed to white background
      appBar: AppBar(
        title: const Text('Attendance Report',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Obx(() {
              final attendanceData = subjectWiseAttendance;

              if (attendanceData.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.list_alt, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "No attendance records found",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: fetchAttendanceRecords,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Date range info
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date Range:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            InkWell(
                              onTap: () => _selectDateRange(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${DateFormat('MMM d, y').format(startDate)} - ${DateFormat('MMM d, y').format(endDate)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subject-wise Attendance List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: attendanceData.length,
                      itemBuilder: (context, index) {
                        String subject = attendanceData.keys.elementAt(index);
                        List<Map<String, dynamic>> records =
                            attendanceData[subject]!;
                        double percentage =
                            calculateAttendancePercentage(records);
                        int presentCount = records
                            .where((record) =>
                                record['status'].toString().toLowerCase() ==
                                'present')
                            .length;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: percentage / 100,
                                  backgroundColor: Colors.grey.shade200,
                                  color: getPercentageColor(percentage),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$presentCount out of ${records.length} classes attended',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: getPercentageColor(percentage),
                              ),
                            ),
                            children: [
                              const Divider(height: 1),
                              ...records.map((record) {
                                return ListTile(
                                  title: Text(
                                    DateFormat('MMM d, y')
                                        .format(DateTime.parse(record['date'])),
                                  ),
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
