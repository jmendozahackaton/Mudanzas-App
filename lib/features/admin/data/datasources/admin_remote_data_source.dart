import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_models.dart';

abstract class AdminRemoteDataSource {
  Future<UsersListResponse> getUsers({int page = 1, int limit = 10});
  Future<void> updateUserStatus(UpdateUserStatusRequest request);
  Future<void> updateUserRole(UpdateUserRoleRequest request);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final ApiClient apiClient;

  AdminRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UsersListResponse> getUsers({int page = 1, int limit = 10}) async {
    try {
      final response = await apiClient.get('/api/admin/users', params: {
        'page': page,
        'limit': limit,
      });
      return UsersListResponse.fromJson(response);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> updateUserStatus(UpdateUserStatusRequest request) async {
    try {
      await apiClient.put('/api/admin/users/status', request.toJson());
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> updateUserRole(UpdateUserRoleRequest request) async {
    try {
      await apiClient.put('/api/admin/users/role', request.toJson());
    } on ServerException {
      rethrow;
    }
  }
}
