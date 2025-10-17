import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/provider_repository.dart';

class UpdateProviderAvailabilityUseCase {
  final ProviderRepository repository;

  UpdateProviderAvailabilityUseCase(this.repository);

  Future<Either<Failure, void>> call(bool disponible, bool modoOcupado) {
    return repository.updateProviderAvailability(disponible, modoOcupado);
  }
}
