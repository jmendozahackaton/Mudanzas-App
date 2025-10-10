import '../constants/app_constants.dart';

class ApiConstants {
  static const String baseUrl = AppConstants.baseUrl;

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // User endpoints
  static const String userProfile = '/api/user/profile';

  // Admin endpoints
  static const String adminUsers = '/api/admin/users';
  static const String adminUsersStatus = '/api/admin/users/status';
  static const String adminUsersRole = '/api/admin/users/role';
}
