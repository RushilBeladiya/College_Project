import 'package:college_project/controller/main/event_Controller';
import 'package:college_project/views/screens/faculty_screens/eventscreen/addeventscreen.dart';
import 'package:college_project/views/screens/faculty_screens/eventscreen/facultydetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';

class FacultyEventScreen extends StatelessWidget {
  final EventController controller = Get.put(EventController());

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor,
      appBar: AppBar(
          title: Text('Faculty Events',
              style: TextStyle(color: AppColor.primaryColor)),
          backgroundColor: Colors.white),
      body: Obx(() => ListView.builder(
            itemCount: controller.events.length,
            itemBuilder: (context, index) {
              final event = controller.events[index];
              return Card(
                color: AppColor.primaryColor.withOpacity(0.1),
                child: ListTile(
                  title: Text(event['title'],
                      style: TextStyle(color: AppColor.primaryColor)),
                  subtitle: Text(event['description']),
                  trailing: Text(event['dateTime']),
                  onTap: () =>
                      Get.to(() => FacultyEventDetailScreen(event: event)),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(AddEventScreen()),
        backgroundColor: AppColor.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
