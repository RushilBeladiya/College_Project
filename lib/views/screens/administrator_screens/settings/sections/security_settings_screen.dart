import 'package:college_project/controller/Administrator/settings/security_settings_controller.dart';
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
  final SecuritySettingsController controller =
      Get.put(SecuritySettingsController());

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
            trailing: Obx(() => Switch(
                  value: controller.isTwoFactorEnabled.value,
                  onChanged: (value) => controller.toggleTwoFactor(value),
                  activeColor: AppColor.primaryColor,
                )),
            onTap: () => controller
                .toggleTwoFactor(!controller.isTwoFactorEnabled.value),
          ),
          Obx(() => _buildSecurityOption(
                icon: Icons.fingerprint,
                title: "Biometric Authentication",
                subtitle: controller.biometricMessage.value,
                trailing: Switch(
                  value: controller.isBiometricEnabled.value,
                  onChanged: controller.isBiometricAvailable.value &&
                          controller.availableBiometrics.isNotEmpty
                      ? (value) => controller.toggleBiometric(value)
                      : null,
                  activeColor: AppColor.primaryColor,
                ),
                onTap: () => controller.isBiometricAvailable.value &&
                        controller.availableBiometrics.isNotEmpty
                    ? controller
                        .toggleBiometric(!controller.isBiometricEnabled.value)
                    : null,
              )),
          Obx(() => _buildSecurityOption(
                icon: Icons.timer,
                title: "Auto Lock",
                subtitle: "Lock app after inactivity",
                trailing: Switch(
                  value: controller.isAutoLockEnabled.value,
                  onChanged: (value) => controller.toggleAutoLock(value),
                  activeColor: AppColor.primaryColor,
                ),
                onTap: () => controller
                    .toggleAutoLock(!controller.isAutoLockEnabled.value),
              )),
          Obx(() => controller.isAutoLockEnabled.value
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto Lock Time: ${controller.autoLockTime.value} minute${controller.autoLockTime.value > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Slider(
                        value: controller.autoLockTime.value.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label:
                            '${controller.autoLockTime.value} minute${controller.autoLockTime.value > 1 ? 's' : ''}',
                        onChanged: (value) =>
                            controller.setAutoLockTime(value.toInt()),
                        activeColor: AppColor.primaryColor,
                      ),
                    ],
                  ),
                )
              : SizedBox()),
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
