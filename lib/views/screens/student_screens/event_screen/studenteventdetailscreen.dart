import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/main/event_Controller.dart';
import '../../../../core/utils/colors.dart';

class StudentEventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const StudentEventDetailScreen({super.key, required this.event});

  @override
  State<StudentEventDetailScreen> createState() =>
      _StudentEventDetailScreenState();
}

class _StudentEventDetailScreenState extends State<StudentEventDetailScreen> {
  final EventController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackGroundColor, // White background
      appBar: AppBar(
        title: Text(
          widget.event['title'],
          style: TextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 2,
        iconTheme: IconThemeData(color: AppColor.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Text(
              widget.event['title'],
              style: TextStyle(
                color: AppColor.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Event Description
            Text(
              widget.event['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Date & Time Section
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColor.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Date: ${widget.event['dateTime']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // View PDF Button (if file exists)
            if (widget.event['fileUrl'] != null)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement PDF viewing logic
                  },
                  icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: Text('View PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 30),

            // Apply for Event Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.applyForEvent(widget.event['id'], 'student_id');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Apply for Event',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
