// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:intl/intl.dart';
// import 'package:college_project/controller/main/lecture_controller.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// class StudentLectureListScreen extends StatefulWidget {
//   const StudentLectureListScreen({super.key, required this.studentStream, required this.studentSemester});

//   final String studentStream;
//   final String studentSemester;

//   @override
//   State<StudentLectureListScreen> createState() => _StudentLectureListScreenState();
// }

// class _StudentLectureListScreenState extends State<StudentLectureListScreen> {
//   final LectureController lectureController = Get.put(LectureController());
//   DateTime selectedDate = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     lectureController.fetchStudentLectures(widget.studentStream, widget.studentSemester);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Lectures"),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 5,
//       ),
//       body: Column(
//         children: [
//           _buildWeekDateSelector(),
//           Expanded(
//             child: Obx(() {
//               if (lectureController.isLoading.value) {
//                 return _buildShimmerLoading();
//               }

//               final filteredLectures = lectureController.studentLecturesList.where((lecture) =>
//               lecture["date"] == DateFormat('dd-MM-yyyy').format(selectedDate)).toList();

//               if (filteredLectures.isEmpty) {
//                 return Center(
//                   child: Text(
//                     "No lectures available",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
//                   ),
//                 );
//               }

//               return AnimationLimiter(
//                 child: ListView.builder(
//                   itemCount: filteredLectures.length,
//                   itemBuilder: (context, index) {
//                     final lecture = filteredLectures[index];
//                     return AnimationConfiguration.staggeredList(
//                       position: index,
//                       duration: Duration(milliseconds: 500),
//                       child: SlideAnimation(
//                         verticalOffset: 50.0,
//                         child: FadeInAnimation(
//                           child: _buildLectureCard(lecture),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeekDateSelector() {
//     DateTime today = DateTime.now();
//     DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(7, (index) {
//           DateTime date = startOfWeek.add(Duration(days: index));
//           bool isSelected = date.day == selectedDate.day;
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 selectedDate = date;
//               });
//             },
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blueAccent : Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   if (isSelected)
//                     BoxShadow(
//                       color: Colors.blue.withOpacity(0.3),
//                       blurRadius: 10,
//                     ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     DateFormat('E').format(date), // Mon, Tue, etc.
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   Text(
//                     "${date.day}",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildShimmerLoading() {
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Card(
//             elevation: 3,
//             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//             child: ListTile(
//               title: Container(height: 16, color: Colors.white),
//               subtitle: Container(height: 12, color: Colors.white),
//               leading: CircleAvatar(backgroundColor: Colors.white),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLectureCard(Map<String, dynamic> lecture) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(10),
//         leading: CircleAvatar(
//           radius: 30,
//           backgroundColor: Colors.blueAccent,
//           child: Icon(Icons.book, color: Colors.white),
//         ),
//         title: Text(
//           lecture["subject"],
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 5),
//           child: Text(
//             "📌 Professor: ${lecture["professor"]}\n"
//                 "Division: ${lecture["division"]}\n"
//                 "📅 Date: ${lecture["date"]}\n"
//                 "⏰ Time: ${lecture["start_time"]} - ${lecture["end_time"]}\n"
//                 "🏫 Room No: ${lecture["room"]}",
//             style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:college_project/controller/main/lecture_controller.dart';
import 'package:college_project/core/utils/colors.dart'; // Added AppColor import
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class StudentLectureListScreen extends StatefulWidget {
  const StudentLectureListScreen({
    super.key,
    required this.studentStream,
    required this.studentSemester,
  });

  final String studentStream;
  final String studentSemester;

  @override
  State<StudentLectureListScreen> createState() =>
      _StudentLectureListScreenState();
}

class _StudentLectureListScreenState extends State<StudentLectureListScreen> {
  final LectureController lectureController = Get.put(LectureController());
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    lectureController.fetchStudentLectures(
        widget.studentStream, widget.studentSemester);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text("My Lectures", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor, // Use primary color
        elevation: 5,
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Column(
        children: [
          _buildWeekDateSelector(),
          Expanded(
            child: Obx(() {
              if (lectureController.isLoading.value) {
                return _buildShimmerLoading();
              }

              final filteredLectures = lectureController.studentLecturesList
                  .where((lecture) =>
                      lecture["date"] ==
                      DateFormat('dd-MM-yyyy').format(selectedDate))
                  .toList();

              if (filteredLectures.isEmpty) {
                return const Center(
                  child: Text(
                    "No lectures available",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return AnimationLimiter(
                child: ListView.builder(
                  itemCount: filteredLectures.length,
                  itemBuilder: (context, index) {
                    final lecture = filteredLectures[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildLectureCard(lecture),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Week date selector with primary color
  Widget _buildWeekDateSelector() {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          DateTime date = startOfWeek.add(Duration(days: index));
          bool isSelected = date.day == selectedDate.day;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryColor
                    : Colors.white, // Primary color
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('E').format(date), // Mon, Tue, etc.
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "${date.day}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Shimmer loading effect
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: const ListTile(
              title: SizedBox(
                  height: 16,
                  width: double.infinity,
                  child: ColoredBox(color: Colors.white)),
              subtitle: SizedBox(
                  height: 12,
                  width: double.infinity,
                  child: ColoredBox(color: Colors.white)),
              leading: CircleAvatar(backgroundColor: Colors.white),
            ),
          ),
        );
      },
    );
  }

  /// Lecture card with consistent primary color
  Widget _buildLectureCard(Map<String, dynamic> lecture) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      color: Colors.white, // Background white for card
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: AppColor.primaryColor, // Primary color
          child: const Icon(Icons.book, color: Colors.white),
        ),
        title: Text(
          lecture["subject"],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            "📌 Professor: ${lecture["professor"]}\n"
            "Division: ${lecture["division"]}\n"
            "📅 Date: ${lecture["date"]}\n"
            "⏰ Time: ${lecture["start_time"]} - ${lecture["end_time"]}\n"
            "🏫 Room No: ${lecture["room"]}",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}
