import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/colors.dart';

class AcademicSettingsScreen extends StatelessWidget {
  const AcademicSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic Settings'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(15.w),
        children: [
          _buildSettingSection(
            title: "Academic Year",
            children: [
              _buildSettingTile(
                title: "Current Academic Year",
                subtitle: "2023-2024",
                onTap: () => _showAcademicYearDialog(),
              ),
              _buildSettingTile(
                title: "Semester Settings",
                subtitle: "Configure semester dates",
                onTap: () => Get.toNamed('/semester-settings'),
              ),
            ],
          ),
          _buildSettingSection(
            title: "Course Management",
            children: [
              _buildSettingTile(
                title: "Course Structure",
                subtitle: "Manage course hierarchy",
                onTap: () => Get.toNamed('/course-structure'),
              ),
              _buildSettingTile(
                title: "Subject Configuration",
                subtitle: "Set up subjects and credits",
                onTap: () => Get.toNamed('/subject-config'),
              ),
            ],
          ),
          _buildSettingSection(
            title: "Examination",
            children: [
              _buildSettingTile(
                title: "Exam Schedule",
                subtitle: "Manage examination dates",
                onTap: () => Get.toNamed('/exam-schedule'),
              ),
              _buildSettingTile(
                title: "Grading System",
                subtitle: "Configure grading criteria",
                onTap: () => Get.toNamed('/grading-system'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
        ),
        ...children,
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showAcademicYearDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Change Academic Year'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Start Year',
                hintText: '2023',
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'End Year',
                hintText: '2024',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Success',
                'Academic year updated',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
