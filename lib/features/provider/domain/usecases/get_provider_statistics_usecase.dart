import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/provider_entities.dart';
import '../repositories/provider_repository.dart';

class GetProviderStatisticsUseCase {
  final ProviderRepository repository;

  GetProviderStatisticsUseCase(this.repository);

  Future<Either<Failure, ProviderStatisticsEntity>> call() {
    return repository.getProviderStatistics();
  }
}
