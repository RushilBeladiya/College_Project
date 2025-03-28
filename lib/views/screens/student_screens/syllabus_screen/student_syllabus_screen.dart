import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/main/syllabus_controller.dart';
import '../../subject_screen/pdf_view_screen.dart';

class StudentSyllabusScreen extends StatefulWidget {
  final String semester;
  final String stream;
  const StudentSyllabusScreen({super.key,required this.semester,required this.stream});

  @override
  _StudentSyllabusScreenState createState() => _StudentSyllabusScreenState();
}

class _StudentSyllabusScreenState extends State<StudentSyllabusScreen> {
  final SyllabusController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Syllabus")),
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
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(child: CircularProgressIndicator());
            }

            Map<dynamic, dynamic> pdfs =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            var filteredPdfs = pdfs.entries.where((entry) {
              var doc = entry.value;
              return doc['stream'] == widget.stream &&
                  doc['semester'] == widget.semester;
            }).toList();

            return ListView.builder(
              itemCount: filteredPdfs.length,
              itemBuilder: (context, index) {
                var entry = filteredPdfs[index];
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
                          subtitle: Text("${doc['subject']} - ${doc['semester']} - ${doc['stream']}\nTime: ${doc['upload_time']}")
                          ,
                          trailing: IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () async {
                              final Uri url = Uri.parse(doc['pdfUrl']);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              } else {
                                Get.snackbar("Error", "Could not open the PDF");
                              }
                            },
                          ),
                          onTap: () => Get.to(() => PDFViewerScreen(pdfUrl: doc['pdfUrl'])),
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
    );
  }
}
