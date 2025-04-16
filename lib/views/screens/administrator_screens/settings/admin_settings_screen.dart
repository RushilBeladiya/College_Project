import 'package:college_project/controller/Administrator/home/admin_home_controller.dart';
import 'package:college_project/controller/Auth/auth_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'sections/academic_settings_screen.dart';
import 'sections/app_settings_screen.dart';
import 'sections/notification_settings_screen.dart';
import 'sections/security_settings_screen.dart';

class AdminSettingsScreen extends StatelessWidget {
  AdminSettingsScreen({Key? key}) : super(key: key);

  final AdminHomeController adminController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title:
            const Text('Setting Screen', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: ListView(
        children: [
          _buildProfileSection(),

          // General Settings Section
          _buildSectionTitle("General Settings"),
          _buildSettingItem(
            icon: Icons.school,
            title: "Academic Settings",
            onTap: () => Get.to(() => AcademicSettingsScreen()),
          ),
          _buildSettingItem(
            icon: Icons.notifications,
            title: "Notification Settings",
            onTap: () => Get.to(() => NotificationSettingsScreen()),
          ),
          _buildSettingItem(
            icon: Icons.security,
            title: "Security Settings",
            onTap: () => Get.to(() => SecuritySettingsScreen()),
          ),

          // App Settings Section
          _buildSectionTitle("Application Settings"),
          _buildSettingItem(
            icon: Icons.apps,
            title: "App Settings",
            onTap: () => Get.to(() => AppSettingsScreen()),
          ),
          _buildSettingItem(
            icon: Icons.backup,
            title: "Backup & Restore",
            onTap: () => _showBackupDialog(context),
          ),

          // Logout Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text('Logout',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return FutureBuilder<String>(
      future: authController.getCurrentUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text("Error loading user role: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No role data available"));
        }

        String role = snapshot.data!;
        if (role == "student") {
          return _buildStudentProfile();
        } else if (role == "faculty") {
          return _buildFacultyProfile();
        } else if (role == "admin") {
          return _buildAdminProfile();
        } else {
          return Center(child: Text("Unknown role: $role"));
        }
      },
    );
  }

  Widget _buildStudentProfile() {
    return Obx(() {
      final student = authController.currentStudent.value;
      if (student.uid.isEmpty) {
        return Center(
          child: Text(
            "No student data available",
            style: TextStyle(color: AppColor.primaryColor, fontSize: 16.sp),
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundImage: student.profileImageUrl.isNotEmpty
                  ? NetworkImage(student.profileImageUrl)
                  : const AssetImage(AppImage.user) as ImageProvider,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${student.firstName} ${student.surName}",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Student",
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColor.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFacultyProfile() {
    return Obx(() {
      final faculty = authController.currentFaculty.value;
      if (faculty.uid.isEmpty) {
        return Center(
          child: Text(
            "No faculty data available",
            style: TextStyle(color: AppColor.primaryColor, fontSize: 16.sp),
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundImage: faculty.profileImageUrl.isNotEmpty
                  ? NetworkImage(faculty.profileImageUrl)
                  : const AssetImage(AppImage.user) as ImageProvider,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${faculty.firstName} ${faculty.lastName}",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Faculty",
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColor.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAdminProfile() {
    return Obx(() => Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(16.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35.r,
                backgroundImage:
                    adminController.adminModel.value.profileImageUrl.isNotEmpty
                        ? NetworkImage(
                            adminController.adminModel.value.profileImageUrl)
                        : const AssetImage(AppImage.user) as ImageProvider,
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${adminController.adminModel.value.firstName} ${adminController.adminModel.value.lastName}",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Administrator",
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColor.primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColor.primaryColor),
          title: Text(title),
          trailing: Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        Divider(height: 1.h, thickness: 0.5, indent: 20.w, endIndent: 20.w),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              authController.logoutUser();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Restore'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Create Backup'),
              onTap: () {
                Navigator.pop(context);
                _showBackupSuccessSnackbar();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore Data'),
              onTap: () {
                Navigator.pop(context);
                _showRestoreDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBackupSuccessSnackbar() {
    Get.snackbar(
      'Backup Created',
      'Your data has been successfully backed up.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data'),
        content: const Text('Select backup version to restore:'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showRestoreSuccessSnackbar();
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showRestoreSuccessSnackbar() {
    Get.snackbar(
      'Data Restored',
      'Your data has been successfully restored.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
