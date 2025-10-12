import 'dart:convert';

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
      print('📤 Get Profile request');

      final response = await apiClient.get('/api/user/profile');

      print('📥 Get Profile response type: ${response.runtimeType}');
      print('📥 Get Profile response: $response');

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
        // ✅ VERIFICAR LA ESTRUCTURA DE TU API (igual que en auth)
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;

          if (data['user'] != null) {
            // ✅ CREAR EL MAP QUE ESPERA UserProfileResponse.fromJson
            final userData = {
              'user': data['user'],
            };
            return UserProfileResponse.fromJson(userData);
          } else {
            throw ServerException('Campo "user" faltante en la respuesta');
          }
        } else {
          final errorMessage =
              responseData['message'] ?? 'Error al obtener perfil';
          throw ServerException(errorMessage);
        }
      } else {
        throw ServerException('Formato de respuesta inválido');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error al obtener perfil: $e');
      throw ServerException('Error al obtener perfil: $e');
    }
  }

  @override
  Future<UserProfileResponse> updateProfile(Map<String, dynamic> data) async {
    try {
      print('📤 Update Profile request: $data');

      final response = await apiClient.put('/api/user/profile', data);

      print('📥 Update Profile response type: ${response.runtimeType}');
      print('📥 Update Profile response: $response');

      if (response == null) {
        throw ServerException('Respuesta vacía del servidor');
      }

      dynamic responseData = response;
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      if (responseData is Map<String, dynamic>) {
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final responseDataMap = responseData['data'] as Map<String, dynamic>;

          if (responseDataMap['user'] != null) {
            final userData = {
              'user': responseDataMap['user'],
            };
            return UserProfileResponse.fromJson(userData);
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
      print('❌ Error al actualizar perfil: $e');
      throw ServerException('Error al actualizar perfil: $e');
    }
  }
}
