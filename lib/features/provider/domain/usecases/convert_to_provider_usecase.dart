import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/provider_entities.dart';
import '../repositories/provider_repository.dart';

class ConvertToProviderUseCase {
  final ProviderRepository repository;

  ConvertToProviderUseCase(this.repository);

  Future<Either<Failure, ProviderEntity>> call(
      Map<String, dynamic> providerData) {
    return repository.convertToProvider(providerData);
  }
}
