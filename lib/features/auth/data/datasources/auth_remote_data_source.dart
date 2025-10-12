import 'dart:convert';
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
      print('📤 Login request: ${request.toJson()}');

      final response =
          await apiClient.post('/api/auth/login', request.toJson());

      print('📥 Login response type: ${response.runtimeType}');
      print('📥 Login response: $response');

      // ✅ VERIFICAR QUE LA RESPUESTA NO SEA NULL
      if (response == null) {
        throw ServerException('Respuesta vacía del servidor');
      }

      // ✅ PARSEAR RESPUESTA
      dynamic responseData = response;
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      if (responseData is Map<String, dynamic>) {
        // ✅ VERIFICAR SI LA RESPUESTA TIENE ÉXITO
        if (responseData['status'] != 'success') {
          final errorMessage = responseData['message'] ?? 'Error en el login';
          throw ServerException(errorMessage);
        }

        if (responseData['data'] == null) {
          throw ServerException('Estructura de respuesta inválida');
        }

        // ✅ EXTRAER DATA
        if (responseData['data'] is Map<String, dynamic>) {
          final data = responseData['data'] as Map<String, dynamic>;

          if (data['user'] == null || data['token'] == null) {
            throw ServerException('Credenciales inválidas');
          }

          // ✅ CREAR MAP PARA LoginResponse
          final loginData = {
            'user': data['user'],
            'token': data['token'],
          };

          return LoginResponse.fromJson(loginData);
        } else {
          throw ServerException('Campo "data" inválido');
        }
      } else {
        throw ServerException('Formato de respuesta inválido');
      }
    }
    // ✅ DEJA QUE LAS EXCEPCIONES ESPECÍFICAS PASEN DIRECTAMENTE
    on ServerException catch (e) {
      print('🎯 DataSource: Relanzando ServerException - ${e.runtimeType}');
      print('🎯 DataSource: Mensaje - "${e.message}"');
      rethrow;
    } on UnauthorizedException catch (e) {
      print('🎯 DataSource: Relanzando UnauthorizedException');
      print('🎯 DataSource: Mensaje - "${e.message}"');
      rethrow; // ✅ Esto preserva la UnauthorizedException
    } on NetworkException catch (e) {
      print('🎯 DataSource: Relanzando NetworkException');
      print('🎯 DataSource: Mensaje - "${e.message}"');
      rethrow; // ✅ Esto preserva la NetworkException
    } catch (e) {
      print('❌ DataSource: Error inesperado - ${e.runtimeType}');
      print('❌ DataSource: Mensaje - "$e"');
      // ✅ Solo para errores realmente inesperados, usa ServerException
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      print('📤 Register request: ${request.toJson()}');

      final response =
          await apiClient.post('/api/auth/register', request.toJson());

      print('📥 Register response type: ${response.runtimeType}');
      print('📥 Register response: $response');

      if (response == null) {
        throw ServerException('Respuesta vacía del servidor');
      }

      dynamic responseData = response;
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      if (responseData is Map<String, dynamic>) {
        // ✅ VERIFICAR STATUS
        if (responseData['status'] != 'success') {
          final errorMessage =
              responseData['message'] ?? 'Error en el registro';
          throw ServerException(errorMessage);
        }

        // ✅ EXTRAER DATA
        if (responseData['data'] is Map<String, dynamic>) {
          final data = responseData['data'] as Map<String, dynamic>;

          if (data['user'] == null || data['token'] == null) {
            throw ServerException('Estructura de datos incompleta');
          }

          final loginData = {
            'user': data['user'],
            'token': data['token'],
          };

          return LoginResponse.fromJson(loginData);
        } else {
          throw ServerException('Campo "data" inválido');
        }
      } else {
        throw ServerException('Formato de respuesta inválido');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error en registro: $e');
      throw ServerException('Error en registro: $e');
    }
  }
}
