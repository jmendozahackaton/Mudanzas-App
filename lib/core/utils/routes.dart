import 'package:flutter/material.dart';

import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/user/presentation/pages/home_page.dart';
import '../../features/user/presentation/pages/profile_page.dart';
import '../../features/provider/presentation/pages/provider_register_page.dart';
import '../../features/provider/presentation/pages/provider_dashboard.dart';
import '../../features/provider/presentation/pages/provider_profile_page.dart';
import '../../features/moving/presentation/pages/moving_request_page.dart';
import '../../features/moving/presentation/pages/client_requests_page.dart';
import '../../features/moving/presentation/pages/client_movings_page.dart';
import '../../features/moving/presentation/pages/moving_tracking_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';
  static const String providerRegister = '/provider/register';
  static const String providerDashboard = '/provider/dashboard';
  static const String providerProfile = '/provider/profile';
  static const String movingRequest = '/moving/request';
  static const String clientRequests = '/client/requests';
  static const String clientMovings = '/client/movings';
  static const String movingTracking = '/moving/tracking';

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) => const HomePage(),
      profile: (context) => const ProfilePage(),
      admin: (context) => const AdminDashboard(),
      providerRegister: (context) => const ProviderRegisterPage(),
      providerDashboard: (context) => const ProviderDashboard(),
      providerProfile: (context) => const ProviderProfilePage(),
      movingRequest: (context) => const MovingRequestPage(),
      clientRequests: (context) => const ClientRequestsPage(),
      clientMovings: (context) => const ClientMovingsPage(),
      movingTracking: (context) => const MovingTrackingPage(),
    };
  }
}
