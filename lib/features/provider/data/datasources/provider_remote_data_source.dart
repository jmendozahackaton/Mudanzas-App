import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/provider_models.dart';

abstract class ProviderRemoteDataSource {
  Future<ProviderModel> registerProvider(Map<String, dynamic> providerData);
  Future<ProviderModel> getProviderProfile();
  Future<ProviderModel> updateProviderProfile(Map<String, dynamic> updateData);
  Future<void> updateProviderAvailability(bool disponible, bool modoOcupado);
  Future<void> updateProviderLocation(double lat, double lng);
  Future<ProviderStatisticsModel> getProviderStatistics();
  Future<ProviderListResponse> getProviders({int page = 1, int limit = 10});
  Future<ProviderListResponse> searchProvidersByLocation({
    required double lat,
    required double lng,
    double radius = 10,
    int limit = 10,
  });
}

class ProviderRemoteDataSourceImpl implements ProviderRemoteDataSource {
  final ApiClient apiClient;

  ProviderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProviderModel> registerProvider(
      Map<String, dynamic> providerData) async {
    try {
      print('📤 Registrando proveedor: ${providerData['email']}');

      final response = await apiClient.post(
        ApiConstants.providerRegister,
        providerData,
      );

      print('📥 Register Provider response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return ProviderModel.fromJson(data['proveedor']);
      } else {
        throw ServerException(
            response['message'] ?? 'Error en registro de proveedor');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error registrando proveedor: $e');
      throw ServerException('Error registrando proveedor: $e');
    }
  }

  @override
  Future<ProviderModel> getProviderProfile() async {
    try {
      print('📤 Obteniendo perfil de proveedor');

      final response = await apiClient.get(ApiConstants.providerProfile);

      print('📥 Get Provider Profile response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return ProviderModel.fromJson(data['proveedor']);
      } else {
        throw ServerException(response['message'] ?? 'Error obteniendo perfil');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo perfil: $e');
      throw ServerException('Error obteniendo perfil: $e');
    }
  }

  @override
  Future<ProviderModel> updateProviderProfile(
      Map<String, dynamic> updateData) async {
    try {
      print('📤 Actualizando perfil de proveedor');

      final response = await apiClient.put(
        ApiConstants.providerProfile,
        updateData,
      );

      print('📥 Update Provider Profile response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return ProviderModel.fromJson(data['proveedor']);
      } else {
        throw ServerException(
            response['message'] ?? 'Error actualizando perfil');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error actualizando perfil: $e');
      throw ServerException('Error actualizando perfil: $e');
    }
  }

  @override
  Future<void> updateProviderAvailability(
      bool disponible, bool modoOcupado) async {
    try {
      print(
          '📤 Actualizando disponibilidad: $disponible, modoOcupado: $modoOcupado');

      final response = await apiClient.put(
        ApiConstants.providerAvailability,
        {
          'disponible': disponible,
          'modo_ocupado': modoOcupado,
        },
      );

      print('📥 Update Availability response: $response');

      if (response is! Map<String, dynamic> ||
          response['status'] != 'success') {
        throw ServerException(
            response['message'] ?? 'Error actualizando disponibilidad');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error actualizando disponibilidad: $e');
      throw ServerException('Error actualizando disponibilidad: $e');
    }
  }

  @override
  Future<void> updateProviderLocation(double lat, double lng) async {
    try {
      print('📤 Actualizando ubicación: $lat, $lng');

      final response = await apiClient.put(
        ApiConstants.providerLocation,
        {
          'lat': lat,
          'lng': lng,
        },
      );

      print('📥 Update Location response: $response');

      if (response is! Map<String, dynamic> ||
          response['status'] != 'success') {
        throw ServerException(
            response['message'] ?? 'Error actualizando ubicación');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error actualizando ubicación: $e');
      throw ServerException('Error actualizando ubicación: $e');
    }
  }

  @override
  Future<ProviderStatisticsModel> getProviderStatistics() async {
    try {
      print('📤 Obteniendo estadísticas de proveedor');

      final response = await apiClient.get(ApiConstants.providerStatistics);

      print('📥 Get Provider Statistics response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return ProviderStatisticsModel.fromJson(data['estadisticas']);
      } else {
        throw ServerException(
            response['message'] ?? 'Error obteniendo estadísticas');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo estadísticas: $e');
      throw ServerException('Error obteniendo estadísticas: $e');
    }
  }

  @override
  Future<ProviderListResponse> getProviders(
      {int page = 1, int limit = 10}) async {
    try {
      print('📤 Obteniendo lista de proveedores - page: $page, limit: $limit');

      final response =
          await apiClient.get(ApiConstants.adminProviders, params: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      print('📥 Get Providers response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return ProviderListResponse.fromJson(data);
      } else {
        throw ServerException(
            response['message'] ?? 'Error obteniendo proveedores');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error obteniendo proveedores: $e');
      throw ServerException('Error obteniendo proveedores: $e');
    }
  }

  @override
  Future<ProviderListResponse> searchProvidersByLocation({
    required double lat,
    required double lng,
    double radius = 10,
    int limit = 10,
  }) async {
    try {
      print(
          '🔍 Buscando proveedores por ubicación: $lat, $lng, radio: $radius');

      final response = await apiClient.get(
        ApiConstants.providerSearchLocation,
        params: {
          'lat': lat.toString(),
          'lng': lng.toString(),
          'radius': radius.toString(),
          'limit': limit.toString(),
        },
      );

      print('📥 Search Providers by Location response: $response');

      if (response is Map<String, dynamic> &&
          response['status'] == 'success' &&
          response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return ProviderListResponse.fromJson({
          'providers': data['proveedores'] ?? [],
          'pagination': {
            'page': 1,
            'limit': limit,
            'total': data['proveedores']?.length ?? 0,
            'pages': 1
          }
        });
      } else {
        throw ServerException(
            response['message'] ?? 'Error buscando proveedores');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print('❌ Error buscando proveedores: $e');
      throw ServerException('Error buscando proveedores: $e');
    }
  }
}
