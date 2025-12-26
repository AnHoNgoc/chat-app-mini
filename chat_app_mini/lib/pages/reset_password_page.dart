import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth_service.dart';
import '../utils/app_validator.dart';
import '../utils/show_snackbar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final _authService = AuthService();

  bool _isLoading = false;

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String? errorMessage =
    await _authService.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      showAppSnackBar(
        context,
        "Password reset email sent!",
        Colors.green,
      );
      Navigator.pop(context);
    } else {
      showAppSnackBar(
        context,
        errorMessage,
        Colors.redAccent,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Enter your email to reset your password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height:150.h),
                  MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: _emailController,
                    validator: AppValidator.validateEmail,
                  ),
                  SizedBox(height: 25.h),
                  MyButton(
                    text: "Send Reset Email",
                    onTap: _isLoading ? null : _resetPassword,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}