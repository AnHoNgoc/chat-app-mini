import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      setState(() => _isLoading = true); // Bắt đầu loading

      final authService = AuthService();
      String? result = await authService.changePassword(
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim()
      );

      setState(() => _isLoading = false); // Kết thúc loading

      if (result == null) {
        showAppSnackBar(context, "Password changed successfully!", Colors.green);
        Navigator.pop(context); // quay về Login
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Change password"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 50),
                Text(
                  "For your security, please set a new password",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                MyTextField(
                  hintText: "Old Password",
                  obscureText: true,
                  controller: _oldPasswordController,
                  validator: AppValidator.validatePassword
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "New Password",
                  obscureText: true,
                  controller: _newPasswordController,
                  validator: (value) => AppValidator.validateNewPassword(
                      value,
                      _oldPasswordController.text),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Confirm New Password",
                  obscureText: true,
                  controller: _confirmNewPasswordController,
                  validator: (value) => AppValidator.validateConfirmPassword(
                      value,
                      _newPasswordController.text
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "Change Password",
                  onTap: _changePassword,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
