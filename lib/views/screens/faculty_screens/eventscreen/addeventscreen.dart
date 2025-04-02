import 'package:college_project/controller/main/event_Controller';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final EventController controller = Get.put(EventController());

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDateTime;

  PlatformFile? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor,
      appBar: AppBar(
          title:
              Text('Add Event', style: TextStyle(color: AppColor.primaryColor)),
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Event Title')),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2101));
                TimeOfDay? pickedTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (pickedDate != null && pickedTime != null) {
                  selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, pickedTime.hour, pickedTime.minute);
                }
              },
              child: Text("Pick Date & Time"),
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['pdf']);
                if (result != null) {
                  selectedFile = result.files.first;
                }
              },
              child: Text("Upload PDF"),
            ),
            Obx(() => controller.isUploading.value
                ? CircularProgressIndicator()
                : Container()),
            ElevatedButton(
              onPressed: () {
                if (selectedDateTime != null && selectedFile != null) {
                  controller.addEvent(
                      titleController.text,
                      descriptionController.text,
                      selectedDateTime!,
                      selectedFile);
                } else {
                  Get.snackbar(
                      "Error", "Please select date/time and upload PDF",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              child: Text("Create Event"),
            ),
          ],
        ),
      ),
    );
  }
}
