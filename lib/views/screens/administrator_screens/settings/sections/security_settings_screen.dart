import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/colors.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool isTwoFactorEnabled = false;
  bool isBiometricEnabled = false;
  bool isAutoLockEnabled = false;
  double autoLockTime = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Settings'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(15.w),
        children: [
          _buildSecurityOption(
            icon: Icons.lock,
            title: "Change Password",
            subtitle: "Update your account password",
            onTap: () => _showChangePasswordDialog(),
          ),
          _buildSecurityOption(
            icon: Icons.verified_user,
            title: "Two-Factor Authentication",
            subtitle: "Add extra security to your account",
            trailing: Switch(
              value: isTwoFactorEnabled,
              onChanged: (value) {
                setState(() {
                  isTwoFactorEnabled = value;
                });
              },
              activeColor: AppColor.primaryColor,
            ),
            onTap: () {
              setState(() {
                isTwoFactorEnabled = !isTwoFactorEnabled;
              });
            },
          ),
          _buildSecurityOption(
            icon: Icons.fingerprint,
            title: "Biometric Authentication",
            subtitle: isBiometricEnabled
                ? "Enabled"
                : "Enable fingerprint or face unlock",
            trailing: Switch(
              value: isBiometricEnabled,
              onChanged: (value) {
                setState(() {
                  isBiometricEnabled = value;
                });
              },
              activeColor: AppColor.primaryColor,
            ),
            onTap: () {
              setState(() {
                isBiometricEnabled = !isBiometricEnabled;
              });
            },
          ),
          _buildSecurityOption(
            icon: Icons.timer,
            title: "Auto Lock",
            subtitle: "Lock app after inactivity",
            trailing: Switch(
              value: isAutoLockEnabled,
              onChanged: (value) {
                setState(() {
                  isAutoLockEnabled = value;
                });
              },
              activeColor: AppColor.primaryColor,
            ),
            onTap: () {
              setState(() {
                isAutoLockEnabled = !isAutoLockEnabled;
              });
            },
          ),
          if (isAutoLockEnabled)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto Lock Time: ${autoLockTime.toInt()} minute${autoLockTime > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Slider(
                    value: autoLockTime,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label:
                        '${autoLockTime.toInt()} minute${autoLockTime > 1 ? 's' : ''}',
                    onChanged: (value) {
                      setState(() {
                        autoLockTime = value;
                      });
                    },
                    activeColor: AppColor.primaryColor,
                  ),
                ],
              ),
            ),
          _buildSecurityOption(
            icon: Icons.devices,
            title: "Manage Devices",
            subtitle: "View and manage connected devices",
            onTap: () => Get.toNamed('/manage-devices'),
          ),
          _buildSecurityOption(
            icon: Icons.history,
            title: "Login History",
            subtitle: "View recent account activity",
            onTap: () => Get.toNamed('/login-history'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColor.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog() {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                Get.snackbar(
                  'Error',
                  'Passwords do not match',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              Navigator.pop(context);
              Get.snackbar(
                'Success',
                'Password changed successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }
}
