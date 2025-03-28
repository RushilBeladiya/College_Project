import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/Administrator/home/admin_home_controller.dart';
import '../../../core/utils/colors.dart';
import '../../../models/faculty_model.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final AdminHomeController adminHomeController = Get.find();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await adminHomeController.fetchFacultyData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Staff List",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColor.primaryColor,
        leading: BackButton(
          color: Colors.white,
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (adminHomeController.isLoading.value) {
          return _buildShimmerEffect();
        }

        if (adminHomeController.facultyList.isEmpty) {
          return const Center(
            child: Text(
              "No Faculty Data Available",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          backgroundColor: Colors.white,
          color: AppColor.primaryColor,
          onRefresh: () async {
            await adminHomeController.fetchFacultyData();
          },
          child: ListView.builder(
            itemCount: adminHomeController.facultyList.length,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            itemBuilder: (context, index) {
              FacultyModel faculty = adminHomeController.facultyList[index];

              return Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.primaryColor, width: 1.5),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  child: Row(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: AppColor.greyColor,
                        backgroundImage: faculty.profileImageUrl.isNotEmpty
                            ? NetworkImage(faculty.profileImageUrl)
                            : const AssetImage("assets/dashboard/user.png")
                        as ImageProvider,
                      ),
                      SizedBox(width: 15.w),

                      // Faculty Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${faculty.firstName.toUpperCase()} ${faculty.lastName.toUpperCase()} ${faculty.surName.toUpperCase()}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              faculty.position,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Navigation Icon
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.grey,
                        onPressed: () {
                          // Navigate or perform action
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Shimmer Loading Effect
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 7,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.h,
                          width: 150.w,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 14.h,
                          width: 100.w,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
