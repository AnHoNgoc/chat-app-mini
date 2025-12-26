import 'package:chat_app_mini/components/my_button.dart';
import 'package:chat_app_mini/components/my_text_field.dart';
import 'package:chat_app_mini/pages/register_page.dart';
import 'package:chat_app_mini/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../utils/show_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      String? result = await _authService.loginUser(email: email,password:password);

      setState(() => _isLoading = false);

      if (result != null) {
        showAppSnackBar(context, result, Colors.red);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                Lottie.asset(
                  'assets/lottie/login.json',
                  width: 250.sp,   // responsive size, giống Icon
                  height: 250.sp,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Welcome Back, you've been missed!",
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
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(right: 24.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.resetPassword);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                MyButton(
                  text: "Login",
                  onTap: _login,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Register now",
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


