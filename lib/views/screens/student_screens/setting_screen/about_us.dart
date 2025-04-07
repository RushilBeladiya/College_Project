import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/core/utils/images.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColor.whiteColor),
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                AppImage.appLogo, // Replace with your logo asset
                height: 100.h,
                width: 100.w,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'About Our College',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Founded in 1990, our college has been a pioneer in providing quality education to students from diverse backgrounds. With state-of-the-art facilities and experienced faculty, we strive to create an environment that fosters learning, innovation, and personal growth.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'To empower students with knowledge, skills, and values that prepare them for successful careers and meaningful contributions to society.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'To be a globally recognized institution known for academic excellence, innovative research, and transformative student experiences.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            SizedBox(height: 10.h),
            _buildContactInfo(Icons.location_on, '123 College Street, Cityville, State 12345'),
            _buildContactInfo(Icons.phone, '+1 (123) 456-7890'),
            _buildContactInfo(Icons.email, 'info@college.edu'),
            _buildContactInfo(Icons.language, 'www.college.edu'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp))),
        ],
      ),
    );
  }
}