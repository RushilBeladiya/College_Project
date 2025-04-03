import 'dart:io';

import 'package:college_project/views/screens/student_screens/attendance_screens/student_attendance_view_screen.dart';
import 'package:college_project/views/screens/student_screens/fees_payment_screen/fess_paying_screen.dart';
import 'package:college_project/views/screens/student_screens/home/bottom_navigation_screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/student_model.dart';
import '../../../views/screens/student_screens/home/bottom_navigation_screen/dash_board_screen.dart';
import '../../../views/screens/student_screens/setting_screen/settings_screen.dart';

class StudentHomeController extends GetxController {
  RxInt bottomScreenIndex = 2.obs;
  final FirebaseAuth authUser = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  var isLoading = true.obs;

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('student');

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
    // fetchCurrentUserData();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   attandencerecods();
    // });
    // // attandencerecods();
    // print("+-+-+---+---+-+-+-+");
  }


  Future<void> _loadInitialData() async {
    try {
      // First ensure student data is loaded
      await fetchCurrentUserData();

      // Then fetch attendance records
      await fetchAttendanceRecords();

      // Calculate attendance percentage
      calculateOverallAttendance();
    } catch (e) {
      Get.snackbar("Error", "Failed to load data: ${e.toString()}");
    }
  }
  void updateProfileImage(String imageUrl) {
    currentStudent.update((student) {
      student?.profileImageUrl = imageUrl;
    });
  }

  final RxList bottomScreenList = [
    const ProfileScreen(),
    const StudentAttendanceViewScreen(),
    const DashBoardScreen(),
    FeePaymentScreen(),
    const SettingsScreen(),
  ].obs;

  var currentStudent = StudentModel(
    uid: '',
    firstName: '',
    lastName: '',
    surName: '',
    spid: '',
    phoneNumber: '',
    email: '',
    stream: '',
    semester: '',
    division: '',
    profileImageUrl: '',
    status: '',
  ).obs;


  Future<void> fetchCurrentUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseEvent event = await dbRef.child(user.uid).once();
        if (event.snapshot.value != null) {
          var data = event.snapshot.value as Map<dynamic, dynamic>?;

          if (data != null) {
            currentStudent.value = StudentModel.fromMap(data);
            print(
                "User Loaded:-----++++ ${currentStudent.value.firstName} ${currentStudent.value.lastName}");
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

  var total = 0.obs;
  var present = 0.obs;
  var absent = 0.obs;
  var overallAttendancePercentage = 0.0.obs;
  var subjectWiseAttendance = <String, List<Map<String, dynamic>>>{}.obs;

  void calculateOverallAttendance() {
    int overallTotalLectures = subjectWiseAttendance.values
        .fold(0, (sum, records) => sum + records.length);
    int overallPresentLectures = subjectWiseAttendance.values.fold(
        0,
        (sum, records) =>
            sum +
            records
                .where((record) =>
                    record['status'].toString().toLowerCase() == 'present')
                .length);

    total.value = overallTotalLectures;
    present.value = overallPresentLectures;
    absent.value = total.value - present.value;
    overallAttendancePercentage.value =
        (total.value == 0) ? 0.0 : (present.value / total.value) * 100;
  }

  Future<void> fetchAttendanceRecords() async {
    try {
      isLoading.value = true; // Start loading

      String loggedInUserSpid = currentStudent.value.spid;
      String stream = currentStudent.value.stream;
      String semester = currentStudent.value.semester;
      String division = currentStudent.value.division;

      if (loggedInUserSpid.isEmpty ||
          stream.isEmpty ||
          semester.isEmpty ||
          division.isEmpty) {
        Get.snackbar("Error", "Student details are missing.");
        isLoading.value = false;
        return;
      }

      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('attendance');
      DatabaseEvent event = await dbRef
          .child(stream)
          .child(semester)
          .child(division)
          .once(); // Fetch data

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> subjects =
            event.snapshot.value as Map<dynamic, dynamic>;
        Map<String, List<Map<String, dynamic>>> groupedAttendance = {};

        subjects.forEach((subjectName, dates) {
          if (dates is Map<dynamic, dynamic>) {
            List<Map<String, dynamic>> attendanceList = [];

            dates.forEach((dateKey, studentRecords) {
              if (studentRecords is Map<dynamic, dynamic>) {
                if (studentRecords.containsKey(loggedInUserSpid)) {
                  var details = studentRecords[loggedInUserSpid];
                  attendanceList.add({
                    'date': dateKey,
                    'status': details['status']?.toString() ?? 'Absent',
                  });
                }
              }
            });

            if (attendanceList.isNotEmpty) {
              groupedAttendance[subjectName] = attendanceList;
            }
          }
        });

        subjectWiseAttendance.assignAll(groupedAttendance);
        print("555555555555555555555555555");
        // isLoading.value = false;
      } else {
        subjectWiseAttendance.clear();
        Get.snackbar("Info", "No attendance records found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch attendance records: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
  Future<String> uploadImage(XFile imageFile) async {
    try {
      String fileName = 'student/${currentStudent.value.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = storage.ref().child(fileName);
      UploadTask uploadTask = ref.putData(await imageFile.readAsBytes());
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Future<void> updateStudentProfileImage(String imageUrl) async {
  //   try {
  //     await dbRef.child(currentStudent.value.uid).update({
  //       'profileImageUrl': imageUrl,
  //     });
  //     currentStudent.update((student) {
  //       student?.profileImageUrl = imageUrl;
  //     });
  //   } catch (e) {
  //     throw Exception('Failed to update profile: $e');
  //   }
  // }

  Future<void> updateStudentProfileImage(String imageUrl) async {
    try {
      String uid = currentStudent.value.uid;
      await FirebaseDatabase.instance
          .ref()
          .child('student')
          .child(uid)
          .update({'profileImageUrl': imageUrl});

      currentStudent.value.profileImageUrl = imageUrl;
      currentStudent.refresh();
    } catch (e) {
      rethrow;
    }
  }
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = 'student_images/${currentStudent.value.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }
}
