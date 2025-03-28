import 'package:college_project/models/faculty_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Administrator/service/faculty_service.dart';
class FacultyHomeController extends GetxController
{
  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref().child('faculty');
  var facultyModel = FacultyModel(
    uid: '',
    firstName: '',
    lastName: '',
    surName: '',
    phoneNumber: '',
    email: '',
    position: '',
    profileImageUrl: '',
  ).obs;


  @override
  void onInit() {
    super.onInit();
    fetchFacultyData();
    fetchStudents();
    fetchFacultyListData();
  }

  Future<void> fetchFacultyData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print("Fetching data for UID: ${user.uid}");

        DatabaseEvent event = await dbRef.child(user.uid).once();
        print("Raw Data: ${event.snapshot.value}");
        if (event.snapshot.value != null) {
          var data = event.snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            facultyModel.value = FacultyModel.fromJson(data);
            print("User Loaded: ${facultyModel.value.firstName} ${facultyModel.value.lastName}");
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





  var students = [].obs;
  var filteredStudents = [].obs;
  var searchQuery = ''.obs;
  final DatabaseReference dbStudentListRef = FirebaseDatabase.instance.ref().child('student');

  void fetchStudents() {
    dbStudentListRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<Object?, Object?> values = event.snapshot.value as Map<Object?, Object?>;
        students.value = values.entries.map((e) => Map<String, dynamic>.from(e.value as Map)).toList();
        filteredStudents.value = students;
      }
    });
  }

  void searchStudent(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredStudents.value = students;
    } else {
      filteredStudents.value = students.where((student) {
        return student['firstName'].toString().toLowerCase().contains(query.toLowerCase()) ||
            student['spid'].toString().contains(query);
      }).toList();
    }
  }

  var facultyList = <FacultyModel>[].obs;
  var isLoading = false.obs;
  Future<void> fetchFacultyListData() async {
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
}

