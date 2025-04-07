import 'package:college_project/controller/Auth/auth_controller.dart';
import 'package:college_project/controller/Student/home/student_home_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/core/utils/images.dart';
import 'package:college_project/views/screens/student_screens/home/college_info_screen.dart';
import 'package:college_project/views/screens/student_screens/home/contact_us_screen.dart';
import 'package:college_project/views/screens/student_screens/setting_screen/privacy_policy_screen.dart';
import 'package:college_project/views/screens/student_screens/setting_screen/terms_conditions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  StudentHomeController homeController = Get.find();
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor,
      appBar: AppBar(
        leading: BackButton(color: AppColor.whiteColor),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            color: AppColor.blackColor.withOpacity(0.1),
            child: Row(
              children: [
                Obx(
                  () => homeController.isLoading.value
                      ? CircularProgressIndicator()
                      : CircleAvatar(
                          radius: 40.r,
                          backgroundColor: AppColor.whiteColor,
                          child: CircleAvatar(
                            radius: 38.r,
                            backgroundImage: homeController.currentStudent.value
                                    .profileImageUrl.isNotEmpty
                                ? NetworkImage(homeController
                                    .currentStudent.value.profileImageUrl)
                                : const AssetImage(AppImage.user)
                                    as ImageProvider,
                          ),
                        ),
                ),
                SizedBox(width: 15.w),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${homeController.currentStudent.value.firstName} ${homeController.currentStudent.value.lastName}",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        homeController.currentStudent.value.email,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Settings Options
          buildSettingsOption(Icons.info, 'About Us', () {
            Get.to(() => const CollegeInfoScreen());
          }),
          buildSettingsOption(Icons.phone, 'Contact Us', () {
            Get.to(() => const ContactUsScreen());
          }),
          buildSettingsOption(Icons.star_rate_rounded, 'Rate Us', () {
            _launchStoreForRating();
          }),
          buildSettingsOption(Icons.share, 'Share App', () {
            Share.share("Check out this amazing college app!");
          }),
          buildSettingsOption(Icons.lock, 'Privacy Policy', () {
            Get.to(() => const PrivacyPolicyScreen());
          }),
          buildSettingsOption(Icons.security, 'Terms & Conditions', () {
            Get.to(() => const TermsConditionsScreen());
          }),
        ],
      ),
    );
  }

  Widget buildSettingsOption(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColor.primaryColor,
        size: 25.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : AppColor.blackColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _launchStoreForRating() {
    // Implement store rating functionality
    Get.snackbar(
      "Rate Us",
      "Redirecting to app store...",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
