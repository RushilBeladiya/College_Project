// import 'package:college_project/controller/main/event_Controller';
// import 'package:college_project/views/screens/faculty_screens/eventscreen/addeventscreen.dart';
// import 'package:college_project/views/screens/faculty_screens/eventscreen/facultydetailscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../core/utils/colors.dart';

// class FacultyEventScreen extends StatelessWidget {
//   final EventController controller = Get.put(EventController());

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBackGroundColor,
//       appBar: AppBar(
//           title: Text('Faculty Events',
//               style: TextStyle(color: AppColor.primaryColor)),
//           backgroundColor: Colors.white),
//       body: Obx(() => ListView.builder(
//             itemCount: controller.events.length,
//             itemBuilder: (context, index) {
//               final event = controller.events[index];
//               return Card(
//                 color: AppColor.primaryColor.withOpacity(0.1),
//                 child: ListTile(
//                   title: Text(event['title'],
//                       style: TextStyle(color: AppColor.primaryColor)),
//                   subtitle: Text(event['description']),
//                   trailing: Text(event['dateTime']),
//                   onTap: () =>
//                       Get.to(() => FacultyEventDetailScreen(event: event)),
//                 ),
//               );
//             },
//           )),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Get.to(AddEventScreen()),
//         backgroundColor: AppColor.primaryColor,
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }

import 'package:college_project/controller/main/event_Controller';
import 'package:college_project/views/screens/faculty_screens/eventscreen/addeventscreen.dart';
import 'package:college_project/views/screens/faculty_screens/eventscreen/facultydetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';

class FacultyEventScreen extends StatelessWidget {
  final EventController controller = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background set to white
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor, // Primary-colored AppBar
        title: Text(
          'Faculty Events',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 4, // Adds shadow
        centerTitle: true, // Centers title
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.events.isEmpty
          ? Center(
              child: Text(
                "No events available",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                final event = controller.events[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    title: Text(
                      event['title'],
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        event['description'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        SizedBox(height: 4),
                        Text(
                          event['dateTime'],
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    onTap: () =>
                        Get.to(() => FacultyEventDetailScreen(event: event)),
                  ),
                );
              },
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(AddEventScreen()),
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        elevation: 6,
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
