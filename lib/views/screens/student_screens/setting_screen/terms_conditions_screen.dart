import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:college_project/core/utils/colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColor.primaryColor),
        title: const Text('Terms & Conditions', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(
                fontSize: 14.sp,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'Please read these Terms and Conditions carefully before using the College App operated by our Institution.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            _buildTermSection(
              '1. Acceptance of Terms',
              'By accessing or using the app, you agree to be bound by these terms. If you disagree, you may not use the app.',
            ),
            _buildTermSection(
              '2. User Accounts',
              'You must provide accurate information when creating an account. You are responsible for maintaining account confidentiality and for all activities under your account.',
            ),
            _buildTermSection(
              '3. Acceptable Use',
              'You agree not to:\n- Violate any laws or college policies\n- Harass or harm others\n- Disrupt app functionality\n- Share login credentials\n- Upload malicious content',
            ),
            _buildTermSection(
              '4. Intellectual Property',
              'All app content, features, and functionality are owned by the College and protected by intellectual property laws. You may not reproduce, modify, or distribute content without permission.',
            ),
            _buildTermSection(
              '5. User Content',
              'You retain rights to content you submit but grant the College a license to use it for app operations. You are responsible for content you post.',
            ),
            _buildTermSection(
              '6. Termination',
              'We may suspend or terminate your access for violations of these terms. You may stop using the app at any time.',
            ),
            _buildTermSection(
              '7. Disclaimers',
              'The app is provided "as is". We make no warranties about accuracy or reliability. Use at your own risk.',
            ),
            _buildTermSection(
              '8. Limitation of Liability',
              'The College is not liable for any indirect, incidental, or consequential damages arising from app use.',
            ),
            _buildTermSection(
              '9. Changes to Terms',
              'We may modify these terms at any time. Continued use after changes constitutes acceptance.',
            ),
            SizedBox(height: 20.h),
            Text(
              'For questions about these Terms, contact our administration at admin@college.edu.',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}