import 'package:college_project/controller/Faculty/home/faculty_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/main/announcement_controller.dart';
import '../../../../core/utils/colors.dart';

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

  void _showAddAnnouncementDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Add Announcement',
            style: TextStyle(
                color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title, color: AppColor.primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon:
                      Icon(Icons.description, color: AppColor.primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor),
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descController.text.isNotEmpty) {
                controller.addAnnouncement(
                  titleController.text,
                  descController.text,
                  "${facultyHomeController.facultyModel.value.firstName} ${facultyHomeController.facultyModel.value.surName}",
                );
                titleController.clear();
                descController.clear();
                Get.back();
              } else {
                Get.snackbar("Error", "Please fill in all fields",
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            child: Text('Add', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Delete Announcement', style: TextStyle(color: Colors.red)),
        content: Text("Are you sure you want to delete this announcement?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteAnnouncement(id);
              Get.back();
            },
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Announcements',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.primaryColor,
        leading: BackButton(color: Colors.white),
      ),
      body: Obx(() {
        return controller.announcements.isEmpty
            ? Center(
                child: Text(
                  "No Announcements",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.announcements.length,
                itemBuilder: (context, index) {
                  final announcement = controller.announcements[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        announcement.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(announcement.description),
                          const SizedBox(height: 5),
                          Text(
                            'Date: ${announcement.date}',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            _showDeleteConfirmationDialog(announcement.id),
                      ),
                    ),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAnnouncementDialog,
        backgroundColor: AppColor.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
