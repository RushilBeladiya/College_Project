// import 'package:college_project/controller/Auth/auth_controller.dart';
// import 'package:college_project/core/utils/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../../core/utils/images.dart';

// class AdminLoginScreen extends StatefulWidget {
//   const AdminLoginScreen({super.key});

//   @override
//   State<AdminLoginScreen> createState() => _AdminLoginScreenState();
// }

// class _AdminLoginScreenState extends State<AdminLoginScreen> {
//   final logGlobalFormKey = GlobalKey<FormState>();
//   final TextEditingController phoneController = TextEditingController();
//   final textFieldFocusNode = FocusNode();
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
//           child: Column(
//             children: [
//               const Spacer(),
//               Image.asset(
//                 AppImage.appLogo,
//                 filterQuality: FilterQuality.high,
//                 fit: BoxFit.contain,
//                 height: 90.h,
//               ),
//               const Spacer(),
//               Form(
//                 key: logGlobalFormKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     TextFormField(
//                       autofocus: false,
//                       maxLength: 40,
//                       buildCounter: (_,
//                           {required int currentLength,
//                           required bool isFocused,
//                           required int? maxLength}) {
//                         return null;
//                       },
//                       cursorColor: AppColor.primaryColor,
//                       controller: AuthController.instance.emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       onChanged: (value) {
//                         AuthController.instance.email.value = value.trim();
//                       },
//                       validator: (value) {
//                         String email = value!.trim();
//                         if (email.isEmpty) return "Please enter your email.";
//                         if (!RegExp(
//                                 r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
//                             .hasMatch(email)) {
//                           return "Please enter a valid email.";
//                         }
//                         return null;
//                       },
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.email_rounded,
//                             color: AppColor.primaryColor),
//                         suffixIcon: Obx(() {
//                           if (AuthController.instance.isEmailVerified.value) {
//                             return Icon(Icons.verified_rounded,
//                                 color: AppColor.primaryColor);
//                           } else {
//                             return ElevatedButton(
//                               onPressed: AuthController
//                                       .instance.isTimerRunning.value
//                                   ? null
//                                   : () async {
//                                       // Start the countdown instantly
//                                       AuthController.instance.startCountdown();
//                                       // Send verification email
//                                       await AuthController.instance
//                                           .sendVerificationEmailWithTimer();
//                                       // Start checking email verification status in the background
//                                       AuthController.instance
//                                           .checkEmailVerificationStatus();
//                                     },
//                               child: Text(
//                                 AuthController.instance.isTimerRunning.value
//                                     ? "${AuthController.instance.remainingSeconds.value}s"
//                                     : "Verify",
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColor.primaryColor,
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 12.w, vertical: 5.h),
//                                 textStyle: TextStyle(fontSize: 12.sp),
//                               ),
//                             );
//                           }
//                         }),
//                         contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12.w, vertical: 10.h),
//                         hintText: "Enter your email",
//                         hintStyle: TextStyle(
//                             fontSize: 13.sp, color: AppColor.greyColor),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                               color: AppColor.primaryColor, width: 1),
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.h,
//                     ),
//                     TextFormField(
//                       autofocus: false,
//                       maxLength: 10,
//                       buildCounter: (_,
//                           {required int currentLength,
//                           required bool isFocused,
//                           required int? maxLength}) {
//                         return null;
//                       },
//                       cursorColor: AppColor.primaryColor,
//                       controller: phoneController,
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         String phoneNumber = value!.trim();

//                         if (phoneNumber.isEmpty) {
//                           return ("Please enter your phone number.");
//                         }

//                         if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phoneNumber)) {
//                           return ("Please enter a valid phone number.");
//                         }

//                         return null;
//                       },
//                       textInputAction: TextInputAction.done,
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Icons.phone),
//                         contentPadding: EdgeInsets.symmetric(
//                             horizontal: 12.w, vertical: 10.h),
//                         hintText: "Mobile Number",
//                         hintStyle: TextStyle(
//                             fontSize: 13.sp, color: AppColor.greyColor),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                               color: AppColor.primaryColor, width: 1),
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30.h),
//                     InkWell(
//                       onTap: () async {
//                         if (logGlobalFormKey.currentState!.validate()) {
//                           AuthController.instance.loginAdmin(
//                             AuthController.instance.emailController.text.trim(),
//                             phoneController.text.trim(),
//                           );
//                         }
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 10.h),
//                         decoration: BoxDecoration(
//                             color: AppColor.primaryColor,
//                             borderRadius: BorderRadius.circular(10.r),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColor.primaryColor,
//                                 blurRadius: 0.5,
//                                 spreadRadius: 0.2,
//                               ),
//                             ]),
//                         child: Center(
//                           child: Text(
//                             "Login",
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                               color: AppColor.whiteColor,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Spacer(
//                 flex: 2,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Are you an student? ",
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       color: AppColor.blackColor,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Text(
//                       "Login Here",
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.primaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:college_project/controller/Auth/auth_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/images.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final logGlobalFormKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Automatically check verification status every few seconds
    AuthController.instance.startEmailVerificationAutoChecker();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                AppImage.appLogo,
                filterQuality: FilterQuality.high,
                fit: BoxFit.contain,
                height: 90.h,
              ),
              const Spacer(),
              Form(
                key: logGlobalFormKey,
                child: Column(
                  children: [
                    // Email Field with Verification
                    Obx(() => TextFormField(
                          maxLength: 40,
                          buildCounter: (_,
                                  {required currentLength,
                                  required isFocused,
                                  required maxLength}) =>
                              null,
                          cursorColor: AppColor.primaryColor,
                          controller: AuthController.instance.emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            AuthController.instance.email.value = value.trim();
                          },
                          validator: (value) {
                            final email = value!.trim();
                            if (email.isEmpty)
                              return "Please enter your email.";
                            if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                .hasMatch(email)) {
                              return "Please enter a valid email.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_rounded,
                                color: AppColor.primaryColor),
                            suffixIcon: AuthController
                                    .instance.isEmailVerified.value
                                ? Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: Icon(Icons.verified_rounded,
                                        size: 20.sp, color: Colors.green),
                                  )
                                : ElevatedButton(
                                    onPressed: AuthController
                                            .instance.isTimerRunning.value
                                        ? null
                                        : () async {
                                            AuthController.instance
                                                .startCountdown();
                                            await AuthController.instance
                                                .sendVerificationEmailWithTimer();
                                            AuthController.instance
                                                .checkEmailVerificationStatus();
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 4.h),
                                      textStyle: TextStyle(fontSize: 12.sp),
                                    ),
                                    child: Text(
                                      AuthController
                                              .instance.isTimerRunning.value
                                          ? "${AuthController.instance.remainingSeconds.value}s"
                                          : "Verify",
                                    ),
                                  ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                            hintText: "Enter your email",
                            hintStyle: TextStyle(
                                fontSize: 13.sp, color: AppColor.greyColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        )),
                    SizedBox(height: 10.h),

                    // Phone Field
                    TextFormField(
                      maxLength: 10,
                      buildCounter: (_,
                              {required currentLength,
                              required isFocused,
                              required maxLength}) =>
                          null,
                      cursorColor: AppColor.primaryColor,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        String phoneNumber = value!.trim();
                        if (phoneNumber.isEmpty)
                          return "Please enter your phone number.";
                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phoneNumber)) {
                          return "Please enter a valid phone number.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(
                            fontSize: 13.sp, color: AppColor.greyColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Login Button
                    InkWell(
                      onTap: () {
                        if (logGlobalFormKey.currentState!.validate()) {
                          AuthController.instance.loginAdmin(
                            AuthController.instance.emailController.text.trim(),
                            phoneController.text.trim(),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryColor,
                              blurRadius: 0.5,
                              spreadRadius: 0.2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you a student? ",
                      style: TextStyle(
                          fontSize: 13.sp, color: AppColor.blackColor)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text("Login Here",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
