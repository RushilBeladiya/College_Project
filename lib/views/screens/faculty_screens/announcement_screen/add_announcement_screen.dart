import 'package:college_project/controller/Faculty/home/faculty_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/main/announcement_controller.dart';

class FacultyAnnouncementScreen extends StatefulWidget {
  const FacultyAnnouncementScreen({super.key});

  @override
  State<FacultyAnnouncementScreen> createState() =>
      _FacultyAnnouncementScreenState();
}

class _FacultyAnnouncementScreenState extends State<FacultyAnnouncementScreen> {
  final AnnouncementController controller = Get.put(AnnouncementController());
  final FacultyHomeController facultyHomeController = Get.find();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Faculty Announcements')),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.announcements.length,
          itemBuilder: (context, index) {
            final announcement = controller.announcements[index];
            return Card(
              margin: EdgeInsets.all(8),
              color: Colors.blue.shade100,
              child: ListTile(
                title: Text(announcement.title,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(announcement.description),
                    SizedBox(height: 5),
                    Text('Date: ${announcement.date}',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      controller.deleteAnnouncement(announcement.id),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Announcement'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Title')),
                    TextField(
                        controller: descController,
                        maxLines: 5,
                        decoration: InputDecoration(labelText: 'Description')),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      controller.addAnnouncement(
                          titleController.text, descController.text, "${facultyHomeController.facultyModel.value.firstName} ${facultyHomeController.facultyModel.value.surName}");
                      titleController.clear();
                      descController.clear();
                      Get.back();
                    },
                    child: Text('Add'),
                  )
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
