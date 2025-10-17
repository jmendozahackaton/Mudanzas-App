import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/provider_entities.dart';
import '../repositories/provider_repository.dart';

class SearchProvidersLocationUseCase {
  final ProviderRepository repository;

  SearchProvidersLocationUseCase(this.repository);

  Future<Either<Failure, List<ProviderEntity>>> call({
    required double lat,
    required double lng,
    double radius = 10,
    int limit = 10,
  }) {
    return repository.searchProvidersByLocation(
      lat: lat,
      lng: lng,
      radius: radius,
      limit: limit,
    );
  }
}
