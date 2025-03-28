import 'package:college_project/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart'
    show canLaunchUrl, launchUrl;
import '../../../../core/utils/colors.dart';

class CollegeInfoScreen extends StatefulWidget {
  const CollegeInfoScreen({super.key});

  @override
  State<CollegeInfoScreen> createState() => _CollegeInfoScreenState();
}

class _CollegeInfoScreenState extends State<CollegeInfoScreen> {
  Future<void> _openMap() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=Sascma+English+Medium+Commerce+College+Surat";
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      print("Could not launch $googleMapsUrl");
    }
  }

  void _shareApp() {
    Share.share("Sascma Commerce College App");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: AppColor.whiteColor),
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          'College Info',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // College Info Card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
                side: BorderSide(color: AppColor.primaryColor, width: 1.5),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // College Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        AppImage.collegeImage,
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // College Name
                    Text(
                      "Sascma English Medium Commerce College",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),

                    // College Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: AppColor.primaryColor),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "5Q48+MWQ, Surat - Dumas Rd, Opp Govardhan Temple (Haveli), Vesu, Surat, Gujarat 395007",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Phone Number
                    Row(
                      children: [
                        Icon(Icons.phone, color: AppColor.primaryColor),
                        SizedBox(width: 8.w),
                        Text(
                          "+91 88666 61565",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Working Hours
                    Row(
                      children: [
                        Icon(Icons.access_time, color: AppColor.primaryColor),
                        SizedBox(width: 8.w),
                        Text(
                          "Opens 7:30 am - Closes 4:00 pm",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Get Directions Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openMap,
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),

                // Share App Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareApp,
                    icon: const Icon(Icons.share),
                    label: const Text('Share App'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
