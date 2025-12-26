import 'package:chat_app_mini/pages/auth_page.dart';
import 'package:flutter/material.dart';

import '../pages/change_password_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/reset_password_page.dart';
import '../pages/settings_page.dart';

class AppRoutes {

  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String changePassword = '/change-password';
  static const String setting = '/setting';
  static const String resetPassword = '/reset-password';


  static Map<String, WidgetBuilder> get routes => {
    home: (context) => HomePage(),
    login: (context) => LoginPage(),
    register: (context) => RegisterPage(),
    changePassword: (context) => ChangePasswordPage(),
    setting: (context) => SettingsPage(),
    resetPassword: (context) => ResetPasswordPage(),
  };
}