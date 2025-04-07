import 'package:college_project/core/utils/colors.dart';
import 'package:college_project/models/faculty_model.dart';
import 'package:flutter/material.dart';

class StaffDetailScreen extends StatelessWidget {
  final FacultyModel faculty;
  StaffDetailScreen(this.faculty);

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColor.primaryColor;
    final secondaryColor = primaryColor.withOpacity(0.6);
    final backgroundColor = AppColor.appBackGroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Staff Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.person, "Full Name",
                        "${faculty.firstName} ${faculty.lastName} ${faculty.surName}"),
                    _buildDivider(),
                    _buildDetailRow(Icons.phone, "Phone", faculty.phoneNumber),
                    _buildDivider(),
                    _buildDetailRow(Icons.email, "Email", faculty.email),
                    _buildDivider(),
                    _buildDetailRow(Icons.work, "Position", faculty.position),
                    _buildDivider(),
                  ],
                ),
              ),
            ),
          ],
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
