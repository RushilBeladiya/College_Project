import 'dart:io';
import 'package:college_project/controller/Faculty/home/faculty_home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SyllabusController extends GetxController {
  FacultyHomeController facultyHomeController = Get.find();
  var titleController = TextEditingController();
  var subjectController = TextEditingController();
  var descriptionController = TextEditingController();
  var selectedSemester = RxnString();
  var selectedStream = RxnString();
  var selectedFile = Rxn<File>();
  var isUploading = false.obs;
  var isLoading = true.obs;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child("syllabus");

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  Future<void> uploadPDF() async {
    if (selectedFile.value != null && titleController.text.isNotEmpty && subjectController.text.isNotEmpty && selectedSemester.value != null && selectedStream.value != null) {
      isUploading.value = true;
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.pdf";
      Reference ref = FirebaseStorage.instance.ref().child("syllabus/$fileName");
      UploadTask uploadTask = ref.putFile(selectedFile.value!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      String uploadTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

      DatabaseReference newPdfRef = databaseRef.push();
      await newPdfRef.set({
        'id': newPdfRef.key,
        'facultyId': facultyHomeController.facultyModel.value.uid,
        'title': titleController.text,
        'subject': subjectController.text,
        'semester': selectedSemester.value,
        'stream': selectedStream.value,
        'description': descriptionController.text,
        'upload_time': uploadTime,
        'pdfUrl': downloadUrl,
        'fileName': fileName,
      });

      isUploading.value = false;
      Get.back();
      Get.snackbar("Success", "PDF Uploaded Successfully", backgroundColor: Colors.green, colorText: Colors.white);
      selectedFile.value = null;
      titleController.clear();
      subjectController.clear();
      descriptionController.clear();
      selectedSemester.value = null;
      selectedStream.value = null;
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 2));
      isLoading.value = false;
    } else {
      Get.snackbar("Error", "Please fill all fields and select a PDF", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deletePDF(String id, String fileName) async {
    await FirebaseStorage.instance.ref().child("syllabus/$fileName").delete();
    await databaseRef.child(id).remove();
    Get.snackbar("Deleted", "PDF Deleted Successfully", backgroundColor: Colors.red, colorText: Colors.white);
  }
}
