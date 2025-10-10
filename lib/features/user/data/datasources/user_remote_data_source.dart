import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_models.dart';

abstract class UserRemoteDataSource {
  Future<UserProfileResponse> getProfile();
  Future<UserProfileResponse> updateProfile(Map<String, dynamic> data);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserProfileResponse> getProfile() async {
    try {
      final response = await apiClient.get('/api/user/profile');
      return UserProfileResponse.fromJson(response);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<UserProfileResponse> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put('/api/user/profile', data);
      return UserProfileResponse.fromJson(response);
    } on ServerException {
      rethrow;
    }
  }
}
