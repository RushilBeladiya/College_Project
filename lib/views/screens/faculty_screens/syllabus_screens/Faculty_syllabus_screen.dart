import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/main/syllabus_controller.dart';
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
        title: Text("Upload PDF"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller.titleController, decoration: InputDecoration(labelText: "PDF Title")),
              TextField(controller: controller.subjectController, decoration: InputDecoration(labelText: "Subject")),
              DropdownButtonFormField<String>(
                value: controller.selectedSemester.value,
                items: ["Semester 1", "Semester 2", "Semester 3","Semester 4", "Semester 5", "Semester 6","Semester 7", "Semester 8"].map((semester) {
                  return DropdownMenuItem(value: semester, child: Text(semester));
                }).toList(),
                onChanged: (value) => controller.selectedSemester.value = value,
                decoration: InputDecoration(labelText: "Semester"),
              ),
              DropdownButtonFormField<String>(
                value: controller.selectedStream.value,
                items: ["BCA", "BCOM", "BBA"].map((stream) {
                  return DropdownMenuItem(value: stream, child: Text(stream));
                }).toList(),
                onChanged: (value) => controller.selectedStream.value = value,
                decoration: InputDecoration(labelText: "Stream"),
              ),
              TextField(controller: controller.descriptionController, decoration: InputDecoration(labelText: "Description")),
              SizedBox(height: 10),
              ElevatedButton(onPressed: controller.pickPDF, child: Text("Pick PDF")),
              Obx(() => controller.selectedFile.value != null ? Text("File Selected") : Container()),
              SizedBox(height: 10),
              ElevatedButton(onPressed: controller.uploadPDF, child: Text("Upload PDF")),
            ],
          ),
        ),
      ),
    );
  }

  void _deletePDF(String key, String pdfUrl) async {
    try {
      await FirebaseDatabase.instance.ref("syllabus").child(key).remove();
      await FirebaseStorage.instance.refFromURL(pdfUrl).delete();
      Get.snackbar("Success", "PDF deleted successfully", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete PDF", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Faculty Panel")),
      body: Obx(() => RefreshIndicator(
        onRefresh: () async {
          controller.isLoading.value = true;
          await Future.delayed(Duration(seconds: 2));
          controller.isLoading.value = false;
        },
        child: controller.isLoading.value
            ? ListView.builder(
          itemCount: 11,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListTile(
                title: Container(height: 10, color: Colors.white),
                subtitle: Container(height: 10, color: Colors.white),
              ),
            );
          },
        )
            : StreamBuilder(
          stream: controller.databaseRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) return Center(child: CircularProgressIndicator());
            Map<dynamic, dynamic> pdfs = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            return ListView.builder(
              itemCount: pdfs.length,
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
                        child: ListTile(
                          title: Text(doc['title']),
                          subtitle: Text("${doc['subject']} - ${doc['semester']} - ${doc['stream']}\nTime: ${doc['upload_time']}"),
                          onTap: () => Get.to(() => PDFViewerScreen(pdfUrl: doc['pdfUrl'])),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deletePDF(key, doc['pdfUrl']),
                          ),
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
        child: Icon(Icons.upload_file),
      ),
    );
  }
}
