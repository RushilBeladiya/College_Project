import 'dart:async';

import 'package:college_project/controller/main/network_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/views/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ErrorScreen extends StatelessWidget {
  final NetworkController _networkController = Get.find<NetworkController>();

  Future<void> _checkInternetAndProceed() async {
    final isConnected = await _networkController.isConnected();

    if (!isConnected) {
      Get.snackbar(
        'Network Error',
        'No internet connection detected',
        backgroundColor: AppColor.errorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Show reconnecting modal
      _showReconnectingModal();

      // Wait then navigate
      await Future.delayed(const Duration(seconds: 2));
      Get.back(); // Close modal
      await Future.delayed(const Duration(milliseconds: 300));
      Get.offAll(() => SplashScreen());
    }
  }

  void _showReconnectingModal() {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 280.w,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular progress with icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.wifi,
                      size: 40.w,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Reconnecting',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textColor,
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  'Please wait while we restore your connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColor.textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColor.errorColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 60.w,
                    color: AppColor.errorColor,
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Error title
              Text(
                'No Connection',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.errorColor,
                ),
              ),
              SizedBox(height: 8.h),

              // Error description
              Text(
                'Unable to connect to the internet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColor.textColor.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Please check your network settings',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColor.textColor.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 40.h),

              // Try Again button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkInternetAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
