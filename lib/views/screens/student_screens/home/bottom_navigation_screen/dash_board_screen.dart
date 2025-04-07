import 'package:college_project/controller/Administrator/home/admin_home_controller.dart';
import 'package:college_project/controller/Auth/auth_controller.dart';
import 'package:college_project/controller/Faculty/home/faculty_home_controller.dart';
import 'package:college_project/controller/Student/home/student_home_controller.dart';
import 'package:college_project/core/utils/images.dart';
import 'package:college_project/views/screens/administrator_screens/staff_list_screen/staff_list_screen.dart';
import 'package:college_project/views/screens/gallery_main_screen/gallery_main_screen.dart';
import 'package:college_project/views/screens/student_screens/Student_lectures_view_screen.dart';
import 'package:college_project/views/screens/student_screens/announcement_screen/student_announcement_screen.dart';
import 'package:college_project/views/screens/student_screens/attendance_screens/student_report_screen.dart';
import 'package:college_project/views/screens/student_screens/event_screen/studenteventscreen.dart';
import 'package:college_project/views/screens/student_screens/home/bottom_navigation_screen/profile_screen.dart';
import 'package:college_project/views/screens/student_screens/home/college_info_screen.dart';
import 'package:college_project/views/screens/student_screens/home/contact_us_screen.dart';
import 'package:college_project/views/screens/student_screens/result_screen/resultscreen.dart';
import 'package:college_project/views/screens/student_screens/syllabus_screen/student_syllabus_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../controller/Auth/dateTimeController.dart';
import '../../../../../controller/main/syllabus_controller.dart';
import '../../../../../core/utils/colors.dart';
import '../../setting_screen/settings_screen.dart';
import '../../setting_screen/webview_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final DateTimeController dateTimeController = Get.find();
  StudentHomeController homeController = Get.find();
  FacultyHomeController facultyHomeController =
      Get.put(FacultyHomeController());
  final SyllabusController controller = Get.put(SyllabusController());
  final AdminHomeController adminHomeController =
      Get.put(AdminHomeController());

  AuthController authController = Get.find();

  // double overallAttendancePercentage = 0.0; // Add this variable

  @override
  void initState() {
    super.initState();
    // homeController.fetchAttendanceRecords();
    // homeController.calculateOverallAttendance();
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
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            dateTimeController.formattedDate.value,
                            // Date
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
                            // Time
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
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Obx(
                        () => CircleAvatar(
                          backgroundColor: AppColor.whiteColor,
                          radius: 32.r,
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundImage: homeController.currentStudent.value
                                    .profileImageUrl.isNotEmpty
                                ? NetworkImage(homeController
                                    .currentStudent.value.profileImageUrl)
                                : const AssetImage(AppImage.user)
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            ("${homeController.currentStudent.value.firstName} ${homeController.currentStudent.value.lastName} ${homeController.currentStudent.value.surName}")
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: AppColor.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Obx(
                          () => Text(
                            'Mobile : ${(homeController.currentStudent.value.phoneNumber)}',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Obx(
                          () => Text(
                            'SPID : ${(homeController.currentStudent.value.spid)}',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Overall Attendance",
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Obx(
                              () => LinearPercentIndicator(
                                width: 140.w,
                                lineHeight: 5.h,
                                percent: homeController
                                        .overallAttendancePercentage.value /
                                    100,
                                leading: Text(
                                  "${homeController.overallAttendancePercentage.value.toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    color: AppColor.whiteColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                barRadius: Radius.circular(10.r),
                                backgroundColor: Colors.white,
                                progressColor: homeController
                                            .overallAttendancePercentage
                                            .value >=
                                        75
                                    ? Colors.green
                                    : homeController.overallAttendancePercentage
                                                .value >=
                                            65
                                        ? Colors.red
                                        : Colors.red.shade900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 15.h,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1.8,
              children: [
                GestureDetector(
                  onTap: () async {
                    Get.to(
                      () => StudentLectureListScreen(
                          studentStream:
                              homeController.currentStudent.value.stream,
                          studentSemester:
                              homeController.currentStudent.value.semester),
                    );
                  },
                  child: buildDashboardItem(
                    title: "Lectures",
                    image: AppImage.lectures,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => StudentSyllabusScreen(
                          semester:
                              homeController.currentStudent.value.semester,
                          stream: homeController.currentStudent.value.stream,
                        ));
                  },
                  child: buildDashboardItem(
                    title: "Syllabus",
                    image: AppImage.subjects,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => StaffListScreen());
                  },
                  child: buildDashboardItem(
                    title: "Staff Profile",
                    image: AppImage.staffProfile,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => StudentReportScreen());
                  },
                  child: buildDashboardItem(
                    title: "Report",
                    image: AppImage.report,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => StudentResultScreen());
                  },
                  child: buildDashboardItem(
                    title: "Result",
                    image: AppImage.result,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => StudentAnnouncementScreen());
                  },
                  child: buildDashboardItem(
                    title: "Notice",
                    image: AppImage.notice,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => StudentEventScreen());
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
                GestureDetector(
                  onTap: () {
                    Get.to(() => CollegeInfoScreen());
                  },
                  child: buildDashboardItem(
                    title: "College Info",
                    image: AppImage.collegeInfo,
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
                accountName:
                    Text(homeController.currentStudent.value.firstName),
                accountEmail: Text(homeController.currentStudent.value.email),
                currentAccountPicture: CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.white,
                  child: homeController.isLoading.value
                      ? Obx(() =>
                          CircularProgressIndicator()) // Show loading indicator
                      : CircleAvatar(
                          radius: 32.r,
                          backgroundColor: AppColor.whiteColor,
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundImage: homeController.currentStudent.value
                                    .profileImageUrl.isNotEmpty
                                ? NetworkImage(homeController
                                    .currentStudent.value.profileImageUrl)
                                : const AssetImage(AppImage.user)
                                    as ImageProvider,
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
              title: const Text('Profile'),
              onTap: () async {
                await Get.to(() => ProfileScreen()); // Close the drawer
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
}
