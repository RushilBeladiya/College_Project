import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_project/models/faculty_model.dart';
import 'package:college_project/models/student_model.dart';
import 'package:college_project/views/screens/faculty_screens/home/faculty_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/screens/administrator_screens/home/admin_home_screen.dart';
import '../../views/screens/auth_screen/student_auth_screen/student_login_screen.dart';
import '../../views/screens/auth_screen/student_auth_screen/student_registration_screen.dart';
import '../../views/screens/student_screens/home/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseReference dbRefStudent =
      FirebaseDatabase.instance.ref().child('student');
  final DatabaseReference dbRefAdmin =
      FirebaseDatabase.instance.ref().child('college_department');
  final DatabaseReference dbRefFaculty =
      FirebaseDatabase.instance.ref().child('faculty');

  var isFormValid = false.obs;

  void validateForm(GlobalKey<FormState> formKey) {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }

  TextEditingController emailController = TextEditingController();

  var email = "".obs;
  var isChecking = false.obs; // Loading state
  var isVerified = false.obs; // Email verified state
  var canResend = false.obs; // Resend button enabled
  var countdown = 0.obs; // Countdown timer
  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> checkEmailVerified() async {
    try {
      isChecking.value = true;
      // Always reload user to get fresh verification status
      await auth.currentUser?.reload();
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        isVerified.value = currentUser.emailVerified;
        // If verified, update state for UI
        if (isVerified.value) {
          canResend.value = false;
          countdown.value = 0;
          _timer?.cancel();
        }
      }
    } catch (e) {
      print("Error checking email verification: $e");
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> sendVerificationEmail() async {
    if (!isValidEmail(email.value)) return;

    isChecking.value = true;
    try {
      final user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        canResend.value = false;
        countdown.value = 90;
        startCountdown();

        // Start periodic verification check
        _timer?.cancel();
        _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
          await checkEmailVerified();
          if (isVerified.value) {
            timer.cancel();
          }
        });
      }
    } catch (e) {
      print("Error sending verification email: $e");
    } finally {
      isChecking.value = false;
    }
  }

  void startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  bool isValidEmail(String email) {
    return GetUtils.isEmail(email);
  }

  Future<bool> checkIfFieldExists(String field, String value) async {
    try {
      String upperCaseValue = value.toUpperCase(); // Convert input to lowercase

      if (["phoneNumber", "firstName", "lastName", "surName"].contains(field)) {
        final studentFuture =
            dbRefStudent.orderByChild(field).equalTo(upperCaseValue).get();
        final facultyFuture =
            dbRefFaculty.orderByChild(field).equalTo(upperCaseValue).get();
        final adminFuture =
            dbRefAdmin.orderByChild(field).equalTo(upperCaseValue).get();

        final results =
            await Future.wait([studentFuture, facultyFuture, adminFuture]);
        return results.any((snapshot) => snapshot.exists);
      }

      // If checking spid → Only check in students collection
      else if (field == "spid") {
        final studentSnapshot =
            await dbRefStudent.orderByChild(field).equalTo(value).get();
        return studentSnapshot.exists;
      }

      return false; // Default return false if field doesn't match expected ones
    } catch (e) {
      print("Error checking field existence: $e");
      return false;
    }
  }

  Future<void> saveStudentData(
      String uid,
      String firstName,
      String lastName,
      String surName,
      String spid,
      String phoneNumber,
      String email,
      String stream,
      String semester,
      String division) async {
    StudentModel user = StudentModel(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      surName: surName,
      spid: spid,
      phoneNumber: phoneNumber,
      email: email,
      stream: stream,
      semester: semester,
      division: division,
      profileImageUrl: "",
    );
    await dbRefStudent.child(uid).set(user.toMap());
  }

  Future<void> registerStudent(
    String firstName,
    String lastName,
    String surName,
    String spid,
    String phoneNumber,
    String email,
    String stream,
    String semester,
    String division,
  ) async {
    try {
      bool spidExists = await checkIfFieldExists("spid", spid);
      bool phoneExists = await checkIfFieldExists("phoneNumber", phoneNumber);
      bool firstNameExists = await checkIfFieldExists("firstName", firstName);
      bool lastNameExists = await checkIfFieldExists("lastName", lastName);
      bool surNameExists = await checkIfFieldExists("surName", surName);

      if (spidExists) {
        Get.snackbar("Error", "SPID already Registered!",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (phoneExists) {
        Get.snackbar("Error", "Phone number or Email already Registered!",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (firstNameExists && lastNameExists && surNameExists) {
        Get.snackbar("Error", "This Name Student already Registered!",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // 🔹 Create User in Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: spid, // Using SPID as default password
      );

      String uid = userCredential.user!.uid;

      await saveStudentData(
        uid,
        firstName.toUpperCase(),
        lastName.toUpperCase(),
        surName.toUpperCase(),
        spid,
        phoneNumber,
        email,
        stream,
        semester,
        division,
      );

      Get.back();
      Get.snackbar("Success", "Registration successful!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Registration Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
    }
  }

  Future<void> saveFacultyData(String uid, String firstName, String lastName,
      String surName, String phoneNumber, String email, String position) async {
    FacultyModel user = FacultyModel(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      surName: surName,
      phoneNumber: phoneNumber,
      email: email,
      position: position,
      profileImageUrl: "",
    );
    await dbRefFaculty.child(uid).set(user.toMap());
  }

  Future<void> registerFaculty(
    String firstName,
    String lastName,
    String surName,
    String phoneNumber,
    String email,
    String position,
  ) async {
    try {
      bool phoneExists = await checkIfFieldExists("phoneNumber", phoneNumber);
      bool firstNameExists = await checkIfFieldExists("firstName", firstName);
      bool lastNameExists = await checkIfFieldExists("lastName", lastName);
      bool surNameExists = await checkIfFieldExists("surName", surName);

      if (phoneExists) {
        Get.snackbar("Error", "Phone number or Email already Registered!",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      if (firstNameExists && lastNameExists && surNameExists) {
        Get.snackbar("Error", "This Name Faculty already Registered!",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: phoneNumber,
      );

      String uid = userCredential.user!.uid;

      await saveFacultyData(
        uid,
        firstName,
        lastName,
        surName,
        phoneNumber,
        email,
        position,
      );

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', true);
      // await prefs.setString('userToken', uid);
      //
      Get.back();
    } catch (e) {
      Get.snackbar("Registration Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
    }
  }

  Future<void> loginStudent(String email, String spid) async {
    try {
      await FirebaseAuth.instance.signOut();

      var query = dbRefStudent.orderByChild('email').equalTo(email);
      DatabaseEvent event = await query.once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> userData =
            event.snapshot.value as Map<dynamic, dynamic>;
        Map<dynamic, dynamic> user = userData.values.first;

        // Verify the SPID matches
        if (user['spid'] == spid) {
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email,
            password: spid,
          );

          String uid = userCredential.user!.uid;
          await checkEmailVerified();
          if (isVerified.value) {
            await saveUserSession(uid, email, "student");
            await Get.offAll(() => HomeScreen());
            Get.snackbar("Welcome", "Login Successful!");
          } else {
            Get.snackbar(
                "Error", "Please verify your email before logging in.");
          }
        } else {
          Get.snackbar("Error", "SPID does not match.");
        }
      } else {
        Get.snackbar("Error", "Email not found.");
      }
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
      print(e);
    }
  }

  Future<void> loginFaculty(String email, String phoneNumber) async {
    try {
      await FirebaseAuth.instance.signOut();

      var facultyQuery =
          dbRefFaculty.orderByChild('email').equalTo(email.toLowerCase());
      DatabaseEvent facultyEvent = await facultyQuery.once();

      if (facultyEvent.snapshot.exists) {
        Map<dynamic, dynamic> facultyData =
            facultyEvent.snapshot.value as Map<dynamic, dynamic>;
        Map<dynamic, dynamic> faculty = facultyData.values.first;

        if (faculty['phoneNumber'] == phoneNumber) {
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email,
            password: phoneNumber,
          );

          String uid = userCredential.user!.uid;
          await checkEmailVerified();
          if (isVerified.value) {
            await saveUserSession(uid, email, "faculty");
            Get.snackbar("Welcome", "Login Successful!");
            await Get.offAll(() => FacultyHomeScreen());
          } else {
            Get.snackbar(
                "Error", "Please verify your email before logging in.");
          } // Navigate to Faculty Dashboard
        } else {
          Get.snackbar("Login Error", "Incorrect phone number");
        }
      } else {
        Get.snackbar("Error", "Faculty email not found.");
      }
    } catch (e) {
      Get.snackbar("Login Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
    }
  }

  Future<void> loginAdmin(String email, String phoneNumber) async {
    try {
      await FirebaseAuth.instance.signOut();

      var adminQuery =
          dbRefAdmin.orderByChild('email').equalTo(email.toLowerCase());
      DatabaseEvent adminEvent = await adminQuery.once();

      print("Admin Data: ${adminEvent.snapshot.value}"); // Debugging Line

      if (adminEvent.snapshot.exists) {
        Map<dynamic, dynamic> adminData =
            adminEvent.snapshot.value as Map<dynamic, dynamic>;
        Map<dynamic, dynamic> admin = adminData.values.first;

        if (admin['phoneNumber'].toString() == phoneNumber.trim()) {
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email.trim(),
            password: phoneNumber.trim(),
          );
          String uid = userCredential.user!.uid;
          await checkEmailVerified();
          if (isVerified.value) {
            await saveUserSession(uid, email, "admin");
            await Get.offAll(() => AdminHomeScreen());
            Get.snackbar("Welcome", "Login Successful!");
          } else {
            Get.snackbar(
                "Error", "Please verify your email before logging in.");
          }
        } else {
          Get.snackbar("Login Error", "Incorrect phone number.");
        }
      } else {
        Get.snackbar("Error", "Admin email not found.");
      }
    } catch (e) {
      Get.snackbar("Login Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Login Error: $e");
    }
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userToken');
    email.value = "";
    emailController.clear();
    isVerified.value = false;
    canResend.value = false;

    Get.offAll(() => const StudentLoginScreen());
  }

  Future<void> saveUserSession(String uid, String email, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', uid);
    await prefs.setString('email', email);
    await prefs.setString('role', role);
  }

  Future<void> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }

      // Navigate to the registration screen
      Get.offAll(() => StudentRegistrationScreen());

      Get.snackbar("Success", "User deleted successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete user: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
