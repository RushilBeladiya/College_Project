import 'package:college_project/controller/Auth/auth_controller.dart';
import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/models/faculty_model.dart';
import 'package:college_project/views/screens/administrator_screens/staff_list_screen/staff_list_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffDetailScreen extends StatelessWidget {
  final FacultyModel faculty;
  StaffDetailScreen(this.faculty);

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColor.primaryColor;
    final secondaryColor = primaryColor.withOpacity(0.6);
    final backgroundColor = AppColor.appBackGroundColor;
    final textColor = AppColor.textColor;

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child('faculty')
          .child(faculty.uid)
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              title:
                  Text("Staff Details", style: TextStyle(color: Colors.white)),
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
              "Staff Details",
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
                // Profile Header Section
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
                        // Profile Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: faculty.profileImageUrl.isNotEmpty
                                ? Image.network(
                                    faculty.profileImageUrl,
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
                                        'assets/dashboard/user.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/dashboard/user.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${faculty.firstName} ${faculty.lastName}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          faculty.position,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Details Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.person, "Full Name",
                            "${faculty.firstName} ${faculty.lastName} ${faculty.surName}"),
                        _buildDivider(),
                        _buildDetailRow(
                            Icons.phone, "Phone", faculty.phoneNumber),
                        _buildDivider(),
                        _buildDetailRow(Icons.email, "Email", faculty.email),
                        _buildDivider(),
                        _buildDetailRow(
                            Icons.work, "Position", faculty.position),
                        _buildDivider(),
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
    final textColor = AppColor.textColor;

    final TextEditingController firstNameController =
        TextEditingController(text: faculty.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: faculty.lastName);
    final TextEditingController surNameController =
        TextEditingController(text: faculty.surName);
    final TextEditingController phoneController =
        TextEditingController(text: faculty.phoneNumber);
    String selectedPosition = faculty.position;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Faculty Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                _buildEditTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                ),
                SizedBox(height: 15),
                _buildEditTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 15),
                _buildEditTextField(
                  controller: surNameController,
                  label: 'Surname',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 15),
                _buildEditTextField(
                  controller: phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedPosition,
                    dropdownColor: backgroundColor,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Position',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      icon: Icon(Icons.work, color: primaryColor),
                    ),
                    items: [
                      "Professor",
                      "Assistant",
                      "HOD",
                      "Tutor",
                      "Principal"
                    ].map((String position) {
                      return DropdownMenuItem<String>(
                        value: position,
                        child: Text(position),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedPosition = newValue!;
                    },
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await faculty.updateFaculty({
                            'firstName': firstNameController.text,
                            'lastName': lastNameController.text,
                            'surName': surNameController.text,
                            'phoneNumber': phoneController.text,
                            'position': selectedPosition,
                          });
                          Navigator.pop(context);
                          Get.snackbar(
                            'Success',
                            'Faculty details updated successfully',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          Get.offAll(() => StaffListScreen());
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to update faculty details',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Update'),
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
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: AppColor.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final primaryColor = AppColor.primaryColor;
    final backgroundColor = AppColor.appBackGroundColor;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
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
                'Delete Faculty',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to delete this faculty member?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textColor,
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Show loading indicator with primary color
                        Get.dialog(
                          Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                          barrierDismissible: false,
                        );

                        // Use AuthController to delete faculty
                        await AuthController.instance
                            .deleteFacultyUser(faculty.uid);

                        // Close dialogs and navigate
                        Get.back(); // Close loading
                        Get.back(); // Close confirmation dialog

                        Get.offAll(() => StaffListScreen());
                        Get.snackbar(
                          'Success',
                          'Faculty deleted successfully',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } catch (e) {
                        Get.back(); // Close loading if there's an error
                        Get.snackbar(
                          'Error',
                          'Failed to delete faculty: ${e.toString()}',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                    color: AppColor.textColor,
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
