import '../constants/app_constants.dart';

class ApiConstants {
  static const String baseUrl = AppConstants.baseUrl;

  // Health check & Test endpoints
  static const String health = '/api/health';
  static const String test = '/api/test';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // User endpoints
  static const String userProfile = '/api/user/profile';

  // Admin endpoints
  static const String adminUsers = '/api/admin/users';
  static const String adminUsersStatus = '/api/admin/users/status';
  static const String adminUsersRole = '/api/admin/users/role';
  static const String adminUsersSearch = '/api/admin/users/search';
  static const String adminUsersSingle = '/api/admin/users/single';
  static const String adminUsersProfile = '/api/admin/users/profile';

  // Client endpoints
  static const String clientEnsure = '/api/client/ensure';
  static const String clientStatistics = '/api/client/statistics';

  // Provider endpoints
  static const String providerRegister = '/api/provider/register';
  static const String providerConvert = '/api/provider/convert';
  static const String providerProfile = '/api/provider/profile';
  static const String providerAvailability = '/api/provider/availability';
  static const String providerLocation = '/api/provider/location';
  static const String providerStatistics = '/api/provider/statistics';
  static const String providerSearchLocation = '/api/provider/search/location';

  // Moving endpoints
  static const String movingRequest = '/api/moving/request';
  static const String movingRequests = '/api/moving/requests';
  static const String movingMovings = '/api/moving/movings';
  static const String movingProviderMovings = '/api/moving/provider-movings';

  static const String movingStatus = '/api/moving/status';

  // Admin - Providers endpoints
  static const String adminProviders = '/api/admin/providers';
  static const String adminProvidersVerification =
      '/api/admin/providers/verification';

  // Admin - Moving endpoints
  static const String adminMovingRequests = '/api/admin/moving/requests';
  static const String adminMovingAssign = '/api/admin/moving/assign';
}
