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

  // final RxMap<String, List<Map<String, dynamic>>> subjectWiseAttendance =
  //     RxMap<String, List<Map<String, dynamic>>>(); // Initialize as RxMap

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUserData();
    attandencerecods();
    print("+-+-+---+---+-+-+-+");
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

  // Future<void> uploadProfileImage(String uid) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final XFile? pickedFile =
  //         await picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       File imageFile = File(pickedFile.path);
  //       // Upload to Firebase Storage
  //       String fileName = '$uid-profile-image.jpg';
  //       Reference ref = storage.ref().child('profile_images').child(fileName);
  //
  //       UploadTask uploadTask = ref.putFile(imageFile);
  //
  //       // Show circular progress while the upload is in progress
  //       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //         // Here you can track the progress if needed
  //       });
  //
  //       TaskSnapshot snapshot = await uploadTask;
  //       String downloadUrl = await snapshot.ref.getDownloadURL();
  //
  //       await firestore.collection('users').doc(uid).update({
  //         'profile_image_url': downloadUrl,
  //       });
  //
  //       // userModel.update((user) {
  //       //   if (user != null) {
  //       //     user.profileImageUrl = downloadUrl;
  //       //   }
  //       // });
  //     }
  //
  //     isLoading.value = false; // Set loading to false when upload finishes
  //   } catch (e) {
  //     isLoading.value = false; // Reset loading on error
  //     Get.snackbar("Error", e.toString());
  //   }
  // }

  // void fetchUserData() async {
  //   try {
  //     String uid = authUser.currentUser!.uid;
  //     DocumentSnapshot userDoc =
  //         await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //
  //     userModel.value = StudentModel.fromFirestore(userDoc);
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to fetch user data: $e");
  //   }
  // }

  // Future<void> updateUserData(String username) async {
  //   String uid = userModel.value.uid;
  //   try {
  //     if (username != userModel.value.firstName) {
  //       await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //         'username': username,
  //       });
  //       fetchUserData();
  //       await Fluttertoast.showToast(
  //           msg: "Update successful", toastLength: Toast.LENGTH_LONG);
  //       Get.back();
  //     } else {
  //       await Fluttertoast.showToast(
  //           msg: "Your username is same!!!", toastLength: Toast.LENGTH_LONG);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to update profile: $e");
  //   }
  // }

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

  void attandencerecods() async {
    await fetchAttendanceRecords();
    calculateOverallAttendance();
  }

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

  Future<void> updateStudentProfileImage(String imageUrl) async {
    try {
      await dbRef.child(currentStudent.value.uid!).update({
        'profileImageUrl': imageUrl,
      });
      currentStudent.update((student) {
        student?.profileImageUrl = imageUrl;
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Future<void> fetchAttendanceRecords() async {
  //   try {
  //     String loggedInUserSpid = currentStudent.value.spid;
  //     String stream = currentStudent.value.stream;
  //     String semester = currentStudent.value.semester;
  //     String division = currentStudent.value.division;

  //     if (loggedInUserSpid.isEmpty ||
  //         stream.isEmpty ||
  //         semester.isEmpty ||
  //         division.isEmpty) {
  //       Get.snackbar("Error", "Student details are missing.");
  //       return;
  //     }

  //     DatabaseReference dbRef =
  //         FirebaseDatabase.instance.ref().child('attendance');
  //     DatabaseEvent event =
  //         await dbRef.child(stream).child(semester).child(division).once();

  //     if (event.snapshot.value != null) {
  //       Map<dynamic, dynamic> subjects =
  //           event.snapshot.value as Map<dynamic, dynamic>;

  //       Map<String, List<Map<String, dynamic>>> groupedAttendance = {};

  //       subjects.forEach((subjectName, dates) {
  //         if (dates is Map<dynamic, dynamic>) {
  //           List<Map<String, dynamic>> attendanceList = [];

  //           dates.forEach((dateKey, studentRecords) {
  //             if (studentRecords is Map<dynamic, dynamic>) {
  //               if (studentRecords.containsKey(loggedInUserSpid)) {
  //                 var details = studentRecords[loggedInUserSpid];
  //                 attendanceList.add({
  //                   'date': dateKey,
  //                   'status': details['status']?.toString() ?? 'Absent',
  //                 });
  //               }
  //             }
  //           });

  //           if (attendanceList.isNotEmpty) {
  //             groupedAttendance[subjectName] = attendanceList;
  //           }
  //         }
  //       });
  //       print("+++++++++++++++++++${subjectWiseAttendance['']}");

  //       subjectWiseAttendance.assignAll(groupedAttendance);
  //       isLoading.value = false; // Update RxMap
  //     } else {
  //       subjectWiseAttendance.clear(); // Clear data if no records found
  //       Get.snackbar("Info", "No attendance records found.");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to fetch attendance records: $e");
  //   }
  // }
}
