import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/provider_entities.dart';
import '../repositories/provider_repository.dart';

class GetProviderProfileUseCase {
  final ProviderRepository repository;

  GetProviderProfileUseCase(this.repository);

  Future<Either<Failure, ProviderEntity>> call() {
    return repository.getProviderProfile();
  }
}
