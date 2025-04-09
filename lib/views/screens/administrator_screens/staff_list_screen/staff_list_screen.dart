import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/models/faculty_model.dart';
import 'package:college_project/views/screens/administrator_screens/staff_list_screen/staff_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final searchController = TextEditingController();
  final _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
  }

  void searchStaff(String query) {
    _searchQuery.value = query;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: searchStaff,
              decoration: InputDecoration(
                labelText: "Search Staff",
                labelStyle: TextStyle(color: AppColor.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
                prefixIcon: Icon(Icons.search, color: AppColor.primaryColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: AppColor.primaryColor, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref().child('faculty').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerEffect();
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData ||
                    snapshot.data?.snapshot.value == null) {
                  return const Center(
                    child: Text(
                      "No Faculty Data Available",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // Convert the database snapshot to List<FacultyModel>
                final Map<dynamic, dynamic> data =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final List<FacultyModel> facultyList = data.entries
                    .map((e) =>
                        FacultyModel.fromJson({...e.value, 'uid': e.key}))
                    .toList();

                // Filter the list based on search query
                final filteredList = facultyList.where((faculty) {
                  final fullName =
                      "${faculty.firstName} ${faculty.lastName}".toLowerCase();
                  return fullName.contains(_searchQuery.value.toLowerCase());
                }).toList();

                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: AppColor.primaryColor,
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 1));
                  },
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 16.w),
                      itemBuilder: (context, index) {
                        FacultyModel faculty = filteredList[index];
                        bool isHighlighted = _searchQuery.value.isNotEmpty &&
                            "${faculty.firstName} ${faculty.lastName}"
                                .toLowerCase()
                                .contains(_searchQuery.value.toLowerCase());

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: isHighlighted
                                        ? AppColor.primaryColor
                                        : Colors.transparent,
                                    width: isHighlighted ? 2 : 1,
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 10.h),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 16.w),
                                  child: Row(
                                    children: [
                                      // Profile Image
                                      CircleAvatar(
                                        radius: 40.r,
                                        backgroundColor: AppColor.greyColor,
                                        backgroundImage: faculty
                                                .profileImageUrl.isNotEmpty
                                            ? NetworkImage(
                                                faculty.profileImageUrl)
                                            : const AssetImage(
                                                    "assets/dashboard/user.png")
                                                as ImageProvider,
                                      ),
                                      SizedBox(width: 15.w),

                                      // Faculty Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                        icon: const Icon(
                                            Icons.arrow_forward_ios_rounded),
                                        color: Colors.grey,
                                        onPressed: () {
                                          Get.to(
                                            () => StaffDetailScreen(faculty),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
