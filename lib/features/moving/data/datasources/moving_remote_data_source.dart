import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../provider/data/models/provider_models.dart';
import '../models/moving_models.dart';

abstract class MovingRemoteDataSource {
  Future<MovingRequestModel> createMovingRequest(
      Map<String, dynamic> requestData);
  Future<MovingRequestListResponse> getClientRequests(
      {int page = 1, int limit = 10});
  Future<MovingRequestListResponse> getAllRequests(
      {int page = 1, int limit = 10, String? estado});
  Future<MovingListResponse> getClientMovings({int page = 1, int limit = 10});
  Future<MovingListResponse> getProviderMovings({int page = 1, int limit = 10});
  Future<MovingModel> updateMovingStatus(int mudanzaId, String estado);
  Future<MovingModel> assignProvider(Map<String, dynamic> assignData);
}

class MovingRemoteDataSourceImpl implements MovingRemoteDataSource {
  final ApiClient apiClient;

  MovingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MovingRequestModel> createMovingRequest(
      Map<String, dynamic> requestData) async {
    try {
      print('📤 Creando solicitud de mudanza');

      final response = await apiClient.post(
        ApiConstants.movingRequest,
        requestData,
      );

      print('📥 Create Moving Request response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return MovingRequestModel.fromJson(data['solicitud']);
      } else {
        throw ServerException(response['message'] ?? 'Error creando solicitud');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error creando solicitud: $e');
      throw ServerException('Error creando solicitud: $e');
    }
  }

  @override
  Future<MovingRequestListResponse> getClientRequests(
      {int page = 1, int limit = 10}) async {
    try {
      print(
          '📤 Obteniendo solicitudes del cliente - page: $page, limit: $limit');

      final response = await apiClient.get(
        ApiConstants.movingRequests,
        params: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      print('📥 Get Client Requests response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;

        // ✅ CORREGIDO: El backend solo devuelve solicitudes, crear paginación por defecto
        final requests = (data['solicitudes'] as List)
            .map((request) => MovingRequestModel.fromJson(request))
            .toList();

        return MovingRequestListResponse(
          requests: requests,
          pagination: PaginationModel(
            page: page,
            limit: limit,
            total: requests.length, // Total temporal
            pages: 1, // Solo una página por ahora
          ),
        );
      } else {
        throw ServerException(
            response['message'] ?? 'Error obteniendo solicitudes');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo solicitudes: $e');
      throw ServerException('Error obteniendo solicitudes: $e');
    }
  }

  @override
  Future<MovingRequestListResponse> getAllRequests(
      {int page = 1, int limit = 10, String? estado}) async {
    try {
      print(
          '📤 Obteniendo todas las solicitudes - page: $page, limit: $limit, estado: $estado');

      final params = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (estado != null) {
        params['estado'] = estado;
      }

      final response = await apiClient.get(
        ApiConstants.adminMovingRequests,
        params: params,
      );

      print('📥 Get All Requests response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return MovingRequestListResponse.fromJson(data);
      } else {
        throw ServerException(
            response['message'] ?? 'Error obteniendo solicitudes');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo solicitudes: $e');
      throw ServerException('Error obteniendo solicitudes: $e');
    }
  }

  @override
  Future<MovingListResponse> getClientMovings(
      {int page = 1, int limit = 10}) async {
    try {
      print('📤 Obteniendo mudanzas del cliente - page: $page, limit: $limit');

      final response = await apiClient.get(
        ApiConstants.movingMovings,
        params: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      print('📥 Get Client Movings response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return MovingListResponse.fromJson(data);
      } else {
        throw ServerException(
            response['message'] ?? 'Error obteniendo mudanzas');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo mudanzas: $e');
      throw ServerException('Error obteniendo mudanzas: $e');
    }
  }

  @override
  Future<MovingListResponse> getProviderMovings(
      {int page = 1, int limit = 10}) async {
    try {
      print(
          '📤 Obteniendo mudanzas del proveedor - page: $page, limit: $limit');

      final response = await apiClient.get(
        ApiConstants.movingProviderMovings,
        params: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      print('📥 Get Provider Movings response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return MovingListResponse.fromJson(data);
      } else {
        throw ServerException(
            response['message'] ?? 'Error obteniendo mudanzas del proveedor');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo mudanzas del proveedor: $e');
      throw ServerException('Error obteniendo mudanzas del proveedor: $e');
    }
  }

  @override
  Future<MovingModel> updateMovingStatus(int mudanzaId, String estado) async {
    try {
      print('📤 Actualizando estado de mudanza: $mudanzaId a $estado');

      final response = await apiClient.put(
        ApiConstants.movingStatus,
        {
          'mudanza_id': mudanzaId,
          'estado': estado,
        },
      );

      print('📥 Update Moving Status response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return MovingModel.fromJson(data['mudanza']);
      } else {
        throw ServerException(
            response['message'] ?? 'Error actualizando estado');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error actualizando estado: $e');
      throw ServerException('Error actualizando estado: $e');
    }
  }

  @override
  Future<MovingModel> assignProvider(Map<String, dynamic> assignData) async {
    try {
      print('📤 Asignando proveedor a solicitud');

      final response = await apiClient.post(
        ApiConstants.adminMovingAssign,
        assignData,
      );

      print('📥 Assign Provider response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return MovingModel.fromJson(data['mudanza']);
      } else {
        throw ServerException(
            response['message'] ?? 'Error asignando proveedor');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error asignando proveedor: $e');
      throw ServerException('Error asignando proveedor: $e');
    }
  }
}
