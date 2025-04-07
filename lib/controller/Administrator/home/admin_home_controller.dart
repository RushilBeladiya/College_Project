import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/admin_Model.dart';
import '../../../models/faculty_model.dart';
import '../service/faculty_service.dart';

class AdminHomeController extends GetxController {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('college_department');
  var facultyList = <FacultyModel>[].obs;
  var isLoading = false.obs;

  final DatabaseReference dbRefFaculty =
      FirebaseDatabase.instance.ref("faculty");
  var adminModel = AdminModel(
    uid: '',
    firstName: '',
    lastName: '',
    surName: '',
    phoneNumber: '',
    email: '',
    profileImageUrl: '',
  ).obs;

  @override
  void onInit() {
    fetchAdminData();
    fetchFacultyData();
    super.onInit();
  }

  Future<void> fetchAdminData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print("Fetching data for UID: ${user.uid}");

        DatabaseEvent event = await dbRef.child(user.uid).once();
        print("Raw Data: ${event.snapshot.value}");
        if (event.snapshot.value != null) {
          var data = event.snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            adminModel.value = AdminModel.fromMap(data);
            print(
                "User Loaded: ${adminModel.value.firstName} ${adminModel.value.lastName}");
          } else {
            print("Failed to parse user data.");
          }
        } else {
          print("No data found for UID: ${user.uid}");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data",
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Error fetching user data: $e");
    }
  }

  Future<void> fetchFacultyData() async {
    try {
      isLoading.value = true;
      List<FacultyModel> data = await FacultyService.getFacultyList();
      facultyList.assignAll(data);
    } catch (e) {
      print("Error fetching faculty data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('admin_profiles')
          .child('${user.uid}.jpg');

      await storageRef.putFile(imageFile);
      String downloadUrl = await storageRef.getDownloadURL();

      // Update profile URL in database
      await dbRef.child(user.uid).update({
        'profileImageUrl': downloadUrl,
      });

      // Update local model
      adminModel.update((val) {
        val?.profileImageUrl = downloadUrl;
      });

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Profile image updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to update profile image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error updating profile image: $e');
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Show confirmation dialog
      bool confirm = await Get.dialog(
        AlertDialog(
          title: const Text('Delete Profile Picture'),
          content: const Text(
              'Are you sure you want to delete your profile picture?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (!confirm) return;

      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Delete image from Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('admin_profiles')
          .child('${user.uid}.jpg');

      await storageRef.delete();

      // Update profile URL in database
      await dbRef.child(user.uid).update({
        'profileImageUrl': '',
      });

      // Update local model
      adminModel.update((val) {
        val?.profileImageUrl = '';
      });

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Profile picture deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to delete profile picture',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error deleting profile image: $e');
    }
  }
}
