import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/colors.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  String selectedLanguage = 'English';
  bool isDarkMode = false;
  bool autoUpdate = true;
  bool analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(15.w),
        children: [
          _buildSettingSection(
            title: "Appearance",
            children: [
              SwitchListTile(
                title: Text('Dark Mode'),
                subtitle: Text('Toggle dark theme'),
                value: isDarkMode,
                onChanged: (value) => setState(() => isDarkMode = value),
                activeColor: AppColor.primaryColor,
              ),
              ListTile(
                title: Text('Language'),
                subtitle: Text(selectedLanguage),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(),
              ),
              SwitchListTile(
                title: Text('Use System Theme'),
                subtitle: Text('Follow system light/dark mode'),
                value: false,
                onChanged: (value) {},
                activeColor: AppColor.primaryColor,
              ),
            ],
          ),
          _buildSettingSection(
            title: "Data & Storage",
            children: [
              ListTile(
                title: Text('Clear Cache'),
                subtitle: Text('Free up space'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _showClearCacheDialog(),
              ),
              ListTile(
                title: Text('Storage Usage'),
                subtitle: Text('Manage app storage'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Get.toNamed('/storage-usage'),
              ),
              SwitchListTile(
                title: Text('Auto Backup'),
                subtitle: Text('Automatically backup data weekly'),
                value: true,
                onChanged: (value) {},
                activeColor: AppColor.primaryColor,
              ),
            ],
          ),
          _buildSettingSection(
            title: "Updates & Analytics",
            children: [
              SwitchListTile(
                title: Text('Automatic Updates'),
                subtitle: Text('Download updates automatically'),
                value: autoUpdate,
                onChanged: (value) => setState(() => autoUpdate = value),
                activeColor: AppColor.primaryColor,
              ),
              SwitchListTile(
                title: Text('Analytics'),
                subtitle: Text('Help improve the app with analytics'),
                value: analyticsEnabled,
                onChanged: (value) => setState(() => analyticsEnabled = value),
                activeColor: AppColor.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
        ),
        ...children,
        SizedBox(height: 20.h),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('English'),
              value: 'English',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Hindi'),
              value: 'Hindi',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Spanish'),
              value: 'Spanish',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
            'Are you sure you want to clear the app cache? This will free up 24.5 MB of space.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement cache clearing
              Navigator.pop(context);
              Get.snackbar(
                'Cache Cleared',
                '24.5 MB of space has been freed',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
