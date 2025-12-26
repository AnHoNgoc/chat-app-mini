import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordDialog {
  /// Hiển thị dialog nhập mật khẩu, trả về mật khẩu hoặc null nếu hủy
  static Future<String?> show(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // không đóng khi nhấn ngoài
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your password to confirm.'),
              SizedBox(height: 10.h),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // user hủy
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(passwordController.text); // trả mật khẩu
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}