import 'package:college_project/views/screens/student_screens/event_screen/studenteventdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/main/event_Controller.dart';
import '../../../../core/utils/colors.dart';

class StudentEventScreen extends StatefulWidget {
  const StudentEventScreen({super.key});

  @override
  State<StudentEventScreen> createState() => _StudentEventScreenState();
}

class _StudentEventScreenState extends State<StudentEventScreen> {
  final EventController controller = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor, // White background
      appBar: AppBar(
        title: Text(
          'Student Events',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 2, // Adds a slight shadow for a modern look
        iconTheme: IconThemeData(color: AppColor.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() => controller.events.isEmpty
            ? Center(
                child: Text(
                  "No events available",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.events.length,
                itemBuilder: (context, index) {
                  final event = controller.events[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        event['title'],
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          event['description'],
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today,
                              color: AppColor.primaryColor, size: 18),
                          SizedBox(height: 4),
                          Text(
                            event['dateTime'],
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      onTap: () =>
                          Get.to(() => StudentEventDetailScreen(event: event)),
                    ),
                  );
                },
              )),
      ),
    );
  }
}
