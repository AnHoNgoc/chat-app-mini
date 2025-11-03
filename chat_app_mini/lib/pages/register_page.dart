import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth_service.dart';
import '../utils/app_validator.dart';
import '../utils/show_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authService = AuthService();
      String? result = await authService.createUser({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      setState(() => _isLoading = false);

      if (result == null) {
        showAppSnackBar(context, "Register successfully!", Colors.green);
        Navigator.pop(context); // quay về Login
      } else {
        showAppSnackBar(context, result, Colors.red);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message,
                  size: 60.sp, // responsive icon size
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 50.h),
                Text(
                  "Let's create an account for you",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16.sp, // responsive font size
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.h),
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                  validator: AppValidator.validateEmail,
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController,
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: _confirmPasswordController,
                  validator: (value) => AppValidator.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                SizedBox(height: 25.h),
                MyButton(
                  text: "Register",
                  onTap: _register,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}