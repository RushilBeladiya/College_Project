// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../controller/main/syllabus_controller.dart';
// import '../../subject_screen/pdf_view_screen.dart';

// class FacultySyllabusScreen extends StatefulWidget {
//   const FacultySyllabusScreen({super.key});

//   @override
//   _FacultySyllabusScreenState createState() => _FacultySyllabusScreenState();
// }

// class _FacultySyllabusScreenState extends State<FacultySyllabusScreen> {
//   final SyllabusController controller = Get.find();

//   void _showUploadDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: Text("Upload PDF"),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(controller: controller.titleController, decoration: InputDecoration(labelText: "PDF Title")),
//               TextField(controller: controller.subjectController, decoration: InputDecoration(labelText: "Subject")),
//               DropdownButtonFormField<String>(
//                 value: controller.selectedSemester.value,
//                 items: ["Semester 1", "Semester 2", "Semester 3","Semester 4", "Semester 5", "Semester 6","Semester 7", "Semester 8"].map((semester) {
//                   return DropdownMenuItem(value: semester, child: Text(semester));
//                 }).toList(),
//                 onChanged: (value) => controller.selectedSemester.value = value,
//                 decoration: InputDecoration(labelText: "Semester"),
//               ),
//               DropdownButtonFormField<String>(
//                 value: controller.selectedStream.value,
//                 items: ["BCA", "BCOM", "BBA"].map((stream) {
//                   return DropdownMenuItem(value: stream, child: Text(stream));
//                 }).toList(),
//                 onChanged: (value) => controller.selectedStream.value = value,
//                 decoration: InputDecoration(labelText: "Stream"),
//               ),
//               TextField(controller: controller.descriptionController, decoration: InputDecoration(labelText: "Description")),
//               SizedBox(height: 10),
//               ElevatedButton(onPressed: controller.pickPDF, child: Text("Pick PDF")),
//               Obx(() => controller.selectedFile.value != null ? Text("File Selected") : Container()),
//               SizedBox(height: 10),
//               ElevatedButton(onPressed: controller.uploadPDF, child: Text("Upload PDF")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _deletePDF(String key, String pdfUrl) async {
//     try {
//       await FirebaseDatabase.instance.ref("syllabus").child(key).remove();
//       await FirebaseStorage.instance.refFromURL(pdfUrl).delete();
//       Get.snackbar("Success", "PDF deleted successfully", snackPosition: SnackPosition.BOTTOM);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to delete PDF", snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Faculty Panel")),
//       body: Obx(() => RefreshIndicator(
//         onRefresh: () async {
//           controller.isLoading.value = true;
//           await Future.delayed(Duration(seconds: 2));
//           controller.isLoading.value = false;
//         },
//         child: controller.isLoading.value
//             ? ListView.builder(
//           itemCount: 11,
//           itemBuilder: (context, index) {
//             return Shimmer.fromColors(
//               baseColor: Colors.grey[300]!,
//               highlightColor: Colors.grey[100]!,
//               child: ListTile(
//                 title: Container(height: 10, color: Colors.white),
//                 subtitle: Container(height: 10, color: Colors.white),
//               ),
//             );
//           },
//         )
//             : StreamBuilder(
//           stream: controller.databaseRef.onValue,
//           builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//             if (!snapshot.hasData || snapshot.data!.snapshot.value == null) return Center(child: CircularProgressIndicator());
//             Map<dynamic, dynamic> pdfs = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//             return ListView.builder(
//               itemCount: pdfs.length,
//               itemBuilder: (context, index) {
//                 var entry = pdfs.entries.elementAt(index);
//                 var key = entry.key;
//                 var doc = entry.value;
//                 return AnimationConfiguration.staggeredList(
//                   position: index,
//                   duration: const Duration(milliseconds: 500),
//                   child: SlideAnimation(
//                     verticalOffset: 50.0,
//                     child: FadeInAnimation(
//                       child: Card(
//                         child: ListTile(
//                           title: Text(doc['title']),
//                           subtitle: Text("${doc['subject']} - ${doc['semester']} - ${doc['stream']}\nTime: ${doc['upload_time']}"),
//                           onTap: () => Get.to(() => PDFViewerScreen(pdfUrl: doc['pdfUrl'])),
//                           trailing: IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deletePDF(key, doc['pdfUrl']),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       )),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showUploadDialog,
//         child: Icon(Icons.upload_file),
//       ),
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controller/main/syllabus_controller.dart';
import '../../../../core/utils/colors.dart';
import '../../subject_screen/pdf_view_screen.dart';

class FacultySyllabusScreen extends StatefulWidget {
  const FacultySyllabusScreen({super.key});

  @override
  _FacultySyllabusScreenState createState() => _FacultySyllabusScreenState();
}

class _FacultySyllabusScreenState extends State<FacultySyllabusScreen> {
  final SyllabusController controller = Get.find();

  void _showUploadDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Upload PDF",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.primaryColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(labelText: "PDF Title")),
              TextField(
                  controller: controller.subjectController,
                  decoration: InputDecoration(labelText: "Subject")),
              DropdownButtonFormField<String>(
                value: controller.selectedSemester.value,
                items: [
                  "Semester 1",
                  "Semester 2",
                  "Semester 3",
                  "Semester 4",
                  "Semester 5",
                  "Semester 6",
                  "Semester 7",
                  "Semester 8"
                ]
                    .map((semester) => DropdownMenuItem(
                        value: semester, child: Text(semester)))
                    .toList(),
                onChanged: (value) =>
                    controller.selectedSemester.value = value!,
                decoration: InputDecoration(labelText: "Semester"),
              ),
              DropdownButtonFormField<String>(
                value: controller.selectedStream.value,
                items: ["BCA", "BCOM", "BBA"]
                    .map((stream) =>
                        DropdownMenuItem(value: stream, child: Text(stream)))
                    .toList(),
                onChanged: (value) => controller.selectedStream.value = value!,
                decoration: InputDecoration(labelText: "Stream"),
              ),
              TextField(
                  controller: controller.descriptionController,
                  decoration: InputDecoration(labelText: "Description")),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: controller.pickPDF, child: Text("Pick PDF")),
              Obx(() => controller.selectedFile.value != null
                  ? Text("File Selected", style: TextStyle(color: Colors.green))
                  : Container()),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: controller.uploadPDF,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor),
                child:
                    Text("Upload PDF", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty Panel", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primaryColor,
        leading: BackButton(color: AppColor.whiteColor),
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: () async {
              controller.isLoading.value = true;
              await Future.delayed(Duration(seconds: 2));
              controller.isLoading.value = false;
            },
            child: controller.isLoading.value
                ? ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          title: Container(
                              height: 12,
                              width: double.infinity,
                              color: Colors.white),
                          subtitle: Container(
                              height: 10, width: 150, color: Colors.white),
                        ),
                      );
                    },
                  )
                : StreamBuilder(
                    stream: controller.databaseRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.data!.snapshot.value == null) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: AppColor.primaryColor));
                      }
                      Map<dynamic, dynamic> pdfs = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      return ListView.builder(
                        itemCount: pdfs.length,
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          var entry = pdfs.entries.elementAt(index);
                          var key = entry.key;
                          var doc = entry.value;
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 3,
                                  color: Colors.white,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    title: Text(doc['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    subtitle: Text(
                                      "${doc['subject']} - ${doc['semester']} - ${doc['stream']}\nTime: ${doc['upload_time']}",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.redAccent),
                                      onPressed: () async {
                                        await FirebaseDatabase.instance
                                            .ref("syllabus")
                                            .child(key)
                                            .remove();
                                        await FirebaseStorage.instance
                                            .refFromURL(doc['pdfUrl'])
                                            .delete();
                                        Get.snackbar("Success",
                                            "PDF deleted successfully",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white);
                                      },
                                    ),
                                    onTap: () => Get.to(() =>
                                        PDFViewerScreen(pdfUrl: doc['pdfUrl'])),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadDialog,
        backgroundColor: AppColor.primaryColor,
        child: Icon(Icons.upload_file, color: Colors.white),
      ),
    );
  }
}
