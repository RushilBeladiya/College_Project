import 'package:college_project/controller/main/event_Controller';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: AppBar(title: Text(widget.event['title'])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.event['description'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Date: ${widget.event['dateTime']}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            if (widget.event['fileUrl'] != null)
              ElevatedButton(
                onPressed: () {},
                child: Text('View PDF'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  controller.applyForEvent(widget.event['id'], 'student_id'),
              child: Text('Apply for Event'),
            ),
          ],
        ),
      ),
    );
  }
}
