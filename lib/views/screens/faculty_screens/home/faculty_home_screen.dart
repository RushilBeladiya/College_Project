import 'dart:io';
import 'package:college_project/controller/Faculty/home/faculty_home_controller.dart';
import 'package:college_project/controller/main/syllabus_controller.dart';
import 'package:college_project/views/screens/auth_screen/student_auth_screen/student_registration_screen.dart';
import 'package:college_project/views/screens/faculty_screens/announcement_screen/add_announcement_screen.dart';
import 'package:college_project/views/screens/faculty_screens/attendance_screen/faculty_attendance_main_screen.dart';
import 'package:college_project/views/screens/faculty_screens/eventscreen/facultyeventscreen.dart';
import 'package:college_project/views/screens/faculty_screens/faculty_stafflist_screen/faculty_staff_list_screen.dart';
import 'package:college_project/views/screens/faculty_screens/home/faculty_lectures_view_screen.dart';
import 'package:college_project/views/screens/faculty_screens/payment_screens/faculty_payment_screen.dart';
import 'package:college_project/views/screens/faculty_screens/student_info_screen/student_list_screen.dart';
import 'package:college_project/views/screens/faculty_screens/syllabus_screens/Faculty_syllabus_screen.dart';
import 'package:college_project/views/screens/gallery_main_screen/gallery_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../controller/Auth/auth_controller.dart';
import '../../../../controller/Auth/dateTimeController.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/images.dart';
import '../../student_screens/home/bottom_navigation_screen/profile_screen.dart';
import '../../student_screens/home/contact_us_screen.dart';
import '../../student_screens/setting_screen/settings_screen.dart';
import '../../student_screens/setting_screen/webview_screen.dart';

class FacultyHomeScreen extends StatefulWidget {
  const FacultyHomeScreen({super.key});

  @override
  State<FacultyHomeScreen> createState() => _FacultyHomeScreenState();
}

class _FacultyHomeScreenState extends State<FacultyHomeScreen> {
  final DateTimeController dateTimeController = Get.find();
  final AuthController authController = Get.find();
  final FacultyHomeController facultyHomeController = Get.put(FacultyHomeController());
  final SyllabusController syllabusController = Get.put(SyllabusController());
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      File imageFile = File(pickedFile.path);
      String fileName = 'faculty_images/${facultyHomeController.facultyModel.value.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(imageFile);
      String imageUrl = await storageRef.getDownloadURL();

      // Update in Firebase Database
      await facultyHomeController.updateFacultyProfileImage(imageUrl);

      Get.back(); // Close loading dialog
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Error', 'Failed to upload image: ${e.toString()}');
    }
  }

  Future<void> _deleteProfileImage() async {
    try {
      // Get the current image URL to delete from storage
      String currentImageUrl = facultyHomeController.facultyModel.value.profileImageUrl;
      if (currentImageUrl.isNotEmpty) {
        // Extract the file path from the URL
        Uri uri = Uri.parse(currentImageUrl);
        String filePath = uri.path.split('/o/')[1].split('?')[0];

        // Delete from storage
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
        await storageRef.delete();
      }

      // Update in Firebase Database
      await facultyHomeController.updateFacultyProfileImage("");

      Get.snackbar('Success', 'Profile image removed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete image: ${e.toString()}');
    }
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickAndUploadImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Obx(
                () => CircleAvatar(
              backgroundColor: AppColor.whiteColor,
              radius: 42.r,
              child: CircleAvatar(
                radius: 40.r,
                backgroundImage: facultyHomeController
                    .facultyModel
                    .value
                    .profileImageUrl
                    .isNotEmpty
                    ? NetworkImage(facultyHomeController
                    .facultyModel.value.profileImageUrl)
                    : const AssetImage(AppImage.user)
                as ImageProvider,
              ),
            ),
          ),
          if (facultyHomeController.facultyModel.value.profileImageUrl.isNotEmpty)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _deleteProfileImage,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.whiteColor, width: 2),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: AppColor.whiteColor,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
          Positioned(
            right: facultyHomeController.facultyModel.value.profileImageUrl.isNotEmpty ? 20.w : 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.whiteColor, width: 2),
              ),
              child: Icon(
                Icons.edit,
                color: AppColor.whiteColor,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDashboardItem({required String title, required String image}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15.w, right: 25.w),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            height: 28.h,
            fit: BoxFit.contain,
            image,
            filterQuality: FilterQuality.high,
          ),
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30.r),
              ),
            ),
            padding: EdgeInsets.only(
              right: 15.w,
              left: 15.w,
              bottom: 20.h,
              top: 40.h,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: Icon(
                            Icons.menu_rounded,
                            color: AppColor.whiteColor,
                            size: 30,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                              () => Text(
                            dateTimeController.formattedDate.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                        Obx(
                              () => Text(
                            dateTimeController.formattedTime.value,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.person_pin,
                        color: AppColor.whiteColor,
                        size: 22.sp,
                      ),
                      onPressed: () async {
                        await Get.to(() => const ProfileScreen());
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: AppColor.whiteColor,
                        size: 22.sp,
                      ),
                      onPressed: () async {
                        await Get.to(() => const SettingsScreen());
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  width: 400.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: _buildProfileImage(),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Obx(
                                  () => Text(
                                "${facultyHomeController.facultyModel.value.firstName} ${facultyHomeController.facultyModel.value.lastName} ${facultyHomeController.facultyModel.value.surName}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Obx(
                                  () => Text(
                                'Mobile : ${facultyHomeController.facultyModel.value.phoneNumber}',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 14.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Obx(
                                  () => Text(
                                'Email : ${facultyHomeController.facultyModel.value.email}',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 14.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 20.h,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1.8,
              children: [
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => const StudentListScreen());
                  },
                  child: buildDashboardItem(
                    title: "Student Info",
                    image: AppImage.studentInfo,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => FacultyAttendanceScreen());
                  },
                  child: buildDashboardItem(
                    title: "Attendance",
                    image: AppImage.attandence,
                  ),
                ),
                // // GestureDetector(
                // //
                // //   child: buildDashboardItem(
                // //     title: "Time-Table",
                // //     image: AppImage.timetable,
                // //   ),
                // // ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => FacultySyllabusScreen());
                  },
                  child: buildDashboardItem(
                    title: "Syllabus",
                    image: AppImage.subjects,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => FacultyLectureListScreen());
                  },
                  child: buildDashboardItem(
                    title: "Lectures",
                    image: AppImage.lectures,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => PaymentStatusShowScreen());
                  },
                  child: buildDashboardItem(
                    title: "Fee payment",
                    image: AppImage.feePayment,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => FacultyAnnouncementScreen());
                  },
                  child: buildDashboardItem(
                    title: "Notice",
                    image: AppImage.notice,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => FacultyStaffListScreen());
                  },
                  child: buildDashboardItem(
                    title: "Staff Profile",
                    image: AppImage.staffProfile,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => FacultyEventScreen());
                  },
                  child: buildDashboardItem(
                    title: "Event",
                    image: AppImage.event,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => GalleryScreen());
                  },
                  child: buildDashboardItem(
                    title: "Gallery",
                    image: AppImage.gallery,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ContactUsScreen());
                  },
                  child: buildDashboardItem(
                    title: "Contact Us",
                    image: AppImage.contactus,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColor.appBackGroundColor,
        clipBehavior: Clip.antiAlias,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Obx(
              () => UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text(""),
                accountEmail: Text(""),
                currentAccountPicture: CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 32.r,
                    backgroundColor: AppColor.whiteColor,
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundImage: facultyHomeController
                              .facultyModel.value.profileImageUrl.isNotEmpty
                          ? NetworkImage(facultyHomeController
                              .facultyModel.value.profileImageUrl)
                          : const AssetImage(AppImage.user) as ImageProvider,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('Add Student'),
              onTap: () async {
                await Get.to(
                    () => StudentRegistrationScreen()); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () async {
                await Get.to(() => const ProfileScreen()); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.share_rounded),
              title: Text('Share'),
              onTap: () {
                Share.share("Share CollegeApp");
              },
            ),
            ListTile(
              leading: Icon(Icons.star_half_rounded),
              title: Text('Rate us'),
              onTap: () {
                Get.to(() => const WebViewScreen(
                    url: "https://play.google.com", title: "RateUs App"));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await authController.logoutUser();
              },
            ),
            SizedBox(
              height: 265.h,
            ),
            Container(
              color: AppColor.primaryColor.withOpacity(0.2),
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () async {
                  await Get.to(
                      () => const SettingsScreen()); // Close the drawer
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildDashboardItem({required String title, required String image}) {
  //   return Container(
  //     alignment: Alignment.center,
  //     padding: EdgeInsets.only(left: 15.w, right: 25.w),
  //     decoration: BoxDecoration(
  //       color: AppColor.primaryColor.withOpacity(0.15),
  //       borderRadius: BorderRadius.circular(8.r),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Image.asset(
  //           height: 28.h,
  //           fit: BoxFit.contain,
  //           image,
  //           filterQuality: FilterQuality.high,
  //         ),
  //         Text(
  //           title,
  //           textAlign: TextAlign.start,
  //           style: TextStyle(
  //             fontSize: 13.sp,
  //             fontWeight: FontWeight.w500,
  //             color: AppColor.blackColor,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
