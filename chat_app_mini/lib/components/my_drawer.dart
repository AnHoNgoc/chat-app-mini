import 'package:chat_app_mini/pages/change_password_page.dart';
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/settings_page.dart';
import '../services/auth_service.dart';
import '../utils/confirmation_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/password_dialog.dart';
import '../utils/show_snackbar.dart';

class MyDrawer extends StatelessWidget {

  const MyDrawer({super.key});

  void _logout(BuildContext context) async {

    final confirm = await showConfirmationDialog(
      context,
      title: "Logout",
      message: "Are you sure you want to logout?",
      confirmText: "Logout",
      cancelText: "Cancel",
    );

    if (confirm == true) {
      final _auth = AuthService();
      await _auth.logout();
    }
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    // 1️⃣ Hiển thị confirmation dialog
    final confirm = await showConfirmationDialog(
      context,
      title: "Delete Account",
      message: "Are you sure you want to delete your account? This action cannot be undone.",
      confirmText: "Delete",
      cancelText: "Cancel",
    );

    if (confirm != true) return; // user hủy

    // 2️⃣ Hiển thị dialog nhập mật khẩu
    final password = await PasswordDialog.show(context);
    if (password == null || password.isEmpty) return; // user hủy

    // 3️⃣ Gọi hàm xóa user từ AuthProvider
    final _auth = AuthService();
    final success = await _auth.deleteUser(password: password);

    // 4️⃣ Xử lý kết quả
    if (success) {
      showAppSnackBar(
        context,
        "Account deleted successfully",
        Colors.green,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
      );
    } else {
      showAppSnackBar(
        context,
        "Failed to delete account. Please try again.",
        Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48.sp, // responsive icon
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.home, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.settings, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "P A S S W O R D",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.password, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "D E L E T E\nA C C O U N T",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.person, size: 22.sp),
                  onTap: () => _handleDeleteAccount(context),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.w, bottom: 25.h),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(fontSize: 16.sp),
              ),
              leading: Icon(Icons.logout, size: 22.sp),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }
}