import 'package:flutter/material.dart';

class StudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> student;
  StudentDetailScreen(this.student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Details"), backgroundColor: Colors.blueAccent),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${student['firstName']} ${student['lastName']} ${student['surName']}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  Divider(),
                  Text("SPID: ${student['spid']}", style: TextStyle(fontSize: 18)),
                  Text("Phone: ${student['phoneNumber']}", style: TextStyle(fontSize: 18)),
                  Text("Email: ${student['email']}", style: TextStyle(fontSize: 18)),
                  Text("Stream: ${student['stream']}", style: TextStyle(fontSize: 18)),
                  Text("Semester: ${student['semester']}", style: TextStyle(fontSize: 18)),
                  Text("Division: ${student['division']}", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
