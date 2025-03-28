import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../controller/Auth/auth_controller.dart';
import '../../../../../core/utils/colors.dart';

class EmailVerificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = AuthController.instance;

    return Obx(() {
      // ✅ If already verified, show checkmark
      if (controller.isVerified.value) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.verified_rounded, color: AppColor.primaryColor, size: 25.sp),
        );
      }

      if (controller.isChecking.value) {
        return Padding(
          padding: EdgeInsets.all(15),
          child: Center(child: CircularProgressIndicator(strokeWidth: 1.w, color: AppColor.primaryColor)),
        );
      }

      // ⏲ Show countdown timer before allowing "Resend"
      if (controller.countdown.value > 0) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Text(
            "${controller.countdown.value} s",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        );
      }
      // 🔄 Show "Resend" button when countdown finishes
      if (controller.canResend.value) {
        return TextButton(
          onPressed: () {
            controller.sendVerificationEmail();
          },
          child: Text("Resend",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        );
      }

      // 🔘 Show "Verify" button (Gray if email is empty, Blue if valid email)
      return Obx(() {
        bool isValidEmail = controller.isValidEmail(controller.email.value);
        return FittedBox(
          fit: BoxFit.fitHeight,
          child: Padding(
            padding:  EdgeInsets.only(right: 5.w),
            child: ElevatedButton(
              onPressed: isValidEmail
                  ? () async {
                      await controller.checkEmailVerified();
                      if (!controller.isVerified.value) {
                        controller.sendVerificationEmail();
                      } else {
                        AuthController.instance.isVerified.value = true;
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                backgroundColor: isValidEmail ? AppColor.primaryColor : AppColor.primaryColor,

              ),
              child: Text("Verify", style: TextStyle(color: AppColor.whiteColor,fontSize: 12.sp,),),
            ),
          ),
        );
      });
    });
  }
}
