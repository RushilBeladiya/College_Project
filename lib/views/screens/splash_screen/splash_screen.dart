// import 'dart:async';
// import 'package:college_project/core/utils/colors.dart';
// import 'package:college_project/core/utils/images.dart';
// import 'package:college_project/views/screens/auth_screen/student_auth_screen/student_login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../administrator_screens/home/admin_home_screen.dart';
// import '../faculty_screens/home/faculty_home_screen.dart';
// import '../student_screens/home/home_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   void navigationToLogin() async {
//     Timer(const Duration(seconds: 3), () async {
//        await checkUserSession();
//     });
//   }

//   Future<void> checkUserSession() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     if (isLoggedIn) {
//       String role = prefs.getString('role') ?? "";
//       print("-----------------------");
//       if (role == "student") {
//         Get.offAll(() => HomeScreen());
//       } else if (role == "faculty") {
//         Get.offAll(() => FacultyHomeScreen());
//       } else if (role == "admin") {
//         Get.offAll(() => AdminHomeScreen());
//       }
//     }
//     else
//       {
//         Get.offAll(() => StudentLoginScreen());

//       }
//   }

//   @override
//   void initState() {
//     super.initState();
//     navigationToLogin();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBackGroundColor,
//       body: Center(
//         child: Image.asset(
//           AppImage.appLogo,
//           filterQuality: FilterQuality.high,
//           fit: BoxFit.contain,
//           height: 130.h,
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:college_project/controller/main/network_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/core/utils/images.dart';
import 'package:college_project/views/screens/auth_screen/student_auth_screen/student_login_screen.dart';
import 'package:college_project/views/screens/splash_screen/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../administrator_screens/home/admin_home_screen.dart';
import '../faculty_screens/home/faculty_home_screen.dart';
import '../student_screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NetworkController _networkController = Get.find<NetworkController>();

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndNavigate();
  }

  Future<void> _checkConnectivityAndNavigate() async {
    final isConnected = await _networkController.isConnected();

    if (!isConnected) {
      Get.offAll(() => ErrorScreen());
    } else {
      Timer(const Duration(seconds: 3), () async {
        await _checkUserSession();
      });
    }
  }

  Future<void> _checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String role = prefs.getString('role') ?? "";
      if (role == "student") {
        Get.offAll(() => HomeScreen());
      } else if (role == "faculty") {
        Get.offAll(() => FacultyHomeScreen());
      } else if (role == "admin") {
        Get.offAll(() => AdminHomeScreen());
      }
    } else {
      Get.offAll(() => StudentLoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor,
      body: Center(
        child: Image.asset(
          AppImage.appLogo,
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          height: 130.h,
        ),
      ),
    );
  }
}
