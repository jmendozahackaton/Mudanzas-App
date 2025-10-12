import 'dart:convert';

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
      print('📤 Get Users request - page: $page, limit: $limit');

      final response = await apiClient.get('/api/admin/users', params: {
        'page': page.toString(), // ✅ CONVERTIR A STRING
        'limit': limit.toString(), // ✅ CONVERTIR A STRING
      });

      print('📥 Get Users response type: ${response.runtimeType}');
      print('📥 Get Users response: $response');

      // ✅ VERIFICAR QUE LA RESPUESTA NO SEA NULL
      if (response == null) {
        throw ServerException('Respuesta vacía del servidor');
      }

      // ✅ PARSEAR RESPUESTA
      dynamic responseData = response;
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      // ✅ VERIFICAR QUE SEA UN MAP VÁLIDO
      if (responseData is Map<String, dynamic>) {
        // ✅ VERIFICAR LA ESTRUCTURA DE TU API
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;

          // ✅ CREAR EL MAP QUE ESPERA UsersListResponse.fromJson
          final usersListData = {
            'users': data['users'] ?? [],
            'pagination': data['pagination'] ?? {},
          };

          return UsersListResponse.fromJson(usersListData);
        } else {
          final errorMessage =
              responseData['message'] ?? 'Error al obtener usuarios';
          throw ServerException(errorMessage);
        }
      } else {
        throw ServerException('Formato de respuesta inválido');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error al obtener usuarios: $e');
      throw ServerException('Error al obtener usuarios: $e');
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
