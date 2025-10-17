import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/provider_entities.dart';

abstract class ProviderRepository {
  Future<Either<Failure, ProviderEntity>> registerProvider(
      Map<String, dynamic> providerData);
  Future<Either<Failure, ProviderEntity>> getProviderProfile();
  Future<Either<Failure, ProviderEntity>> updateProviderProfile(
      Map<String, dynamic> updateData);
  Future<Either<Failure, void>> updateProviderAvailability(
      bool disponible, bool modoOcupado);
  Future<Either<Failure, void>> updateProviderLocation(double lat, double lng);
  Future<Either<Failure, ProviderStatisticsEntity>> getProviderStatistics();
  Future<Either<Failure, List<ProviderEntity>>> getProviders(
      {int page = 1, int limit = 10});
  Future<Either<Failure, List<ProviderEntity>>> searchProvidersByLocation({
    required double lat,
    required double lng,
    double radius = 10,
    int limit = 10,
  });
}
