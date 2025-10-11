import 'package:flutter/material.dart';

import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/user/presentation/pages/home_page.dart';
import '../../features/user/presentation/pages/profile_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) => const HomePage(),
      profile: (context) => const ProfilePage(),
      admin: (context) => const AdminDashboard(),
    };
  }
}
