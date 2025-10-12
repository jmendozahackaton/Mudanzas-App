import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout =
        const Duration(milliseconds: AppConstants.connectTimeout);
    _dio.options.receiveTimeout =
        const Duration(milliseconds: AppConstants.receiveTimeout);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token to requests
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          print('🔑 Token añadido a la petición');
        }
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = 'application/json'; // ✅ Agregar esto
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        handler.next(error);
      },
    ));
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return _parseResponse(response.data);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      print('🚀 ApiClient: POST $endpoint');
      final response = await _dio.post(endpoint, data: data);
      return _parseResponse(response.data);
    } on DioException catch (error) {
      print('❌ ApiClient: DioException capturada');
      print('❌ ApiClient: Tipo - ${error.type}');
      print('❌ ApiClient: Mensaje - ${error.message}');
      print('❌ ApiClient: Status Code - ${error.response?.statusCode}');

      final exception = _handleError(error);
      print(
          '🎯 ApiClient: Excepción final a lanzar - ${exception.runtimeType}');
      print('🎯 ApiClient: Mensaje final - "${exception.toString()}"');

      throw exception;
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _parseResponse(response.data);
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  // ✅ NUEVO MÉTODO: Parsear respuesta consistentemente
  dynamic _parseResponse(dynamic responseData) {
    if (responseData is String) {
      try {
        return json.decode(responseData);
      } catch (e) {
        // Si no es JSON válido, devolver el string
        return responseData;
      }
    }
    return responseData; // Ya es Map/List
  }

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      print('🔍 Error HTTP - Status: $statusCode, Data: $data');
      print('🎯 ApiClient: Tipo de error Dio - ${error.type}');

      // ✅ Parsear la respuesta de error
      dynamic errorData = data;
      if (errorData is String) {
        try {
          errorData = json.decode(errorData);
        } catch (e) {
          // Mantener como string si no es JSON
        }
      }

      final errorMessage = errorData is Map
          ? errorData['message'] ?? 'Error del servidor'
          : errorData.toString();

      print('🎯 ApiClient: Mensaje extraído - "$errorMessage"');

      // ✅ VERIFICAR QUE ESTÉ LANZANDO LA EXCEPCIÓN CORRECTA
      switch (statusCode) {
        case 400:
          print('🎯 ApiClient: Lanzando BadRequestException');
          return BadRequestException(errorMessage);
        case 401:
          print('🎯 ApiClient: Lanzando UnauthorizedException');
          return UnauthorizedException(
              errorMessage); // ← Esto debería ejecutarse
        case 404:
          print('🎯 ApiClient: Lanzando NotFoundException');
          return NotFoundException(errorMessage);
        case 422:
          print('🎯 ApiClient: Lanzando BadRequestException');
          return BadRequestException(errorMessage);
        case 500:
          print('🎯 ApiClient: Lanzando ServerException');
          return ServerException(errorMessage);
        default:
          print('🎯 ApiClient: Lanzando ServerException por defecto');
          return ServerException('Error $statusCode: $errorMessage');
      }
    } else {
      // ✅ SOLO para errores de conexión reales
      print('🎯 ApiClient: Error sin respuesta - Tipo: ${error.type}');

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        print('🎯 ApiClient: Lanzando NetworkException por timeout');
        return NetworkException(
            'Tiempo de conexión agotado. Verifica tu internet.');
      } else if (error.type == DioExceptionType.connectionError) {
        print('🎯 ApiClient: Lanzando NetworkException por connection error');
        return NetworkException('Error de conexión. Verifica tu internet.');
      } else {
        print('🎯 ApiClient: Lanzando NetworkException genérico');
        return NetworkException('Error de red: ${error.message}');
      }
    }
  }
}
