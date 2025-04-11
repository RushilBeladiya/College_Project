// import 'dart:io';

// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:college_project/controller/Student/home/student_home_controller.dart';
// import 'package:college_project/core/utils/colors.dart';
// import 'package:college_project/core/utils/images.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final StudentHomeController studentHomeController = Get.find();
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _editProfileImage() async {
//     try {
//       // Pick an image
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image == null) return;

//       // Upload to Firebase Storage
//       final storageRef = FirebaseStorage.instance.ref().child(
//           'profile_images/${studentHomeController.currentStudent.value.uid}.jpg');
//       final uploadTask = storageRef.putFile(File(image.path));
//       final snapshot = await uploadTask.whenComplete(() => null);

//       // Get the download URL
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       // Update the profile image URL in the database
//       await studentHomeController.currentStudent.value.updateStudent({
//         'profileImageUrl': downloadUrl,
//       });

//       // Update the local model
//       studentHomeController.currentStudent.update((student) {
//         student?.profileImageUrl = downloadUrl;
//       });

//       Get.snackbar("Success", "Profile image updated successfully!",
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to update profile image: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final student = studentHomeController.currentStudent.value;

//     return Scaffold(
//       backgroundColor: AppColor.whiteColor,
//       appBar: AppBar(
//         backgroundColor: AppColor.primaryColor,
//         title: const Text('Profile', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(15.w),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: AppColor.whiteColor,
//             borderRadius: BorderRadius.circular(15.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 blurRadius: 6,
//                 offset: const Offset(2, 4),
//               ),
//             ],
//             border: Border.all(color: Colors.black12),
//           ),
//           child: Column(
//             children: [
//               SizedBox(height: 10.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       AppImage.appLogo,
//                       height: 50.h,
//                       width: 50.h,
//                     ),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Text(
//                             "THE SURAT TECHNICAL EDUCATION & RESEARCH SOCIETY",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 9.sp),
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             "SASCM ENGLISH MEDIUM COMMERCE COLLEGE & STTERS COLLEGE OF BUSINESS ADMINISTRATION",
//                             style: TextStyle(fontSize: 7.5.sp),
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             "STERS COLLEGE OF COMPUTER APPLICATION",
//                             style: TextStyle(
//                               color: AppColor.primaryColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 9.sp,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                   color: Colors.black26,
//                   thickness: 1,
//                   indent: 10,
//                   endIndent: 10),
//               Text(
//                 "Near Lalbhai Contractor Stadium, Opp. Goverdhan Temple,\n(Haveli), Dumas Road, Vesu, SURAT-395 007.",
//                 style: TextStyle(fontSize: 8.sp),
//                 textAlign: TextAlign.center,
//               ),
//               Divider(
//                   color: Colors.black26,
//                   thickness: 1,
//                   indent: 10,
//                   endIndent: 10),
//               Text("Contact: 88-66-66-15-65",
//                   style: TextStyle(fontSize: 10.sp)),
//               Divider(
//                   color: Colors.black26,
//                   thickness: 1,
//                   indent: 10,
//                   endIndent: 10),
//               Container(
//                 color: AppColor.whiteColor,
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 4.h),
//                 child: Center(
//                   child: Text(
//                     student.stream,
//                     style: TextStyle(
//                       color: const Color.fromARGB(255, 227, 105, 103),
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 10.w,
//                   vertical: 10.h,
//                 ),
//                 child: Column(
//                   children: [
//                     // Image & Barcode aligned to left with 20 padding
//                     Padding(
//                       padding: EdgeInsets.only(left: 40.w),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           RotatedBox(
//                             quarterTurns: 3,
//                             child: BarcodeWidget(
//                               barcode: Barcode.code128(),
//                               data: student.spid,
//                               color: const Color.fromARGB(208, 39, 37, 37),
//                               width: 100.h,
//                               height: 50.w,
//                             ),
//                           ),
//                           SizedBox(width: 10.w),
//                           Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.r),
//                                 child: Image.network(
//                                   student.profileImageUrl,
//                                   height: 100.h,
//                                   width: 100.h,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder: (context, child, progress) {
//                                     if (progress == null) return child;
//                                     return Center(
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         color: AppColor.primaryColor,
//                                       ),
//                                     );
//                                   },
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Image.asset(
//                                       'assets/college_image/avatar.png',
//                                       height: 100.h,
//                                       width: 100.h,
//                                       fit: BoxFit.cover,
//                                     );
//                                   },
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 5.h,
//                                 right: 5.w,
//                                 child: IconButton(
//                                   icon: Icon(Icons.edit,
//                                       color: AppColor.primaryColor),
//                                   onPressed: _editProfileImage,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 10.h),

//                     // Student Name
//                     Text(
//                       "${student.firstName} ${student.surName}",
//                       style: TextStyle(
//                           fontSize: 16.sp, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.h),

//                     // Student Info aligned left with 20 padding
//                     Padding(
//                       padding: EdgeInsets.only(left: 30.w, right: 0.w),
//                       child: Column(
//                         children: [
//                           buildInfoRow("Email", student.email),
//                           buildInfoRow("Mobile", student.phoneNumber),
//                           buildInfoRow("Semester", student.semester),
//                           buildInfoRow("Division", student.division),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 10.h),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           children: [
//                             Text("Student's sign",
//                                 style: TextStyle(fontSize: 10.sp)),
//                             SizedBox(height: 3.h),
//                             Text("✍️ ${student.firstName}",
//                                 style: TextStyle(fontSize: 10.sp)),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Text("Principal's sign",
//                                 style: TextStyle(fontSize: 10.sp)),
//                             SizedBox(height: 3.h),
//                             Text("✍️ Ascii", style: TextStyle(fontSize: 10.sp)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(String title, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100.w,
//             child: Text(
//               "$title:",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12.sp,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontSize: 12.sp),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:college_project/controller/Student/home/student_home_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/core/utils/images.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StudentHomeController studentHomeController = Get.find();
  final ImagePicker _picker = ImagePicker();

  Future<void> _editProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final storageRef = FirebaseStorage.instance.ref().child(
          'profile_images/${studentHomeController.currentStudent.value.uid}.jpg');
      final uploadTask = storageRef.putFile(File(image.path));
      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadUrl = await snapshot.ref.getDownloadURL();

      await studentHomeController.currentStudent.value.updateStudent({
        'profileImageUrl': downloadUrl,
      });

      studentHomeController.currentStudent.update((student) {
        student?.profileImageUrl = downloadUrl;
      });

      Get.snackbar("Success", "Profile image updated successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile image: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = studentHomeController.currentStudent.value;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Image.asset(
                      AppImage.appLogo,
                      height: 50.h,
                      width: 50.h,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "THE SURAT TECHNICAL EDUCATION & RESEARCH SOCIETY",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 9.sp),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "SASCM ENGLISH MEDIUM COMMERCE COLLEGE & STTERS COLLEGE OF BUSINESS ADMINISTRATION",
                            style: TextStyle(fontSize: 7.5.sp),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "STERS COLLEGE OF COMPUTER APPLICATION",
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                  color: Colors.black26,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10),
              Text(
                "Near Lalbhai Contractor Stadium, Opp. Goverdhan Temple,\n(Haveli), Dumas Road, Vesu, SURAT-395 007.",
                style: TextStyle(fontSize: 8.sp),
                textAlign: TextAlign.center,
              ),
              Divider(
                  color: Colors.black26,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10),
              Text("Contact: 88-66-66-15-65",
                  style: TextStyle(fontSize: 10.sp)),
              Divider(
                  color: Colors.black26,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10),
              Container(
                color: AppColor.whiteColor,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Center(
                  child: Text(
                    student.stream,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 227, 105, 103),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 40.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: student.spid,
                              color: const Color.fromARGB(208, 39, 37, 37),
                              width: 100.h,
                              height: 50.w,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 100.h,
                                width: 100.h,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    student.profileImageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.primaryColor,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/college_image/avatar.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5.h,
                                right: 5.w,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColor.primaryColor,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.edit,
                                        size: 15, color: Colors.white),
                                    onPressed: _editProfileImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "${student.firstName} ${student.surName}",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.only(left: 30.w, right: 0.w),
                      child: Column(
                        children: [
                          buildInfoRow("Email", student.email),
                          buildInfoRow("Mobile", student.phoneNumber),
                          buildInfoRow("Semester", student.semester),
                          buildInfoRow("Division", student.division),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Student's sign",
                                style: TextStyle(fontSize: 10.sp)),
                            SizedBox(height: 3.h),
                            Text("✍️ ${student.firstName}",
                                style: TextStyle(fontSize: 10.sp)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Principal's sign",
                                style: TextStyle(fontSize: 10.sp)),
                            SizedBox(height: 3.h),
                            Text("✍️ Ascii", style: TextStyle(fontSize: 10.sp)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              "$title:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}
