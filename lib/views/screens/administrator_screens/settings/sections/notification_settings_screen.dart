import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool academicAlerts = true;
  bool eventReminders = true;
  bool emergencyAlerts = true;
  bool assignmentDeadlines = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(15.w),
        children: [
          _buildSectionHeader('Notification Preferences'),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: emailNotifications,
            onChanged: (value) => setState(() => emailNotifications = value),
          ),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: pushNotifications,
            onChanged: (value) => setState(() => pushNotifications = value),
          ),
          _buildDivider(),
          _buildSectionHeader('Notification Types'),
          _buildSwitchTile(
            title: 'Academic Alerts',
            subtitle: 'Important academic notifications',
            value: academicAlerts,
            onChanged: (value) => setState(() => academicAlerts = value),
          ),
          _buildSwitchTile(
            title: 'Event Reminders',
            subtitle: 'Notifications for upcoming events',
            value: eventReminders,
            onChanged: (value) => setState(() => eventReminders = value),
          ),
          _buildSwitchTile(
            title: 'Emergency Alerts',
            subtitle: 'Critical system-wide notifications',
            value: emergencyAlerts,
            onChanged: (value) => setState(() => emergencyAlerts = value),
          ),
          _buildSwitchTile(
            title: 'Assignment Deadlines',
            subtitle: 'Reminders for upcoming assignments',
            value: assignmentDeadlines,
            onChanged: (value) => setState(() => assignmentDeadlines = value),
          ),
          _buildDivider(),
          _buildSectionHeader('Notification Schedule'),
          ListTile(
            title: Text('Quiet Hours'),
            subtitle: Text('10:00 PM to 6:00 AM'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _showQuietHoursDialog(),
          ),
          ListTile(
            title: Text('Notification Sound'),
            subtitle: Text('Default'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _showSoundSelectionDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColor.primaryColor,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 20.h, thickness: 1);
  }

  void _showQuietHoursDialog() {
    TimeOfDay startTime = TimeOfDay(hour: 22, minute: 0);
    TimeOfDay endTime = TimeOfDay(hour: 6, minute: 0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Quiet Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Start Time'),
              subtitle: Text('${startTime.format(context)}'),
              trailing: Icon(Icons.edit),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: startTime,
                );
                if (picked != null) {
                  setState(() => startTime = picked);
                }
              },
            ),
            ListTile(
              title: Text('End Time'),
              subtitle: Text('${endTime.format(context)}'),
              trailing: Icon(Icons.edit),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: endTime,
                );
                if (picked != null) {
                  setState(() => endTime = picked);
                }
              },
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
              Navigator.pop(context);
              Get.snackbar(
                'Quiet Hours Set',
                'Notifications will be silent from ${startTime.format(context)} to ${endTime.format(context)}',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSoundSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Notification Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Default'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Sound Set',
                  'Default notification sound selected',
                );
              },
            ),
            ListTile(
              title: Text('Chime'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Sound Set',
                  'Chime notification sound selected',
                );
              },
            ),
            ListTile(
              title: Text('Bell'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Sound Set',
                  'Bell notification sound selected',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
