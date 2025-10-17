import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/provider_repository.dart';

class UpdateProviderLocationUseCase {
  final ProviderRepository repository;

  UpdateProviderLocationUseCase(this.repository);

  Future<Either<Failure, void>> call(double lat, double lng) {
    return repository.updateProviderLocation(lat, lng);
  }
}
