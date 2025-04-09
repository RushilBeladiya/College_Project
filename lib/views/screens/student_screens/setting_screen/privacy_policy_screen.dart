import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:college_project/core/utils/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColor.whiteColor),
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
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
              'Privacy Policy',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our College App.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            _buildPolicySection(
              '1. Information We Collect',
              'We may collect personal information such as your name, email address, student ID, and other details you provide when registering or using our services. We also collect usage data and device information to improve our app.',
            ),
            _buildPolicySection(
              '2. How We Use Your Information',
              'We use the information we collect to:\n- Provide and maintain our services\n- Notify you about important changes\n- Allow participation in interactive features\n- Provide customer support\n- Improve app performance and user experience\n- Ensure app security and prevent fraud',
            ),
            _buildPolicySection(
              '3. Data Sharing and Disclosure',
              'We do not sell your personal information. We may share data with:\n- College administration for academic purposes\n- Service providers who assist with app operations\n- Legal authorities when required by law',
            ),
            _buildPolicySection(
              '4. Data Security',
              'We implement industry-standard security measures including encryption and access controls. However, no internet transmission is 100% secure, so we cannot guarantee absolute security.',
            ),
            _buildPolicySection(
              '5. Your Rights',
              'You have the right to:\n- Access your personal data\n- Request correction of inaccurate data\n- Request deletion of your data\n- Opt-out of certain data uses',
            ),
            _buildPolicySection(
              '6. Changes to This Policy',
              'We may update this policy periodically. We will notify you of significant changes through the app or email. Continued use after changes constitutes acceptance.',
            ),
            SizedBox(height: 20.h),
            Text(
              'If you have any questions about this Privacy Policy, please contact our Data Protection Officer at dpo@college.edu.',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
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