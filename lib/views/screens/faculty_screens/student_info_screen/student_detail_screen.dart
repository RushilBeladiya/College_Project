import 'package:college_project/controller/Auth/auth_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/models/student_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentModel student;
  StudentDetailScreen(this.student);

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColor.primaryColor;
    final secondaryColor = primaryColor.withOpacity(0.6);
    final backgroundColor = AppColor.appBackGroundColor;

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child('student')
          .child(student.uid)
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text("Student Details",
                  style: TextStyle(color: Colors.white)),
            ),
            body: Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          );
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            title: Text(
              "Student Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => _showEditDialog(context),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: ClipOval(
                            child: student.profileImageUrl != null
                                ? Image.network(
                                    student.profileImageUrl!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/college_image/avatar.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/college_image/avatar.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${student.firstName} ${student.lastName}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "SPID: ${student.spid}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.person, "Full Name",
                            "${student.firstName} ${student.lastName} ${student.surName}"),
                        _buildDivider(),
                        _buildDetailRow(
                            Icons.phone, "Phone", student.phoneNumber),
                        _buildDivider(),
                        _buildDetailRow(Icons.email, "Email", student.email),
                        _buildDivider(),
                        _buildDetailRow(Icons.school, "Stream", student.stream),
                        _buildDivider(),
                        _buildDetailRow(
                            Icons.calendar_today, "Semester", student.semester),
                        _buildDivider(),
                        _buildDetailRow(
                            Icons.group, "Division", student.division),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    final primaryColor = AppColor.primaryColor;
    final backgroundColor = AppColor.appBackGroundColor;

    final TextEditingController firstNameController =
        TextEditingController(text: student.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: student.lastName);
    final TextEditingController surNameController =
        TextEditingController(text: student.surName);
    final TextEditingController phoneController =
        TextEditingController(text: student.phoneNumber);

    // Initialize dropdown values with current student values
    String selectedStream = student.stream;
    String selectedSemester = student.semester;
    String selectedDivision = student.division;

    // Define dropdown options
    final List<String> streamOptions = ["BCA", "BCOM", "BBA"];
    final List<String> semesterOptions = [
      'Semester 1',
      'Semester 2',
      'Semester 3',
      'Semester 4',
      'Semester 5',
      'Semester 6',
      'Semester 7',
      'Semester 8'
    ];

    final List<String> divisionOptions = ["A", "B", "C", "D"];

    // Validate that current values exist in options
    if (!streamOptions.contains(selectedStream)) {
      selectedStream = streamOptions.first;
    }
    if (!semesterOptions.contains(selectedSemester)) {
      selectedSemester = semesterOptions.first;
    }
    if (!divisionOptions.contains(selectedDivision)) {
      selectedDivision = divisionOptions.first;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit Student Details',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _buildEditTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                ),
                SizedBox(height: 10),
                _buildEditTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 10),
                _buildEditTextField(
                  controller: surNameController,
                  label: 'Surname',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 10),
                _buildEditTextField(
                  controller: phoneController,
                  label: 'Phone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedStream,
                  decoration: InputDecoration(
                    labelText: 'Stream',
                    border: OutlineInputBorder(),
                  ),
                  items: streamOptions.map((String stream) {
                    return DropdownMenuItem<String>(
                      value: stream,
                      child: Text(stream),
                    );
                  }).toList(),
                  onChanged: (value) => selectedStream = value!,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedSemester,
                  decoration: InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                  ),
                  items: semesterOptions.map((String semester) {
                    return DropdownMenuItem<String>(
                      value: semester,
                      child: Text(semester),
                    );
                  }).toList(),
                  onChanged: (value) => selectedSemester = value!,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedDivision,
                  decoration: InputDecoration(
                    labelText: 'Division',
                    border: OutlineInputBorder(),
                  ),
                  items: divisionOptions.map((String division) {
                    return DropdownMenuItem<String>(
                      value: division,
                      child: Text(division),
                    );
                  }).toList(),
                  onChanged: (value) => selectedDivision = value!,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await student.updateStudent({
                            'firstName': firstNameController.text.toUpperCase(),
                            'lastName': lastNameController.text.toUpperCase(),
                            'surName': surNameController.text.toUpperCase(),
                            'phoneNumber': phoneController.text,
                            'stream': selectedStream,
                            'semester': selectedSemester,
                            'division': selectedDivision,
                          });

                          Navigator.pop(context);
                          Get.back(); // Return to previous screen
                          Get.snackbar(
                            'Success',
                            'Student details updated successfully',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to update student details: ${e.toString()}',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child:
                          Text('Update', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final primaryColor = AppColor.primaryColor;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.orange,
                size: 50,
              ),
              SizedBox(height: 15),
              Text(
                'Delete Student',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to delete this student?',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        Get.dialog(
                          Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                          barrierDismissible: false,
                        );

                        await AuthController.instance.deleteStudentUser(
                          student.uid,
                          student.email,
                          student.spid,
                        );

                        Get.back(); // Close loading
                        Get.back(); // Close confirmation dialog
                        Get.snackbar(
                          'Success',
                          'Student deleted successfully',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } catch (e) {
                        Get.back(); // Close loading
                        Get.snackbar(
                          'Error',
                          'Failed to delete student: ${e.toString()}',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColor.primaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.grey[300],
    );
  }
}
