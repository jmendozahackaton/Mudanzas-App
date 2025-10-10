import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<LoginResponse> register(RegisterRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response =
          await apiClient.post('/api/auth/login', request.toJson());
      return LoginResponse.fromJson(response);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final response =
          await apiClient.post('/api/auth/register', request.toJson());
      return LoginResponse.fromJson(response);
    } on ServerException {
      rethrow;
    }
  }
}
