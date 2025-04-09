// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../controller/Student/home/student_home_controller.dart';
// import '../../../../core/utils/colors.dart';

// class StudentReportScreen extends StatefulWidget {
//   const StudentReportScreen({super.key});

//   @override
//   _StudentReportScreenState createState() => _StudentReportScreenState();
// }

// class _StudentReportScreenState extends State<StudentReportScreen> {
//   final StudentHomeController studentHomeController = Get.find();

//   double overallAttendancePercentage = 0.0; // Add this variable

//   @override
//   void initState() {
//     super.initState();
//     studentHomeController.fetchAttendanceRecords(); // Fetch attendance data
//     calculateOverallAttendance(); // Calculate attendance percentage
//   }

//   void calculateOverallAttendance() {
//     final attendanceData = studentHomeController.subjectWiseAttendance;

//     int overallTotalLectures =
//         attendanceData.values.fold(0, (sum, records) => sum + records.length);
//     int overallPresentLectures = attendanceData.values.fold(
//         0,
//         (sum, records) =>
//             sum +
//             records
//                 .where((record) =>
//                     record['status'].toString().toLowerCase() == 'present')
//                 .length);
//     overallAttendancePercentage = (overallTotalLectures == 0)
//         ? 0.0
//         : (overallPresentLectures / overallTotalLectures) * 100;
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
//         final attendanceData = studentHomeController.subjectWiseAttendance;

//         if (attendanceData.isEmpty) {
//           return const Center(
//             child: Text(
//               "No attendance data available.",
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           );
//         }

//         calculateOverallAttendance(); // Ensure percentage is updated

//         return Center(
//           child: Card(
//             margin: const EdgeInsets.all(16),
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColor.primaryColor, Colors.blue.shade800],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Overall Attendance',
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                   const SizedBox(height: 20),
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 130,
//                         height: 130,
//                         child: CircularProgressIndicator(
//                           value: overallAttendancePercentage / 100,
//                           strokeWidth: 12,
//                           backgroundColor: Colors.white.withOpacity(0.2),
//                           color: Colors.greenAccent,
//                         ),
//                       ),
//                       Text(
//                         '${overallAttendancePercentage.toStringAsFixed(1)}%',
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Total Lectures: ${attendanceData.values.fold(0, (sum, records) => sum + records.length)}',
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   Text(
//                     'Present Lectures: ${attendanceData.values.fold(0, (sum, records) => sum + records.where((record) => record['status'].toString().toLowerCase() == 'present').length)}',
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:college_project/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/Student/home/student_home_controller.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({super.key});

  @override
  _StudentReportScreenState createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  final StudentHomeController studentHomeController = Get.find();
  // double overallAttendancePercentage = 0.0;
  // int present = 0;
  // int total = 0;
  // int absent = 0;

  @override
  void initState() {
    super.initState();
    studentHomeController.fetchAttendanceRecords();
    studentHomeController.calculateOverallAttendance();
    // loadAttendanceData();
  }

  // Future<void> loadAttendanceData() async {
  //   setState(() => isLoading = true);
  //   try {
  //     await studentHomeController.fetchAttendanceRecords();
  //     calculateOverallAttendance();
  //   } finally {
  //     if (mounted) {
  //       setState(() => isLoading = false);
  //     }
  //   }
  // }

  // void calculateOverallAttendance() {
  //   final attendanceData = studentHomeController.subjectWiseAttendance;

  //   int overallTotalLectures =
  //       attendanceData.values.fold(0, (sum, records) => sum + records.length);
  //   int overallPresentLectures = attendanceData.values.fold(
  //       0,
  //       (sum, records) =>
  //           sum +
  //           records
  //               .where((record) =>
  //                   record['status'].toString().toLowerCase() == 'present')
  //               .length);

  //   setState(() {
  //     total = overallTotalLectures;
  //     present = overallPresentLectures;
  //     absent = total - present;
  //     overallAttendancePercentage =
  //         (total == 0) ? 0.0 : (present / total) * 100;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text(
            'Attendance Report',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: studentHomeController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              )
            : Obx(() {
                final attendanceData =
                    studentHomeController.subjectWiseAttendance;

                if (attendanceData.isEmpty) {
                  return const Center(
                    child: Text(
                      "No attendance data available.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      // Overall Attendance Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Text(
                              'Overall Attendance',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              studentHomeController
                                  .currentStudent.value.semester,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 180, // Reduced width
                                  height: 180, // Reduced height
                                  child: CustomPaint(
                                    painter: AttendanceProgressPainter(
                                      progress: studentHomeController
                                              .overallAttendancePercentage
                                              .value /
                                          100,
                                      primaryColor: AppColor.primaryColor,
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Obx(
                                      () => Text(
                                        '${studentHomeController.overallAttendancePercentage.value.toStringAsFixed(1)}%', // Added % symbol
                                        style: const TextStyle(
                                          fontSize: 42, // Reduced font size
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(
                                  () => _buildMetricCard(
                                    icon: Icons.check_circle,
                                    value: studentHomeController.present.value,
                                    label: 'Attended',
                                    color: Colors.green,
                                  ),
                                ),
                                Obx(
                                  () => _buildMetricCard(
                                    icon: Icons.close,
                                    value: studentHomeController.absent.value,
                                    label: 'Absent',
                                    color: Colors.red,
                                  ),
                                ),
                                Obx(
                                  () => _buildMetricCard(
                                    icon: Icons.calendar_today,
                                    value: studentHomeController.total.value,
                                    label: 'Total',
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Subject-wise attendance list
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Subject-wise Attendance',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...attendanceData.entries.map((entry) {
                              final subject = entry.key;
                              final records = entry.value;
                              final presentCount = records
                                  .where((record) =>
                                      record['status']
                                          .toString()
                                          .toLowerCase() ==
                                      'present')
                                  .length;
                              final percentage = (records.isEmpty)
                                  ? 0.0
                                  : (presentCount / records.length) * 100;

                              // Updated color logic
                              Color getPercentageColor(double percentage) {
                                if (percentage >= 75) return Colors.green;
                                if (percentage >= 65) return Colors.orange;
                                return Colors
                                    .red.shade800; // Dark red for below 65%
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          subject,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${percentage.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                getPercentageColor(percentage),
                                          ),
                                        ),
                                      ],
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
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class AttendanceProgressPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color backgroundColor;

  AttendanceProgressPainter({
    required this.progress,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10 // Reduced stroke width
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 5, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 10 // Reduced stroke width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius - 5);
    canvas.drawArc(
      rect,
      -0.5 * 3.1416,
      2 * 3.1416 * progress,
      false,
      progressPaint,
    );

    // Draw progress fill
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.1),
          primaryColor.withOpacity(0.05),
        ],
        stops: [0.0, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius - 18, fillPaint); // Adjusted fill radius
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
