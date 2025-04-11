import 'package:college_project/controller/Auth/auth_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/images.dart';
import '../admin_auth_screen/admin_login_screen.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> studentGlobalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> facultyGlobalFormKey = GlobalKey<FormState>();
  final TextEditingController spidController = TextEditingController();
  final textFieldFocusNode = FocusNode();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appBackGroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 280.h,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                ),
                child: Stack(
                  children: [
                    // Background Logo with Low Opacity
                    Positioned.fill(
                      left: -180.w,
                      bottom: -80.h,
                      child: Opacity(
                        opacity: 0.09, // Adjust the opacity here
                        child: Image.asset(
                          AppImage.appLogo,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 50.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.greenAccent,
                                  AppColor.whiteColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                'STERS',
                                style: TextStyle(
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 60.r,
                              backgroundColor: AppColor.whiteColor,
                              backgroundImage: AssetImage(AppImage.appLogo),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 180.h,
              left: 25.w,
              right: 25.w,
              child: Container(
                // padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: DefaultTabController(
                  length: 2, // Number of tabs
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TabBar
                      TabBar(
                        controller: tabController,
                        indicator: BoxDecoration(
                          color: AppColor.primaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(18.r)),
                        ),
                        labelColor: AppColor.whiteColor,
                        labelStyle: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                        unselectedLabelColor: AppColor.primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: AppColor.primaryColor,
                        dividerHeight: 1.h,
                        dividerColor: AppColor.primaryColor,
                        tabs: [
                          Tab(text: "Student"),
                          Tab(text: "Faculty"),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TabBar View (Content for each tab)
                            SizedBox(
                              height: 180.h, // Adjust height as needed
                              child: TabBarView(
                                controller: tabController,
                                physics: ScrollPhysics(
                                    parent: NeverScrollableScrollPhysics()),
                                children: [
                                  Form(
                                    key: studentGlobalFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome Student",
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          "Login to your account",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(height: 20.h),
                                        TextFormField(
                                          autofocus: false,
                                          maxLength: 40,
                                          buildCounter: (_,
                                              {required int currentLength,
                                              required bool isFocused,
                                              required int? maxLength}) {
                                            return null;
                                          },
                                          cursorColor: AppColor.primaryColor,
                                          controller: AuthController
                                              .instance.emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onChanged: (value) {
                                            AuthController.instance.email
                                                .value = value.trim();
                                          },
                                          validator: (value) {
                                            String email = value!.trim();
                                            if (email.isEmpty)
                                              return "Please enter your email.";
                                            if (!RegExp(
                                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                                .hasMatch(email)) {
                                              return "Please enter a valid email.";
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.email_rounded,
                                                color: AppColor.primaryColor),
                                            suffixIcon: Obx(() => AuthController
                                                    .instance
                                                    .isEmailVerified
                                                    .value
                                                ? Icon(Icons.verified_rounded,
                                                    color:
                                                        AppColor.primaryColor)
                                                : ElevatedButton(
                                                    onPressed: AuthController
                                                            .instance
                                                            .isTimerRunning
                                                            .value
                                                        ? null
                                                        : () async {
                                                            await AuthController
                                                                .instance
                                                                .sendVerificationEmailWithTimer();
                                                          },
                                                    child: Text(AuthController
                                                            .instance
                                                            .isTimerRunning
                                                            .value
                                                        ? "${AuthController.instance.remainingSeconds.value}s"
                                                        : "Verify"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColor.primaryColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.w,
                                                              vertical: 5.h),
                                                      textStyle: TextStyle(
                                                          fontSize: 12.sp),
                                                    ),
                                                  )),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 10.h),
                                            hintText: "Enter your email",
                                            hintStyle: TextStyle(
                                                fontSize: 13.sp,
                                                color: AppColor.greyColor),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColor.primaryColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        TextFormField(
                                          autofocus: false,
                                          maxLength: 10,
                                          buildCounter: (_,
                                              {required int currentLength,
                                              required bool isFocused,
                                              required int? maxLength}) {
                                            return null;
                                          },
                                          cursorColor: AppColor.primaryColor,
                                          controller: spidController,
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            String spid = value!.trim();

                                            if (spid.isEmpty) {
                                              return ("Please enter SPID.");
                                            }

                                            if (!RegExp(r'^\d{10}$')
                                                .hasMatch(spid)) {
                                              return ("Please enter a valid SPID");
                                            }

                                            return null;
                                          },
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.verified_user_rounded,
                                                color: AppColor.primaryColor),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 10.h),
                                            hintText: "SPID",
                                            hintStyle: TextStyle(
                                                fontSize: 13.sp,
                                                color: AppColor.greyColor),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColor.primaryColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Form(
                                    key: facultyGlobalFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome Faculty",
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          "Login to your account",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(height: 20.h),
                                        TextFormField(
                                          autofocus: false,
                                          maxLength: 40,
                                          buildCounter: (_,
                                              {required int currentLength,
                                              required bool isFocused,
                                              required int? maxLength}) {
                                            return null;
                                          },
                                          cursorColor: AppColor.primaryColor,
                                          controller: AuthController
                                              .instance.emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onChanged: (value) {
                                            AuthController.instance.email
                                                .value = value.trim();
                                          },
                                          validator: (value) {
                                            String email = value!.trim();
                                            if (email.isEmpty)
                                              return "Please enter your email.";
                                            if (!RegExp(
                                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                                .hasMatch(email)) {
                                              return "Please enter a valid email.";
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.email_rounded,
                                                color: AppColor.primaryColor),
                                            suffixIcon: Obx(() => AuthController
                                                    .instance
                                                    .isEmailVerified
                                                    .value
                                                ? Icon(Icons.verified_rounded,
                                                    color:
                                                        AppColor.primaryColor)
                                                : ElevatedButton(
                                                    onPressed: AuthController
                                                            .instance
                                                            .isTimerRunning
                                                            .value
                                                        ? null
                                                        : () async {
                                                            await AuthController
                                                                .instance
                                                                .sendVerificationEmailWithTimer();
                                                          },
                                                    child: Text(AuthController
                                                            .instance
                                                            .isTimerRunning
                                                            .value
                                                        ? "${AuthController.instance.remainingSeconds.value}s"
                                                        : "Verify"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColor.primaryColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.w,
                                                              vertical: 5.h),
                                                      textStyle: TextStyle(
                                                          fontSize: 12.sp),
                                                    ),
                                                  )),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 10.h),
                                            hintText: "Enter your email",
                                            hintStyle: TextStyle(
                                                fontSize: 13.sp,
                                                color: AppColor.greyColor),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColor.primaryColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        TextFormField(
                                          autofocus: false,
                                          maxLength: 10,
                                          buildCounter: (_,
                                              {required int currentLength,
                                              required bool isFocused,
                                              required int? maxLength}) {
                                            return null;
                                          },
                                          cursorColor: AppColor.primaryColor,
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            String phoneNumber = value!.trim();

                                            if (phoneNumber.isEmpty) {
                                              return ("Please enter your phone number.");
                                            }

                                            if (!RegExp(r'^[6-9]\d{9}$')
                                                .hasMatch(phoneNumber)) {
                                              return ("Please enter a valid phone number.");
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(Icons.phone),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 10.h),
                                            hintText: "Mobile Number",
                                            hintStyle: TextStyle(
                                                fontSize: 13.sp,
                                                color: AppColor.greyColor),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColor.primaryColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 25.h),
                            InkWell(
                              onTap: () async {
                                if (tabController.index == 0) {
                                  if (studentGlobalFormKey.currentState!
                                      .validate()) {
                                    AuthController.instance.loginStudent(
                                      AuthController
                                          .instance.emailController.text
                                          .trim(),
                                      spidController.text.trim(),
                                    );
                                  }
                                } else {
                                  if (facultyGlobalFormKey.currentState!
                                      .validate()) {
                                    AuthController.instance.loginFaculty(
                                      AuthController
                                          .instance.emailController.text
                                          .trim(),
                                      phoneController.text.trim(),
                                    );
                                  }
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
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Are you an administrator? ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColor.blackColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AdminLoginScreen());
                    },
                    child: Text(
                      "Login Here",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
