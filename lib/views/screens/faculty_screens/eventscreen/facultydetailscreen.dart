import 'package:flutter/material.dart';

class FacultyEventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const FacultyEventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event['title'])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event['description'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Date: ${event['dateTime']}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
