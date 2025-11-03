import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth_service.dart';
import '../utils/app_validator.dart';
import '../utils/show_snackbar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _isLoading = false;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String? result = await authService.changePassword(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (result == null) {
        showAppSnackBar(context, "Password changed successfully!", Colors.green);
        Navigator.pop(context);
      } else {
        showAppSnackBar(context, result, Colors.red);
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Change password",
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(
                  Icons.message,
                  size: 60.r, // responsive
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 50.h),
                Text(
                  "For your security, please set a new password",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.h),
                MyTextField(
                  hintText: "Old Password",
                  obscureText: true,
                  controller: _oldPasswordController,
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  hintText: "New Password",
                  obscureText: true,
                  controller: _newPasswordController,
                  validator: (value) =>
                      AppValidator.validateNewPassword(value, _oldPasswordController.text),
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  hintText: "Confirm New Password",
                  obscureText: true,
                  controller: _confirmNewPasswordController,
                  validator: (value) =>
                      AppValidator.validateConfirmPassword(value, _newPasswordController.text),
                ),
                SizedBox(height: 25.h),
                MyButton(
                  text: "Change Password",
                  onTap: _changePassword,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}