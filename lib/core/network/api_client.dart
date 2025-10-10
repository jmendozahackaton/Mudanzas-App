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
        }
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        throw _handleError(error);
      },
    ));
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return BadRequestException(data['message'] ?? 'Solicitud incorrecta');
        case 401:
          return UnauthorizedException(data['message'] ?? 'No autorizado');
        case 404:
          return NotFoundException(data['message'] ?? 'Recurso no encontrado');
        case 500:
          return ServerException(data['message'] ?? 'Error del servidor');
        default:
          return ServerException('Error desconocido: $statusCode');
      }
    } else {
      return NetworkException('Error de conexión');
    }
  }
}
