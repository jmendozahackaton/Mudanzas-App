import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../provider/data/models/provider_models.dart';
import '../../domain/entities/admin_entities.dart';
import '../models/admin_models.dart';

abstract class AdminRemoteDataSource {
  Future<UsersListResponse> getUsers({int page = 1, int limit = 10});
  Future<void> updateUserStatus(UpdateUserStatusRequest request);
  Future<void> updateUserRole(UpdateUserRoleRequest request);
  Future<UsersListResponse> searchUsers({
    required String query,
    int page = 1,
    int limit = 10,
  });

  Future<UserModel> getUserById({required int userId});
  Future<UserModel> updateUserProfile({required UserEntity user});
  Future<ProviderListResponse> getProviders({int page = 1, int limit = 10});
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

  @override
  Future<UsersListResponse> searchUsers({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('🔍 Buscando usuarios: $query');

      final response = await apiClient.get('/api/admin/users/search', params: {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      });

      print('📥 Search response type: ${response.runtimeType}');
      print('📥 Search response: $response');

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
              responseData['message'] ?? 'Error en la búsqueda';
          throw ServerException(errorMessage);
        }
      } else {
        throw ServerException('Formato de respuesta inválido');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error en búsqueda: $e');
      throw ServerException('Error en búsqueda: $e');
    }
  }

  @override
  Future<UserModel> getUserById({required int userId}) async {
    try {
      print('📤 Obteniendo usuario ID: $userId');

      final response = await apiClient.get('/api/admin/users/single', params: {
        'id': userId.toString(),
      });

      print('📥 Get User By ID response type: ${response.runtimeType}');
      print('📥 Get User By ID response: $response');

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

          if (data['user'] != null) {
            // ✅ DEVOLVER UserModel INDIVIDUAL, NO UsersListResponse
            return UserModel.fromJson(data['user']);
          } else {
            throw ServerException('Campo "user" faltante en la respuesta');
          }
        } else {
          final errorMessage =
              responseData['message'] ?? 'Error al obtener usuario';
          throw ServerException(errorMessage);
        }
      } else {
        throw ServerException('Formato de respuesta inválido');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      throw ServerException('Error obteniendo usuario: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile({required UserEntity user}) async {
    try {
      print('📤 Actualizando perfil usuario ID: ${user.id}');

      final requestData = {
        'user_id': user.id,
        'nombre': user.nombre,
        'apellido': user.apellido,
        'email': user.email,
        'telefono': user.telefono,
        'rol': user.rol,
        'estado': user.estado,
      };

      final response =
          await apiClient.put('/api/admin/users/profile', requestData);

      print('📥 Update Profile response type: ${response.runtimeType}');
      print('📥 Update Profile response: $response');

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

          if (data['user'] != null) {
            // ✅ DEVOLVER UserModel INDIVIDUAL
            return UserModel.fromJson(data['user']);
          } else {
            throw ServerException('Campo "user" faltante en la respuesta');
          }
        } else {
          final errorMessage =
              responseData['message'] ?? 'Error al actualizar perfil';
          throw ServerException(errorMessage);
        }
      } else {
        throw ServerException('Formato de respuesta inválido');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error actualizando perfil: $e');
      throw ServerException('Error actualizando perfil: $e');
    }
  }

  @override
  Future<ProviderListResponse> getProviders(
      {int page = 1, int limit = 10}) async {
    try {
      print('📤 Get Providers request - page: $page, limit: $limit');

      final response =
          await apiClient.get(ApiConstants.adminProviders, params: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      print('📥 Get Providers response: $response');
      print('📥 Response type: ${response.runtimeType}');

      if (response is Map<String, dynamic>) {
        print('✅ Response is Map<String, dynamic>');

        if (response['status'] == 'success' && response['data'] != null) {
          final data = response['data'] as Map<String, dynamic>;
          print('📊 Data keys: ${data.keys}');
          print('📊 Providers count: ${data['providers']?.length ?? 0}');

          return ProviderListResponse.fromJson(data);
        } else {
          print('❌ Error in response: ${response['message']}');
          throw ServerException(
              response['message'] ?? 'Error obteniendo proveedores');
        }
      } else {
        print('❌ Response is not Map<String, dynamic>');
        throw ServerException('Formato de respuesta inválido');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error in getProviders: $e');
      throw ServerException('Error obteniendo proveedores: $e');
    }
  }
}
