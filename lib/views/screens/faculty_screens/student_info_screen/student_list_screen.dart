import 'package:college_project/controller/Faculty/home/faculty_home_controller.dart';
import 'package:college_project/views/screens/faculty_screens/student_info_screen/student_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final FacultyHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Student List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => controller.searchStudent(value),
              decoration: InputDecoration(
                labelText: "Search Student",
                labelStyle: TextStyle(color: AppColor.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
                prefixIcon: Icon(Icons.search, color: AppColor.primaryColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
                ),
              ),
            ),
          ),

          // Student List
          Expanded(
            child: Obx(() => AnimationLimiter(
              child: ListView.builder(
                itemCount: controller.filteredStudents.length,
                itemBuilder: (context, index) {
                  var student = controller.filteredStudents[index];
                  String searchQuery = controller.searchQuery.value;

                  // Check if the student name or SPID contains the search query
                  bool isHighlighted = searchQuery.isNotEmpty &&
                      ("${student['firstName']} ${student['lastName']}"
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                          student['spid']
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()));

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isHighlighted
                                ? BorderSide(
                                color: AppColor.primaryColor, width: 2)
                                : BorderSide(
                                color: Colors.transparent, width: 1),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            leading: CircleAvatar(
                              backgroundColor: AppColor.primaryColor,
                              child: Text(
                                student['firstName'][0].toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              "${student['firstName']} ${student['lastName']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              "SPID: ${student['spid']}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.grey),
                            onTap: () {
                              Get.to(
                                    () => StudentDetailScreen(student),
                                transition: Transition.rightToLeft,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )),
          ),
        ],
      ),
    );
  }
}
