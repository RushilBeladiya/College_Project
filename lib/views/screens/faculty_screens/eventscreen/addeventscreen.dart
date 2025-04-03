// import 'package:college_project/controller/main/event_Controller';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../core/utils/colors.dart';

// class AddEventScreen extends StatefulWidget {
//   const AddEventScreen({super.key});

//   @override
//   State<AddEventScreen> createState() => _AddEventScreenState();
// }

// class _AddEventScreenState extends State<AddEventScreen> {
//   final EventController controller = Get.put(EventController());

//   final TextEditingController titleController = TextEditingController();

//   final TextEditingController descriptionController = TextEditingController();

//   DateTime? selectedDateTime;

//   PlatformFile? selectedFile;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBackGroundColor,
//       appBar: AppBar(
//           title:
//               Text('Add Event', style: TextStyle(color: AppColor.primaryColor)),
//           backgroundColor: Colors.white),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(labelText: 'Event Title')),
//             TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(labelText: 'Description')),
//             ElevatedButton(
//               onPressed: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2022),
//                     lastDate: DateTime(2101));
//                 TimeOfDay? pickedTime = await showTimePicker(
//                     context: context, initialTime: TimeOfDay.now());
//                 if (pickedDate != null && pickedTime != null) {
//                   selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
//                       pickedDate.day, pickedTime.hour, pickedTime.minute);
//                 }
//               },
//               child: Text("Pick Date & Time"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 FilePickerResult? result = await FilePicker.platform.pickFiles(
//                     type: FileType.custom, allowedExtensions: ['pdf']);
//                 if (result != null) {
//                   selectedFile = result.files.first;
//                 }
//               },
//               child: Text("Upload PDF"),
//             ),
//             Obx(() => controller.isUploading.value
//                 ? CircularProgressIndicator()
//                 : Container()),
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedDateTime != null && selectedFile != null) {
//                   controller.addEvent(
//                       titleController.text,
//                       descriptionController.text,
//                       selectedDateTime!,
//                       selectedFile);
//                 } else {
//                   Get.snackbar(
//                       "Error", "Please select date/time and upload PDF",
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white);
//                 }
//               },
//               child: Text("Create Event"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:college_project/controller/main/event_Controller.dart';
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
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(
          'Add Event',
          style: TextStyle(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 3,
        iconTheme: IconThemeData(color: AppColor.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(titleController, "Event Title"),
            SizedBox(height: 16),
            _buildInputField(descriptionController, "Event Description",
                maxLines: 3),
            SizedBox(height: 16),
            _buildDatePickerButton(),
            SizedBox(height: 16),
            _buildUploadButton(),
            SizedBox(height: 20),
            Obx(() => controller.isUploading.value
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink()),
            SizedBox(height: 25),
            _buildCreateEventButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2101),
        );
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedDate != null && pickedTime != null) {
          setState(() {
            selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
                pickedDate.day, pickedTime.hour, pickedTime.minute);
          });
        }
      },
      icon: Icon(Icons.calendar_today, color: Colors.white),
      label: Text(
        selectedDateTime != null
            ? "Selected: ${selectedDateTime!.toLocal()}"
            : "Pick Date & Time",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: () async {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
        if (result != null) {
          setState(() {
            selectedFile = result.files.first;
          });
        }
      },
      icon: Icon(Icons.upload_file, color: Colors.white),
      label: Text(
        selectedFile != null ? "PDF Uploaded" : "Upload PDF",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildCreateEventButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: () {
        if (selectedDateTime != null && selectedFile != null) {
          controller.addEvent(
            titleController.text,
            descriptionController.text,
            selectedDateTime!,
            selectedFile,
          );
          Get.snackbar("Success", "Event added successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else {
          Get.snackbar("Error", "Please select date/time and upload PDF",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      },
      child: Center(
        child: Text(
          "Create Event",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
